RComicOnlineTo = Parser:new("ReadComicOnline.to", "https://readcomiconline.to", "ENG", "RCOMICONLINETOENG", 1)

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

function RComicOnlineTo:getManga(link, dt)
    local content = downloadContent(link)
    
    for ImageLink, Link, Name in content:gmatch('td title=\'[^<]-<img[^>]-src="([^"]-)".-href="([^"]-)">(.-)</a>') do
        if not ImageLink:find("^http") then
            ImageLink = self.Link .. ImageLink
        end
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function RComicOnlineTo:getLatestManga(page, dt)
    self:getManga(self.Link .. "/ComicList/Newest?page=" .. page, dt)
end

function RComicOnlineTo:getPopularManga(page, dt)
    self:getManga(self.Link .. "/ComicList/MostPopular?page=" .. page, dt)
end

function RComicOnlineTo:searchManga(search, _, dt)
    self:getManga({Link = self.Link .. "/Search/Comic", PostData = "keyword="..search, HttpMethod = POST_METHOD}, dt)
    dt.NoPages = true
end

function RComicOnlineTo:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link)
    local t = {}
    for Link, Name in content:gmatch('<td>[^<]-<a[^>]-href="/Comic/[^/]-(/[^"]-)"[^>]->[ \n\r]+(.-)</a>') do
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

function RComicOnlineTo:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. chapter.Manga.Link .. chapter.Link)
    for Link in content:gmatch('lstImages%.push%("(.-)"%)') do
        dt[#dt + 1] = Link:gsub("\\/", "/")
    end
end

function RComicOnlineTo:loadChapterPage(link, dt)
    dt.Link = link
end
