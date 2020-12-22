MangaChan = Parser:new("Манга-Тян!", "https://manga-chan.me", "RUS", "MANGACHANRU", 1)

local function stringify(string)
	if u8c then
		return string:gsub(
			"&#([^;]-);",
			function(a)
				local number = tonumber("0" .. a) or tonumber(a)
				return number and u8c(number) or "&#" .. a .. ";"
			end
		):gsub(
			"&([^;]-);",
			function(a)
				return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
			end
		)
	else
		return string
	end
end

local function downloadContent(link)
	local file = {}
	Threads.insertTask(
		file,
		{
			Type = "StringRequest",
			Link = link,
			Table = file,
			Index = "string"
		}
	)
	while Threads.check(file) do
		coroutine.yield(false)
	end
	return file.string or ""
end

function MangaChan:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('content_row" title=".-href="/manga/([^"]-)%.html"><img src="([^"]-)".-manga_row1.-title_link">(.-)</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/manga/" .. Link .. ".html", self.Link .. "/manga/" .. Link .. ".html")
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaChan:getPopularManga(page, dt)
	self:getManga(self.Link .. "/mostfavorites?offset=" .. ((page - 1) * 20), dt)
end

function MangaChan:getLatestManga(page, dt)
	self:getManga(self.Link .. "/manga/new?offset=" .. ((page - 1) * 20), dt)
end

function MangaChan:searchManga(search, page, dt)
	local content = downloadContent(self.Link .. "/index.php?do=search&subaction=search&search_start=1&full_search=0&result_from=" .. (1 + (page-1) * 40) .. "&result_num=40&story=" .. search .. "&need_sort_date=false")
	dt.NoPages = true
	for ImageLink, Link, Name in content:gmatch('content_row" title=".-<img src="([^"]-)".-href="[^"]*/manga/([^"]-)%.html[^>]->(.-)</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/manga/" .. Link .. ".html", self.Link .. "/manga/" .. Link .. ".html")
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaChan:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/manga/" .. manga.Link .. ".html")
	local t = {}
	for Link, Name in content:gmatch("href='/online/([^']-).html' title='[^']-'>(.-)</span>") do
		t[#t + 1] = {
			Name = stringify(Name),
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function MangaChan:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/online/" .. chapter.Link .. ".html"):match('"fullimg":%[(.-)%]') or ""
	for link in content:gmatch('"([^"]-)"') do
		dt[#dt + 1] = link:gsub("\\/", "/"):gsub("%%", "%%%%")
	end
end

function MangaChan:loadChapterPage(link, dt)
	dt.Link = link
end
