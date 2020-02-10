if Settings.Version > 0.32 then
    MangaTR = Parser:new("MangaTR", "https://manga-tr.com", "TUR", "MANGATRTR")

    local notify = false

    local function stringify(string)
        if not u8c then
            if not notify then
                Notifications.push("Please update app, to see fixed titles")
                notify = true
            end
            return string
        end
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

    function MangaTR:getManga(link, dest_table)
        local content = downloadContent(link)
        local t = dest_table
        local done = true
        for ImageLink, Link, Name in content:gmatch('media%-object img.-src="(%S-)".-href="(%S-)">([^<]-)<') do
            local manga = CreateManga(stringify(Name), Link, ImageLink:find("^http") and ImageLink or self.Link.."/"..ImageLink, self.ID, self.Link.."/".. Link)
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

    function MangaTR:getPopularManga(page, dest_table)
        self:getManga(self.Link.."/manga-list.html?listType=pagination&page="..page.."&durum=&ceviri=&yas=&icerik=&artist=&author=&name=&tur=&sort=views&sort_type=DESC", dest_table)
    end

    function MangaTR:getLatestManga(page, dest_table)
        self:getManga(self.Link.."/manga-list.html?listType=pagination&page="..page.."&durum=&ceviri=&yas=&icerik=&artist=&author=&name=&tur=&sort=last_update&sort_type=DESC", dest_table)
    end

    if not u8c then
        function MangaTR:searchManga(search, page, dest_table)
            Notifications.push("Parser don't support search feature")
            Notifications.push("Please update App")
        end
    end

    function MangaTR:getChapters(manga, dest_table)
        local content = downloadContent(self.Link.."/"..manga.Link)
        local fetch_link = content:match('(/cek/fetch_pages_manga%.php%?manga_cek=.-)"')
        local t = {}
        local page = 1
        while true do
            local file = {}
            Threads.insertTask(file, {
                Type = "StringRequest",
                Link = self.Link..fetch_link,
                Table = file,
                Index = "string",
                PostData = "page="..page,
                HttpMethod = POST_METHOD,
                Header1 = "X-Requested-With:XMLHttpRequest",
            })
            while Threads.check(file) do
                coroutine.yield(false)
            end
            page = page + 1
            content = file.string or ""
            local continue = true
            for Link, Name in content:gmatch('class="table%-bordered">.-href=\'(%S-)\'><b>(.-)<') do
                t[#t + 1] = {
                    Name = Name,
                    Link = Link,
                    Pages = {},
                    Manga = manga
                }
                continue = false
            end
            if continue then break end
        end
        for i = #t, 1, -1 do
            dest_table[#dest_table + 1] = t[i]
        end
    end

    function MangaTR:prepareChapter(chapter, dest_table)
        local content = downloadContent(self.Link.."/"..chapter.Link)
        local max_page = 0
        for num in content:gmatch('option value="[^"]-">(%d-)</option>') do
            max_page = math.max(tonumber(num), max_page)
        end
        local t = dest_table
        for i = 1, max_page do
            t[#t + 1] = chapter.Link:gsub(".html","-page-"..i..".html")
        end
    end

    function MangaTR:loadChapterPage(link, dest_table)
        local content = downloadContent(self.Link.."/"..link)
        dest_table.Link = self.Link.."/"..(content:match("<img src='(%S-)' class='chapter%-img'>") or "")
    end
end