MangaDoor = Parser:new("MangaDoor", "http://mangadoor.com", "ESP", "MANGADOORESP", 1)

MangaDoor.Tags = {"Acción", "Aventura", "Comedia", "Drama", "Ecchi", "Fantasía", "Gender Bender", "Harem", "Histórico", "Horror", "Josei", "Artes Marciales", "Maduro", "Mecha", "Misterio", "One Shot", "Psicológico", "Romance", "Escolar", "Ciencia Ficción", "Seinen", "Shoujo", "Shoujo Ai", "Shounen", "Shounen Ai", "Recuentos de la vida", "Deportes", "Supernatural", "Tragedia", "Yaoi", "Yuri", "Demonios", "Juegos", "Policial", "Militar", "Thriller", "Autos", "Música", "Vampiros", "Magia", "Samurai", "Boys love", "Hentai"}

MangaDoor.TagValues = {
	["Acción"] = 1,
	["Aventura"] = 2,
	["Comedia"] = 3,
	["Drama"] = 5,
	["Ecchi"] = 6,
	["Fantasía"] = 7,
	["Gender Bender"] = 8,
	["Harem"] = 9,
	["Histórico"] = 10,
	["Horror"] = 11,
	["Josei"] = 12,
	["Artes Marciales"] = 13,
	["Maduro"] = 14,
	["Mecha"] = 15,
	["Misterio"] = 16,
	["One Shot"] = 17,
	["Psicológico"] = 18,
	["Romance"] = 19,
	["Escolar"] = 20,
	["Ciencia Ficción"] = 21,
	["Seinen"] = 22,
	["Shoujo"] = 23,
	["Shoujo Ai"] = 24,
	["Shounen"] = 25,
	["Shounen Ai"] = 26,
	["Recuentos de la vida"] = 27,
	["Deportes"] = 28,
	["Supernatural"] = 29,
	["Tragedia"] = 30,
	["Yaoi"] = 31,
	["Yuri"] = 32,
	["Demonios"] = 33,
	["Juegos"] = 34,
	["Policial"] = 35,
	["Militar"] = 36,
	["Thriller"] = 37,
	["Autos"] = 38,
	["Música"] = 39,
	["Vampiros"] = 40,
	["Magia"] = 41,
	["Samurai"] = 42,
	["Boys love"] = 43,
	["Hentai"] = 44
}

MangaDoor.Letters = {"#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

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

local function stringify2(string)
	return string:gsub(
		"\\u(....)",
		function(a)
			return u8c(tonumber("0x" .. a))
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

function MangaDoor:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('<a href="[^"]-/manga/([^"]-)"[^>]->[^>]-src=\'([^\']-)\' alt=\'([^\']-)\'>[^<]-</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/manga/" .. Link, self.Link .. "/manga/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaDoor:getPopularManga(page, dt)
	self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function MangaDoor:getAZManga(page, dt)
	self:getManga(self.Link .. "/filterList?sortBy=name&asc=true&page=" .. page, dt)
end

function MangaDoor:getLetterManga(page, dt, letter)
	self:getManga(self.Link .. "/filterList?alpha=" .. letter:gsub("#", "Other") .. "&sortBy=name&asc=true&page=" .. page, dt)
end

function MangaDoor:getTagManga(page, dt, tag)
	self:getManga(self.Link .. "/filterList?alpha=&cat=" .. (self.TagValues[tag] or "0") .. "&sortBy=name&asc=true&page=" .. page, dt)
end

function MangaDoor:searchManga(search, page, dt)
	local content = downloadContent(self.Link .. "/search?query=" .. search)
	dt.NoPages = true
	for value, data in content:gmatch('{"value":"(.-)","data":"(.-)"}') do
		dt[#dt + 1] = CreateManga(stringify2(value), data, self.Link .. "/uploads/manga/" .. data .. "/cover/cover_250x350.jpg", self.ID, self.Link .. "/manga/" .. data, self.Link .. "/manga/" .. data)
		coroutine.yield(false)
	end
end

function MangaDoor:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/manga/" .. manga.Link)
	local t = {}
	for Link, Name, SubName in content:gmatch('chapter%-title%-rtl">[^<]-<a href="[^"]-/manga/([^"]-)">([^<]-)</a>(.-)</h5>') do
		SubName = SubName:match("<em>([^<]-)</em>")
		t[#t + 1] = {
			Name = stringify(Name .. (SubName and (": " .. SubName) or "")),
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function MangaDoor:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/manga/" .. chapter.Link)
	for Link in content:gmatch('img%-responsive"[^>]-data%-src=\'//([^\']-)\'') do
		dt[#dt + 1] = Link
	end
end

function MangaDoor:loadChapterPage(link, dt)
	dt.Link = link
end
