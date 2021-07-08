TumangaOnline = Parser:new("TumangaOnline", "http://tumangaonline.uno", "ESP", "TMANGAONLESP", 3)

TumangaOnline.Disabled = true

TumangaOnline.Letters = {"#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
TumangaOnline.Tags = {"Acción", "Aventura", "Comedia", "Drama", "Ecchi", "Fantasía", "Gender Bender", "Harem", "Histórico", "Horror", "Josei", "Artes Marciales", "Maduro", "Mecha", "Misterio", "One Shot", "Psicológico", "Romance", "Escolar", "Ciencia Ficción", "Seinen", "Shoujo", "Shoujo Ai", "Shounen", "Shounen Ai", "Recuentos de la vida", "Deportes", "Supernatural", "Tragedia", "Yaoi", "Yuri", "Demonios", "Juegos", "Policial", "Militar", "Thriller", "Autos", "Música", "Vampiros", "Magia", "Samurai", "Boys love"}

TumangaOnline.TagValues = {
	["Acción"] = "1",
	["Aventura"] = "2",
	["Comedia"] = "3",
	["Drama"] = "5",
	["Ecchi"] = "6",
	["Fantasía"] = "7",
	["Gender Bender"] = "8",
	["Harem"] = "9",
	["Histórico"] = "10",
	["Horror"] = "11",
	["Josei"] = "12",
	["Artes Marciales"] = "13",
	["Maduro"] = "14",
	["Mecha"] = "15",
	["Misterio"] = "16",
	["One Shot"] = "17",
	["Psicológico"] = "18",
	["Romance"] = "19",
	["Escolar"] = "20",
	["Ciencia Ficción"] = "21",
	["Seinen"] = "22",
	["Shoujo"] = "23",
	["Shoujo Ai"] = "24",
	["Shounen"] = "25",
	["Shounen Ai"] = "26",
	["Recuentos de la vida"] = "27",
	["Deportes"] = "28",
	["Supernatural"] = "29",
	["Tragedia"] = "30",
	["Yaoi"] = "31",
	["Yuri"] = "32",
	["Demonios"] = "33",
	["Juegos"] = "34",
	["Policial"] = "35",
	["Militar"] = "36",
	["Thriller"] = "37",
	["Autos"] = "38",
	["Música"] = "39",
	["Vampiros"] = "40",
	["Magia"] = "41",
	["Samurai"] = "42",
	["Boys love"] = "43"
}

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

function TumangaOnline:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('<a href="([^"]-)" class="thumbnail">[^>]-src=\'([^\']-)\' alt=\'([^\']-)\'>[^<]-</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function TumangaOnline:getPopularManga(page, dt)
	self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function TumangaOnline:getLetterManga(page, dt, letter)
	self:getManga(self.Link .. "/filterList?alpha=" .. letter:gsub("#", "Other") .. "&sortBy=name&asc=true&page=" .. page, dt)
end

function TumangaOnline:getTagManga(page, dt, tag)
	self:getManga(self.Link .. "/filterList?alpha=&cat=" .. (self.TagValues[tag] or "0") .. "&sortBy=name&asc=true&page=" .. page, dt)
end

function TumangaOnline:getLatestManga(page, dt)
	local content = downloadContent(self.Link .. "/latest-release?page=" .. page)
	dt.NoPages = true
	for Link, Name in content:gmatch('manga%-item.-href="([^"]-)">(.-)</a>') do
		local key = Link:match("manga/(.*)/?") or ""
		dt[#dt + 1] = CreateManga(stringify(Name), Link, self.Link .. "/uploads/manga/" .. key .. "/cover/cover_250x350.jpg", self.ID, Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function TumangaOnline:searchManga(search, page, dt)
	self:getManga(self.Link .. "/filterList?alpha=" .. search .. "&sortBy=views&asc=false&page=" .. page, dt)
end

function TumangaOnline:getChapters(manga, dt)
	local content = downloadContent(manga.Link)
	local description = content:match('class="well">.-<p[^>]->(.-)</div>') or ""
	dt.Description = stringify(description:gsub("<.->", ""):gsub("^%s+", ""):gsub("%s+$", ""))
	local t = {}
	for Link, Name in content:gmatch('chapter%-title%-rtl">[^<]-<a href="([^"]-)">([^<]-)</a>') do
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

function TumangaOnline:prepareChapter(chapter, dt)
	local content = downloadContent(chapter.Link)
	for Link in content:gmatch('img%-responsive"[^>]-data%-src=\'[/]*([^\']-)\'') do
		dt[#dt + 1] = Link
	end
end

function TumangaOnline:loadChapterPage(link, dt)
	dt.Link = link
end
