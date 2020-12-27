Mabushimajo = Parser:new("Mabushimajo", "http://mabushimajo.com", "TUR", "MABUSHTR", 1)

Mabushimajo.Disabled = true

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

function Mabushimajo:getManga(link, dt)
	local content = downloadContent(link)
	for Link, ImageLink, Name in content:gmatch('class="group"><a href="(%S-)">.-src="(%S-)".-title=.->([^<]-)<') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link:match("^.+/(.-)/$"), ImageLink, self.ID, Link)
		coroutine.yield(false)
	end
	dt.NoPages = not content:find("Last")
end

function Mabushimajo:getPopularManga(page, dt)
	self:getManga(self.Link .. "/onlineokuma/directory/" .. page, dt)
end

function Mabushimajo:getChapters(manga, dt)
	local content = downloadContent(manga.RawLink)
	local t = {}
	for Link, Name in content:gmatch('class="element">.-<a href="(%S-)" title=[^>]->([^<]-)<') do
		t[#t + 1] = {
			Name = stringify(Name),
			Link = Link:match("read/(.+)"),
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function Mabushimajo:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/onlineokuma/read/" .. chapter.Link .. "/page/1")
	for Link in content:gmatch('"url" ?: ?"(%S-)"') do
		dt[#dt + 1] = Link:gsub("\\/", "/")
	end
end

function Mabushimajo:loadChapterPage(link, dt)
	dt.Link = link
end
