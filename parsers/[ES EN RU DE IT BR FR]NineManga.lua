if Settings.Version > 0.35 then
    ESNineManga = Parser:new("NineManga Español", "http://es.ninemanga.com", "ESP", "NINEMANGASPA",1)

    local pt = {
        ["&Agrave;"] = "À",
        ["&Aacute;"] = "Á",
        ["&Acirc;"] = "Â",
        ["&Atilde;"] = "Ã",
        ["&Ccedil;"] = "Ç",
        ["&Egrave;"] = "È",
        ["&Eacute;"] = "É",
        ["&Ecirc;"] = "Ê",
        ["&Igrave;"] = "Ì",
        ["&Iacute;"] = "Í",
        ["&Iuml;"] = "Ï",
        ["&Ograve;"] = "Ò",
        ["&Oacute;"] = "Ó",
        ["&Otilde;"] = "Õ",
        ["&Ugrave;"] = "Ù",
        ["&Uacute;"] = "Ú",
        ["&Uuml;"] = "Ü",
        ["&agrave;"] = "à",
        ["&aacute;"] = "á",
        ["&acirc;"] = "â",
        ["&atilde;"] = "ã",
        ["&ccedil;"] = "ç",
        ["&egrave;"] = "è",
        ["&eacute;"] = "é",
        ["&ecirc;"] = "ê",
        ["&igrave;"] = "ì",
        ["&iacute;"] = "í",
        ["&iuml;"] = "ï",
        ["&ograve;"] = "ò",
        ["&oacute;"] = "ó",
        ["&otilde;"] = "õ",
        ["&ugrave;"] = "ù",
        ["&uacute;"] = "ú",
        ["&uuml;"] = "ü",
        ["&ordf;"] = "ª",
        ["&ordm;"] = "º",

    }
    local function stringify(str)
        for k, v in pairs(pt) do
            str = str:gsub(k, v)
        end
        return str
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

    function ESNineManga:getManga(link, dest_table)
        local content = downloadContent(link)
        local t = dest_table
        local done = true
        for Link,ImageLink,Name in content:gmatch('bookinfo.-href="([^"]-)".-src="([^"]-)".-bookname"[^>]->([^<]-)</a>') do
            local manga = CreateManga(stringify(Name), Link:gsub("%%","%%%%"), ImageLink:gsub("%%","%%%%"), self.ID, Link)
            if manga then
                t[#t + 1] = manga
                done = false
            end
            coroutine.yield(false)
        end
        if done then
            t.NoPages = true
        end
    end

    function ESNineManga:getPopularManga(page, dest_table)
        self:getManga(self.Link.."/category/index_"..page..".html", dest_table)
    end

    function ESNineManga:searchManga(search, page, dest_table)
        self:getManga(self.Link.."/search/?name_sel=&wd="..search.."&page="..page..".html", dest_table)
    end

    function ESNineManga:getChapters(manga, dest_table)
        local content = downloadContent(manga.Link.."?waring=1")
        local t = {}
        for Link, Name in content:gmatch('chapter_list_a" href="([^"]-)"[^>]->([^<]-)</a>') do
            t[#t + 1] = {
                Name = stringify(Name),
                Link = Link:gsub("%%","%%%%"),
                Pages = {},
                Manga = manga
            }
        end
        for i = #t, 1, -1 do
            dest_table[#dest_table + 1] = t[i]
        end
    end

    function ESNineManga:prepareChapter(chapter, dest_table)
        local content = downloadContent(chapter.Link)
        local t = dest_table
        content = content:match("changepage(.-)</div>") or ""
        for Link in content:gmatch('value="([^"]-)"[^>]->') do
            t[#t + 1] = Link:gsub("%%","%%%%")
            Console.write("Got " .. t[#t])
        end
    end

    function ESNineManga:loadChapterPage(link, dest_table)
        local file = {}
        Threads.insertTask(file, {
            Type = "StringRequest",
            Link = self.Link..link,
            Table = file,
            Index = "string",
            Header1 = "Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7"
        })
        while Threads.check(file) do
            coroutine.yield(false)
        end
        local content = file.string or ""
        dest_table.Link = content:match('.+img src="([^"]-)".-$'):gsub("%%","%%%%") or ""
    end
    ENNineManga = ESNineManga:new("NineManga English", "http://ninemanga.com", "ENG", "NINEMANGAENG",1)
    RUNineManga = ESNineManga:new("NineManga Россия", "http://ru.ninemanga.com", "RUS", "NINEMANGARUS",1)
    DENineManga = ESNineManga:new("NineManga Deutschland", "http://de.ninemanga.com", "DEU", "NINEMANGAGER", 2)
    ITNineManga = ESNineManga:new("NineManga Italy", "http://it.ninemanga.com", "ITA", "NINEMANGAITA",1)
    BRNineManga = ESNineManga:new("NineManga Brazil", "http://br.ninemanga.com", "BRA", "NINEMANGABRA",1)
end