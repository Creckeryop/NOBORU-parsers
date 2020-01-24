MangaReader = Parser:new("MangaReader", "https://www.mangareader.net", "ENG", 1)

function MangaReader:getManga(link, table)
	local file = {}
	Threads.DownloadStringAsync(link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	local done = true
	for ImageLink, Link, Name in file.string:gmatch('image:url%(\'(%S-)\'.-<div class="manga_name">.-<a href="(%S-)">(.-)</a>') do
		t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link .. Link)
		done = false
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function MangaReader:getPopularManga(page, table)
	self:getManga(string.format("%s/popular/%s", self.Link, (page - 1) * 30), table)
end

function MangaReader:searchManga(search, page, table)
	self:getManga(string.format("%s/search/?w=%s&rd=&status=&order=&genre=&p=%s", self.Link, search, (page - 1) * 30), table)
end

function MangaReader:getChapters(manga, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link .. manga.Link, file, "string", true)
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
	Threads.DownloadStringAsync(self.Link .. chapter.Manga.Link .. chapter.Link .. "#", file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local count = file.string:match("</select> of (.-)<")
	local t = table
	for i = 1, count do
		t[i] = self.Link .. chapter.Manga.Link .. chapter.Link .. "/" .. i
		Console.write("Got " .. t[i])
	end
end

function MangaReader:loadChapterPage(link, table)
	local file = {}
	Threads.DownloadStringAsync(link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	table.Link = file.string:match('id="img".-src="(.-)"')
end

function MangaReader:getMangaUrl(url, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link .. url, file, "string", true)
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

MangaPanda = MangaReader:new("MangaPanda", "https://www.mangapanda.com", "ENG", 4)
