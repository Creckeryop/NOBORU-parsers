if u8c then
    HentaiRead = Parser:new("HentaiRead", "https://hentairead.com", "DIF", "HENREADDIF", 1)
    
    HentaiRead.NSFW = true
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
    
    function HentaiRead:getManga(link, dest_table, is_search)
        local content = downloadContent(link)
        local t = dest_table
        local done = true
        local regex = 'page%-item%-detail manga">.-href=".-/hentai/([^"]-)/" title="([^"]-)".-data%-src="([^"]-)"'
        if is_search then
            regex = 'row c%-tabs%-item__content">.-href=".-/hentai/([^"]-)/" title="([^"]-)".-data%-src="([^"]-)"'
        end
        for Link, Name, ImageLink in content:gmatch(regex) do
            local manga = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/hentai/" .. Link)
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

    function HentaiRead:getLatestManga(page, dest_table)
        self:getManga(self.Link .. "/hentai/page/" .. page .. "/?m_orderby=latest&m_order=desc",dest_table)
    end
    
    function HentaiRead:getPopularManga(page, dest_table)
        self:getManga(self.Link .. "/hentai/page/" .. page .. "/?m_orderby=views&m_order=desc",dest_table)
    end
    
    function HentaiRead:searchManga(search, page, dest_table)
        self:getManga(self.Link .. "/page/"..page.."/?s="..search.."&post_type=wp-manga&verified=1",dest_table, true)
    end

    function HentaiRead:getChapters(manga, dest_table)
        local content = downloadContent(self.Link.."/hentai/"..manga.Link):match("page%-content%-listing single%-page(.-)</ul>") or ""
        for Link, Name in content:gmatch('wp%-manga%-chapter[^>]->[^<]-<a href=".-/hentai/([^"]-)/">.-\n*([^<]-)</a>') do
            dest_table[#dest_table+1] = {
                Name = stringify(Name):gsub("&emsp;"," "),
				Link = Link,
				Pages = {},
				Manga = manga
            }
        end
    end
    
    function HentaiRead:prepareChapter(chapter, dest_table)
        local content = downloadContent(self.Link .."/hentai/".. chapter.Link .. "/english"):match("var chapter_preloaded_images = %[(.-)%]") or ""
        local t = dest_table
        for Link in content:gmatch('"([^"]-)"') do
            t[#t + 1] = Link:gsub("\\/","/")
            Console.write("Got " .. t[#t])
        end
    end

    function HentaiRead:loadChapterPage(link, dest_table)
        dest_table.Link = link
    end
end
