HipercooL = Parser:new("HipercooL", "https://hiper.cool", "PRT", "HIPCOOLPT", 1)

HipercooL.NSFW = true

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

function HipercooL:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('href="/books/([^"]-)"[^>]-style="background%-image:url%(&quot;(.-)&quot;.-class="title"[^>]->(.-)</div>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, {Link = ImageLink:gsub("%%", "%%%%"), Header1 = "Referer: https://hiper.cool/"}, self.ID, self.Link .. "/books/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function HipercooL:getLatestManga(page, dt)
	self:getManga(self.Link .. "/home/" .. page, dt)
end

function HipercooL:searchManga(search, page, dt)
	self:getManga(self.Link .. "/page/" .. page .. "?s=" .. search, dt)
end

function HipercooL:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/books/" .. manga.Link)
	local newLink = content:match('div class="cover" style="background%-image:url%(&quot;(.-)&quot;')
	if newLink then
		manga.NewImageLink = {Link = newLink,  Header1 = "Referer: https://hiper.cool/"}
	end
	manga.Name = stringify(content:match('span class="title"[^>]->(.-)</span>') or manga.Name)
	for link in content:gmatch('div class="chapter"[^>]-><a href="/books/[^/]-/(.-)"') do
		dt[#dt + 1] = {
			Name = "Capítulo " .. link,
			Link = link,
			Pages = {},
			Manga = manga
		}
	end
end

function HipercooL:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/books/"..chapter.Manga.Link.."/" .. chapter.Link)
	for link in content:gmatch('img src="(.-)"') do
		dt[#dt + 1] = link:gsub("\\/", "/"):gsub("%%", "%%%%")
	end
end

function HipercooL:loadChapterPage(link, dt)
	dt.Link = {Link = link, Header1 = "Referer: https://hiper.cool/"}
end
