VerComicsPorno = Parser:new("VerComicsPorno", "https://vercomicsporno.xxx", "ESP", "VERCOMICSPORNOESP", 3)

VerComicsPorno.NSFW = true

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

function VerComicsPorno:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, Name, ImageLink in content:gmatch('<div id="post%-.-href="[^"]-/([^/"]-)/" title="([^"]-)">.-src="([^"]-)"') do
        dt[#dt + 1] = CreateManga(stringify(Name:gsub("<[^>]->", "")), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/" .. Link .. "/")
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function VerComicsPorno:getPopularManga(page, dt)
    self:getManga(self.Link .. "/page/" .. page .. "/", dt)
end

function VerComicsPorno:searchManga(search, page, dt)
    self:getManga(self.Link .. "/page/" .. page .. "/?s=" .. search, dt)
end

function VerComicsPorno:getChapters(manga, dt)
    local link, name = manga.Link, "Leer"
    if link then
        dt[#dt + 1] = {
            Name = name,
            Link = link,
            Pages = {},
            Manga = manga
        }
    end
end

function VerComicsPorno:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/" .. chapter.Link .. "/")
    for link in content:gmatch('wp%-block%-image"><[^<]-><img src="([^"]-)"') do
        dt[#dt + 1] = link:gsub("%%", "%%%%")
    end
end

function VerComicsPorno:loadChapterPage(link, dt)
    dt.Link = {
        Link = link,
        Header1 = "Referer: "..self.Link
    }
end
