MangaPoisk = Parser:new("МангаПоиск", "https://mangapoisk.ru", "RUS", "MANGAPOISK", 3)

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

function MangaPoisk:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('rounded">.-href="(%S-)".-src="(%S-)"%s*width=.-class.-title pl%-1 h3">([^<]-)</h2>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
		coroutine.yield(false)
		dt.NoPages = false
	end
end

function MangaPoisk:getPopularManga(page, dest_table)
	self:getManga(self.Link .. "/manga?page=" .. page, dest_table)
end

function MangaPoisk:getLatestManga(page, dest_table)
	self:getManga(self.Link .. "/manga?sortBy=-last_chapter_at&page=" .. page, dest_table)
end

function MangaPoisk:searchManga(search, page, dest_table)
	self:getManga(self.Link .. "/search?q=" .. search .. "&page=" .. page, dest_table)
end

function MangaPoisk:getChapters(manga, dt)
	local description = (downloadContent(self.Link .. manga.Link):match('class="manga%-description.->(.-)</div>') or ""):gsub("<br>","\n"):gsub("<.->",""):gsub("\n+","\n"):gsub("^%s+",""):gsub("%s+$","")
	dt.Description = stringify(description)
	local page = 1
	local res = 0
	local t = {}
	while true do
		local content = downloadContent(self.Link .. manga.Link .. "/chaptersList?infinite=1&page="..page)
		for Link, Name, subName in content:gmatch('href="(%S-)"[^>]->%s+<span class="chapter%-title">%s*(.-)%s*</span>%s*(.-)%s*</a>') do
			local sub_n = stringify(subName:gsub("%s+", " "):gsub("<[^>]->",""))
			t[#t + 1] = {
				Name = stringify(Name:gsub("%s+", " ")) .. (sub_n ~= "" and (": " .. sub_n) or ""),
				Link = Link,
				Pages = {},
				Manga = manga
			}
			res = res + 1
		end
		if res == 0 then
			break
		else
			page = page + 1
			res = 0
		end
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function MangaPoisk:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Link)
	for Link in content:gmatch('src="(%S-)"%s*class="img%-fluid page%-image') do
		dt[#dt + 1] = Link
	end
end

function MangaPoisk:loadChapterPage(link, dt)
	dt.Link = link
end
