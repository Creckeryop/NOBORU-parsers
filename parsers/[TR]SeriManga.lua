SeriManga = Parser:new("SeriManga", "https://serimanga.com", "TUR", "SERIMANGATR", 1)

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

function SeriManga:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch('mangas%-item">.-href="[^"]-(/manga/[^"]-)".-url%(\'([^"]-)\'%).-"mlb%-name">([^<]-)</span>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link..Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function SeriManga:getPopularManga(page, dt)
    self:getManga(self.Link .. "/mangalar?filtrele=goruntulenme&sirala=DESC&page=" .. page, dt)
end

function SeriManga:searchManga(search, page, dt)
    self:getManga(self.Link .. "/mangalar?search=" .. search .. "&page=" .. page, dt)
end

function SeriManga:getChapters(manga, dt)
    local t = {}
    local next = self.Link..manga.Link
    repeat
        local content = downloadContent(next)
        for Link, Name in content:gmatch('spl%-list%-item">[^"]-href="[^"]-(/manga/[^"]-)" title="([^"]-)"') do
            t[#t + 1] = {
                Name = stringify(Name):gsub("^"..manga.Name,""):gsub("^[ -]+",""),
                Link = Link,
                Pages = {},
                Manga = manga
            }
        end
        next = content:match('"page%-link" href="([^"]-)" rel="next"')
    until not next
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function SeriManga:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link..chapter.Link)
    for Link in content:gmatch('<img class="chapter%-pages__[^<]-src="([^"]-)"') do
        dt[#dt + 1] = Link
        Console.write("Got " .. dt[#dt])
    end
end

function SeriManga:loadChapterPage(link, dt)
    dt.Link = link
end
