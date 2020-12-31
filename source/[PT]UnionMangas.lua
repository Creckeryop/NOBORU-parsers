UnionMangas = Parser:new("UnionMangas", "https://unionleitor.top", "PRT", "UNIONMANGASPT", 1)

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

function UnionMangas:getManga(link, dt)
	local content = downloadContent(link)
	local t = dt
	local done = true
	for Link, ImageLink, Name in content:gmatch('media lancamento%-linha">[^>]-href="([^"]-)">[^>]-src="([^"]-)".->%s+([^<]-)</a>') do
		t[#t + 1] = CreateManga(stringify(Name), Link:match(".+/(.-)$"), ImageLink, self.ID, Link)
		done = false
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function UnionMangas:getPopularManga(page, dt)
	self:getManga(self.Link .. "/lista-mangas/visualizacoes/" .. page, dt)
end

function UnionMangas:searchManga(search, page, dt)
	local content = downloadContent(self.Link .. "/assets/busca.php?q=" .. search)
	local done = true
	for ImageLink, Name, Link in content:gmatch('"imagem":"([^"]-)","titulo":"([^"]-)","url":"([^"]-)"') do
		dt[#dt + 1] = CreateManga(Name, Link, ImageLink:gsub("\\/", "/"), self.ID, self.Link .. "/perfil-manga/" .. Link)
		done = false
		coroutine.yield(false)
	end
	if done then
		dt.NoPages = true
	end
end

function UnionMangas:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/perfil-manga/" .. manga.Link)
	local description = (content:match('class="panel%-body">(.-)</div>') or ""):gsub("^%s+",""):gsub("%s+$","")
	dt.Description = stringify(description)
	local t = {}
	for Link, Name in content:gmatch('row lancamento%-linha">.-href="([^"]-)">([^<]-)</a>') do
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

function UnionMangas:prepareChapter(chapter, dt)
	local content = downloadContent(chapter.Link)
	local t = dt
	for Link in content:gmatch('img src="([^"]-/leitor/[^"]-)"') do
		t[#t + 1] = Link:gsub("%s", "%%%%20")
	end
end

function UnionMangas:loadChapterPage(link, dt)
	dt.Link = link
end
