HentaiCafeV2 = Parser:new("HentaiCafeV2 v2", "https://hentaicafe.xxx", "ENG", "HENCAFENGV2", 1)

HentaiCafeV2.NSFW = true

local function stringify(string)
    if u8c then
        return string:gsub(
            "&#([^;]-);",
            function(a)
                local number = tonumber("0" .. a) or tonumber(a)
                return number and u8c(number) or "&#" .. a .. ";"
            end
        ):gsub(
            "&([^;]-);",
            function(a)
                return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
            end
        )
    else
        return string
    end
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

function HentaiCafeV2:getManga(link, dt, mode)
    local content = downloadContent(link)
    dt.NoPages = true
    if mode == "latest" then
        content = content:match("</i>%s*New Uploads%s*</h2>(.*)$") or ""
    elseif mode == "popular" then
        content = content:match("^(.*)</i>%s*New Uploads%s*</h2>") or ""
    end
    for Link, ImageLink, Name in content:gmatch('href="[^"]*/g/([^"]-)/?"[^>]->%s*<[^>]-src="([^"]-)"[^>]->%s*<div class="caption">%s*([^<]-)%s*</div>') do
        dt[#dt + 1] = CreateManga(stringify(Name:gsub("<[^>]->", "")), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/g/" .. Link)
        dt.NoPages = mode ~= "popular"
        coroutine.yield(false)
    end
end

function HentaiCafeV2:getPopularManga(page, dt)
    self:getManga(self.Link .. "/?page=" .. page, dt, "popular")
end

function HentaiCafeV2:getLatestManga(page, dt)
    self:getManga(self.Link .. "/?page=" .. page, dt, "latest")
end

function HentaiCafeV2:searchManga(search, page, dt)
    self:getManga(self.Link .. "/search?page=" .. page .. "?q=" .. search, dt, "search")
end

function HentaiCafeV2:getChapters(manga, dt)
    dt[#dt + 1] = {
        Name = "Read chapter",
        Link = manga.Link,
        Pages = {},
        Manga = manga
    }
end

function HentaiCafeV2:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/g/" .. chapter.Link)
    local pages = content:match('Pages:%s*<span class="tags">.*name">%s*(%d*)%s*</span>') or 0
    for i = 1, pages do
        dt[#dt + 1] = self.Link .. "/g/" .. chapter.Link .. "/" .. i
    end
end

function HentaiCafeV2:loadChapterPage(link, dt)
    local content = downloadContent(link)
    dt.Link = content:match('id="image%-container">.*src="([^"]-)" class') or ""
end
