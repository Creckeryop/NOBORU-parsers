MangaChan = Parser:new("Манга-Тян!", "https://im.manga-chan.me", "RUS", "MANGACHANRU", 3)

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

function MangaChan:downloadContent(link)
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

function MangaChan:getManga(link, dt)
	local content = self:downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('content_row" title=".-href=[\'"][^\'"]-/manga/([^\'"]-)%.html[\'"]>.-<img[^>]-src="([^"]-)".-manga_row1.-title_link">(.-)</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name):gsub("<[^>]+>", ""):gsub("%s+", " "), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/manga/" .. Link .. ".html", self.Link .. "/manga/" .. Link .. ".html")
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaChan:getPopularManga(page, dt)
	self:getManga(self.Link .. "/mostfavorites?offset=" .. ((page - 1) * 20), dt)
end

function MangaChan:getLatestManga(page, dt)
	self:getManga(self.Link .. "/manga/new?offset=" .. ((page - 1) * 20), dt)
end

function MangaChan:searchManga(search, page, dt)
	local content = self:downloadContent(self.Link .. "/index.php?do=search&subaction=search&search_start=1&full_search=0&result_from=" .. (1 + (page - 1) * 40) .. "&result_num=40&story=" .. search .. "&need_sort_date=false")

	dt.NoPages = true
	for ImageLink, Link, Name in content:gmatch('content_row"%s*title=".-<img src="([^"]-)".-manga_row1.-href=[\'"][^\'"]-/manga/([^\'"]-)%.html[\'"]%s*>([^>]-)</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name):gsub("%s+", " "), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/manga/" .. Link .. ".html", self.Link .. "/manga/" .. Link .. ".html")
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaChan:getChapters(manga, dt)
	local content = self:downloadContent(self.Link .. "/manga/" .. manga.Link .. ".html")
	local description = (content:match('id="description" style.->(.-)<div') or ""):gsub("<br[^>]->", "\n"):gsub("<.->", ""):gsub("\n+", "\n"):gsub("^%s+", ""):gsub("%s+$", "")
	dt.Description = stringify(description):gsub("<[^>]+>", "")
	local t = {}
	for Link, Name in content:gmatch("href='[^']-/online/([^']-).html' title='[^']-'>(.-)</span>") do
		t[#t + 1] = {
			Name = stringify(Name):gsub("%s+", " "),
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function MangaChan:prepareChapter(chapter, dt)
	local content = self:downloadContent(self.Link .. "/online/" .. chapter.Link .. ".html"):match('"fullimg"%s*:%s*%[(.-)%]') or ""
	for link in content:gmatch('"([^"]-)"') do
		dt[#dt + 1] = {
			Link = link:gsub("\\/", "/"):gsub("%%", "%%%%"),
			Header1 = "Referer: " .. self.Link
		}
	end
end

function MangaChan:loadChapterPage(link, dt)
	dt.Link = link
end

YaoiChan = MangaChan:new("Яой-Тян!", "https://v8.yaoi-chan.me", "RUS", "YAOICHANRU", 3)
YaoiChan.NSFW = true

function YaoiChan:getPopularManga(page, dt)
	---Reason Popular doesn't work
	self:getManga(self.Link .. "/manga/new?offset=" .. ((page - 1) * 20), dt)
end

HentaiChan = MangaChan:new("Хентай-Тян!", "https://x2.h-chan.me", "RUS", "HENTAICHANRU", 6)

HentaiChan.NSFW = true

function HentaiChan:downloadContent(link)
	local file = {}
	Threads.insertTask(
		file,
		{
			Type = "StringRequest",
			Link = link,
			Table = file,
			Index = "string",
			Cookie = "dle_restore_pass11=1"
		}	
	)
	while Threads.check(file) do
		coroutine.yield(false)
	end
	return file.string or ""
end

local extended_hentai_link = "http://exhentai-dono.me"

function HentaiChan:getChapters(manga, dt)
	local content = self:downloadContent(self.Link .. "/related/" .. manga.Link .. ".html")
	manga.NewImageLink = content:match('<img id="cover" src="(.-)"') or ""
	if manga.NewImageLink == "" then
		manga.NewImageLink = nil
	end
	if content:match('<p class="extra_on">Все главы</p>') or content:match('<p class="extra_on">Все части</p>') then
		local t = {}
		local offset = 0
		while true do
			local flag = false
			for Link, Name in content:gmatch('related_info">.-href="[^"]*/manga/([^"]-)%.html"[^>]->(.-)<') do
				flag = true
				t[#t + 1] = {
					Name = stringify(Name),
					Link = Link,
					Pages = {},
					Manga = manga
				}
			end
			coroutine.yield(true)
			if not flag then
				break
			end
			offset = offset + 20
			content = self:downloadContent(self.Link .. "/related/" .. manga.Link .. ".html?offset=" .. offset)
		end
		for i = 1, #t do
			dt[i] = t[i]
		end
	else
		local url = {
			Name = stringify(manga.Name),
			Link = manga.Link,
			Pages = {},
			Manga = manga
		}
		dt[#dt + 1] = url
	end
end

function HentaiChan:prepareChapter(chapter, dt)
	local content = self:downloadContent(extended_hentai_link .. "/online/" .. chapter.Link .. ".html?development_access=true"):match('"fullimg"%s*:%s*%[(.-)%]') or ""
	for link in content:gmatch("'([^']-)'") do
		dt[#dt + 1] = {
			Link = link:gsub("\\/", "/"):gsub("%%", "%%%%"),
			Header1 = "Referer: " .. self.Link
		}
	end
end

function HentaiChan:loadChapterPage(link, dt)
	dt.Link = link
end
