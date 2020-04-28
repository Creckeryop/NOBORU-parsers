HentaiCafe = Parser:new("HentaiCafe", "https://hentai.cafe", "ENG", "HENCAFENG", 1)

HentaiCafe.NSFW = true

local function stringify(string)
    if u8c then
        return string:gsub("&#([^;]-);", function(a)
            local number = tonumber("0" .. a) or tonumber(a)
            return number and u8c(number) or "&#" .. a .. ";"
        end):gsub("&([^;]-);", function(a) return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&"..a..";" end)
    else
        return string
    end
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

function HentaiCafe:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch('article.-href=".-/(%d-)".-src="(%S-)".-entry%-title">.-<a href.->(.-)</a>') do
        dt[#dt + 1] = CreateManga(stringify(Name:gsub("<[^>]->","")), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .."/hc.fyi/".. Link)
        dt.NoPages  = false
        coroutine.yield(false)
    end
end

function HentaiCafe:getPopularManga(page, dt)
    self:getManga(self.Link.."/page/"..page, dt)
end

function HentaiCafe:searchManga(search, page, dt)
    self:getManga(self.Link.."/page/"..page.."?s=" .. search, dt)
end

function HentaiCafe:getChapters(manga, dt)
    local content = downloadContent(self.Link .."/hc.fyi/".. manga.Link)
    manga.Name = stringify(content:match('<h1 class="entry-title">(.-)</h1>') or manga.Name)
    local link, name = content:match('/manga/read/(.-)"'), "Read chapter"
    if link then
        dt[#dt + 1] = {
            Name = name,
            Link = link,
            Pages = {},
            Manga = manga
        }
    end
end

function HentaiCafe:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/manga/read/"..chapter.Link)
    for link in content:gmatch('"url"%s?:%s?"(%S-)"') do
        dt[#dt + 1] = link:gsub("\\/","/"):gsub("%%","%%%%")
        Console.write("Got " .. dt[#dt])
    end
end

function HentaiCafe:loadChapterPage(link, dt)
    dt.Link = link
end