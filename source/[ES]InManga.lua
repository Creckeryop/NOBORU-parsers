InManga = Parser:new("InManga", "https://inmanga.com", "ESP", "INMANGASPA", 2)

InManga.Filters = {
	{
		Name = "Géneros",
		Type = "check",
		Tags = {
			"Aventura",
			"Shounen",
			"Suspenso",
			"Misterio",
			"Acción",
			"Fantasía",
			"Gore",
			"Sobrenatural",
			"Romance",
			"Drama",
			"Artes Marciales",
			"Ciencia Ficción",
			"Thriller",
			"Comedia",
			"Mecha",
			"Supernatural",
			"Tragedia",
			"Adulto",
			"Harem",
			"Yuri",
			"Seinen",
			"Horror",
			"Webtoon",
			"Apocalíptico",
			"Boys Love",
			"Ciberpunk",
			"Crimen",
			"Demonios",
			"Deporte",
			"Ecchi",
			"Extranjero",
			"Familia",
			"Fantasia",
			"Género Bender",
			"Girls Love",
			"Guerra",
			"Historia",
			"Magia",
			"Militar",
			"Musica",
			"Parodia",
			"Policiaco",
			"Psicológico",
			"Realidad",
			"Realidad Virtual",
			"Recuentos de la vida",
			"Reencarnación",
			"Samurái",
			"Superpoderes",
			"Supervivencia",
			"Vampiros",
			"Vida Escolar"
		}
	},
	{
		Name = "Ordenar por",
		Type = "radio",
		Tags = {
			"Vistos",
			"Nombre",
			"Relevancia",
			"Recién agregado",
			"Recién actualizado",
			"Más capítulos",
			"Menos capítulos"
		}
	},
	{
		Name = "Estado",
		Type = "radio",
		Tags = {
			"Todos",
			"En Emisión",
			"Finalizado"
		}
	}
}

InManga.Filtros = {
	["Todos"] = "0",
	["En Emisión"] = "1",
	["Finalizado"] = "2"
}

InManga.Classes = {
	["Vistos"] = "1",
	["Relevancia"] = "2",
	["Recién agregado"] = "4",
	["Nombre"] = "5",
	["Recién actualizado"] = "3",
	["Más capítulos"] = "6",
	["Menos capítulos"] = "7"
}

InManga.Keys = {
	["Vistos"] = "1",
	["Relevancia"] = "2",
	["Recién agregado"] = "4",
	["Recién actualizado"] = "3",
	["Más capítulos"] = "6",
	["Menos capítulos"] = "7",
	["Aventura"] = "33",
	["Shounen"] = "34",
	["Suspenso"] = "35",
	["Misterio"] = "36",
	["Acción"] = "37",
	["Fantasía"] = "38",
	["Gore"] = "39",
	["Sobrenatural"] = "40",
	["Romance"] = "41",
	["Drama"] = "42",
	["Artes Marciales"] = "43",
	["Ciencia Ficción"] = "44",
	["Thriller"] = "45",
	["Comedia"] = "46",
	["Mecha"] = "47",
	["Supernatural"] = "48",
	["Tragedia"] = "49",
	["Adulto"] = "50",
	["Harem"] = "51",
	["Yuri"] = "52",
	["Seinen"] = "53",
	["Horror"] = "54",
	["Webtoon"] = "55",
	["Apocalíptico"] = "56",
	["Boys Love"] = "57",
	["Ciberpunk"] = "58",
	["Crimen"] = "59",
	["Demonios"] = "60",
	["Deporte"] = "61",
	["Ecchi"] = "62",
	["Extranjero"] = "63",
	["Familia"] = "64",
	["Fantasia"] = "65",
	["Género Bender"] = "66",
	["Girls Love"] = "67",
	["Guerra"] = "68",
	["Historia"] = "69",
	["Magia"] = "70",
	["Militar"] = "71",
	["Musica"] = "72",
	["Parodia"] = "73",
	["Policiaco"] = "74",
	["Psicológico"] = "75",
	["Realidad"] = "76",
	["Realidad Virtual"] = "77",
	["Recuentos de la vida"] = "78",
	["Reencarnación"] = "79",
	["Samurái"] = "80",
	["Superpoderes"] = "81",
	["Supervivencia"] = "82",
	["Vampiros"] = "83",
	["Vida Escolar"] = "84"
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

function InManga:getManga(post, dt)
	local file = {}
	Threads.insertTask(
		file,
		{
			Type = "StringRequest",
			Link = self.Link .. "/manga/getMangasConsultResult",
			Table = file,
			Index = "string",
			HttpMethod = POST_METHOD,
			PostData = post:gsub("%%", "%%%%"),
			ContentType = XWWW
		}
	)
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	dt.NoPages = true
	for Link, Name, ImageLink in content:gmatch('href="(/ver/manga/[^"]-)".-</em> (.-)</h4>.-data%-src="([^"]-)"') do
		local link, id = Link:match("(.+)/(.-)$")
		local manga = CreateManga(stringify(Name), link, self.Link .. ImageLink, self.ID, self.Link .. Link)
		if manga then
			manga.Data = {
				id = id
			}
			dt[#dt + 1] = manga
		end
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function InManga:getLatestManga(page, dt)
	self:getManga("filter%5Bgeneres%5D%5B%5D=-1&filter%5BqueryString%5D=&filter%5Bskip%5D=" .. ((page - 1) * 10) .. "&filter%5Btake%5D=10&filter%5Bsortby%5D=3&filter%5BbroadcastStatus%5D=0&filter%5BonlyFavorites%5D=false&d=", dt)
end

function InManga:getPopularManga(page, dt)
	self:getManga("filter%5Bgeneres%5D%5B%5D=-1&filter%5BqueryString%5D=&filter%5Bskip%5D=" .. ((page - 1) * 10) .. "&filter%5Btake%5D=10&filter%5Bsortby%5D=1&filter%5BbroadcastStatus%5D=0&filter%5BonlyFavorites%5D=false&d=", dt)
end

function InManga:searchManga(search, page, dt, tags)
	local genres = "filter%5Bgeneres%5D%5B%5D=-1&filter%5Bsortby%5D=1&filter%5BbroadcastStatus%5D=0"
	if tags then
		local Genres = tags[1]
		local Class = tags[2]
		local Filtr = tags[3]
		genres = ""
		if Genres and #Genres > 0 then
			for _, v in pairs(Genres) do
				genres = genres .. "&filter%5Bgeneres%5D%5B%5D=" .. self.Keys[v]
			end
		else
			genres = "filter%5Bgeneres%5D%5B%5D=-1"
		end
		if Class then
			genres = genres .. "&filter%5Bsortby%5D=" .. self.Classes[Class]
		else
			genres = genres .. "&filter%5Bsortby%5D%=1"
		end
		if Filtr then
			genres = genres .. "&filter%5BbroadcastStatus%5D=" .. self.Filtros[Filtr]
		else
			genres = genres .. "&filter%5BbroadcastStatus%5D=0"
		end
	end
	self:getManga(genres .. "&filter%5BqueryString%5D=" .. search .. "&filter%5Bskip%5D=" .. ((page - 1) * 10) .. "&filter%5Btake%5D=10&filter%5BonlyFavorites%5D=false&d=", dt)
end

function InManga:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/chapter/getall?mangaIdentification=" .. manga.Data.id)
	local t = {}
	for Id, Num in content:gmatch('\\"Identification\\":\\"(.-)\\".-Number\\":\\"(.-)\\"') do
		Num = tonumber(Num)
		t[#t + 1] = {
			Name = Num,
			Link = Id,
			Pages = {},
			Manga = manga
		}
	end
	table.sort(
		t,
		function(a, b)
			return (a.Name < b.Name)
		end
	)
	for i = 1, #t do
		t[i].Name = "Capítulo " .. t[i].Name
		dt[#dt + 1] = t[i]
	end
end

function InManga:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/chapter/chapterIndexControls?identification=" .. chapter.Link)
	local manga_title = chapter.Manga.Link:match(".+/(.-)$")
	content = content:match("<select[^>]-PageList.-</select>") or ""
	for Link, Num in content:gmatch('value="([^"]-)">(.-)<') do
		dt[#dt + 1] = self.Link .. "/images/manga/" .. manga_title .. "/chapter/" .. chapter.Name .. "/page/" .. Num .. "/" .. Link
	end
end

function InManga:loadChapterPage(link, dt)
	dt.Link = link
end
