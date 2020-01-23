ReadManga = Parser:new("ReadManga", "https://readmanga.me", "RUS", 2)

function ReadManga:getLatestManga(page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/list?sortType=updated&offset=" .. ((page - 1) * 70), file, "string", true)
	--Threads.DownloadStringAsync(self.Link.."/search", file, "string", true, POST_METHOD, "q=naruto&offset="..((page-1)*50))
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for Link, ImageLink, Name in file.string:gmatch('<a href="(/%S-)" class="non%-hover".-original=\'(%S-)\' title=\'(.-)\' alt') do
		if Link:match("^/") then
			t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link..Link)
		end
		coroutine.yield(false)
	end
end

function ReadManga:getPopularManga(page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/list?sortType=rate&offset=" .. ((page - 1) * 70), file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for Link, ImageLink, Name in file.string:gmatch('<a href="(/%S-)" class="non%-hover".-original=\'(%S-)\' title=\'(.-)\' alt') do
		if Link:match("^/") then
			t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link..Link)
		end
		coroutine.yield(false)
	end
end

function ReadManga:searchManga(data, page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/search", file, "string", true, POST_METHOD, string.format("q=%s&offset=",data)..((page-1)*50))
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for Link, ImageLink, Name in file.string:gmatch('<a href="(/%S-)" class="non%-hover".-original=\'(%S-)\' title=\'(.-)\' alt') do
		if Link:match("^/") then
			t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link..Link)
		end
		coroutine.yield(false)
	end
end

function ReadManga:getChapters(manga, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link .. manga.Link, file, "string", true)
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
	Threads.DownloadStringAsync(self.Link .. chapter.Manga.Link .. chapter.Link .. "?mtr=1", file, "string", true)
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
	Threads.DownloadStringAsync(self.Link .. url, file, "string", true)
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