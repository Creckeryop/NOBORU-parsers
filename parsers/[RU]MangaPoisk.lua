MangaPoisk = Parser:new("МангаПоиск", "https://mangapoisk.ru", "RUS", "MANGAPOISK")

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

function MangaPoisk:getManga(link, t)
    local content = downloadContent(link)
    local done = true
    for Link, ImageLink, Name in content:gmatch('rounded">.-href="(%S-)".-src="(%S-)" class.-title pl%-1 h3">([^<]-)</h2>') do
        t[#t + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
        coroutine.yield(false)
        done = false
    end
    if done then
        t.NoPages = true
    end
end

function MangaPoisk:getPopularManga(page, dest_table)
    self:getManga(self.Link .. "/manga?page=" .. page, dest_table)
end

function MangaPoisk:getLatestManga(page, dest_table)
    self:getManga(self.Link .. "/manga?sortBy=-last_chapter_at&page=" .. page, dest_table)
end

function MangaPoisk:searchManga(search, page, dest_table)
    self:getManga(self.Link .. "/search?q="..search.."&page=" .. page, dest_table)
end

function MangaPoisk:getChapters(manga, dest_table)
    local content = downloadContent(self.Link..manga.Link.."/chaptersList")
    local t = {}
    for Link, Name, subName in content:gmatch('d%-none.-href="(%S-)".-class="chapter%-title">\n(.-)</span>\n(.-)\n') do
        t[#t + 1] = {
			Name = stringify(Name:gsub("%s+"," "):match("^%s*(.-)%s*$"))..": "..subName:gsub("%s+"," "):match("^%s*(.-)%s*$"),
			Link = Link,
			Pages = {},
			Manga = manga
		}
    end
	for i = #t, 1, -1 do
		dest_table[#dest_table + 1] = t[i]
	end
end

function MangaPoisk:prepareChapter(chapter, dest_table)
    local content = downloadContent(self.Link..chapter.Link)
	local t = dest_table
    for Link in content:gmatch('data%-alternative="(%S-)"') do
        t[#t + 1] = Link
		Console.write("Got " .. t[#t])
    end
end

function MangaPoisk:loadChapterPage(link, dest_table)
	dest_table.Link = link
end
