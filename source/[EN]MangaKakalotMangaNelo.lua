MangaKakalot = Parser:new("MangaKakalot", "https://mangakakalot.com", "ENG", "MANGAKAKALOT", 2)

local Patterns = {
	["https://manganelo.com"] = {"a%-h", 'class="container%-chapter%-reader">(.-)$'},
	["https://mangakakalot.com"] = {"row", 'class="vung%-doc" id="vungdoc">(.-)$'}
}

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

function MangaKakalot:getManga(link, page, dt)
	local content = downloadContent(link .. page)
	for Link, ImageLink, Name in content:gmatch('class="list%-truyen%-item%-wrap".-href="(%S-)".-src="(%S-)".-title="[^>]-">([^<]-)<') do
		local manga = CreateManga(stringify(Name), Link:match("manga/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
		if manga then
			manga.Data.Source = Link:match("(https://%S-)/")
			dt[#dt + 1] = manga
			coroutine.yield(false)
		end
	end
	local pages = content:match("Last%((.-)%)") or content:match("LAST%((.-)%)")
	dt.NoPages = pages == nil or pages == page
end

function MangaKakalot:getPopularManga(page, dt)
	self:getManga(self.Link .. "/manga_list?type=topview&category=all&state=all&page=", page, dt)
end

function MangaKakalot:getLatestManga(page, dt)
	self:getManga(self.Link .. "/manga_list?type=latest&category=all&state=all&page=", page, dt)
end

function MangaKakalot:searchManga(search, page, dt)
	local content = downloadContent(self.Link .. "/search/" .. search .. "?page=" .. page)
	for Link, ImageLink, Name in content:gmatch('class="story_item".-href="(%S-)".-src="(%S-)".-href="[^>]-">([^<]-)<') do
		local manga = CreateManga(stringify(Name), Link:match("manga/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
		if manga then
			manga.Data.Source = Link:match("(https://%S-)/")
			dt[#dt + 1] = manga
		end
		coroutine.yield(false)
	end
	local pages = content:match("Last%((.-)%)") or content:match("LAST%((.-)%)")
	dt.NoPages = pages == nil or pages == page
end

function MangaKakalot:getChapters(manga, dt)
	local content = downloadContent(manga.Data.Source .. "/manga/" .. manga.Link)
	local t = {}
	for Link, Name in content:gmatch('class="' .. Patterns[manga.Data.Source][1] .. '">.-href="(%S-)" title=".-">([^<]-)<') do
		t[#t + 1] = {
			Name = Name,
			Link = Link:match(".+/(.-)$"),
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function MangaKakalot:prepareChapter(chapter, dt)
	local content = downloadContent(chapter.Manga.Data.Source .. "/chapter/" .. chapter.Manga.Link .. "/" .. chapter.Link):match(Patterns[chapter.Manga.Data.Source][2]) or ""
	for Link in content:gmatch('img src="(%S-)" alt') do
		dt[#dt + 1] = {
			Link = Link:gsub("%%", "%%%%"),
			Header1 = "referer: " .. chapter.Manga.Data.Source .. "/chapter/" .. chapter.Manga.Link .. "/" .. chapter.Link
		}
	end
end

function MangaKakalot:loadChapterPage(link, dt)
	dt.Link = link
end

MangaNelo = MangaKakalot:new("MangaNelo", "https://manganelo.com", "ENG", "MANGANELO", 2)

function MangaNelo:getManga(link, page, dt)
	local content = downloadContent(link .. page)
	for Link, ImageLink, Name in content:gmatch('class="content%-genres%-item".-href="(%S-)".-src="(%S-)".-title="[^>]-">([^<]-)<') do
		local manga = CreateManga(stringify(Name), Link:match("manga/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
		if manga then
			manga.Data.Source = Link:match("(https://%S-)/")
			dt[#dt + 1] = manga
			coroutine.yield(false)
		end
	end
	local pages = content:match("Last%((.-)%)") or content:match("LAST%((.-)%)")
	dt.NoPages = pages == nil or pages == page
end

function MangaNelo:getPopularManga(page, dt)
	self:getManga(self.Link .. "/genre-all?type=topview&category=all&state=all&page=", page, dt)
end

function MangaNelo:getLatestManga(page, dt)
	self:getManga(self.Link .. "/genre-all?type=latest&category=all&state=all&page=", page, dt)
end

function MangaNelo:searchManga(search, page, dt)
	local content = downloadContent(self.Link .. "/search/" .. search .. "?page=" .. page)
	for Link, ImageLink, Name in content:gmatch('class="search%-story%-item".-href="(%S-)".-src="(%S-)".-title="[^>]-">([^<]-)<') do
		local manga = CreateManga(stringify(Name), Link:match("manga/(.-)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
		if manga then
			manga.Data.Source = Link:match("(https://%S-)/")
			dt[#dt + 1] = manga
		end
		coroutine.yield(false)
	end
	local pages = content:match("Last%((.-)%)") or content:match("LAST%((.-)%)")
	dt.NoPages = pages == nil or pages == page
end
