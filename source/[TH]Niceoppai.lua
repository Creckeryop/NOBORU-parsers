NiceOppai = Parser:new("NiceOppai", "https://www.niceoppai.net", "THA", "NICEOPPAITHA", 1)

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
    local f = {}
    Threads.insertTask(
        f,
        {
            Type = "StringRequest",
            Link = link,
            Table = f,
            Index = "text"
        }
    )
    while Threads.check(f) do
        coroutine.yield(false)
    end
    return f.text or ""
end

function NiceOppai:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch('"cvr">.-href="[^"]-/([^/"]-)/"><img src="([^"]-)" alt="([^"]-)"') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/" .. Link .. "/")
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function NiceOppai:getAZManga(page, dt)
    self:getManga(self.Link .. "/manga_list/all/any/name-az/" .. page .. "/", dt)
end

function NiceOppai:getLatestManga(page, dt)
    self:getManga(self.Link .. "/manga_list/all/any/last-updated/" .. page .. "/", dt)
end

function NiceOppai:getPopularManga(page, dt)
    self:getManga(self.Link .. "/manga_list/all/any/most-popular/" .. page .. "/", dt)
end

function NiceOppai:searchManga(search, page, dt)
    self:getManga(self.Link .. "/manga_list/search/" .. search .. "/most-popular/" .. page .. "/", dt)
end

function NiceOppai:getChapters(manga, dt)
    local t = {}
    local k = 1
    while true do
        local content = downloadContent(self.Link .. "/" .. manga.Link .. "/chapter-list/" .. k .. "/")
        k = k + 1
        local gobreak = true
        for Link, Name in content:gmatch('"lst" href="[^"]-/([^/"]-)/".-"val">([^<]-)</b>') do
            gobreak = false
            t[#t + 1] = {
                Name = stringify(Name),
                Link = Link,
                Pages = {},
                Manga = manga
            }
        end
        if gobreak then
            break
        end
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function NiceOppai:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/" .. chapter.Manga.Link .. "/" .. chapter.Link .. "/")
    for Link  in content:gmatch('<center><img rel="noreferrer" src="([^"]-)"') do
        dt[#dt + 1] = Link:gsub("\\/", "/")
    end
end

function NiceOppai:loadChapterPage(link, dt)
    dt.Link = link
end
