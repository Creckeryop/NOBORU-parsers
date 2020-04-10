if u8c then
    BatoTo = Parser:new("Bato.TO", "https://bato.to", "DIF", "BATODIF", 1)
    
    local function stringify(string)
        return string:gsub("&#([^;]-);", function(a)
            local number = tonumber("0" .. a) or tonumber(a)
            return number and u8c(number) or "&#" .. a .. ";"
        end)
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
    
    local langs = {
        RUS = "russian",
        ENG = "english",
        BRA = "brazilian",
        FRA = "french",
        POL = "polish",
        DEU = "german",
        SPA = "spanish",
        TUR = "turkish",
        ITA = "italian",
        VIE = "vietnamese",
        PRT = "portuguese"
    }

    local cntrys = {
        russia = "RUS",
        england = "ENG",
        mexico = "MEX",
        brazil = "BRA",
        france = "FRA",
        poland = "POL",
        spain = "SPA",
        germany = "DEU",
        turkey = "TUR",
        italy = "ITA",
        vietnam = "VIE",
        portugal = "PRT"
    }


    function BatoTo:getManga(link, dest_table)
        local content
        if link:find("latest") then
            content = downloadContent(link):match('id="series%-list"(.-)class="footer') or ""
        else
            content = downloadContent(link):match('id="series%-list"(.-)class="browse%-pager"') or ""
        end
        local t = dest_table
        local done = true
        for block in content:gmatch(' item (.-)class="col%-24') do
            local flag = not block:find("no%-flag")
            local cntry = "england"
            if flag then
                cntry = block:match('flag_(.-)"')
            end
            ImageLink, Link, Name = block:match('cover.-src="//([^"]-)".-item%-text.-href="([^"]-)"[^>]->(.-)</a>')
            Name = Name:gsub("<.->","")
            local manga = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
            if manga and (cntrys[cntry] == Settings.ParserLanguage or Settings.ParserLanguage == "DIF") then
                if Settings.ParserLanguage == "DIF" then
                    manga.Name = "["..(cntrys[cntry] or (cntry:sub(0, 3):upper())).."] "..manga.Name
                end
                t[#t + 1] = manga
            end
            done = false
            coroutine.yield(false)
        end
        if done then
            t.NoPages = true
        end
    end

    function BatoTo:getLatestManga(page, dest_table)
        local addition = ""
        if Settings.ParserLanguage ~= "DIF" and langs[Settings.ParserLanguage] then
            addition = "&langs="..langs[Settings.ParserLanguage]
        end
        self:getManga(self.Link .. "/latest?page=" .. page..addition,dest_table)
    end
    
    function BatoTo:getPopularManga(page, dest_table)
        local addition = ""
        if Settings.ParserLanguage ~= "DIF" and langs[Settings.ParserLanguage] then
            addition = "&langs="..langs[Settings.ParserLanguage]
        end
        self:getManga(self.Link .. "/browse?page=" .. page..addition,dest_table)
    end
    
    function BatoTo:searchManga(search, page, dest_table)
        self:getManga(self.Link .. "/search?q="..search.."&p="..page,dest_table)
    end

    function BatoTo:getChapters(manga, dest_table)
        local content = downloadContent(self.Link..manga.Link)
        local t = {}
        for Link, Name in content:gmatch('chapt" href="([^"]-)">.-<b>(.-)</a>') do
            Name = Name:gsub("\n%s*(.-)\n%s*"," %1")
            Name = stringify(Name):gsub("<.->","")
            t[#t+1] = {
                Name = Name:gsub(" %- Read Online",""),
				Link = Link,
				Pages = {},
				Manga = manga
            }
        end
        for i = #t, 1, -1 do
            dest_table[#dest_table + 1] = t[i]
        end
    end
    
    function BatoTo:prepareChapter(chapter, dest_table)
        local content = downloadContent(self.Link .. chapter.Link)
        local t = dest_table
        for Link in content:gmatch('"%d-":"([^"]-)"') do
            t[#t + 1] = Link
            Console.write("Got " .. t[#t])
        end
    end

    function BatoTo:loadChapterPage(link, dest_table)
        dest_table.Link = link
    end
end
