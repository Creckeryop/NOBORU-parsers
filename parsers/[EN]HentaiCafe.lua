HentaiCafe = Parser:new("HentaiCafe", "https://hentai.cafe", "ENG", "HENCAFENG")

HentaiCafe.NSFW = true

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

function HentaiCafe:getManga(link, dest_table)
    local content = downloadContent(link)
    local t = dest_table
    local done = true
    for Link, ImageLink, Name in content:gmatch('article.-href=".-/(%d-)".-src="(%S-)".-entry%-title">.-<a href.->([^<]-)<') do
        done = false
        t[#t + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .."/hc.fyi/".. Link)
        coroutine.yield(false)
    end
    if done then
        t.NoPages = true
    end
end

function HentaiCafe:getPopularManga(page, dest_table)
    self:getManga(self.Link.."/page/"..page, dest_table)
end

function HentaiCafe:searchManga(search, page, dest_table)
    self:getManga(self.Link.."/page/"..page.."?s=" .. search, dest_table)
end

function HentaiCafe:getChapters(manga, dest_table)
    local content = downloadContent(self.Link .."/hc.fyi/".. manga.Link)
    local t = dest_table
    local link, name = content:match('/manga/read/(.-)"'), "Read chapter"
    if link then
        t[#t + 1] = {
            Name = name,
            Link = link,
            Pages = {},
            Manga = manga
        }
    end
end

function HentaiCafe:prepareChapter(chapter, dest_table)
    local content = downloadContent(self.Link .. "/manga/read/"..chapter.Link)
    local t = dest_table
    for link in content:gmatch('"url"%s?:%s?"(%S-)"') do
        t[#t + 1] = link:gsub("\\/","/"):gsub("%%","%%%%")
		Console.write("Got " .. t[#t])
    end
end

function HentaiCafe:loadChapterPage(link, dest_table)
    dest_table.Link = link
end