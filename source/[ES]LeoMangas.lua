LeoMangas = Parser:new("LeoMangas", "https://leomangas.xyz", "ESP", "LEOMANGASSPA", 1)

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

function LeoMangas:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('<a href="[^"]-/manga/([^"]-)"[^>]->[^>]-src=\'/*([^\']-)\' alt=\'([^\']-)\'>[^<]-</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, "https://" .. ImageLink, self.ID, Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function LeoMangas:getPopularManga(page, dt)
	self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function LeoMangas:searchManga(search, page, dt)
	self:getManga(self.Link .. "/filterList?alpha=" .. search .. "&sortBy=views&asc=false&page=" .. page, dt)
end

function LeoMangas:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/manga/" .. manga.Link)
	local t = {}

	for Link, Name in content:gmatch('chapter%-title%-rtl">%s*<a href="[^"]-([^/"]*)">([^<]-)</a>') do
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

function LeoMangas:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/manga/" .. chapter.Manga.Link .. "/" .. chapter.Link)
	for Link in content:gmatch('img%-responsive"[^>]-data%-src=\'%s*/*([^\']-)%s*\'') do
		dt[#dt + 1] = "https://" .. Link
	end
end

function LeoMangas:loadChapterPage(link, dt)
	dt.Link = link
end
