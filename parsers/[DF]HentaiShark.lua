HentaiShark = Parser:new("Hentai Shark", "https://readhent.ai", "DIF", "HENSHARKDIF", 2)

HentaiShark.NSFW = true

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
        Index = "text",
        Header1 = "accept-language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7"
    })
    while Threads.check(f) do
        coroutine.yield(false)
    end
    return f.text or ""
end

function HentaiShark:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name, flag in content:gmatch('manga%-cover%-frontend">.-href="[^"]-/manga/([^"]-)".-src=\'([^\']-)\' alt=\'([^>]-)\'>[^<]-</div>.-flag%-([^"]-)"') do
        if flag == "gb" then flag = "en" end
        dt[#dt + 1] = CreateManga("[" .. flag:upper() .. "] " .. stringify(Name), Link, ImageLink, self.ID, self.Link .. "/manga/" .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function HentaiShark:getLatestManga(page, dt)
    self:getManga(self.Link .. "/manga-list?page=" .. page .. "&sortBy=created_at&asc=false", dt)
end

function HentaiShark:getPopularManga(page, dt)
    self:getManga(self.Link .. "/manga-list?fl=1&page=" .. page .. "&sortBy=views&asc=false", dt)
end

function HentaiShark:searchManga(search, page, dt)
    self:getManga(self.Link .. "/advanced-search?fl=1&params=name%3D" .. search .. "%26author%3D&page=" .. page, dt)
end

function HentaiShark:getChapters(manga, dt)
    dt[#dt + 1] = {
        Name = "Read chapter",
        Link = manga.Link,
        Pages = {},
        Manga = manga
    }
end

function HentaiShark:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/manga/" .. chapter.Link .. "/1/1")
    for Link in content:gmatch("data%-src=' (%S-) '") do
        dt[#dt + 1] = Link
        Console.write("Got " .. dt[#dt])
    end
end

function HentaiShark:loadChapterPage(link, dt)
    dt.Link = link
end
