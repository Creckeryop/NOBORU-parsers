SenManga = Parser:new("SenManga", "https://raw.senmanga.com", "JAP", "SENGMANGAJAP")

local notify = false

local function stringify(string)
    if not u8c then
        if not notify then
            Notifications.push("Please update app, to see fixed titles")
            notify = true
        end
        return string
    end
    return string:gsub("&#([^;]-);", function(a)
        local number = tonumber("0" .. a) or tonumber(a)
        return number and u8c(number) or "&#" .. a .. ";"
    end)
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

function SenManga:getManga(link, dest_table, page, search)
    local content = downloadContent(link)
    local t = dest_table
    local class = "border%-light"
    if search then
        class = "series"
    end
    for Link, ImageLink, Name in content:gmatch(class..'">.-href="(%S-)".-src="(%S-)" alt="([^"]-)"') do
        t[#t + 1] = CreateManga(stringify(Name), Link:match(self.Link.."/(.*)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
		coroutine.yield(false)
    end
    local last_page = tonumber(content:match('^.*page=(%d*)">.-$') or 1)
    if page == last_page then
        t.NoPages = true
    end
end

function SenManga:getPopularManga(page, dest_table)
    self:getManga(self.Link.."/directory/popular?page="..page, dest_table, page)
end

function SenManga:getLatestManga(page, dest_table)
    self:getManga(self.Link.."/directory/last_update?page="..page, dest_table, page)
end

function SenManga:searchManga(search, page, dest_table)
    self:getManga(self.Link.."/search?s="..search.."&author=&artist=&genre=&nogenre=&completed=0&released=&page="..page, dest_table, page, true)
end

function SenManga:getChapters(manga, dest_table)
    local content = downloadContent(self.Link .."/".. manga.Link)
    local t = {}
    for Link, Name in content:gmatch('class="element">[^>]-class="title">[^<]-<a href="(%S-)">[\n%s]*(.-)[\n%s]*</a>') do
        t[#t + 1] = {
            Name = Name,
            Link = Link:match(self.Link.."/(.*)"),
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
		dest_table[#dest_table + 1] = t[i]
	end
end

function SenManga:prepareChapter(chapter, dest_table)
    local content = downloadContent(self.Link .."/".. chapter.Link)
    local t = dest_table
    local count = tonumber(content:match(" of (%d*)") or 0)
    for i = 1, count do
        t[#t + 1] = self.Link.."/viewer/"..chapter.Link.."/"..i
		Console.write("Got " .. t[#t])
    end
end

function SenManga:loadChapterPage(link, dest_table)
    dest_table.Link = link
end