MangaTown = Parser:new("MangaTown", "https://www.mangatown.com", "ENG", "MANGATOWNEN")

function MangaTown:getManga(link, dest_table)
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
	local content = file.string or ""
	local t = dest_table
	local done = true
	for Link, Name, ImageLink in content:gmatch('cover" href="([^"]-)" title="([^"]-)".-src="([^"]-)"') do
		t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link .. Link)
		done = false
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function MangaTown:getPopularManga(page, dest_table)
	self:getManga(string.format("%s/hot/%s.htm", self.Link, page), dest_table)
end

function MangaTown:getLatestManga(page, dest_table)
	self:getManga(string.format("%s/new/%s.htm", self.Link, page), dest_table)
end

function MangaTown:searchManga(search, page, dest_table)
	self:getManga(string.format("%s/search?page=%s&name=%s", self.Link, page, search), dest_table)
end

function MangaTown:getChapters(manga, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link .. manga.Link,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	local t = {}
	for Link, Name in content:gmatch('href="([^"]-)" name=".-">%s-(.-)%s-</a') do
		t[#t + 1] = {
            Name = Name,
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dest_table[#dest_table+1] = t[i]
    end
end

function MangaTown:prepareChapter(chapter, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link.. chapter.Link .. "1.html",
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	local count = content:match("total_pages = (.-);") or 0
	local t = dest_table
	for i = 1, count do
		t[i] = string.format("%s%s%s.html", self.Link, chapter.Link, i)
		Console.write("Got " .. t[i])
	end
end

function MangaTown:loadChapterPage(link, dest_table)
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
	local content = file.string or ""
	dest_table.Link = content:match('img src="//([^"]-)"')
end
