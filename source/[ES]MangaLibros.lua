MangaLibros = Parser:new("MangaLibros", "http://mangalibros.com", "ESP", "MANGALIBROSESP", 1)

local function stringify(string)
	return string:gsub(
		"&#([^;]-);",
		function(a)
			local number = tonumber("0" .. a) or tonumber(a)
			return number and u8c(number) or "&#" .. a .. ";"
		end
	):gsub(
		"&(.-);",
		function(a)
			return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
		end
	)
end

local function stringify2(string)
	return string:gsub(
		"\\u(....)",
		function(a)
			return u8c(tonumber("0x" .. a))
		end
	)
end

local function downloadContent(link)
	local f = {}
	Threads.insertTask(
		f,
		{
			Type = "StringRequest",
			Link = link,
			Table = f,
			Index = "text"
		}
	)
	while Threads.check(f) do
		coroutine.yield(false)
	end
	return f.text or ""
end

function MangaLibros:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('<a href="[^"]-/manga/([^"]-)" class="thumbnail">[^>]-src=\'([^\']-)\' alt=\'([^\']-)\'>[^<]-</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaLibros:getPopularManga(page, dt)
	self:getManga(self.Link .. "/filterList?page=" .. page .. "&cat=&alpha=&sortBy=views&asc=true&author=&tag=", dt)
end
function MangaLibros:getAZManga(page, dt)
	self:getManga(self.Link .. "/filterList?page=" .. page .. "&cat=&alpha=&sortBy=name&asc=true&author=&tag=", dt)
end

function MangaLibros:searchManga(search, _, dt)
	local content = downloadContent(self.Link .. "/search?query=" .. search)
	for Name, Link in content:gmatch('"value":"([^"]-)","data":"([^"]-)"') do
		dt[#dt + 1] = CreateManga(stringify2(Name), Link, self.Link .. "/uploads/manga/" .. Link .. "/cover/cover_250x350.jpg", self.ID, Link)
		coroutine.yield(false)
	end
	dt.NoPages = true
end

function MangaLibros:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/manga/" .. manga.Link)
	local t = {}
	local description = (content:match('class="well">(.-)</div>') or ""):gsub("^\n*", ""):gsub("\n*$", ""):gsub("<[^>]->", "")
	dt.Description = stringify(description or "")
	for Link, Name, SubName in content:gmatch('class="chapter%-title%-.-href="[^"]-/manga/([^"]-)">([^<]-)</a>(.-)</h5>') do
		SubName = SubName or ""
		t[#t + 1] = {
			Name = stringify(Name .. SubName):gsub("<[^>]->", ""):gsub("%s+", " "),
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function MangaLibros:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/manga/" .. chapter.Link)
	for Link in content:gmatch('"page_image":"\\/image\\/([^"]-)"') do
		dt[#dt + 1] = {
			Link = self.Link .. "/image/" .. Link,
			Header1 = "Referer: " .. self.Link
		}
	end
end

function MangaLibros:loadChapterPage(link, dt)
	dt.Link = link
end
