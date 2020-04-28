Desu = Parser:new("Desu", "https://desu.me", "RUS", "DESURU", 3)

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

local function stringify(string)
    if u8c then
        return string:gsub("&#([^;]-);", function(a)
            local number = tonumber("0" .. a) or tonumber(a)
            return number and u8c(number) or "&#" .. a .. ";"
        end):gsub("&([^;]-);", function(a) return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&"..a..";" end)
    else
        return string
    end
end

function Desu:getManga(link, dt, is_search)
    local content = downloadContent(link)
    local pattern = is_search and '<a href="(manga/%S-)".-src="(.-)".-SubTitle">(.-)</div>' or 'memberListItem.-<a href="(manga/%S-)".-url%(\'([^\']-)\'%);.-title="([^"]-)"'
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch(pattern) do
        ImageLink = "https://desu.me/data/manga/covers/x225/" .. (Link:match("%.([^%.]-)/?$") or "") .. ".jpg"
        dt[#dt + 1] = CreateManga(stringify(Name), "/" .. Link, ImageLink, self.ID, self.Link .. "/" .. Link)
        if not is_search then
            dt.NoPages = false
        end
        coroutine.yield(false)
    end
end

function Desu:getPopularManga(page, dt)
    Desu:getManga(self.Link.."/manga/?order_by=popular&page="..page, dt)
end

function Desu:getLatestManga(page, dt)
    Desu:getManga(self.Link .. "/manga/?page=" .. page, dt)
end

function Desu:searchManga(search, _, dt)
    Desu:getManga(self.Link .. "/manga/search?q=" .. search, dt, true)
end

function Desu:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link)
	local t = {}
	local rus_name = content:match('<span class="rus%-name"[^>]->(.-)</span>') or ""
	local org_name = content:match('<span class="name"[^>]->(.-)</span>') or manga.Name
	manga.Name = stringify(org_name..(rus_name=="" and "" or " ("..rus_name..")"))
    for Link, Name in content:gmatch('<a href="(/manga/%S-)" class="tips Tooltip"[^>]-title="([^>]-)">') do
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

function Desu:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. chapter.Link)
    local dir = content:match('dir: "\\/\\/([^"]-)",'):gsub("\\/", "/") or ""
    local images = content:match('images: %[%[(.-)%]%],') or ""
    for link in images:gmatch('"(.-)"') do
        if not link:find("%.gif") then
            dt[#dt + 1] = dir .. link
            Console.write("Got " .. dt[#dt])
        else
            Console.write("Skipping " .. link)
        end
    end
end

function Desu:loadChapterPage(link, dt)
    dt.Link = link
end
