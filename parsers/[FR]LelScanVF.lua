LelScanVF = Parser:new("LELSCAN-VF", "https://www.lelscan-vf.com", "FRA", "LELSCANFRA", 1)

local function stringify(string)
    return string:gsub("&#([^;]-);", function(a)
        local x = tonumber("0" .. a) or tonumber(a)
        return x and u8c(x) or "&#" .. a .. ";"
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

function LelScanVF:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch("<a href=\"([^\"]-)\" class=\"thumbnail\">[^>]-src='([^']-)' alt='([^']-)'>[^<]-</a>") do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function LelScanVF:getPopularManga(page, dt)
    self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function LelScanVF:searchManga(search, page, dt)
    self:getManga(self.Link .. "/filterList?alpha=" .. search .. "&sortBy=views&asc=false&page=" .. page, dt)
end

function LelScanVF:getChapters(manga, dt)
    local content = downloadContent(manga.Link)
    local t = {}
    for Link, Name, SubName in content:gmatch("chapter%-title%-rtl\">[^<]-<a href=\"([^\"]-)\">([^<]-)</a>.-<em>(.-)</em>") do
        t[#t + 1] = {
            Name = stringify(Name .. (SubName ~= "" and (":" .. SubName) or "")),
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function LelScanVF:prepareChapter(chapter, dt)
    local content = downloadContent(chapter.Link)
    for Link in content:gmatch("img%-responsive\"[^>]-data%-src=' ([^']-) '") do
        dt[#dt + 1] = Link
        Console.write("Got " .. dt[#dt])
    end
end

function LelScanVF:loadChapterPage(link, dt)
    dt.Link = link
end
