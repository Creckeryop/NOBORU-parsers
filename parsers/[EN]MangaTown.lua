MangaTown = Parser:new("MangaTown", "https://www.mangatown.com", "ENG", 8)

function MangaTown:getManga(link, table)
	local file = {}
	Threads.DownloadStringAsync(link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	local done = true
	for Link, Name, ImageLink in file.string:gmatch('cover" href="([^"]-)" title="([^"]-)".-src="([^"]-)"') do
		t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link .. Link)
		done = false
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function MangaTown:getPopularManga(page, table)
	self:getManga(string.format("%s/hot/%s.htm", self.Link, page), table)
end

function MangaTown:getLatestManga(page, table)
	self:getManga(string.format("%s/new/%s.htm", self.Link, page), table)
end

function MangaTown:searchManga(search, page, table)
	self:getManga(string.format("%s/search?page=%s&name=%s", self.Link, page, search), table)
end

function MangaTown:getChapters(manga, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link .. manga.Link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = {}
	for Link, Name in file.string:gmatch('href="([^"]-)" name=".-">%s-(.-)%s-</a') do
		t[#t + 1] = {
            Name = Name,
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        table[#table+1] = t[i]
    end
end

function MangaTown:prepareChapter(chapter, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.. chapter.Link .. "/1.html", file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local count = file.string:match("total_pages = (.-);") or 0
	local t = table
	for i = 1, count do
		t[i] = string.format("%s%s/%s.html", self.Link, chapter.Link, i)
		Console.write("Got " .. t[i])
	end
end

function MangaTown:loadChapterPage(link, table)
	local file = {}
	Threads.DownloadStringAsync(link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	table.Link = file.string:match('img src="//([^"]-)"')
end
