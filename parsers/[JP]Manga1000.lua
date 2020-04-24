if u8c then
    Manga1000 = Parser:new("Manga1000", "http://manga1000.com", "JAP", "MANGA1000JP", 1)
    
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
    
    local function to_hex(a)
        return string.byte(a)>127 and "%"..string.format("%02X",string.byte(a)) or a
    end

    function Manga1000:getManga(link, dest_table)
        local content = downloadContent(link)
        local t = dest_table
        local done = true
        for Link, ImageLink, Name, Categories in content:gmatch('article%-wrap%-inner">.-href=".-/([^/]*)/?".-src="(%S-)".-rel="bookmark">([^<%(]*).-<span class="cat%-links">(.-)</span>') do
            local catlist = {}
            for category in Categories:gmatch("<a[^>]->(.-)</a>") do
                catlist[#catlist+1] = category
            end
            local manga = CreateManga(stringify(Name), Link, ImageLink:gsub("^https","http"):gsub(".", to_hex), self.ID, table.concat(catlist," / "))
            t[#t + 1] = manga
            done = false
            coroutine.yield(false)
        end
        if done then
            t.NoPages = true
        end
    end

    function Manga1000:getLatestManga(page, dest_table)
        self:getManga(self.Link .. "/page/" .. page, dest_table)
    end
    
    function Manga1000:getPopularManga(page, dest_table)
        self:getManga(self.Link .. "/seachlist/page/" .. page.."/?cat=-1", dest_table)
    end
    
    function Manga1000:searchManga(search, page, dest_table)
        self:getManga(self.Link .. "/page/" .. page.."/?s="..search:gsub(".",to_hex), dest_table)
    end
    
    function Manga1000:getChapters(manga, dest_table)
        local content = downloadContent(self.Link.."/"..manga.Link)
        local t = {}
        for Link, Name in content:gmatch('<tr><td>.-<a[^>]-href=".-/([^/]*)/?">(.-)</a>') do
            t[#t+1] = {
                Name = Name,
				Link = Link,
				Pages = {},
				Manga = manga
            }
        end
        for i = #t, 1, -1 do
            dest_table[#dest_table + 1] = t[i]
        end
    end
    
    function Manga1000:prepareChapter(chapter, dest_table)
        local content = downloadContent(self.Link.."/"..chapter.Link)
        local t = dest_table
        for Link in content:gmatch('src="(%S-)" alt') do
            t[#t + 1] = Link:gsub("^https://","")
            Console.write("Got " .. t[#t])
        end
    end

    function Manga1000:loadChapterPage(link, dest_table)
        dest_table.Link = {
			Link = link,
			Header1 = "referer: https://manga1000.com"
		}
    end
end
