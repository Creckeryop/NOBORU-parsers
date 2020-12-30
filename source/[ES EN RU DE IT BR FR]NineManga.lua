if Settings.Version > 0.35 then
	ESNineManga = Parser:new("NineManga Español", "http://es.ninemanga.com", "ESP", "NINEMANGASPA", 5)

	ESNineManga.Filters = {
		{
			Name = "Género",
			Type = "checkcross",
			Tags = {
				"4-Koma",
				"AcciÓN",
				"AccióN",
				"Action",
				"Adult",
				"Adulto",
				"Adventure",
				"AnimacióN",
				"ApocalíPtico",
				"Artes Marciales",
				"Aventura",
				"Aventuras",
				"BL (Boys Love)",
				"Boys Love",
				"Ciberpunk",
				"Ciencia FiccióN",
				"Comedia",
				"Comedy",
				"Crimen",
				"Cyberpunk",
				"Demonios",
				"Deporte",
				"Deportes",
				"Doujinshi",
				"Drama",
				"Ecchi",
				"Escolar",
				"EspañOl",
				"Extranjero",
				"Familia",
				"Fantacia",
				"FantasÍA",
				"FantasíA",
				"Fantasy",
				"Gender Bender",
				"GéNero Bender",
				"Girls Love",
				"GL (Girls Love)",
				"Gore",
				"Guerra",
				"Harem",
				"Hentai",
				"Historia",
				"Historical",
				"HistóRico",
				"Horror",
				"Isekai",
				"Josei",
				"Maduro",
				"Magia",
				"Magical Girls",
				"Manga",
				"Martial",
				"Martial Arts",
				"Mecha",
				"Medical",
				"Militar",
				"Misterio",
				"Music",
				"MúSica",
				"Musical",
				"Mystery",
				"NiñOs",
				"Oeste",
				"One Shot",
				"One-Shot",
				"Oneshot",
				"Parodia",
				"Philosophical",
				"PolicíAca",
				"Policiaco",
				"Policial",
				"PsicolóGica",
				"PsicolóGico",
				"Psychological",
				"Realidad",
				"Realidad Virtual",
				"Recuentos De La Vida",
				"ReencarnacióN",
				"Romance",
				"Samurai",
				"School Life",
				"Sci-Fi",
				"Seinen",
				"Shojo",
				"Shojo Ai",
				"Shojo-Ai (Yuri Soft)",
				"Shonen",
				"Shonen Ai",
				"Shonen-Ai",
				"Shonen-Ai (Yaoi Soft)",
				"Shota",
				"Shoujo",
				"Shoujo Ai",
				"Shoujo-Ai",
				"Shounen",
				"Shounen Ai",
				"Slice Of Life",
				"Smut",
				"Sobrenatural",
				"Sports",
				"Super Natural",
				"Super Poderes",
				"Superhero",
				"Supernatural",
				"Superpoderes",
				"Supervivencia",
				"Suspense",
				"Telenovela",
				"Thiller",
				"Thriller",
				"Tragedia",
				"Tragedy",
				"Vampiros",
				"Ver En Lectormanga",
				"Vida Cotidiana",
				"Vida Escolar",
				"Vida Escolar.",
				"Webcomic",
				"Webtoon",
				"Wuxia",
				"Yaoi",
				"Yaoi (Soft)",
				"Yonkoma",
				"Yuri",
				"Yuri (Soft)"
			}
		},
		{
			Name = "Series Completado",
			Type = "radio",
			Tags = {
				"Si",
				"No",
				"O"
			},
			Default = "O"
		}
	}

	ESNineManga.Completed = {
		["Si"] = "yes",
		["No"] = "no",
		["O"] = "either"
	}

	ESNineManga.Genre = {
		["4-Koma"] = "201",
		["AcciÓN"] = "213",
		["AccióN"] = "69",
		["Action"] = "177",
		["Adult"] = "193",
		["Adulto"] = "86",
		["Adventure"] = "179",
		["AnimacióN"] = "229",
		["ApocalíPtico"] = "202",
		["Artes Marciales"] = "66",
		["Aventura"] = "64",
		["Aventuras"] = "120",
		["BL (Boys Love)"] = "223",
		["Boys Love"] = "228",
		["Ciberpunk"] = "225",
		["Ciencia FiccióN"] = "93",
		["Comedia"] = "75",
		["Comedy"] = "178",
		["Crimen"] = "227",
		["Cyberpunk"] = "199",
		["Demonios"] = "126",
		["Deporte"] = "76",
		["Deportes"] = "111",
		["Doujinshi"] = "216",
		["Drama"] = "79",
		["Ecchi"] = "65",
		["Escolar"] = "81",
		["EspañOl"] = "249",
		["Extranjero"] = "238",
		["Familia"] = "237",
		["Fantacia"] = "100",
		["FantasÍA"] = "214",
		["FantasíA"] = "70",
		["Fantasy"] = "180",
		["Gender Bender"] = "175",
		["GéNero Bender"] = "230",
		["Girls Love"] = "226",
		["GL (Girls Love)"] = "222",
		["Gore"] = "108",
		["Guerra"] = "234",
		["Harem"] = "78",
		["Hentai"] = "83",
		["Historia"] = "233",
		["Historical"] = "190",
		["HistóRico"] = "95",
		["Horror"] = "99",
		["Isekai"] = "240",
		["Josei"] = "112",
		["Maduro"] = "72",
		["Magia"] = "172",
		["Magical Girls"] = "248",
		["Manga"] = "251",
		["Martial"] = "189",
		["Martial Arts"] = "181",
		["Mecha"] = "115",
		["Medical"] = "247",
		["Militar"] = "205",
		["Misterio"] = "88",
		["Music"] = "241",
		["MúSica"] = "121",
		["Musical"] = "197",
		["Mystery"] = "187",
		["NiñOs"] = "235",
		["Oeste"] = "239",
		["One Shot"] = "184",
		["One-Shot"] = "221",
		["Oneshot"] = "195",
		["Parodia"] = "198",
		["Philosophical"] = "252",
		["PolicíAca"] = "220",
		["Policiaco"] = "236",
		["Policial"] = "208",
		["PsicolóGica"] = "219",
		["PsicolóGico"] = "96",
		["Psychological"] = "192",
		["Realidad"] = "231",
		["Realidad Virtual"] = "196",
		["Recuentos De La Vida"] = "169",
		["ReencarnacióN"] = "207",
		["Romance"] = "67",
		["Samurai"] = "210",
		["School Life"] = "176",
		["Sci-Fi"] = "123",
		["Seinen"] = "73",
		["Shojo"] = "80",
		["Shojo Ai"] = "186",
		["Shojo-Ai (Yuri Soft)"] = "218",
		["Shonen"] = "77",
		["Shonen Ai"] = "128",
		["Shonen-Ai"] = "174",
		["Shonen-Ai (Yaoi Soft)"] = "217",
		["Shota"] = "224",
		["Shoujo"] = "85",
		["Shoujo Ai"] = "194",
		["Shoujo-Ai"] = "173",
		["Shounen"] = "68",
		["Shounen Ai"] = "185",
		["Slice Of Life"] = "182",
		["Smut"] = "183",
		["Sobrenatural"] = "74",
		["Sports"] = "188",
		["Super Natural"] = "124",
		["Super Poderes"] = "206",
		["Superhero"] = "246",
		["Supernatural"] = "119",
		["Superpoderes"] = "215",
		["Supervivencia"] = "203",
		["Suspense"] = "171",
		["Telenovela"] = "242",
		["Thiller"] = "204",
		["Thriller"] = "97",
		["Tragedia"] = "87",
		["Tragedy"] = "191",
		["Vampiros"] = "209",
		["Ver En Lectormanga"] = "243",
		["Vida Cotidiana"] = "84",
		["Vida Escolar"] = "170",
		["Vida Escolar."] = "122",
		["Webcomic"] = "92",
		["Webtoon"] = "200",
		["Wuxia"] = "244",
		["Yaoi"] = "105",
		["Yaoi (Soft)"] = "211",
		["Yonkoma"] = "232",
		["Yuri"] = "127",
		["Yuri (Soft)"] = "212"
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
				Index = "text",
				Header1 = "Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7"
			}
		)
		while Threads.check(f) do
			coroutine.yield(false)
		end
		return f.text or ""
	end

	function ESNineManga:getManga(link, dt)
		local content = downloadContent(link)
		dt.NoPages = true
		for Link, ImageLink, Name in content:gmatch('bookinfo.-href="([^"]-)".-src="([^"]-)".-bookname"[^>]->([^<]-)</a>') do
			dt[#dt + 1] = CreateManga(stringify(Name), Link:gsub("%%", "%%%%"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
			dt.NoPages = false
			coroutine.yield(false)
		end
	end

	function ESNineManga:getPopularManga(page, dt)
		self:getManga(self.Link .. "/category/index_" .. page .. ".html", dt)
	end

	function ESNineManga:searchManga(search, page, dt, tags)
		local query = ""
		if tags then
			local include = {}
			for k, v in ipairs(tags[1].include) do
				include[#include + 1] = self.Genre[v]
			end
			include = table.concat(include, "%%2C")
			query = query .. "&category_id=" .. include
			local exclude = {}
			for k, v in ipairs(tags[1].exclude) do
				exclude[#exclude + 1] = self.Genre[v]
			end
			exclude = table.concat(exclude, "%%2C")
			query = query .. "&out_category_id=" .. exclude
			local completed = self.Completed[tags[2]]
			query = query .. "&completed_series=" .. completed
		end
		self:getManga(self.Link .. "/search/?name_sel=&wd=" .. search .. "&page=" .. page .. query .. "&type=high.html", dt)
	end

	function ESNineManga:getChapters(manga, dt)
		local content = downloadContent(manga.Link .. "?waring=1")
		local description = (content:match('itemprop="description".-</b>(.-)</p>') or ""):gsub("^\n+",""):gsub("\n+$","")
		dt.Description = stringify(description)
		local t = {}
		for Link, Name in content:gmatch('chapter_list_a" href="([^"]-)"[^>]->([^<]-)</a>') do
			t[#t + 1] = {
				Name = stringify(Name),
				Link = Link:gsub("%%", "%%%%"),
				Pages = {},
				Manga = manga
			}
		end
		for i = #t, 1, -1 do
			dt[#dt + 1] = t[i]
		end
	end

	function ESNineManga:prepareChapter(chapter, dt)
		local content = downloadContent(chapter.Link):match("changepage(.-)</div>") or ""
		for Link in content:gmatch('value="([^"]-)"[^>]->') do
			dt[#dt + 1] = Link:gsub("%%", "%%%%")
		end
	end

	function ESNineManga:loadChapterPage(link, dt)
		dt.Link = downloadContent(self.Link .. link):match('.+img src="([^"]-)".-$'):gsub("%%", "%%%%") or ""
	end
	ENNineManga = ESNineManga:new("NineManga English", "http://ninemanga.com", "ENG", "NINEMANGAENG", 5)

	ENNineManga.Filters = {
		{
			Name = "Genres",
			Type = "checkcross",
			Tags = {
				"4-Koma",
				"Action",
				"Adult",
				"Adventure",
				"Anime",
				"Award Winning",
				"Comedy",
				"Cooking",
				"Demons",
				"Doujinshi",
				"Drama",
				"Ecchi",
				"Fantasy",
				"Gender Bender",
				"Harem",
				"Historical",
				"Horror",
				"Josei",
				"Live Action",
				"Magic",
				"Manhua",
				"Manhwa",
				"Martial Arts",
				"Matsumoto Tomokicomedy",
				"Mature",
				"Mecha",
				"Medical",
				"Military",
				"Music",
				"Mystery",
				"N/A",
				"One Shot",
				"Oneshot",
				"Psychological",
				"Reverse Harem",
				"Romance",
				"Romance Shoujo",
				"School Life",
				"Sci-Fi",
				"Seinen",
				"Shoujo",
				"Shoujo Ai",
				"Shoujo-Ai",
				"Shoujoai",
				"Shounen",
				"Shounen Ai",
				"Shounen-Ai",
				"Shounenai",
				"Slice Of Life",
				"Smut",
				"Sports",
				"Supernatural",
				"Suspense",
				"Tragedy",
				"Vampire",
				"Webtoon",
				"Webtoons",
				"Yaoi",
				"Yuri"
			}
		},
		{
			Name = "Completed Series",
			Type = "radio",
			Tags = {
				"Yes",
				"No",
				"Either"
			},
			Default = "Either"
		}
	}

	ENNineManga.Completed = {
		["Yes"] = "yes",
		["No"] = "no",
		["Either"] = "either"
	}

	ENNineManga.Genre = {
		["4-Koma"] = "56",
		["Action"] = "1",
		["Adult"] = "39",
		["Adventure"] = "2",
		["Anime"] = "3",
		["Award Winning"] = "59",
		["Comedy"] = "4",
		["Cooking"] = "5",
		["Demons"] = "49",
		["Doujinshi"] = "45",
		["Drama"] = "6",
		["Ecchi"] = "7",
		["Fantasy"] = "8",
		["Gender Bender"] = "9",
		["Harem"] = "10",
		["Historical"] = "11",
		["Horror"] = "12",
		["Josei"] = "13",
		["Live Action"] = "14",
		["Magic"] = "47",
		["Manhua"] = "15",
		["Manhwa"] = "16",
		["Martial Arts"] = "17",
		["Matsumoto Tomokicomedy"] = "37",
		["Mature"] = "36",
		["Mecha"] = "18",
		["Medical"] = "19",
		["Military"] = "51",
		["Music"] = "20",
		["Mystery"] = "21",
		["N/A"] = "54",
		["One Shot"] = "22",
		["Oneshot"] = "57",
		["Psychological"] = "23",
		["Reverse Harem"] = "55",
		["Romance"] = "24",
		["Romance Shoujo"] = "38",
		["School Life"] = "25",
		["Sci-Fi"] = "26",
		["Seinen"] = "27",
		["Shoujo"] = "28",
		["Shoujo Ai"] = "44",
		["Shoujo-Ai"] = "29",
		["Shoujoai"] = "48",
		["Shounen"] = "30",
		["Shounen Ai"] = "42",
		["Shounen-Ai"] = "31",
		["Shounenai"] = "46",
		["Slice Of Life"] = "32",
		["Smut"] = "41",
		["Sports"] = "33",
		["Supernatural"] = "34",
		["Suspense"] = "53",
		["Tragedy"] = "35",
		["Vampire"] = "52",
		["Webtoon"] = "58",
		["Webtoons"] = "50",
		["Yaoi"] = "40",
		["Yuri"] = "43"
	}

	RUNineManga = ESNineManga:new("NineManga Россия", "http://ru.ninemanga.com", "RUS", "NINEMANGARUS", 5)

	RUNineManga.Filters = {
		{
			Name = "Жанры",
			Type = "checkcross",
			Tags = {
				"Арт",
				"Боевик",
				"Боевые искусства",
				"Вампиры",
				"Гарем",
				"Гендерная интрига",
				"Героическое фэнтези",
				"Детектив",
				"Дзёсэй",
				"Додзинси",
				"Драма",
				"Игра",
				"История",
				"Киберпанк",
				"Кодомо",
				"Комедия",
				"Махо-сёдзё",
				"Меха",
				"Мистика",
				"Научная фантастика",
				"Омегаверс",
				"Повседневность",
				"Постапокалиптика",
				"Приключения",
				"Психология",
				"Романтика",
				"Самурайский боевик",
				"Сверхъестественное",
				"Сёдзё",
				"Сёдзё-ай",
				"Сёнэн",
				"Сёнэн-ай",
				"Спорт",
				"Сэйнэн",
				"Трагедия",
				"Триллер",
				"Ужасы",
				"Фантастика",
				"Фэнтези",
				"Школа",
				"Эротика",
				"Этти",
				"Юри",
				"Яой"
			}
		},
		{
			Name = "Завершена серия",
			Type = "radio",
			Tags = {
				"Да",
				"Нет",
				"или"
			},
			Default = "или"
		}
	}

	RUNineManga.Completed = {
		["Да"] = "yes",
		["Нет"] = "no",
		["или"] = "either"
	}

	RUNineManga.Genre = {
		["Арт"] = "90",
		["Боевик"] = "53",
		["Боевые искусства"] = "58",
		["Вампиры"] = "85",
		["Гарем"] = "73",
		["Гендерная интрига"] = "81",
		["Героическое фэнтези"] = "68",
		["Детектив"] = "72",
		["Дзёсэй"] = "64",
		["Додзинси"] = "62",
		["Драма"] = "51",
		["Игра"] = "76",
		["История"] = "75",
		["Киберпанк"] = "91",
		["Кодомо"] = "89",
		["Комедия"] = "57",
		["Махо-сёдзё"] = "88",
		["Меха"] = "84",
		["Мистика"] = "71",
		["Научная фантастика"] = "79",
		["Омегаверс"] = "94",
		["Повседневность"] = "65",
		["Постапокалиптика"] = "87",
		["Приключения"] = "59",
		["Психология"] = "54",
		["Романтика"] = "61",
		["Самурайский боевик"] = "82",
		["Сверхъестественное"] = "55",
		["Сёдзё"] = "67",
		["Сёдзё-ай"] = "78",
		["Сёнэн"] = "52",
		["Сёнэн-ай"] = "63",
		["Спорт"] = "69",
		["Сэйнэн"] = "74",
		["Трагедия"] = "70",
		["Триллер"] = "83",
		["Ужасы"] = "86",
		["Фантастика"] = "77",
		["Фэнтези"] = "56",
		["Школа"] = "66",
		["Эротика"] = "93",
		["Этти"] = "60",
		["Юри"] = "80",
		["Яой"] = "92"
	}

	DENineManga = ESNineManga:new("NineManga Deutschland", "http://de.ninemanga.com", "DEU", "NINEMANGAGER", 6)
	DENineManga.Filters = {
		{
			Name = "Genres",
			Type = "checkcross",
			Tags = {
				"Abenteuer",
				"Action",
				"Alltagsdrama",
				"Comedy",
				"DäMonen",
				"Doujinshi",
				"Drama",
				"Ecchi",
				"Erotik",
				"Fantasy",
				"Gender Bender",
				"Harem",
				"Historisch",
				"Horror",
				"Isekai",
				"Josei",
				"Kampfsport",
				"Kartenspiel",
				"KomöDie",
				"Magie",
				"Mecha",
				"MilitäR",
				"Musik",
				"Mystery",
				"Romance",
				"Romanze",
				"Schule",
				"Sci-Fi",
				"Seinen",
				"Shoujo",
				"Shounen",
				"Slice Of Life",
				"Spiel",
				"Sport",
				"Super KräFte",
				"Thriller",
				"Tragedy",
				"Vampire",
				"Videospiel",
				"Yaoi"
			}
		},
		{
			Name = "Abgeschlossene Serie",
			Type = "radio",
			Tags = {
				"Ja",
				"Nein",
				"Entweder"
			},
			Default = "Entweder"
		}
	}

	DENineManga.Completed = {
		["Ja"] = "yes",
		["Nein"] = "no",
		["Entweder"] = "either"
	}

	DENineManga.Genre = {
		["Abenteuer"] = "63",
		["Action"] = "64",
		["Alltagsdrama"] = "82",
		["Comedy"] = "110",
		["DäMonen"] = "76",
		["Doujinshi"] = "97",
		["Drama"] = "65",
		["Ecchi"] = "79",
		["Erotik"] = "88",
		["Fantasy"] = "66",
		["Gender Bender"] = "91",
		["Harem"] = "73",
		["Historisch"] = "84",
		["Horror"] = "72",
		["Isekai"] = "109",
		["Josei"] = "95",
		["Kampfsport"] = "81",
		["Kartenspiel"] = "78",
		["KomöDie"] = "67",
		["Magie"] = "68",
		["Mecha"] = "89",
		["MilitäR"] = "90",
		["Musik"] = "83",
		["Mystery"] = "69",
		["Romance"] = "111",
		["Romanze"] = "74",
		["Schule"] = "70",
		["Sci-Fi"] = "86",
		["Seinen"] = "96",
		["Shoujo"] = "85",
		["Shounen"] = "75",
		["Slice Of Life"] = "112",
		["Spiel"] = "92",
		["Sport"] = "87",
		["Super KräFte"] = "80",
		["Thriller"] = "94",
		["Tragedy"] = "115",
		["Vampire"] = "71",
		["Videospiel"] = "77",
		["Yaoi"] = "93"
	}
	ITNineManga = ESNineManga:new("NineManga Italy", "http://it.ninemanga.com", "ITA", "NINEMANGAITA", 5)

	ITNineManga.Filters = {
		{
			Name = "Generi",
			Type = "checkcross",
			Tags = {
				"Avventura",
				"Vita Quotidiana"
			}
		},
		{
			Name = "Abgeschlossene Serie",
			Type = "radio",
			Tags = {
				"Si",
				"No",
				"O"
			},
			Default = "O"
		}
	}

	ITNineManga.Completed = {
		["Si"] = "yes",
		["No"] = "no",
		["O"] = "either"
	}

	ITNineManga.Genre = {
		["Avventura"] = "63",
		["Vita Quotidiana"] = "77"
	}

	BRNineManga = ESNineManga:new("NineManga Brazil", "http://br.ninemanga.com", "BRA", "NINEMANGABRA", 5)

	BRNineManga.Filters = {
		{
			Name = "Géneros",
			Type = "checkcross",
			Tags = {
				"AçãO",
				"ComéDia",
				"Fantasia",
				"Hentai",
				"OneShot",
				"Yaoi"
			}
		},
		{
			Name = "Série Concluído",
			Type = "radio",
			Tags = {
				"Sim",
				"Não",
				"Ou"
			},
			Default = "Ou"
		}
	}

	BRNineManga.Completed = {
		["Sim"] = "yes",
		["Não"] = "no",
		["Ou"] = "either"
	}

	BRNineManga.Genre = {
		["AçãO"] = "71",
		["ComéDia"] = "64",
		["Fantasia"] = "65",
		["Hentai"] = "137",
		["OneShot"] = "69",
		["Yaoi"] = "90"
	}
end
