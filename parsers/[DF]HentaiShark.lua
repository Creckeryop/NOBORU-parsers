if u8c then
    HentaiShark = Parser:new("Hentai Shark", "https://readhent.ai", "DIF", "HENSHARKDIF", 1)
    
    HentaiShark.NSFW = true
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
            Index = "string",
            Header1 = "accept-language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7"
        })
        while Threads.check(file) do
            coroutine.yield(false)
        end
        return file.string or ""
    end
    
    function HentaiShark:getManga(link, dest_table)
        local content = downloadContent(link)
        local t = dest_table
        local done = true
        for Link, ImageLink, Name, flag in content:gmatch('manga%-cover%-frontend">.-href="[^"]-/manga/([^"]-)".-src=\'([^\']-)\' alt=\'([^>]-)\'>[^<]-</div>.-flag%-([^"]-)"') do
            if flag=="gb" then flag="en" end
            local manga = CreateManga("["..flag:upper().."]"..stringify(Name), Link, ImageLink, self.ID, self.Link .. "/manga/" .. Link)
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

    function HentaiShark:getLatestManga(page, dest_table)
        self:getManga(self.Link .. "/manga-list?page="..page.."&sortBy=created_at&asc=false",dest_table)
    end
    
    function HentaiShark:getPopularManga(page, dest_table)
        self:getManga(self.Link .. "/manga-list?fl=1&page=" .. page .. "&sortBy=views&asc=false",dest_table)
    end
    
    function HentaiShark:searchManga(search, page, dest_table)
        self:getManga(self.Link .. "/advanced-search?fl=1&params=name%3D"..search.."%26author%3D&page="..page, dest_table)
    end

    function HentaiShark:getChapters(manga, dest_table)
        dest_table[#dest_table+1] = {
            Name = "Read chapter",
            Link = manga.Link,
            Pages = {},
            Manga = manga
        }
    end
    
    function HentaiShark:prepareChapter(chapter, dest_table)
        local content = downloadContent(self.Link .."/manga/".. chapter.Link .. "/1/1")
        local t = dest_table
        for Link in content:gmatch("data%-src=' (%S-) '") do
            t[#t + 1] = Link
            Console.write("Got " .. t[#t])
        end
    end

    function HentaiShark:loadChapterPage(link, dest_table)
        dest_table.Link = link
    end
end
