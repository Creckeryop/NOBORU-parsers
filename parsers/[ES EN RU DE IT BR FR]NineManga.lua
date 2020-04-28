if Settings.Version > 0.35 then
    ESNineManga = Parser:new("NineManga Español", "http://es.ninemanga.com", "ESP", "NINEMANGASPA", 3)
    
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
            Header1 = "Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7"
        })
        while Threads.check(f) do
            coroutine.yield(false)
        end
        return f.text or ""
    end
    
    function ESNineManga:getManga(link, dt)
        local content = downloadContent(link)
        dt.NoPages = true
        for Link, ImageLink, Name in content:gmatch('bookinfo.-href="([^"]-)".-src="([^"]-)".-bookname"[^>]->([^<]-)</a>') do
            dt[#dt + 1] = CreateManga(stringify(Name), Link:gsub("%%", "%%%%"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
            dt.NoPages = false
            coroutine.yield(false)
        end
    end
    
    function ESNineManga:getPopularManga(page, dt)
        self:getManga(self.Link .. "/category/index_" .. page .. ".html", dt)
    end
    
    function ESNineManga:searchManga(search, page, dt)
        self:getManga(self.Link .. "/search/?name_sel=&wd=" .. search .. "&page=" .. page .. ".html", dt)
    end
    
    function ESNineManga:getChapters(manga, dt)
        local content = downloadContent(manga.Link .. "?waring=1")
        local t = {}
        for Link, Name in content:gmatch('chapter_list_a" href="([^"]-)"[^>]->([^<]-)</a>') do
            t[#t + 1] = {
                Name = stringify(Name),
                Link = Link:gsub("%%", "%%%%"),
                Pages = {},
                Manga = manga
            }
        end
        for i = #t, 1, -1 do
            dt[#dt + 1] = t[i]
        end
    end
    
    function ESNineManga:prepareChapter(chapter, dt)
        local content = downloadContent(chapter.Link):match("changepage(.-)</div>") or ""
        for Link in content:gmatch('value="([^"]-)"[^>]->') do
            dt[#dt + 1] = Link:gsub("%%", "%%%%")
            Console.write("Got " .. dt[#dt])
        end
    end
    
    function ESNineManga:loadChapterPage(link, dt)
        dt.Link = downloadContent(self.Link .. link):match('.+img src="([^"]-)".-$'):gsub("%%", "%%%%") or ""
    end
    ENNineManga = ESNineManga:new("NineManga English", "http://ninemanga.com", "ENG", "NINEMANGAENG", 3)
    RUNineManga = ESNineManga:new("NineManga Россия", "http://ru.ninemanga.com", "RUS", "NINEMANGARUS", 3)
    DENineManga = ESNineManga:new("NineManga Deutschland", "http://de.ninemanga.com", "DEU", "NINEMANGAGER", 4)
    ITNineManga = ESNineManga:new("NineManga Italy", "http://it.ninemanga.com", "ITA", "NINEMANGAITA", 3)
    BRNineManga = ESNineManga:new("NineManga Brazil", "http://br.ninemanga.com", "BRA", "NINEMANGABRA", 3)
end
