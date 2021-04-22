MangaHubRU = Parser:new("MangaHub (Русский)", "https://mangahub.ru", "RUS", "MANGAHUBRU", 1)

local function stringify(string)
	if u8c then
		return string:gsub(
			"&#([^;]-);",
			function(a)
				local number = tonumber("0" .. a) or tonumber(a)
				return number and u8c(number) or "&#" .. a .. ";"
			end
		):gsub(
			"&([^;]-);",
			function(a)
				return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
			end
		)
	else
		return string
	end
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

function MangaHubRU:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch('<a href="/([^"]-)" class="d%-block position%-relative">.-data%-background%-image="([^"]-)"></div>.-<a class="comic%-grid%-name[^>]->%s*(.-)%s*</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaHubRU:getPopularManga(page, dt)
	self:getManga(self.Link .. "/explore?filter%5Bsort%5D=rating&filter%5Btypes%5D%5Bexcludes%5D=&filter%5Bgenres%5D%5Bexcludes%5D=&filter%5Bstatus%5D%5Bexcludes%5D=&filter%5Bcountry%5D%5Bexcludes%5D=&page="..page, dt)
end

function MangaHubRU:getLatestManga(page, dt)
	self:getManga(self.Link .. "/explore?filter%5Bsort%5D=update&filter%5Btypes%5D%5Bexcludes%5D=&filter%5Bgenres%5D%5Bexcludes%5D=&filter%5Bstatus%5D%5Bexcludes%5D=&filter%5Bcountry%5D%5Bexcludes%5D=&page="..page, dt)
end

function MangaHubRU:searchManga(search, page, dt)
	self:getManga(self.Link .. "/search/manga?filter%5Bsort%5D=score&query="..search.."&filter%5Bquery%5D="..search.."&filter%5Btypes%5D%5Bexcludes%5D=&filter%5Bgenres%5D%5Bexcludes%5D=&filter%5Bstatus%5D%5Bexcludes%5D=&filter%5Bcountry%5D%5Bexcludes%5D=&page=".. page, dt)
end

function MangaHubRU:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/" .. manga.Link)
	local t = {}
    for Link, Name in content:gmatch('<a class="[^>]-text%-truncate" href="/[^"]-/read/([^"]-)/">%s*(.-)%s*</a>') do
		t[#t + 1] = {
			Name = stringify(Name:gsub("[\t\n ]+"," ")),
			Link = Link,
			Pages = {},
			Manga = manga
		}
    end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function MangaHubRU:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .."/"..chapter.Manga.Link.. "/read/" .. chapter.Link)
    for Link in content:gmatch('src&quot;:&quot;[\\/]*([^&]-)&quot;') do
		dt[#dt + 1] = Link:gsub("\\/", "/"):gsub("%%", "%%%%")
	end
end

function MangaHubRU:loadChapterPage(link, dt)
	dt.Link = link
end
