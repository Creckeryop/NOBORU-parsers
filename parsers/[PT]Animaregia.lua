Animeregia = Parser:new("Animeregia", "https://animaregia.net", "PRT", "ANIMEREGIAPTG", 1)

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

function Animeregia:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch("<a href=\"([^\"]-)\" class=\"thumbnail\">[^>]-src='([^']-)' alt='([^']-)'>[^<]-</a>") do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, self.Link .. ImageLink, self.ID, Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function Animeregia:getPopularManga(page, dt)
    self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function Animeregia:getLatestManga(page, dt)
    local content = downloadContent(self.Link .. "/latest-release?page=" .. page)
    dt.NoPages = true
    for Link, Name in content:gmatch('manga%-item.-href="([^"]-)">(.-)</a>') do
        local key = Link:match("manga/(.*)/?") or ""
        dt[#dt + 1] = CreateManga(stringify(Name), Link, self.Link .. "/uploads/manga/"..key.."/cover/cover_250x350.jpg", self.ID, Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function Animeregia:searchManga(search, page, dt)
    self:getManga(self.Link .. "/filterList?alpha=" .. search .. "&sortBy=views&asc=false&page=" .. page, dt)
end

function Animeregia:getChapters(manga, dt)
    local content = downloadContent(manga.Link)
    local t = {}
    for Link, Name in content:gmatch("chapter%-title%-rtl\">[^<]-<a href=\"([^\"]-)\">([^<]-)</a>") do
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

function Animeregia:prepareChapter(chapter, dt)
    local content = downloadContent(chapter.Link)
    for Link in content:gmatch("img%-responsive\"[^>]-data%-src=' ([^']-) '") do
        dt[#dt + 1] = Link
        Console.write("Got " .. dt[#dt])
    end
end

function Animeregia:loadChapterPage(link, dt)
    dt.Link = link
end
