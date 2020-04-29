MangaReader = Parser:new("MangaReader", "https://www.mangareader.net", "ENG", "MANGAREADEREN", 1)

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

function MangaReader:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for ImageLink, Link, Name in content:gmatch('image:url%(\'(%S-)\'.-<div class="manga_name">.-<a href="(%S-)">(.-)</a>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function MangaReader:getPopularManga(page, dt)
    self:getManga(self.Link .. "/popular/" .. ((page - 1) * 30), dt)
end

function MangaReader:searchManga(search, page, dt)
    self:getManga(self.Link .. "/search/?w=" .. search .. "&rd=&status=&order=&genre=&p=" .. ((page - 1) * 30), dt)
end

function MangaReader:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link):match('id="chapterlist"(.+)$') or ""
    for Link, Name, subName in content:gmatch('chico_manga.-<a href%="/.-(/%S-)">(.-)</a>(.-)</td>') do
        dt[#dt + 1] = {
            Name = stringify(Name .. subName),
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
end

function MangaReader:prepareChapter(chapter, dt)
    local count = downloadContent(self.Link .. chapter.Manga.Link .. chapter.Link .. "#"):match("</select> of (.-)<") or 0
    for i = 1, count do
        dt[i] = self.Link .. chapter.Manga.Link .. chapter.Link .. "/" .. i
        Console.write("Got " .. dt[i])
    end
end

function MangaReader:loadChapterPage(link, dest_table)
    dest_table.Link = downloadContent(link):match('id="img".-src="(.-)"')
end

MangaPanda = MangaReader:new("MangaPanda", "https://www.mangapanda.com", "ENG", "MANGAPANDAEN", 1)
