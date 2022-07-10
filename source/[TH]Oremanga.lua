Oremanga = Parser:new("Oremanga", "https://www.oremanga.net", "THA", "OREMANGATHA", 2)

local function stringify(string)
    return string:gsub(
        "&#([^;]-);",
        function(a)
            local number = tonumber("0" .. a) or tonumber(a)
            return number and u8c(number) or "&#" .. a .. ";"
        end
    ):gsub(
        "&(.-);",
        function(a)
            return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
        end
    )
end

local function downloadContent(link)
    local file = {}
    Threads.insertTask(
        file,
        {
            Type = "StringRequest",
            Link = link,
            Table = file,
            Index = "string"
        }
    )
    while Threads.check(file) do
        coroutine.yield(false)
    end
    return file.string or ""
end

function Oremanga:getManga(link, dt)
    local content = downloadContent(link)
    local t = dt
    t.NoPages = true
    for Link, Name, ImageLink in content:gmatch('flexbox2%-item">.-href="[^"]*/([^"]-)/" title="([^"]-)".-img src="([^"]-)"') do
        local manga = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/series/" .. Link)
        if manga then
            t.NoPages = false
            t[#t + 1] = manga
        end
        coroutine.yield(false)
    end
end

function Oremanga:getPopularManga(page, dt)
    self:getManga(self.Link .. "/advance-search/page/" .. page .. "/?title=&author&yearx&status&type&order=popular", dt)
end

function Oremanga:getLatestManga(page, dt)
    self:getManga(self.Link .. "/advance-search/page/" .. page .. "/?title=&author&yearx&status&type&order=update", dt)
end

function Oremanga:getAZManga(page, dt)
    self:getManga(self.Link .. "/advance-search/page/" .. page .. "/?title=&author&yearx&status&type&order=title", dt)
end

function Oremanga:searchManga(search, page, dt)
    self:getManga(self.Link .. "/advance-search/page/" .. page .. "/?title=" .. search .. "&author&yearx&status&type&order=popular", dt)
end

function Oremanga:getChapters(manga, dt)
    local content = downloadContent(self.Link .. "/manga/" .. manga.Link)
    local description = (content:match('series%-synops">(.-)</div>') or ""):gsub("^%s+", ""):gsub("%s+$", ""):gsub("<[^>]->", "")
    dt.Description = stringify(description)
    local t = {}
    for Link, Name in content:gmatch('flexch%-book">.-href="[^"]*/([^"]-/[^"]-)/" title="([^"]-)"') do
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

function Oremanga:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/" .. chapter.Link)
    local t = dt
    for Link in (content:match('reader%-area">(.-)</div>') or ""):gmatch('src="([^"]-)"') do
        local link = Link:gsub("\\/", "/")
        t[#t + 1] = link
    end
end

function Oremanga:loadChapterPage(link, dt)
    dt.Link = link
end
