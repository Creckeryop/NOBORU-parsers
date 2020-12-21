DoujinHentai = Parser:new("DoujinHentai", "https://www.doujinhentai.net", "ESP", "DOUJINHENTAIESP", 2)

DoujinHentai.NSFW = true

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

function DoujinHentai:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, Name, ImageLink in content:gmatch('class="col%-sm%-6 col%-md%-3.-href="([^"]-)".-title="(.-)">.-<img data%-src="(.-)" class') do
        dt[#dt + 1] = CreateManga(stringify(Name:gsub("^Leer ", "")), Link:gsub("%%", "%%%%"):gsub(" ", "%%%%20"):match("/manga%-hentai/(.+)$") or " ", ImageLink:gsub("%%", "%%%%"):gsub(" ", "%%%%20"), self.ID, Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function DoujinHentai:getPopularManga(page, dt)
    self:getManga(self.Link .. "/lista-manga-hentai?orderby=views&page=" .. page, dt)
end

function DoujinHentai:getLatestManga(page, dt)
    self:getManga(self.Link .. "/lista-manga-hentai?orderby=last&page=" .. page, dt)
end

function DoujinHentai:getAZManga(page, dt)
    self:getManga(self.Link .. "/lista-manga-hentai?page=" .. page, dt)
end

function DoujinHentai:searchManga(search, page, dt)
    local content = downloadContent(self.Link .. "/search?query=" .. search .. "&page=" .. page)
    dt.NoPages = true
    for Link, Name, ImageLink in content:gmatch('class="tab%-thumb c%-image%-hover">.-href="([^"]-)" title="(.-)">.-data%-src=\'([^\']-)\'') do
        dt[#dt + 1] = CreateManga(stringify(Name:gsub("^Leer ", "")), Link:gsub("%%", "%%%%"):gsub(" ", "%%%%20"):match("/manga%-hentai/(.+)$") or " ", ImageLink:gsub("%%", "%%%%"):gsub(" ", "%%%%20"), self.ID, Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function DoujinHentai:getChapters(manga, dt)
    local content = downloadContent(self.Link .. "/manga-hentai/" .. manga.Link)
    local t = {}
    for Link, Name in content:gmatch('ion%-ios%-play">.-href="(.-)">(.-)</a>') do
        Link = Link:gsub("%%", "%%%%"):gsub(" ", "%%%%20")
        t[#t + 1] = {
            Name = stringify(Name),
            Link = Link:match("/([^/]-)$"),
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function DoujinHentai:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/manga-hentai/" .. chapter.Manga.Link .. "/" .. chapter.Link)
    for Link in content:match("id=\"all\"(.-)id=\"ppp\""):gmatch('data%-src=\' (.-) \'') do
        dt[#dt + 1] = Link
    end
end

function DoujinHentai:loadChapterPage(link, dt)
    dt.Link = link
end
