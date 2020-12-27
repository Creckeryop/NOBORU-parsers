Manga1000 = Parser:new("Manga1000", "http://manga1000.com", "JAP", "MANGA1000JP", 2)

Manga1000.Disabled = true

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

local function to_hex(a)
	return string.byte(a) > 127 and "%" .. string.format("%02X", string.byte(a)) or a
end

function Manga1000:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name, Categories in content:gmatch('article%-wrap%-inner">.-href=".-/([^/]*)/?".-src="(%S-)".-rel="bookmark">([^<%(]*).-<span class="cat%-links">(.-)</span>') do
		local catlist = {}
		for category in Categories:gmatch("<a[^>]->(.-)</a>") do
			catlist[#catlist + 1] = category
		end
		local manga = CreateManga(stringify(Name), Link, ImageLink:gsub("^https", "http"):gsub(".", to_hex), self.ID, table.concat(catlist, " / "))
		dt[#dt + 1] = manga
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function Manga1000:getLatestManga(page, dt)
	self:getManga(self.Link .. "/page/" .. page, dt)
end

function Manga1000:getPopularManga(page, dt)
	self:getManga(self.Link .. "/seachlist/page/" .. page .. "/?cat=-1", dt)
end

function Manga1000:searchManga(search, page, dt)
	self:getManga(self.Link .. "/page/" .. page .. "/?s=" .. search:gsub(".", to_hex), dt)
end

function Manga1000:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/" .. manga.Link)
	local t = {}
	for Link, Name in content:gmatch('<tr><td>.-<a[^>]-href=".-/([^/]*)/?">(.-)</a>') do
		t[#t + 1] = {
			Name = Name,
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function Manga1000:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/" .. chapter.Link)
	for Link in content:gmatch('src="(%S-)" alt') do
		dt[#dt + 1] = Link:gsub("^https://", "")
	end
end

function Manga1000:loadChapterPage(link, dt)
	dt.Link = {
		Link = link,
		Header1 = "referer: https://manga1000.com"
	}
end
