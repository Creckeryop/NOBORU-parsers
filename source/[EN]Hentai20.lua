Hentai20 = Parser:new("Hentai20", "https://hentai20.com", "ENG", "HENTAITWENTYENG", 3)

Hentai20.Disabled = true --Reason: Cloudflare protection

Hentai20.NSFW = true

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
            Index = "string",
            Header1 = "Referer: https://hentai20.com/"
        }
    )
    while Threads.check(file) do
        coroutine.yield(false)
    end
    return file.string or ""
end

function Hentai20:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, Name, ImageLink in content:gmatch('<div class="row c%-tabs%-item__content">.-href="[^"]-/manga/([^"]-)/" title="([^"]-)">.-src="([^"]-)"') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, {Link = ImageLink:gsub("%%", "%%%%"), Header1 = "Referer: https://hentai20.com/"}, self.ID, self.Link .. "/manga/" .. Link .. "/")
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function Hentai20:getPopularManga(page, dt)
    self:getManga(self.Link .. "/page/" .. page .. "/?s&post_type=wp-manga&m_orderby=trending", dt)
end

function Hentai20:getLatestManga(page, dt)
    self:getManga(self.Link .. "/page/" .. page .. "/?s&post_type=wp-manga&m_orderby=latest", dt)
end

function Hentai20:getAZManga(page, dt)
    self:getManga(self.Link .. "/page/" .. page .. "/?s&post_type=wp-manga&m_orderby=alphabet", dt)
end

function Hentai20:searchManga(search, page, dt)
    self:getManga(self.Link .. "/page/" .. page .. "/?s=" .. search .. "&post_type=wp-manga&m_orderby", dt)
end

function Hentai20:getChapters(manga, dt)
    local content = downloadContent(self.Link .. "/manga/" .. manga.Link .. "/")
    local t = {}
    dt.Description = stringify((content:match('<div class="summary__content ">%s*(.-)%s*</div>') or content:match('<div class="summary__content show%-more">%s*<p>(.-)</p>') or ""):gsub("<br>", "\n"):gsub("<[^>]->", "")):gsub("^%l", string.upper):gsub("%.%s*%l", string.upper)
    for Link, Name in content:gmatch('<li class="wp%-manga%-chapter.-href="[^"]-/manga/[^/]-/([^"]-)/">%s*(.-)%s*</a>') do
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

function Hentai20:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/manga/" .. chapter.Manga.Link .. "/" .. chapter.Link .. "/")
    for link in content:gmatch('<img id="image%-[^>]-src="%s*([^"]-)%s*"') do
        dt[#dt + 1] = {
            Link = link:gsub("%%", "%%%%"),
            Header1 = "Referer: https://hentai20.com/"
        }
    end
end

function Hentai20:loadChapterPage(link, dt)
    dt.Link = link
end
