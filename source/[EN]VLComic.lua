VLComic = Parser:new("VLComic", "http://vlcomic.com", "ENG", "VLCOMIC", 1)

VLComic.Disabled = true

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

function VLComic:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('class="ig%-grid">.-href="(%S-)".-src="(%S-)".-title="[^"]-">(.-)</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, self.Link .. ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function VLComic:getPopularManga(page, dt)
	self:getManga(self.Link .. "/popular-comics/" .. page, dt)
end

function VLComic:getLatestManga(page, dt)
	self:getManga(self.Link .. "/new-comics/" .. page, dt)
end

function VLComic:searchManga(search, _, dt)
	self:getManga(self.Link .. "/comic-collection/" .. search, dt)
	dt.NoPages = true
end

function VLComic:getChapters(manga, dt)
	local content = downloadContent(self.Link .. manga.Link)
	local t = {}
	for Link, Name in content:gmatch('class="ch%-name" href="(%S-)">(.-)</a>') do
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

function VLComic:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Link)
	for link in content:gmatch('<img src="(%S-)" title') do
		dt[#dt + 1] = link:gsub("%%", "%%%%")
	end
end

function VLComic:loadChapterPage(link, dt)
	dt.Link = link
end
