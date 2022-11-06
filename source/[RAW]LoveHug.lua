--[[
	Links structure
	Manga.Link = 964/
	Chapter.Link = 32976/
--]]
LoveHug = Parser:new("LoveHug", "https://lovehug.net", "RAW", "LOVEHUGRAW", 4)

LoveHug.Disabled = true --Reason is simple LoveHug is now mobile app with login password (currently not supported)

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

local manga_list = "https://lovehug.net/manga-list.html?listType=pagination&page=%s&artist=&author=&group=&m_status=&name=&genre=&ungenre=&magazine=&sort=%s&sort_type=%s"
local manga_srch = "https://lovehug.net/manga-list.html?listType=pagination&page=%s&artist=&author=&group=&m_status=&name=%s&genre=&ungenre=&magazine=&sort=views&sort_type=DESC"

local function genMangaListLink(page, sort, sort_type)
	return manga_list:format(page, sort, sort_type)
end

local function genMangaSearchLink(page, search_string)
	return manga_srch:format(page, search_string)
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

function LoveHug:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	local pageA, pageB = content:match("Page (%d+) of (%d+)")
	for ImageLink, Link, Name in content:gmatch('<div class="thumb%-item%-flow.-data%-bg="([^"]-)".-class="thumb_attr series%-title">.-href="/(.-)"[^>]->([^<]-)<') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, {Link = ImageLink, Header1 = "Referer: https://lovehug.net/manga-list.html"}, self.ID, self.Link .. "/" .. Link)
		if tonumber(pageA) < tonumber(pageB) then
			dt.NoPages = false
		end
		coroutine.yield(false)
	end
end

function LoveHug:getPopularManga(page, dt)
	self:getManga(genMangaListLink(page, "views", "DESC"), dt)
end

function LoveHug:getLatestManga(page, dt)
	self:getManga(genMangaListLink(page, "last_update", "DESC"), dt)
end

function LoveHug:getAZManga(page, dt)
	self:getManga(genMangaListLink(page, "name", "DESC"), dt)
end

function LoveHug:searchManga(search, page, dt)
	self:getManga(genMangaSearchLink(page, search), dt)
end

function LoveHug:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/" .. manga.Link)
	local t = {}
	for Link, Name in content:gmatch('<a href="/[^/>]-/([^/>]-/)" target="_blank" title=[^>]->[^<]-<li>[^<]-<div class="chapter%-name text%-truncate">([^<]-)</div>') do
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

function LoveHug:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/" .. chapter.Manga.Link .. chapter.Link)
	for Link in content:gmatch("<img class='[^']-chapter%-img' [^>]+src[^>]-='%s*([^']-)%s*'") do
		dt[#dt + 1] = {
			Link = Link:gsub("[\r\n]", ""),
			Header1 = "Referer: https://lovehug.net/manga-list.html"
		}
	end
end

function LoveHug:loadChapterPage(link, dt)
	dt.Link = link
end
