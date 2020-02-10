VLComic = Parser:new("VLComic", "http://vlcomic.com", "ENG", "VLCOMIC")

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

function VLComic:getManga(link, dest_table)
    local content = downloadContent(link)
    local t = dest_table
    local done = true
    for Link, ImageLink, Name in content:gmatch('class="ig%-grid">.-href="(%S-)".-src="(%S-)".-title="[^"]-">(.-)</a>') do
        done = false
        t[#t + 1] = CreateManga(stringify(Name), Link, self.Link..ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. Link)
		coroutine.yield(false)
    end
    if done then
        t.NoPages = true
    end
end

function VLComic:getPopularManga(page, dest_table)
    self:getManga(self.Link.."/popular-comics/"..page, dest_table)
end

function VLComic:getLatestManga(page, dest_table)
    self:getManga(self.Link.."/new-comics/"..page, dest_table)
end

function VLComic:searchManga(search, page, dest_table)
    self:getManga(self.Link.."/comic-collection/"..search, dest_table)
    dest_table.NoPages = true
end

function VLComic:getChapters(manga, dest_table)
    local content = downloadContent(self.Link .. manga.Link)
    local t = {}
    for Link, Name in content:gmatch('class="ch%-name" href="(%S-)">(.-)</a>') do
        t[#t + 1] = {
            Name = Name,
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
		dest_table[#dest_table + 1] = t[i]
	end
end

function VLComic:prepareChapter(chapter, dest_table)
    local content = downloadContent(self.Link .. chapter.Link)
    local t = dest_table
    for link in content:gmatch('<img src="(%S-)" title') do
        t[#t + 1] = link:gsub("%%","%%%%")
		Console.write("Got " .. t[#t])
    end
end

function VLComic:loadChapterPage(link, dest_table)
    dest_table.Link = link
end