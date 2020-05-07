MangaSee = Parser:new("MangaSee", "https://mangaseeonline.us", "ENG", "MANGASEE", 1)

local mangasee_api = "https://mangaseeonline.us/search/request.php"
local query = "page=%s&keyword=%s&year=&author=&sortBy=%s&sortOrder=descending&status=&pstatus=&type=&genre=&genreNo="

local function stringify(string)
    return string:gsub("&#([^;]-);", function(a)
        local number = tonumber("0" .. a) or tonumber(a)
        return number and u8c(number) or "&#" .. a .. ";"
    end):gsub("&(.-);", function(a) return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";" end)
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

function MangaSee:getManga(data, dt)
    local content = downloadContent({
        Link = mangasee_api,
        HttpMethod = POST_METHOD,
        PostData = data,
        ContentType = XWWW
    })
    dt.NoPages = true
    for ImageLink, Link, Name in content:gmatch('class="requested">.-src="([^"]-)".-href="([^"]-)">([^<]-)</a>') do
        local manga = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link..Link)
        dt[#dt + 1] = manga
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function MangaSee:getLatestManga(page, dt)
    self:getManga(query:format(page, "", "dateUpdated"), dt)
end

function MangaSee:getPopularManga(page, dt)
    self:getManga(query:format(page, "", "popularity"), dt)
end

function MangaSee:searchManga(search, page, dt)
    self:getManga(query:format(page, search, "popularity"), dt)
end

function MangaSee:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link)
    local t = {}
    for Link, Name in content:gmatch('class="list%-group%-item".-href="(.-)".-chapterLabel">(.-)</span>') do
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

function MangaSee:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. chapter.Link)
    for Link in content:gmatch('"%d-":"([^"]-)"') do
        dt[#dt + 1] = Link:gsub("\\/","/")
        Console.write("Got " .. dt[#dt])
    end
end

function MangaSee:loadChapterPage(link, dt)
    dt.Link = link
end
