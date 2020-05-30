nhentai = Parser:new("nhentai", "https://nhentai.net", "DIF", "NHENTAI", 1)

nhentai.NSFW = true

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

function nhentai:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch('class="gallery".-href="(%S-)".-data%-src="(%S-)".->([^<]-)</div>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function nhentai:getPopularManga(page, dt)
    self:getManga(self.Link .. "/?page=" .. page, dt)
end

function nhentai:searchManga(search, page, dt)
    self:getManga(self.Link .. "/search/?q=" .. search .. "&page=" .. page, dt)
end

function nhentai:getChapters(manga, dt)
    dt[#dt + 1] = {
        Name = "Read chapter",
        Link = manga.Link,
        Pages = {},
        Manga = manga
    }
end

function nhentai:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. chapter.Link)
    for link in content:gmatch('class="gallerythumb".-href="(%S-)"') do
        dt[#dt + 1] = self.Link .. link
    end
end

function nhentai:loadChapterPage(link, dt)
    dt.Link = downloadContent(link):match('image%-container">.-src="(%S-)"')
end
