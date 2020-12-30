XoXoComics = Parser:new("XoXoComics", "https://www.xoxocomics.com", "ENG", "XOXOCEN", 2)

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

function XoXoComics:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Name, Link, ImageLink in content:gmatch('item">.-"image">[\r\n]<a title="(.-)" href=".-/comic/(.-)".-original="(%S-)" alt') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/comic/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function XoXoComics:getPopularManga(page, dt)
	self:getManga(self.Link .. "/hot?page=" .. page, dt)
end

function XoXoComics:getLatestManga(page, dt)
	self:getManga(self.Link .. "/", dt)
	dt.NoPages = true
end

function XoXoComics:searchManga(search, page, dt)
	self:getManga(self.Link .. "/search?keyword=" .. search .. "&page=" .. page, dt)
end

function XoXoComics:getChapters(manga, dt)
	local t = {}
	local page = 1
	local description = nil
	while true do
		local content = downloadContent(self.Link .. "/comic/" .. manga.Link .. "?page=" .. page)
		if description == nil then
			description = (content:match("Summary.-<p[^>]->(.-)</p>") or "")
			dt.Description = description
		end
		for Link, Name in content:gmatch('chapter">[\r\n]+<a href=".-/comic/.-/(.-)">(.-)</a>') do
			t[#t + 1] = {
				Name = stringify(Name:gsub("[\r\n]", " ")),
				Link = Link,
				Pages = {},
				Manga = manga
			}
		end
		if content:find('rel="next">') then
			page = page + 1
		else
			break
		end
		coroutine.yield(true)
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function XoXoComics:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/comic/" .. chapter.Manga.Link .. "/" .. chapter.Link)
	dt[#dt + 1] = self.Link .. "/comic/" .. chapter.Manga.Link .. "/" .. chapter.Link
	for Link in (content:match('id="selectPage"(.-)</select>') or ""):gmatch('<option value="([^"]-)">%d-</option>') do
		dt[#dt + 1] = Link
	end
end

function XoXoComics:loadChapterPage(link, dt)
	local content = downloadContent(link)
	dt.Link = content:match("class='page%-chapter'><[^>]-src='([^']-)'") or content:match('class=\'page%-chapter\'><[^>]-src="([^"]-)"') or ""
end
