LoveHeaven = Parser:new("LoveHeaven", "https://loveheaven.net", "RAW", "LOVEHEAVENRAW", 1)

local function stringify(string)
    return string:gsub("&#([^;]-);", function(a)
        local x = tonumber("0" .. a) or tonumber(a)
        return x and u8c(x) or "&#" .. a .. ";"
    end):gsub("&(.-);", function(a) return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";" end)
end

local manga_list = 'https://loveheaven.net/manga-list.html?listType=pagination&page=%s&artist=&author=&group=&m_status=&name=&genre=&ungenre=&sort=%s&sort_type=%s'
local manga_srch = 'https://loveheaven.net/manga-list.html?listType=pagination&page=%s&artist=&author=&group=&m_status=&name=%s&genre=&ungenre=&sort=views&sort_type=DESC'

local function genMangaListLink(page, sort, sort_type)
    return manga_list:format(page, sort, sort_type)
end

local function genMangaSearchLink(page, search_string)
    return manga_srch:format(page, search_string)
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

function LoveHeaven:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    local pageA, pageB = content:match("Page (%d+) of (%d+)")
    for Link, ImageLink, Name in content:gmatch('<div class="col%-lg%-12 col%-md%-12.-href="(.-)".-data%-src="([^"]-)" alt="([^"]-)"') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, {Link = ImageLink, Header1 = "Referer: https://loveheaven.net/manga-list.html"}, self.ID, self.Link.."/"..Link)
        if tonumber(pageA) < tonumber(pageB) then
            dt.NoPages = false
        end
        coroutine.yield(false)
    end
end

function LoveHeaven:getPopularManga(page, dt)
    self:getManga(genMangaListLink(page, "views", "DESC"), dt)
end

function LoveHeaven:getLatestManga(page, dt)
    self:getManga(genMangaListLink(page, "last_update", "DESC"), dt)
end

function LoveHeaven:getAZManga(page, dt)
    self:getManga(genMangaListLink(page, "name", "DESC"), dt)
end

function LoveHeaven:searchManga(search, page, dt)
    self:getManga(genMangaSearchLink(page, search), dt)
end

function LoveHeaven:getChapters(manga, dt)
    local content = downloadContent(self.Link.."/"..manga.Link)
    local t = {}
    for Link, Name in content:gmatch('<a class="chapter" href=\'([^\']-)\'.-<b>(.-)</b>') do
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

function LoveHeaven:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .."/"..chapter.Link)
    for Link in content:gmatch('<img class=\'chapter%-img\' .-data%-src=\'([^\']-)\'') do
        dt[#dt + 1] = {
            Link = Link:gsub("[\r\n]",""),
            Header1 = "Referer: https://loveheaven.net/manga-list.html"
        }
    end
end

function LoveHeaven:loadChapterPage(link, dt)
    dt.Link = link
end
