MangaOwl = Parser:new("MangaOwl", "https://mangaowl.com", "ENG", "MANGAOWLEN")

local notify = false

local function stringify(string)
    if not u8c then
        if not notify then
            Notifications.push("Please update app, to see fixed titles")
            notify = true
        end
        return string
    end
    return string:gsub("&#([^;]-);", function(a)
        local number = tonumber("0" .. a) or tonumber(a)
        return number and u8c(number) or "&#" .. a .. ";"
    end)
end

local function downloadContent(link)
    local file = {}
    Threads.insertTask(file, {
        Type = "StringRequest",
        Link = link,
        Table = file,
        Index = "string"
    })
    while Threads.check(file) do
        coroutine.yield(false)
    end
    return file.string or ""
end

function MangaOwl:getPopularManga(page, dest_table)
    local content = downloadContent(self.Link.."/list/"..page)
    local t = dest_table
    local done = true
    for Link, ImageLink, Name in content:gmatch('w3%-list%-img">.-href="(%S-)".-image="(%S-)".-<td>([^<]-)</td>') do
        local Manga = CreateManga(stringify(Name), Link:match("single/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
        if Manga then
            t[#t + 1] = Manga
        end
        done = false
        coroutine.yield(false)
    end
    if done then
        t.NoPages = true
    end
end

function MangaOwl:searchManga(search, page, dest_table)
    local content = downloadContent(self.Link.."/search/"..search.."/"..page)
    local t = dest_table
    local done = true
    for ImageLink, Link, Name in content:gmatch('comicView".-image="(%S-)".-agileits_w3layouts_mid_1_home">.-href="(%S-)".->([^<]-)</a>') do
        local Manga = CreateManga(stringify(Name), Link:match("single/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
        if Manga then
            t[#t + 1] = Manga
        end
        done = false
        coroutine.yield(false)
    end
    if done then
        t.NoPages = true
    end
end

function MangaOwl:getChapters(manga, dest_table)
    local content = downloadContent(self.Link.."/single/"..manga.Link)
    local t = {}
    for Link, Name in content:gmatch('chapter_list">.-href="(%S-)">[\n%s]-(%S[^<]-)[\n%s]-</a>') do
        t[#t + 1] = {
			Name = stringify(Name),
			Link = Link,
			Pages = {},
			Manga = manga
		}
    end
	for i = #t, 1, -1 do
		dest_table[#dest_table + 1] = t[i]
	end
end

function MangaOwl:prepareChapter(chapter, dest_table)
    local content = downloadContent(chapter.Link)
    local t = dest_table
    for Link in content:gmatch('owl%-lazy" data%-src="(%S-)"') do
        t[#t + 1] = Link
		Console.write("Got " .. t[#t])
    end
end

function MangaOwl:loadChapterPage(link, dest_table)
	dest_table.Link = link
end