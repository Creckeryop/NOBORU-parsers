Mabushimajo = Parser:new("Mabushimajo","http://mabushimajo.com", "TUR", "MABUSHTR")

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

function Mabushimajo:getManga(link, dest_table)
    local content = downloadContent(link)
    local t = dest_table
    for Link, ImageLink,Name in content:gmatch('class="group"><a href="(%S-)">.-src="(%S-)".-title=.->([^<]-)<') do
		local manga = CreateManga(stringify(Name), Link:match("^.+/(.-)/$"), ImageLink, self.ID, Link)
		if manga then
			t[#t + 1] = manga
		end
		coroutine.yield(false)
	end
    t.NoPages = not content:find("Last")
end

function Mabushimajo:getPopularManga(page, dest_table)
    self:getManga(self.Link.."/onlineokuma/directory/"..page, dest_table)
end

if not u8c then
    function Mabushimajo:searchManga(search, page, dest_table)
        Notifications.push("Parser don't support search feature")
        Notifications.push("Please update App")
    end
end

function Mabushimajo:getChapters(manga, dest_table)
    local content = downloadContent(manga.RawLink)
    local t = {}
    for Link, Name in content:gmatch('class="element">.-<a href="(%S-)" title=[^>]->([^<]-)<') do
        t[#t + 1] = {
			Name = Name,
			Link = Link:match("read/(.+)"),
			Pages = {},
			Manga = manga
		}
    end
	for i = #t, 1, -1 do
		dest_table[#dest_table + 1] = t[i]
	end
end

function Mabushimajo:prepareChapter(chapter, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link.."/onlineokuma/read/"..chapter.Link.."/page/1",
		Table = file,
        Index = "string",
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
    local t = dest_table
    for Link in content:gmatch('"url" ?: ?"(%S-)"') do
        t[#t + 1] = Link:gsub("\\/","/")
		Console.write("Got " .. t[#t])
    end
end

function Mabushimajo:loadChapterPage(link, dest_table)
	dest_table.Link = link
end
