NudeMoon = Parser:new("Nude-Moon", "https://nude-moon.net", "RUS", "NUDEMOONRU")

NudeMoon.NSFW = true


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


function NudeMoon:getManga(link, dest_table)
	local content = downloadContent(link)
	local t = dest_table
	local done = true
	for Link, Name, ImageLink in content:gmatch('<td colspan.-<a href="(.-)".-title="(.-)".-src="(.-)"') do
		local manga = CreateManga(stringify(AnsiToUtf8(Name)), Link, self.Link .. ImageLink, self.ID, self.Link .. Link)
		if manga then
			t[#t + 1] = manga
			done = false
		end
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function NudeMoon:getLatestManga(page, dest_table)
	self:getManga(string.format("%s/all_manga?rowstart=%s", self.Link, (page - 1) * 30), dest_table)
end

function NudeMoon:getPopularManga(page, dest_table)
	self:getManga(string.format("%s/all_manga?views&rowstart=%s", self.Link, (page - 1) * 30), dest_table)
end

function NudeMoon:searchManga(data, page, dest_table)
	local stext = {}
	for c in it_utf8(data) do
		if utf8ascii[c] then
			stext[#stext + 1] = utf8ascii[c]
		else
			stext[#stext + 1] = c
		end
	end
	stext = table.concat(stext)
	self:getManga(string.format("%s/search?stext=%s&rowstart=%s", self.Link, stext, (page - 1) * 30), dest_table)
end

function NudeMoon:getChapters(manga, dest_table)
	local content = downloadContent(self.Link .. manga.Link)
	local link = content:match('"(/vse_glavy/[^"]-)"')
	if link then
		local t = {}
		self:getManga(self.Link .. link, t)
		for i = #t, 1, -1 do
			local m = t[i]
			dest_table[#dest_table + 1] = {
				Name = stringify(m.Name),
				Link = m.Link:gsub("^(/%d*)", "%1-online"),
				Pages = {},
				Manga = manga
			}
		end
	else
		dest_table[#dest_table + 1] = {
			Name = stringify(manga.Name),
			Link = manga.Link:gsub("^(/%d*)", "%1-online"),
			Pages = {},
			Manga = manga
		}
	end
end

function NudeMoon:prepareChapter(chapter, dest_table)
	local content = downloadContent(self.Link .. chapter.Link .. "?page=1")
	local t = dest_table
	for link in content:gmatch("images%[%d-%].src = '%.(.-)';") do
		t[#t + 1] = self.Link .. link
		Console.write("Got " .. t[#t])
	end
end

function NudeMoon:loadChapterPage(link, dest_table)
	dest_table.Link = link
end
