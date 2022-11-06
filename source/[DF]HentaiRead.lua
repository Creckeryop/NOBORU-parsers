HentaiRead = Parser:new("HentaiRead", "https://hentairead.com", "DIF", "HENREADDIF", 3)

HentaiRead.NSFW = true

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

function HentaiRead:getManga(link, dt, is_search)
	local content = downloadContent(link)
	dt.NoPages = true
	local regex = 'item%-thumb c%-image%-hover".-href=".-/hentai/([^"]-)/" title="([^"]-)".-data%-src="([^"]-)"'
	--[[if is_search then
		regex = 'row c%-tabs%-item__content">.-href=".-/hentai/([^"]-)/" title="([^"]-)".-data%-src="([^"]-)"'
	end]]
	for Link, Name, ImageLink in content:gmatch(regex) do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/hentai/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function HentaiRead:getLatestManga(page, dt)
	self:getManga(self.Link .. "/hentai/page/" .. page .. "/?m_orderby=latest&m_order=desc", dt)
end

function HentaiRead:getPopularManga(page, dt)
	self:getManga(self.Link .. "/hentai/page/" .. page .. "/?m_orderby=views&m_order=desc", dt)
end

function HentaiRead:searchManga(search, page, dt)
	self:getManga(self.Link .. "/page/" .. page .. "/?s=" .. search .. "&post_type=wp-manga&verified=1", dt, true)
end

function HentaiRead:getChapters(manga, dt)
	dt[#dt + 1] = {
		Name = "Read chapter",
		Link = manga.Link,
		Pages = {},
		Manga = manga
	}
end

function HentaiRead:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/hentai/" .. chapter.Link .. "/english"):match("var chapter_preloaded_images = %[(.-)%]") or ""
	for Link in content:gmatch('"([^"]-)"') do
		dt[#dt + 1] = Link:gsub("\\/", "/")
	end
end

function HentaiRead:loadChapterPage(link, dt)
	dt.Link = link
end
