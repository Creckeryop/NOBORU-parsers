BRMangas = Parser:new("BRMangas", "https://www.brmangas.com", "PRT", "BRMANGASPT", 1)

local function stringify(string)
    if u8c then
        return string:gsub(
            "&#([^;]-);",
            function(a)
                local number = tonumber("0" .. a) or tonumber(a)
                return number and u8c(number) or "&#" .. a .. ";"
            end
        ):gsub(
            "&([^;]-);",
            function(a)
                return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
            end
        )
    else
        return string
    end
end

local function downloadContent(link)
    local file = {}
    Threads.insertTask(
        file,
        {
            Type = "StringRequest",
            Link = link,
            Table = file,
            Index = "string"
        }
    )
    while Threads.check(file) do
        coroutine.yield(false)
    end
    return file.string or ""
end

function BRMangas:getManga(content, dt)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch('class="item".-href="[^"]-/manga/(.-)/".-img[^>]-src="(.-)".-titulo[^"]-">(.-)</h2>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/manga/" .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function BRMangas:getPopularManga(page, dt)
    local content = downloadContent(self.Link .. "/page/" .. page):match("Todos[^<]-os[^<]-<em>Mangás</em>(.-)$") or ""
    self:getManga(content, dt)
end

function BRMangas:getLatestManga(page, dt)
    local content = downloadContent(self.Link .. "/category/mangas/page/" .. page)
    self:getManga(content, dt)
end

function BRMangas:searchManga(search, page, dt)
    local content = downloadContent(self.Link .. "/page/" .. page .. "/?s=" .. search)
    self:getManga(content, dt)
end

function BRMangas:getChapters(manga, dt)
    local content = downloadContent(self.Link .. "/manga/" .. manga.Link)
    dt.Description = (content:match('manga_sinopse">.-</div>(.-)</div>') or ""):gsub("<[^>]->",""):gsub("^\n+",""):gsub("\n+$","")
    for link, name in content:gmatch('row lista_ep.-href="[^"]-/ler/(.-)/"[^>]->(.-)</a>') do
        dt[#dt + 1] = {
            Name = stringify(name),
            Link = link,
            Pages = {},
            Manga = manga
        }
    end
end

function BRMangas:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/ler/" .. chapter.Link):match('imageArray[^:]-":(.-)[\n\r]') or ""
    for link in content:gmatch('\\"([^"]-)\\"') do
        dt[#dt + 1] = link:gsub("\\/", "/"):gsub("%%", "%%%%")
    end
end

function BRMangas:loadChapterPage(link, dt)
    dt.Link = link
end
