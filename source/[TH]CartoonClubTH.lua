CartoonClubTH = Parser:new("CartoonClub-TH", "https://www.toonclub-th.co", "THA", "CARTOONCLUBTH", 1)

---Reason: Host is unavailable
CartoonClubTH.Disabled = true

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

function CartoonClubTH:getManga(link, dt)
    local content = downloadContent(link)
    local t = dt
    t.NoPages = true
    for Link, ImageLink, Name in content:gmatch('aniframe">.-href="[^"]*/([^"]-)/".-src="([^"]-)".-manga%-title">([^<]-)</a>') do
        local manga = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/" .. Link)
        if manga then
            t.NoPages = false
            t[#t + 1] = manga
        end
        coroutine.yield(false)
    end
end

function CartoonClubTH:getPopularManga(page, dt)
    self:getManga(self.Link .. "/page/" .. page .. "/?s=mostviews", dt)
end

function CartoonClubTH:getLatestManga(page, dt)
    self:getManga(self.Link .. "/page/" .. page .. "/?s=manga-ongoing", dt)
end

function CartoonClubTH:searchManga(search, page, dt)
    self:getManga(self.Link .. "/page/" .. page .. "/?s=" .. search, dt)
end

function CartoonClubTH:getChapters(manga, dt)
    local content = downloadContent(self.Link .. "/" .. manga.Link)
    local t = {}
    for Link, Name in (content:match('chapter%-name">(.-)</table>') or ""):gmatch('href="[^"]*/([^"]-)/"[^>]->([^<]-)<') do
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

function CartoonClubTH:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/" .. chapter.Manga.Link .. "/" .. chapter.Link)
    local t = dt
    for Link in (content:match('id="page_select1"(.-)</div>') or ""):gmatch('value="([^"]-)"') do
        t[#t + 1] = Link
    end
end

function CartoonClubTH:loadChapterPage(link, dt)
    local content = downloadContent(link)
    dt.Link = content:match('name="img_page"[^>]-src="([^"]-)"'):gsub("^%s*", ""):gsub("%s*$", ""):gsub("\\/","/")
end
