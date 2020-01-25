MangaReader = Parser:new("MangaReader", "https://www.mangareader.net", "ENG", "MANGAREADEREN")

function MangaReader:getManga(link, dest_table)
	local file = {}
	Threads.DownloadStringAsync(link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = dest_table
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

function MangaReader:getPopularManga(page, dest_table)
	self:getManga(string.format("%s/popular/%s", self.Link, (page - 1) * 30), dest_table)
end

function MangaReader:searchManga(search, page, dest_table)
	self:getManga(string.format("%s/search/?w=%s&rd=&status=&order=&genre=&p=%s", self.Link, search, (page - 1) * 30), dest_table)
end

function MangaReader:getChapters(manga, dest_table)
	local file = {}
	Threads.DownloadStringAsync(self.Link .. manga.Link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	file.string = file.string:match('id="chapterlist"(.+)$') or ""
	local t = dest_table
	for Link, Name, subName in file.string:gmatch('chico_manga.-<a href%="/.-(/%S-)">(.-)</a>(.-)</td>') do
		t[#t + 1] = {Name = Name .. subName, Link = Link, Pages = {}, Manga = manga}
	end
end

function MangaReader:prepareChapter(chapter, dest_table)
	local file = {}
	Threads.DownloadStringAsync(self.Link .. chapter.Manga.Link .. chapter.Link .. "#", file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local count = file.string:match("</select> of (.-)<")
	local t = dest_table
	for i = 1, count do
		t[i] = self.Link .. chapter.Manga.Link .. chapter.Link .. "/" .. i
		Console.write("Got " .. t[i])
	end
end

function MangaReader:loadChapterPage(link, dest_table)
	local file = {}
	Threads.DownloadStringAsync(link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	dest_table.Link = file.string:match('id="img".-src="(.-)"')
end

MangaPanda = MangaReader:new("MangaPanda", "https://www.mangapanda.com", "ENG", "MANGAPANDAEN")
