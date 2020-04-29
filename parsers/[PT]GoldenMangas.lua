GoldenMangas = Parser:new("GoldenMangas", "https://www.goldenmangas.online", "PRT", "GOLDENMANGAS", 1)

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

function GoldenMangas:getManga(link, key, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch(key .. '.-href="([^"]-)".-src="(.-)".-<h3.->(.-)</h3>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, self.Link .. ImageLink, self.ID, self.Link .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function GoldenMangas:getPopularManga(_, dt)
    self:getManga(self.Link, "itemmanga", dt)
    dt.NoPages = true
end

function GoldenMangas:getLatestManga(page, dt)
    self:getManga(self.Link .. "/index.php?pagina=" .. page, "atualizacao", dt)
end

function GoldenMangas:searchManga(search, page, dt)
    self:getManga(self.Link .. "/mangabr?busca=" .. search .. "&pagina=" .. page, "mangas col", dt)
end

function GoldenMangas:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link)
    local t = {}
    for Link, Name in content:gmatch('class="row" style.-href="([^"]-)".-</i>.-\n%s+(.-)%s+<span') do
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

function GoldenMangas:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. chapter.Link)
    for link in content:gmatch('img src="([^"]-)" class="img%-responsive img%-manga') do
        dt[#dt + 1] = self.Link .. link
        Console.write("Got " .. dt[#dt])
    end
end

function GoldenMangas:loadChapterPage(link, dt)
    dt.Link = link
end
