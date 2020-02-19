MangaKakalot = Parser:new("MangaKakalot", "https://mangakakalot.com", "ENG", "MANGAKAKALOT")

local notify = false

local Patterns = {
    ["https://manganelo.com"] = {"a%-h",'class="container%-chapter%-reader">(.-)$'},
    ["https://mangakakalot.com"] = {"row",'class="vung%-doc" id="vungdoc">(.-)$'},
}

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

function MangaKakalot:getManga(link, page, dest_table)
    local content = downloadContent(link..page)
    local t = dest_table
    for Link,ImageLink,Name in content:gmatch('class="list%-truyen%-item%-wrap".-href="(%S-)".-src="(%S-)".-title="[^>]-">([^<]-)<') do
        local manga = CreateManga(stringify(Name), Link:match("manga/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
        if manga then
            manga.Data.Source = Link:match("(https://%S-)/")
            t[#t + 1] = manga
        end
        coroutine.yield(false)
    end
    local pages = content:match("Last%((.-)%)") or content:match("LAST%((.-)%)")
    t.NoPages = pages == nil or pages == page
end

function MangaKakalot:getPopularManga(page, dest_table)
    self:getManga(self.Link.."/manga_list?type=topview&category=all&state=all&page=",page, dest_table)
end

function MangaKakalot:getLatestManga(page, dest_table)
    self:getManga(self.Link.."/manga_list?type=latest&category=all&state=all&page=",page, dest_table)
end

function MangaKakalot:searchManga(search, page, dest_table)
    local content = downloadContent(self.Link.."/search/"..search.."?page="..page)
    local t = dest_table
    for Link,ImageLink,Name in content:gmatch('class="story_item".-href="(%S-)".-src="(%S-)".-href="[^>]-">([^<]-)<') do
        local manga = CreateManga(stringify(Name), Link:match("manga/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
        if manga then
            manga.Data.Source = Link:match("(https://%S-)/")
            t[#t + 1] = manga
        end
        coroutine.yield(false)
    end
    local pages = content:match("Last%((.-)%)")
    t.NoPages = pages == nil or pages == page
end

function MangaKakalot:getChapters(manga, dest_table)
    local content = downloadContent(manga.Data.Source.."/manga/"..manga.Link)
    local t = {}
    for Link, Name in content:gmatch('class="'..Patterns[manga.Data.Source][1]..'">.-href="(%S-)" title=".-">([^<]-)<') do
        t[#t + 1] = {
            Name = Name,
            Link = Link:match(".+/(.-)$"),
            Pages = {},
            Manga = manga
        }
    end
	for i = #t, 1, -1 do
		dest_table[#dest_table + 1] = t[i]
	end
end

function MangaKakalot:prepareChapter(chapter, dest_table)
    local content = downloadContent(chapter.Manga.Data.Source .. "/chapter/"..chapter.Manga.Link.."/"..chapter.Link)
    local t = dest_table
    content = content:match(Patterns[chapter.Manga.Data.Source][2]) or ""
    for Link in content:gmatch('img src="(%S-)" alt') do
        t[#t + 1] = Link:gsub("%%","%%%%")
		Console.write("Got " .. t[#t])
    end
end

function MangaKakalot:loadChapterPage(link, dest_table)
    dest_table.Link = link
end

MangaNelo = MangaKakalot:new("MangaNelo", "https://manganelo.com", "ENG", "MANGANELO")

function MangaNelo:getManga(link, page, dest_table)
    local content = downloadContent(link..page)
    local t = dest_table
    for Link,ImageLink,Name in content:gmatch('class="content%-genres%-item".-href="(%S-)".-src="(%S-)".-title="[^>]-">([^<]-)<') do
        local manga = CreateManga(stringify(Name), Link:match("manga/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
        if manga then
            manga.Data.Source = Link:match("(https://%S-)/")
            t[#t + 1] = manga
        end
        coroutine.yield(false)
    end
    local pages = content:match("Last%((.-)%)") or content:match("LAST%((.-)%)")
    t.NoPages = pages == nil or pages == page
end

function MangaNelo:getPopularManga(page, dest_table)
    self:getManga(self.Link.."/genre-all?type=topview&category=all&state=all&page=",page, dest_table)
end

function MangaNelo:getLatestManga(page, dest_table)
    self:getManga(self.Link.."/genre-all?type=latest&category=all&state=all&page=",page, dest_table)
end

function MangaNelo:searchManga(search, page, dest_table)
    local content = downloadContent(self.Link.."/search/"..search.."?page="..page)
    local t = dest_table
    for Link,ImageLink,Name in content:gmatch('class="search%-story%-item".-href="(%S-)".-src="(%S-)".-title="[^>]-">([^<]-)<') do
        local manga = CreateManga(stringify(Name), Link:match("manga/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
        if manga then
            manga.Data.Source = Link:match("(https://%S-)/")
            t[#t + 1] = manga
        end
        coroutine.yield(false)
    end
    local pages = content:match("Last%((.-)%)") or content:match("LAST%((.-)%)")
    t.NoPages = pages == nil or pages == page
end
