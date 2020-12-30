Submanga = Parser:new("Submanga", "https://submangas.net", "ESP", "SUBMANGASPA", 2)

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

function Submanga:getManga(link, dt)
	local content = downloadContent(link)
	local t = dt
	local done = true
	for Link, ImageLink, Name in content:gmatch('<a href="([^"]-)"[^>]->[^>]-src=\'([^\']-)\' alt=\'([^\']-)\'>[^<]-</a>') do
		local manga = CreateManga(stringify(Name), Link, ImageLink, self.ID, Link)
		if manga then
			t[#t + 1] = manga
			done = false
		end
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function Submanga:getPopularManga(page, dt)
	self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function Submanga:searchManga(search, page, dt)
	self:getManga(self.Link .. "/filterList?alpha=" .. search .. "&sortBy=views&asc=false&page=" .. page, dt)
end

function Submanga:getChapters(manga, dt)
	local content = downloadContent(manga.Link)
	local description = (content:match('span class="list%-group%-item">.-<br>(.-)</span>') or ""):gsub("^%s+",""):gsub("%s+$","")
	dt.Description = stringify(description)
	local t = {}
	for Link, Name in content:gmatch('fa fa%-eye"></i>[^<]-<a href="([^"]-)">([^<]-)</a>') do
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

function Submanga:prepareChapter(chapter, dt)
	local content = downloadContent(chapter.Link)
	local t = dt
	for Link in content:gmatch('img%-responsive"[^>]-data%-src=\' ([^\']-) \'') do
		t[#t + 1] = Link
	end
end

function Submanga:loadChapterPage(link, dt)
	dt.Link = link
end
