WIEManga = Parser:new("Wie Manga!", "https://www.wiemanga.com", "DEU", "WIEMANGADE", 1)

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
WIEManga.Filters = {
	{
		Name = "Kategorie",
		Type = "checkcross",
		Tags = {
			"4-Koma",
			"Abenteuer",
			"Action",
			"Adventure",
			"Alltagsdrama",
			"Boys Love",
			"Comedy",
			"Crime",
			"DäMonen",
			"Doujinshi",
			"Drama",
			"Ecchi",
			"Erotik",
			"Fantasy",
			"Geister",
			"Gender Bender",
			"Girls Love",
			"Harem",
			"Historical",
			"Historisch",
			"Horror",
			"Isekai",
			"Josei",
			"Kampfsport",
			"Kartenspiel",
			"Kinder",
			"Kochen",
			"KomöDie",
			"Krimi",
			"Magie",
			"Mecha",
			"Medical",
			"MilitäR",
			"Monster",
			"Musik",
			"Mystery",
			"OneShots",
			"Philosophical",
			"Psychodrama",
			"Psychological",
			"Romance",
			"Romanze",
			"Schule",
			"Sci-Fi",
			"Seinen",
			"Shoujo",
			"Shoujo Ai",
			"Shounen",
			"Shounen Ai",
			"Slice Of Life",
			"Spiel",
			"Sport",
			"Sports",
			"Super KräFte",
			"Superhero",
			"SuperkräFte",
			"Thriller",
			"Tragedy",
			"Vampire",
			"Videospiel",
			"Yaoi",
			"Yuri"
		}
	}
	--[[
	{
		Name = "Status",
		Type = "radio",
		Tags = {
			"Finished",
			"Onging",
			"Entweder"
		}
	}]]
}

WIEManga.KategorieKeys = {
	["4-Koma"] = "104",
	["Abenteuer"] = "63",
	["Action"] = "64",
	["Adventure"] = "113",
	["Alltagsdrama"] = "82",
	["Boys Love"] = "106",
	["Comedy"] = "110",
	["Crime"] = "122",
	["DäMonen"] = "76",
	["Doujinshi"] = "97",
	["Drama"] = "65",
	["Ecchi"] = "79",
	["Erotik"] = "88",
	["Fantasy"] = "66",
	["Geister"] = "108",
	["Gender Bender"] = "91",
	["Girls Love"] = "99",
	["Harem"] = "73",
	["Historical"] = "114",
	["Historisch"] = "84",
	["Horror"] = "72",
	["Isekai"] = "109",
	["Josei"] = "95",
	["Kampfsport"] = "81",
	["Kartenspiel"] = "78",
	["Kinder"] = "101",
	["Kochen"] = "107",
	["KomöDie"] = "67",
	["Krimi"] = "105",
	["Magie"] = "68",
	["Mecha"] = "89",
	["Medical"] = "123",
	["MilitäR"] = "90",
	["Monster"] = "100",
	["Musik"] = "83",
	["Mystery"] = "69",
	["OneShots"] = "124",
	["Philosophical"] = "116",
	["Psychodrama"] = "103",
	["Psychological"] = "121",
	["Romance"] = "111",
	["Romanze"] = "74",
	["Schule"] = "70",
	["Sci-Fi"] = "86",
	["Seinen"] = "96",
	["Shoujo"] = "85",
	["Shoujo Ai"] = "118",
	["Shounen"] = "75",
	["Shounen Ai"] = "119",
	["Slice Of Life"] = "112",
	["Spiel"] = "92",
	["Sport"] = "87",
	["Sports"] = "117",
	["Super KräFte"] = "80",
	["Superhero"] = "120",
	["SuperkräFte"] = "102",
	["Thriller"] = "94",
	["Tragedy"] = "115",
	["Vampire"] = "71",
	["Videospiel"] = "77",
	["Yaoi"] = "93",
	["Yuri"] = "98"
}
--[[
WIEManga.StatusKeys = {
	["Finished"] = "yes",
	["Onging"] = "no",
	["Entweder"] = "either"
}
--]]
WIEManga.Letters = {"#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
WIEManga.Tags = {"4-Koma", "Abenteuer", "Action", "Adventure", "Alltagsdrama", "Boys Love", "Comedy", "Crime", "DäMonen", "Doujinshi", "Drama", "Ecchi", "Erotik", "Fantasy", "Geister", "Gender Bender", "Girls Love", "Harem", "Historical", "Historisch", "Horror", "Isekai", "Josei", "Kampfsport", "Kartenspiel", "Kinder", "Kochen", "KomöDie", "Krimi", "Magie", "Mecha", "Medical", "MilitäR", "Monster", "Musik", "Mystery", "OneShots", "Philosophical", "Psychodrama", "Psychological", "Romance", "Romanze", "Schule", "Sci-Fi", "Seinen", "Shoujo", "Shoujo Ai", "Shounen", "Shounen Ai", "Slice Of Life", "Spiel", "Sport", "Sports", "Super KräFte", "Superhero", "SuperkräFte", "Thriller", "Tragedy", "Vampire", "Videospiel", "Yaoi", "Yuri"}
WIEManga.TagValues = {
	["4-Koma"] = "4-Koma",
	["Abenteuer"] = "Abenteuer",
	["Action"] = "Action",
	["Adventure"] = "Adventure",
	["Alltagsdrama"] = "Alltagsdrama",
	["Boys Love"] = "Boys%20Love",
	["Comedy"] = "Comedy",
	["Crime"] = "Crime",
	["DäMonen"] = "Dämonen",
	["Doujinshi"] = "Doujinshi",
	["Drama"] = "Drama",
	["Ecchi"] = "Ecchi",
	["Erotik"] = "Erotik",
	["Fantasy"] = "Fantasy",
	["Geister"] = "Geister",
	["Gender Bender"] = "Gender%20Bender",
	["Girls Love"] = "Girls%20Love",
	["Harem"] = "Harem",
	["Historical"] = "Historical",
	["Historisch"] = "Historisch",
	["Horror"] = "Horror",
	["Isekai"] = "Isekai",
	["Josei"] = "Josei",
	["Kampfsport"] = "Kampfsport",
	["Kartenspiel"] = "Kartenspiel",
	["Kinder"] = "Kinder",
	["Kochen"] = "Kochen",
	["KomöDie"] = "Komödie",
	["Krimi"] = "Krimi",
	["Magie"] = "Magie",
	["Mecha"] = "Mecha",
	["Medical"] = "Medical",
	["MilitäR"] = "Militär",
	["Monster"] = "Monster",
	["Musik"] = "Musik",
	["Mystery"] = "Mystery",
	["OneShots"] = "OneShots",
	["Philosophical"] = "Philosophical",
	["Psychodrama"] = "Psychodrama",
	["Psychological"] = "Psychological",
	["Romance"] = "Romance",
	["Romanze"] = "Romanze",
	["Schule"] = "Schule",
	["Sci-Fi"] = "Sci-Fi",
	["Seinen"] = "Seinen",
	["Shoujo"] = "Shoujo",
	["Shoujo Ai"] = "Shoujo%20Ai",
	["Shounen"] = "Shounen",
	["Shounen Ai"] = "Shounen%20Ai",
	["Slice Of Life"] = "Slice%20of%20Life",
	["Spiel"] = "Spiel",
	["Sport"] = "Sport",
	["Sports"] = "Sports",
	["Super KräFte"] = "Super%20Kräfte",
	["Superhero"] = "Superhero",
	["SuperkräFte"] = "Superkräfte",
	["Thriller"] = "Thriller",
	["Tragedy"] = "Tragedy",
	["Vampire"] = "Vampire",
	["Videospiel"] = "Videospiel",
	["Yaoi"] = "Yaoi",
	["Yuri"] = "Yuri"
}

local function downloadContent(link)
	local file = {}
	Threads.insertTask(
		file,
		{
			Type = "StringRequest",
			Link = link,
			Table = file,
			Index = "string",
			Header1 = "Accept-Language: en-US,en;q=0.5",
			Header2 = "Referer: https://www.wiemanga.com"
		}
	)
	while Threads.check(file) do
		coroutine.yield(false)
	end
	return file.string or ""
end

function WIEManga:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('<dt><a href="[^"]-/manga/([^"]-)%.html"[^>]-><img src="([^"]-)".-title="[^>]-">([^<]-)</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/manga/" .. Link .. ".html", self.Link .. "/manga/" .. Link .. ".html")
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function WIEManga:getLatestManga(page, dt)
	self:getManga(self.Link .. "/list/New-Update/", dt)
	dt.NoPages = true
end

function WIEManga:getPopularManga(page, dt)
	self:getManga(self.Link .. "/list/Hot-Book/", dt)
	dt.NoPages = true
end

function WIEManga:getTagManga(page, dt, tag)
	self:getManga(self.Link .. "/category/" .. self.TagValues[tag] .. "_" .. page .. ".html", dt)
end

function WIEManga:getLetterManga(page, dt, letter)
	self:getManga(self.Link .. "/category/" .. letter:gsub("#", "0-9") .. "_" .. page .. ".html", dt)
end

function WIEManga:searchManga(search, page, dt, tags)
	local query = "/search/?name_sel=&wd=" .. search .. "&author_sel=&author=&artist_sel=&artist="
	if tags then
		local Kategorie = tags["Kategorie"]
		--local Status = tags["Status"]
		if Kategorie then
			local inc = {}
			local exc = {}
			for i = 1, #Kategorie.include do
				inc[#inc + 1] = self.KategorieKeys[Kategorie.include[i]]
			end
			for i = 1, #Kategorie.exclude do
				exc[#exc + 1] = self.KategorieKeys[Kategorie.exclude[i]]
			end
			query = query .. "&category_id=" .. table.concat(inc, "%2C")
			query = query .. "&out_category_id=" .. table.concat(exc, "%2C")
		end
	--[[
		if Status then
			query = query .. "&completed_series=" .. self.StatusKeys[Status]
		end
		--]]
	end
	query = query .. "&completed_series=either&page=" .. page .. ".html"
	local content = downloadContent(self.Link .. query)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('"resultimg" href="[^"]-/manga/([^"]-)%.html"><img src="([^"]-)".->([^><]-)<br') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/manga/" .. Link .. ".html", self.Link .. "/manga/" .. Link .. ".html")
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function WIEManga:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/manga/" .. manga.Link)
	local t = {}
	for Link, Name in content:gmatch('"col1"><a href="[^"]-/chapter/([^"]-)[/]*"[^>]->([^<]-)</a>') do
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

function WIEManga:prepareChapter(chapter, dt)
	local pages = tonumber(downloadContent(self.Link .. "/chapter/" .. chapter.Link):match(">(%d+)</option>[^<]-</select>") or "0")
	for i = 1, pages do
		dt[#dt + 1] = self.Link .."/chapter/".. chapter.Link.."-"..i..".html"
	end
end

function WIEManga:loadChapterPage(link, dt)
	local image_link = downloadContent(link):match("comicpic' src=\"([^\"]-)\"") or ""
	dt.Link = {
		Link = image_link,
		Header1 = "Accept-Language: en-US,en;q=0.5",
		Header2 = "Referer: https://www.wiemanga.com"
	}
end
