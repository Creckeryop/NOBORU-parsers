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

function ReadManga:getManga(i, table, index)
	local file = {}
	Net.downloadStringAsync("http://readmanga.me/list?sortType=rate&offset=" .. ((i - 1) * 70), file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	for link, img_link, name in file.string:gmatch('<a href="(/%S-)" class="non%-hover".-original=\'(%S-)\' title=\'(.-)\' alt') do
		if link:match("^/") then
			table[index][#table[index] + 1] = Manga:new(name, link, img_link, self)
		end
		coroutine.yield(true)
	end
end

function ReadManga:getChapters(manga, index)
	local file = {}
	Net.downloadStringAsync("http://readmanga.me" .. manga.link, file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	for link, name in file.string:gmatch('<td class%=.-<a href%="/.-(/vol%S-)".->(.-)</a>') do
		local chapter = {name = name:gsub("%s+", " "), link = link, pages = {}, manga = manga}
		manga[index][#manga[index] + 1] = chapter
	end
	manga[index] = TableReverse(manga[index])
end

function ReadManga:getChapterInfo(chapter, index)
	local file = {}
	Net.downloadStringAsync("http://readmanga.me" .. chapter.manga.link .. chapter.link .. "?mtr=1", file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	local text = file.string:match("rm_h.init%( %[%[(.-)%]%]")
	if text ~= nil then
		local list = load("return {{" .. text:gsub("%],%[", "},{") .. "}}")()
		for i = 1, #list do
			chapter[index][i] = list[i][2] .. list[i][3]
		end
	end
end

function ReadManga:getMangaFromUrl(url)
	local file = {}
	Net.downloadStringAsync("http://www.readmanga.me" .. url, file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	local name = file.string:match("<span class%='name'>(.-)</span>")
	local img_link = file.string:match('<img class="" src%="(.-)"')
	return Manga:new(name, url, img_link, self)
end

MintManga = Parser:new("MintManga", "https://mintmanga.live", "RUS", 3)

function MintManga:getManga(i, table, index)
	local file = {}
	Net.downloadStringAsync("http://mintmanga.live/list?sortType=rate&offset=" .. ((i - 1) * 70), file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	for link, img_link, name in file.string:gmatch('<a href="(/%S-)" class="non%-hover".-original=\'(%S-)\' title=\'(.-)\' alt') do
		if link:match("^/") then
			table[index][#table[index] + 1] = Manga:new(name, link, img_link, self)
		end
		coroutine.yield(true)
	end
end

function MintManga:getChapters(manga, index)
	local file = {}
	Net.downloadStringAsync("http://mintmanga.live" .. manga.link, file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	for link, name in file.string:gmatch('<td class%=.-<a href%="/.-(/vol%S-)".->(.-)</a>') do
		local chapter = {name = name:gsub("%s+", " "), link = link, pages = {}, manga = manga}
		manga[index][#manga[index] + 1] = chapter
	end
	manga[index] = TableReverse(manga[index])
end

function MintManga:getChapterInfo(chapter, index)
	local file = {}
	Net.downloadStringAsync("http://mintmanga.live" .. chapter.manga.link .. chapter.link .. "?mtr=1", file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	local text = file.string:match("rm_h.init%( %[%[(.-)%]%]")
	if text ~= nil then
		local list = load("return {{" .. text:gsub("%],%[", "},{") .. "}}")()
		for i = 1, #list do
			chapter[index][i] = list[i][2] .. list[i][3]
		end
	end
end

function MintManga:getMangaFromUrl(url)
	local file = {}
	Net.downloadStringAsync("http://www.mintmanga.live" .. url, file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	local name = file.string:match("<span class%='name'>(.-)</span>")
	local img_link = file.string:match('<img class="" src%="(.-)"')
	return Manga:new(name, url, img_link, self)
end

MangaPanda = Parser:new("MangaPanda", "https://www.mangapanda.com", "ENG", 4)

function MangaPanda:getManga(i, table, index)
	local file = {}
	Net.downloadStringAsync("https://www.mangapanda.com/popular/" .. ((i - 1) * 30), file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	for img_link, link, name in file.string:gmatch('image:url%(\'(%S-)\'.-<div class="manga_name">.-<a href="(%S-)">(.-)</a>') do
		table[index][#table[index] + 1] = Manga:new(name, link, img_link, self)
		coroutine.yield(true)
	end
end

function MangaPanda:getChapters(manga, index)
	local file = {}
	Net.downloadStringAsync("https://www.mangapanda.com" .. manga.link, file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	file.string = file.string:match('id="chapterlist"(.+)$') or ""
	for link, name, subName in file.string:gmatch('<td>.-<a href%="/.-(/%S-)">(.-)</a>(.-)</td>') do
		local chapter = {name = name .. subName, link = link, pages = {}, manga = manga}
		manga[index][#manga[index] + 1] = chapter
		--Console.addLine ("Parser: Got chapter \""..chapter.name.."\" ("..chapter.link..")", LUA_COLOR_GREEN)
	end
end

function MangaPanda:getChapterInfo(chapter, index)
	local file = {}
	Net.downloadStringAsync("https://www.mangapanda.com" .. chapter.manga.link .. chapter.link .. "#", file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	local count = file.string:match(" of (.-)<")
	for i = 1, count do
		file = {}
		Net.downloadStringAsync("https://www.mangapanda.com" .. chapter.manga.link .. chapter.link .. "/" .. i, file, "string")
		while file.string == nil do
			coroutine.yield(false)
		end
		chapter[index][i] = file.string:match('id="img".-src="(.-)"')
		coroutine.yield(true)
	end
end

function MangaPanda:getMangaFromUrl(url)
	local file = {}
	Net.downloadStringAsync("https://www.mangapanda.com" .. url, file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	local name = file.string:match('aname">(.-)<')
	local img_link = file.string:match('mangaimg">.-src%="(.-)"')
	return Manga:new(name, url, img_link, self)
end