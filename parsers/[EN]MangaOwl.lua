MangaOwl = Parser:new("MangaOwl", "https://mangaowl.net", "ENG", "MANGAOWLEN", 2)

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

function MangaOwl:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for ImageLink, Link, Name in content:gmatch('comicView".-image="(%S-)".-agileits_w3layouts_mid_1_home">.-href="(%S-)".->([^<]-)</a>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link:match("single/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function MangaOwl:getPopularManga(page, dt)
    self:getManga(self.Link .. "/popular/" .. page, dt)
end

function MangaOwl:getLatestManga(page, dt)
    self:getManga(self.Link .. "/lastest/" .. page, dt)
end

function MangaOwl:searchManga(search, page, dt)
    self:getManga(self.Link .. "/search/" .. search .. "/" .. page, dt)
end

function MangaOwl:getChapters(manga, dt)
    local content = downloadContent(self.Link .. "/single/" .. manga.Link)
    local t = {}
    for Link, Name in content:gmatch('chapter_list">.-href="([^"]-)".-chapter%-title">[ \n\r]+(.-)[ \n\r]-</label>') do
        t[#t + 1] = {
            Name = stringify(Name),
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function MangaOwl:prepareChapter(chapter, dt)
    local content = downloadContent(chapter.Link)
    for Link in content:gmatch('owl%-lazy" data%-src="(%S-)"') do
        dt[#dt + 1] = Link
        Console.write("Got " .. dt[#dt])
    end
end

function MangaOwl:loadChapterPage(link, dt)
    dt.Link = link
end
