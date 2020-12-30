--https://readcomicsonline.ru/filterList?sortBy=Views&page=1
ReadComicsOnline = Parser:new("ReadComicsOnline", "https://readcomicsonline.ru", "ENG", "READCONLINEENG", 2)

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

function ReadComicsOnline:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('<a href="([^"]-)">[^>]-src=\'//([^\']-)\' alt=\'([^\']-)\'>[^<]-</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function ReadComicsOnline:getLatestManga(page, dt)
	self:getManga(self.Link .. "/filterList?sortBy=last_release&asc=false&page=" .. page, dt)
end

function ReadComicsOnline:getPopularManga(page, dt)
	self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function ReadComicsOnline:searchManga(search, page, dt)
	self:getManga(self.Link .. "/filterList?alpha=" .. search .. "&sortBy=views&asc=false&page=" .. page, dt)
end

function ReadComicsOnline:getChapters(manga, dt)
	local content = downloadContent(manga.Link)
	local description = content:match('manga well">.-<p[^>]->(.-)</p>') or ""
	dt.Description = stringify(description)
	local t = {}
	for Link, Name in content:gmatch('chapter%-title%-rtl">[^<]-<a href="([^"]-)">([^<]-)</a>') do
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

function ReadComicsOnline:prepareChapter(chapter, dt)
	local content = downloadContent(chapter.Link)
	for Link in content:gmatch('img%-responsive"[^>]-data%-src=\' ([^\']-) \'') do
		dt[#dt + 1] = Link
	end
end

function ReadComicsOnline:loadChapterPage(link, dt)
	dt.Link = link
end
