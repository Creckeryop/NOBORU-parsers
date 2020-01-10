MangaReader = Parser:new("MangaReader", "https://www.mangareader.net", "ENG", 1)

function MangaReader:getManga(i, table, index)
	local file = {}
	Net.downloadStringAsync("https://www.mangareader.net/popular/" .. ((i - 1) * 30), file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	for img_link, link, name in file.string:gmatch('image:url%(\'(%S-)\'.-<div class="manga_name">.-<a href="(%S-)">(.-)</a>') do
		table[index][#table[index] + 1] = Manga:new(name, link, img_link, self)
		coroutine.yield(true)
	end
end

function MangaReader:getChapters(manga, index)
	local file = {}
	Net.downloadStringAsync("https://www.mangareader.net" .. manga.link, file, "string")
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

function MangaReader:getChapterInfo(chapter, index)
	local file = {}
	Net.downloadStringAsync("https://www.mangareader.net" .. chapter.manga.link .. chapter.link .. "#", file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	local count = file.string:match(" of (.-)<")
	for i = 1, count do
		file = {}
		Net.downloadStringAsync("https://www.mangareader.net" .. chapter.manga.link .. chapter.link .. "/" .. i, file, "string")
		while file.string == nil do
			coroutine.yield(false)
		end
		chapter[index][i] = file.string:match('id="img".-src="(.-)"')
		coroutine.yield(true)
	end
end

function MangaReader:getMangaFromUrl(url)
	local file = {}
	Net.downloadStringAsync("https://www.mangareader.net" .. url, file, "string")
	while file.string == nil do
		coroutine.yield(false)
	end
	local name = file.string:match('aname">(.-)<')
	local img_link = file.string:match('mangaimg">.-src%="(.-)"')
	return Manga:new(name, url, img_link, self)
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
	local img_link = file.string:match('<img class="" src%="(.-)" alt')
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
	local img_link = file.string:match('<img class="" src%="(.-)" alt')
	return Manga:new(name, url, img_link, self)
end
