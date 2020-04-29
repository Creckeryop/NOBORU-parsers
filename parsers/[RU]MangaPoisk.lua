MangaPoisk = Parser:new("МангаПоиск", "https://mangapoisk.ru", "RUS", "MANGAPOISK", 1)

local function stringify(string)
    return string:gsub("&#([^;]-);", function(a)
        local number = tonumber("0" .. a) or tonumber(a)
        return number and u8c(number) or "&#" .. a .. ";"
    end):gsub("&(.-);", function(a) return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";" end)
end

local function downloadContent(link)
    local f = {}
    Threads.insertTask(f, {
        Type = "StringRequest",
        Link = link,
        Table = f,
        Index = "text"
    })
    while Threads.check(f) do
        coroutine.yield(false)
    end
    return f.text or ""
end

function MangaPoisk:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch('rounded">.-href="(%S-)".-src="(%S-)" class.-title pl%-1 h3">([^<]-)</h2>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
        coroutine.yield(false)
        dt.NoPages = false
    end
end

function MangaPoisk:getPopularManga(page, dest_table)
    self:getManga(self.Link .. "/manga?page=" .. page, dest_table)
end

function MangaPoisk:getLatestManga(page, dest_table)
    self:getManga(self.Link .. "/manga?sortBy=-last_chapter_at&page=" .. page, dest_table)
end

function MangaPoisk:searchManga(search, page, dest_table)
    self:getManga(self.Link .. "/search?q=" .. search .. "&page=" .. page, dest_table)
end

function MangaPoisk:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link .. "/chaptersList")
    local t = {}
    for Link, Name, subName in content:gmatch('d%-none.-href="(%S-)".-class="chapter%-title">\n(.-)</span>\n(.-)\n') do
        local sub_n = subName:gsub("%s+", " "):match("^%s*(.-)%s*$")
        t[#t + 1] = {
            Name = stringify(Name:gsub("%s+", " "):match("^%s*(.-)%s*$")) .. (sub_n ~= "" and (": " .. sub_n) or ""),
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function MangaPoisk:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. chapter.Link)
    for Link in content:gmatch('data%-alternative="(%S-)"') do
        dt[#dt + 1] = Link
        Console.write("Got " .. dt[#dt])
    end
end

function MangaPoisk:loadChapterPage(link, dt)
    dt.Link = link
end
