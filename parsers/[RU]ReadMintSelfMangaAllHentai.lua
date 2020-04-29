ReadManga = Parser:new("ReadManga", "https://readmanga.me", "RUS", "READMANGARU", 2)

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

function ReadManga:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch('<a href="(/%S-)" class="non%-hover".-original=\'(%S-)\' title=\'(.-)\' alt') do
        if Link:find("^/[^/]-$") then
            dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
        end
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function ReadManga:getLatestManga(page, dt)
    self:getManga(self.Link .. "/list?sortType=updated&offset=" .. ((page - 1) * 70), dt)
end

function ReadManga:getPopularManga(page, dt)
    self:getManga(self.Link .. "/list?sortType=rate&offset=" .. ((page - 1) * 70), dt)
end

function ReadManga:searchManga(data, page, dt)
    self:getManga({
        Link = self.Link .. "/search",
        HttpMethod = POST_METHOD,
        PostData = "q=" .. data .. "&offset=" .. ((page - 1) * 50)
    }, dt)
end

function ReadManga:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link)
    local t = {}
    for Link, Name in content:gmatch('<td class%=.-<a href%="/.-(/vol%S-)".->%s*(.-)</a>') do
        t[#t + 1] = {
            Name = stringify(Name:gsub("%s+", " "):gsub("<sup>.-</sup>", "")),
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function ReadManga:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. chapter.Manga.Link .. chapter.Link .. "?mtr=1")
    local text = content:match("rm_h.init%( %[%[(.-)%]%]")
    if text then
        local list = load("return {{" .. text:gsub("%],%[", "},{") .. "}}")()
        for i = 1, #list do
            dt[i] = list[i][1] .. list[i][3]
            Console.write("Got " .. dt[i])
        end
    end
end

function ReadManga:loadChapterPage(link, dt)
    dt.Link = link
end

MintManga = ReadManga:new("MintManga", "https://mintmanga.live", "RUS", "MINTMANGARU", 1)

SelfManga = ReadManga:new("SelfManga", "https://selfmanga.ru", "RUS", "SELFMANGARU", 1)

AllHentai = ReadManga:new("AllHentai", "http://allhentai.ru", "RUS", "ALLHENTAIRU", 2)
AllHentai.NSFW = true
