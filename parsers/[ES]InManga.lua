InManga = Parser:new("InManga", "https://inmanga.com", "ESP", "INMANGASPA", 1)

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

function InManga:getManga(post, dt)
    local file = {}
    Threads.insertTask(file, {
        Type = "StringRequest",
        Link = self.Link .. "/manga/getMangasConsultResult",
        Table = file,
        Index = "string",
        HttpMethod = POST_METHOD,
        PostData = post:gsub("%%", "%%%%"),
        ContentType = XWWW
    })
    while Threads.check(file) do
        coroutine.yield(false)
    end
    local content = file.string or ""
    dt.NoPages = true
    for Link, Name, ImageLink in content:gmatch('href="(/ver/manga/[^"]-)".-</em> (.-)</h4>.-data%-src="([^"]-)"') do
        local link, id = Link:match("(.+)/(.-)$")
        local manga = CreateManga(stringify(Name), link, self.Link .. ImageLink, self.ID, self.Link .. Link)
        if manga then
            manga.Data = {
                id = id
            }
            dt[#dt + 1] = manga
        end
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function InManga:getLatestManga(page, dt)
    self:getManga("filter%5Bgeneres%5D%5B%5D=-1&filter%5BqueryString%5D=&filter%5Bskip%5D=" .. ((page - 1) * 10) .. "&filter%5Btake%5D=10&filter%5Bsortby%5D=3&filter%5BbroadcastStatus%5D=0&filter%5BonlyFavorites%5D=false&d=", dt)
end

function InManga:getPopularManga(page, dt)
    self:getManga("filter%5Bgeneres%5D%5B%5D=-1&filter%5BqueryString%5D=&filter%5Bskip%5D=" .. ((page - 1) * 10) .. "&filter%5Btake%5D=10&filter%5Bsortby%5D=1&filter%5BbroadcastStatus%5D=0&filter%5BonlyFavorites%5D=false&d=", dt)
end

function InManga:searchManga(search, page, dt)
    self:getManga("filter%5Bgeneres%5D%5B%5D=-1&filter%5BqueryString%5D=" .. search .. "&filter%5Bskip%5D=" .. ((page - 1) * 10) .. "&filter%5Btake%5D=10&filter%5Bsortby%5D=1&filter%5BbroadcastStatus%5D=0&filter%5BonlyFavorites%5D=false&d=", dt)
end

function InManga:getChapters(manga, dt)
    local content = downloadContent(self.Link .. "/chapter/getall?mangaIdentification=" .. manga.Data.id)
    local t = {}
    for Id, Num in content:gmatch('\\"Identification\\":\\"(.-)\\".-Number\\":\\"(.-)\\"') do
        Num = tonumber(Num)
        t[#t + 1] = {
            Name = Num,
            Link = Id,
            Pages = {},
            Manga = manga
        }
    end
    table.sort(t, function(a, b) return (a.Name < b.Name) end)
    for i = 1, #t do
        t[i].Name = "Capítulo " .. t[i].Name
        dt[#dt + 1] = t[i]
    end
end

function InManga:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/chapter/chapterIndexControls?identification=" .. chapter.Link)
    local manga_title = chapter.Manga.Link:match(".+/(.-)$")
    content = content:match("<select[^>]-PageList.-</select>") or ""
    for Link, Num in content:gmatch('value=\"([^"]-)\">(.-)<') do
        dt[#dt + 1] = self.Link .. "/images/manga/" .. manga_title .. "/chapter/" .. chapter.Name .. "/page/" .. Num .. "/" .. Link
        Console.write("Got " .. dt[#dt])
    end
end

function InManga:loadChapterPage(link, dt)
    dt.Link = link
end
