HhentaiFR = Parser:new("Histoire d'Hentai", "https://hhentai.fr", "FRA", "HHENFRA", 1)

HhentaiFR.NSFW = true

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

function HhentaiFR:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, Name, ImageLink in content:gmatch('c%-image%-hover.-href="[^"]-/manga/([^"/]-)/?" title="([^"]-)".-src="([^"]-)"') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/manga/" .. Link .. "/")
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function HhentaiFR:getPopularManga(page, dt)
	self:getManga(self.Link .. "/page/" .. page .. "/?s&post_type=wp-manga", dt)
end

function HhentaiFR:getLatestManga(page, dt)
	self:getManga(self.Link .. "/page/" .. page .. "/?s&post_type=wp-manga&m_orderby=latest", dt)
end

function HhentaiFR:getAZManga(page, dt)
	self:getManga(self.Link .. "/page/" .. page .. "/?s&post_type=wp-manga&m_orderby=alphabet", dt)
end

function HhentaiFR:searchManga(search, page, dt)
	self:getManga(self.Link .. "/page/" .. page .. "/?s=" .. search .. "&post_type=wp-manga", dt)
end

function HhentaiFR:getChapters(manga, dt)
	do --DESCRIPTION PARSER
		local content = downloadContent(self.Link .. "/manga/" .. manga.Link)
		local description = content:match("description%-summary.-<p>([^<]-)</p>") or ""
		dt.Description = stringify(description:gsub("<.->", ""):gsub("^%s+", ""):gsub("%s+$", ""))
	end
	do --CHAPTERS PARSER
		local t = {}
		local content =
			downloadContent(
			{
				Link = self.Link .. "/manga/" .. manga.Link .. "/ajax/chapters/",
				HttpMethod = POST_METHOD
			}
		)
		for Link, Name in content:gmatch('wp%-manga%-chapter.-href="[^"]-/manga/([^"]-)">%s*([^<]-)%s*</a>') do
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
end

function HhentaiFR:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/manga/" .. chapter.Link):match("var chapter_preloaded_images = %[([^%]]-)%]") or ""
	for Link in content:gmatch('"([^"]-)"') do
		dt[#dt + 1] = Link:gsub("\\/", "/")
	end
end

function HhentaiFR:loadChapterPage(link, dt)
	dt.Link = link
end
