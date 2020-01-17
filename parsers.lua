MangaReader = Parser:new("MangaReader", "https://www.mangareader.net", "ENG", 1)

function MangaReader:getManga(page, table)
	local file = {}
	threads.DownloadStringAsync(self.Link .. "/popular/" .. ((page - 1) * 30), file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for ImageLink, Link, Name in file.string:gmatch('image:url%(\'(%S-)\'.-<div class="manga_name">.-<a href="(%S-)">(.-)</a>') do
		t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link..Link)
		coroutine.yield(true)
	end
end

function MangaReader:getChapters(manga, table)
	local file = {}
	threads.DownloadStringAsync(self.Link .. manga.Link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	file.string = file.string:match('id="chapterlist"(.+)$') or ""
	local t = table
	for Link, Name, subName in file.string:gmatch('chico_manga.-<a href%="/.-(/%S-)">(.-)</a>(.-)</td>') do
		t[#t + 1] = {Name = Name .. subName, Link = Link, Pages = {}, Manga = manga}
	end
end

function MangaReader:prepareChapter(chapter, table)
	local file = {}
	threads.DownloadStringAsync(self.Link .. chapter.Manga.Link .. chapter.Link .. "#", file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local count = file.string:match("</select> of (.-)<")
	local t = table
	for i = 1, count do
		t[i] = self.Link .. chapter.Manga.Link .. chapter.Link .. "/" .. i
		Console.writeLine("Got "..t[i])
	end
end

function MangaReader:loadChapterPage(link, table)
	local file = {}
	threads.DownloadStringAsync(link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	table.Link = file.string:match('id="img".-src="(.-)"')
end

function MangaReader:getMangaUrl(url, table)
	local file = {}
	threads.DownloadStringAsync(self.Link .. url, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	table.Name = file.string:match('aname">(.-)<')
	table.ImageLink = file.string:match('mangaimg">.-src%="(.-)"')
	table.Link = url
	table.ParserID = self.ID
	table.RawLink = self.Link .. url
	if table.Name == nil or table.ImageLink == nil then
		table.Name = nil
		table.ImageLink = nil
		table.Link = nil
		table.ParserID = nil
		table.RawLink = nil
	end
end

ReadManga = Parser:new("ReadManga", "https://readmanga.me", "RUS", 2)

function ReadManga:getManga(page, table)
	local file = {}
	threads.DownloadStringAsync(self.Link.."/list?sortType=rate&offset=" .. ((page - 1) * 70), file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for Link, ImageLink, Name in file.string:gmatch('<a href="(/%S-)" class="non%-hover".-original=\'(%S-)\' title=\'(.-)\' alt') do
		if Link:match("^/") then
			t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link..Link)
		end
		coroutine.yield(true)
	end
end

function ReadManga:getChapters(manga, table)
	local file = {}
	threads.DownloadStringAsync(self.Link .. manga.Link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = {}
	for Link, Name in file.string:gmatch('<td class%=.-<a href%="/.-(/vol%S-)".->%s*(.-)</a>') do
		t[#t + 1] = {
			Name = Name:gsub("%s+", " "):gsub("<sup>.-</sup>",""):gsub("&quot;","\""):gsub("&amp;","&"):gsub("&#92;","\\"):gsub("&#39;","'"), 
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		table[#table + 1] = t[i]
	end
end

function ReadManga:prepareChapter(chapter, table)
	local file = {}
	threads.DownloadStringAsync(self.Link .. chapter.Manga.Link .. chapter.Link .. "?mtr=1", file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local text = file.string:match("rm_h.init%( %[%[(.-)%]%]")
	local t = table
	if text ~= nil then
		local list = load("return {{" .. text:gsub("%],%[", "},{") .. "}}")()
		for i = 1, #list do
			t[i] = list[i][2] .. list[i][3]
			Console.writeLine("Got "..t[i])
		end
	end
end

function ReadManga:loadChapterPage(link, table)
	table.Link = link
end

function ReadManga:getMangaUrl(url, table)
	local file = {}
	threads.DownloadStringAsync(self.Link .. url, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	table.Name = file.string:match("<span class%='name'>(.-)</span>")
	table.ImageLink = file.string:match('<img class="" src%="(.-)"')
	table.Link = url
	table.ParserID = self.ID
	table.RawLink = self.Link .. url
	if table.Name == nil or table.ImageLink == nil then
		table.Name = nil
		table.ImageLink = nil
		table.Link = nil
		table.ParserID = nil
		table.RawLink = nil
	end
end

MintManga = ReadManga:new("MintManga", "https://mintmanga.live", "RUS", 3)
MangaPanda = MangaReader:new("MangaPanda", "https://www.mangapanda.com", "ENG", 4)