NudeMoon = Parser:new("Nude-Moon", "https://nude-moon.net", "RUS", 6)

NudeMoon.NSFW = true

function NudeMoon:getManga(link, table)
	local file = {}
	Threads.DownloadStringAsync(link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	local done = true
	for Link, Name, ImageLink in file.string:gmatch('<td colspan.-<a href="(.-)".-title="(.-)".-src="(.-)"') do
		local manga = CreateManga(AnsiToUtf8(Name), Link, self.Link .. ImageLink, self.ID, self.Link .. Link)
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

function NudeMoon:getLatestManga(page, table)
	self:getManga(string.format("%s/all_manga?rowstart=%s", self.Link, (page - 1) * 30), table)
end

function NudeMoon:getPopularManga(page, table)
	self:getManga(string.format("%s/all_manga?views&rowstart=%s", self.Link, (page - 1) * 30), table)
end

local concat = table.concat
function NudeMoon:searchManga(data, page, table)
	local stext = {}
	for c in it_utf8(data) do
		if utf8ascii[c] then
			stext[#stext + 1] = utf8ascii[c]
		else
			stext[#stext + 1] = c
		end
	end
	stext = concat(stext)
	self:getManga(string.format("%s/search?stext=%s&rowstart=%s", self.Link, stext, (page - 1) * 30), table)
end

function NudeMoon:getChapters(manga, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link .. manga.Link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local link = file.string:match('"(/vse_glavy/[^"]-)"')
	if link then
		local t = {}
		self:getManga(self.Link .. link, t)
		for i = #t, 1, -1 do
			local m = t[i]
			table[#table + 1] = {
				Name = m.Name,
				Link = m.Link:gsub("^(/%d*)", "%1-online"),
				Pages = {},
				Manga = m
			}
		end
	else
		table[#table + 1] = {
			Name = manga.Name,
			Link = manga.Link:gsub("^(/%d*)", "%1-online"),
			Pages = {},
			Manga = manga
		}
	end
end

function NudeMoon:prepareChapter(chapter, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link .. chapter.Link .. "?page=1", file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for link in file.string:gmatch("images%[%d-%].src = '%.(.-)';") do
		t[#t + 1] = self.Link .. link
		Console.write("Got " .. t[#t])
	end
end

function NudeMoon:loadChapterPage(link, table)
	table.Link = link
end
