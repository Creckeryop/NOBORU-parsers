Puzzmos = Parser:new("Puzzmos", "https://www.puzzmos.com", "TUR", "PUZZMOSTUR", 2)

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

local function stringify(string)
    return string:gsub("&#([^;]-);", function(a)
        local number = tonumber("0" .. a) or tonumber(a)
        return number and u8c(number) or "&#" .. a .. ";"
    end):gsub("&(.-);", function(a) return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";" end)
end

local function stringify2(string)
    return string:gsub("\\u(....)", function(a) return u8c(tonumber("0x" .. a)) end)
end

function Puzzmos:getPopularManga(page, dt)
    local content = downloadContent(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch("<a href=\"([^\"]-)\" class=\"thumbnail\">[^>]-src='([^']-)' alt='([^']-)'>[^<]-</a>") do
        dt[#dt + 1] = CreateManga(stringify(Name), Link:gsub("%%", "%%%%"), ImageLink:gsub(" ", "%%20"):gsub("%%", "%%%%"), self.ID, Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

local unique = {}
function Puzzmos:getLatestManga(page, dt)
    local content = downloadContent(self.Link .. "/latest-release?page=" .. page, dt)
    dt.NoPages = true
    if page == 1 then
        unique = {}
    end
    for Link, Name in content:gmatch('"manga%-item">.-href="(%S-)">([^<]-)</a>') do
        dt.NoPages = false
        local l = Link:match("/([^/]-)$") or ""
        if not unique[Link] then
            local manga = CreateManga(stringify(Name), self.Link .. "/manga/" .. l:gsub(" ", "%%20"):gsub("%%", "%%%%"), self.Link .. "//uploads/manga/" .. l:gsub("%%", "%%%%") .. "/cover/cover_250x350.jpg", self.ID, Link)
            dt[#dt + 1] = manga
            if manga then
                unique[Link] = true
            end
            coroutine.yield(false)
        end
    end
end

function Puzzmos:searchManga(search, page, dt)
    local old_gsub = string.gsub
    string.gsub = function(self, one, sec)
        return old_gsub(self, sec, one)
    end
    search = search:gsub("!", "%%%%21"):gsub("#", "%%%%23"):gsub("%$", "%%%%24"):gsub("&", "%%%%26"):gsub("'", "%%%%27"):gsub("%(", "%%%%28"):gsub("%)", "%%%%29"):gsub("%*", "%%%%2A"):gsub("%+", "%%%%2B"):gsub(",", "%%%%2C"):gsub("%.", "%%%%2E"):gsub("/", "%%%%2F"):gsub(" ", "%+"):gsub("%%", "%%%%25")
    string.gsub = old_gsub
    local searchLink = self.Link .. "/search?query=" .. search
    local content = downloadContent(searchLink)
    for Name, Link in content:gmatch('"value":"([^"]-)","data":"([^"]-)"') do
        local manga = CreateManga(stringify2(Name), self.Link .. "/manga/" .. stringify2(Link):gsub(" ", "%%20"):gsub("%%", "%%%%"), self.Link .. "//uploads/manga/" .. stringify2(Link):gsub(" ", "%%20"):gsub("%%", "%%%%") .. "/cover/cover_250x350.jpg", self.ID, self.Link .. "/manga/" .. stringify2(Link))
        dt[#dt + 1] = manga
        coroutine.yield(false)
    end
    dt.NoPages = true
end

function Puzzmos:getChapters(manga, dt)
    local content = downloadContent(manga.Link)
    local t = {}
    for Link, Name in content:gmatch("chapter%-title%-rtl\">[^<]-<a href=\"([^\"]-)\">([^<]-)</a>") do
        t[#t + 1] = {
            Name = stringify(Name),
            Link = Link:gsub(" ", "%%20"):gsub("%%", "%%%%"),
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function Puzzmos:prepareChapter(chapter, dt)
    local content = downloadContent(chapter.Link)
    for Link in content:gmatch("img%-responsive\"[^>]-data%-src=' ([^']-) '") do
        dt[#dt + 1] = Link:gsub(" ", "%%20"):gsub("%%", "%%%%")
    end
end

function Puzzmos:loadChapterPage(link, dt)
    dt.Link = link
end
