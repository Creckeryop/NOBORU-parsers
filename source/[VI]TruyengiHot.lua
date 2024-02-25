TruyengiHot = Parser:new("TruyengiHot", "https://truyengihot.net", "VIE", "TRUYENGIHOTVI", 1)

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

function TruyengiHot:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('href="[^"]*/([^"/]-)%.html" class="cw%-list%-item.-src="([^"]-)" alt="([^"]-)"') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/truyen/" .. Link .. ".html")
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function TruyengiHot:getPopularManga(page, dt)
	self:getManga(self.Link .. "/danh-sach-truyen.html?sort=hot&sort_type=DESC&page=" .. page, dt)
end

function TruyengiHot:getLatestManga(page, dt)
	self:getManga(self.Link .. "/danh-sach-truyen.html?sort=last_update&sort_type=DESC&page=" .. page, dt)
end

function TruyengiHot:searchManga(search, page, dt)
	self:getManga(self.Link .. "/danh-sach-truyen.html?name=" .. search .. "&sort=hot&sort_type=DESC&page=" .. page, dt)
end

function TruyengiHot:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/truyen/" .. manga.Link .. ".html")
	local t = {}
	for Link, Name in content:gmatch('class="episode%-item"[^>]-href="[^"]*/([^"/]-)%.html">.->%s*([^<]-)%s*</span>') do
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

function TruyengiHot:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/chapter/" .. chapter.Link .. ".html")
	for Link in content:gmatch('data%-src="([^"]-)"') do
		dt[#dt + 1] = Link
	end
end

function TruyengiHot:loadChapterPage(link, dt)
	dt.Link = link
end
