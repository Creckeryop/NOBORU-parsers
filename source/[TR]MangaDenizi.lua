MangaDenizi = Parser:new("MangaDenizi", "https://mangadenizi.net", "TUR", "MANGADENIZI", 3)

MangaDenizi.Letters = {"#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

local function stringify(string)
	return string:gsub(
		"&#([^;]-);",
		function(a)
			local x = tonumber("0" .. a) or tonumber(a)
			return x and u8c(x) or "&#" .. a .. ";"
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

function MangaDenizi:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('<a href="([^"]-)" class="thumbnail">[^>]-src=[\'"]//([^\'"]-)[\'"][^>]-alt="([^"]-)"') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaDenizi:getPopularManga(page, dt)
	self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function MangaDenizi:getLetterManga(page, dt, letter)
	self:getManga(self.Link .. "/filterList?alpha=" .. letter:gsub("#", "Other") .. "&sortBy=name&asc=true&page=" .. page, dt)
end

function MangaDenizi:searchManga(search, page, dt)
	self:getManga(self.Link .. "/filterList?alpha=" .. search .. "&sortBy=views&asc=false&page=" .. page, dt)
end

function MangaDenizi:getChapters(manga, dt)
	local content = downloadContent(manga.Link)
	local description = content:match('class="well">.-<p[^>]->(.-)</p>') or ""
	dt.Description = stringify(description)
	local t = {}
	for Link, Name, SubName in content:gmatch('chapter%-title%-rtl">[^<]-<a href="([^"]-)">([^<]-)</a>.-<em>(.-)</em>') do
		t[#t + 1] = {
			Name = stringify(Name .. (SubName ~= "" and (":" .. SubName) or "")),
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function MangaDenizi:prepareChapter(chapter, dt)
	local content = downloadContent(chapter.Link)
	for Link in content:gmatch('img%-responsive"[^>]-data%-src=\' //([^\']-) \'') do
		dt[#dt + 1] = Link
	end
end

function MangaDenizi:loadChapterPage(link, dt)
	dt.Link = link
end
