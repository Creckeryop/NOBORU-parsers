Desu = Parser:new("Desu", "https://desu.me", "RUS", "DESURU", 5)

Desu.Filters = {
	{
		Name = "Сортировка",
		Type = "radio",
		Tags = {
			"По алфавиту",
			"По популярности",
			"По обновлению"
		},
		Default = "По популярности"
	},
	{
		Name = "Тип манги",
		Type = "check",
		Tags = {
			"Манга",
			"Манхва",
			"Маньхуа",
			"Ваншот",
			"Комикс"
		}
	},
	{
		Name = "Жанры",
		Type = "check",
		Tags = {
			"Безумие",
			"Боевые искусства",
			"Вампиры",
			"Военное",
			"Гарем",
			"Демоны",
			"Детектив",
			"Детское",
			"Дзёсей",
			"Додзинси",
			"Драма",
			"Игры",
			"Исторический",
			"Комедия",
			"Космос",
			"Магия",
			"Машины",
			"Меха",
			"Музыка",
			"Пародия",
			"Повседневность",
			"Полиция",
			"Приключения",
			"Психологическое",
			"Романтика",
			"Самураи",
			"Сверхъестественное",
			"Сёдзе",
			"Сёдзе Ай",
			"Сейнен",
			"Сёнен",
			"Сёнен Ай",
			"Смена пола",
			"Спорт",
			"Супер сила",
			"Триллер",
			"Ужасы",
			"Фантастика",
			"Фэнтези",
			"Хентай",
			"Школа",
			"Экшен",
			"Этти",
			"Юри",
			"Яой"
		}
	}
}

Desu.Keys = {
	["По алфавиту"] = "name",
	["По популярности"] = "popular",
	["По обновлению"] = "update",
	["Манга"] = "manga",
	["Манхва"] = "manhwa",
	["Маньхуа"] = "manhua",
	["Ваншот"] = "one_shot",
	["Комикс"] = "comics",
	["Безумие"] = "Dementia",
	["Боевые искусства"] = "Martial Arts",
	["Вампиры"] = "Vampire",
	["Военное"] = "Military",
	["Гарем"] = "Harem",
	["Демоны"] = "Demons",
	["Детектив"] = "Mystery",
	["Детское"] = "Kids",
	["Дзёсей"] = "Josei",
	["Додзинси"] = "Doujinshi",
	["Драма"] = "Drama",
	["Игры"] = "Game",
	["Исторический"] = "Historical",
	["Комедия"] = "Comedy",
	["Космос"] = "Space",
	["Магия"] = "Magic",
	["Машины"] = "Cars",
	["Меха"] = "Mecha",
	["Музыка"] = "Music",
	["Пародия"] = "Parody",
	["Повседневность"] = "Slice of Life",
	["Полиция"] = "Police",
	["Приключения"] = "Adventure",
	["Психологическое"] = "Psychological",
	["Романтика"] = "Romance",
	["Самураи"] = "Samurai",
	["Сверхъестественное"] = "Supernatural",
	["Сёдзе"] = "Shoujo",
	["Сёдзе Ай"] = "Shoujo Ai",
	["Сейнен"] = "Seinen",
	["Сёнен"] = "Shounen",
	["Сёнен Ай"] = "Shounen Ai",
	["Смена пола"] = "Gender Bender",
	["Спорт"] = "Sports",
	["Супер сила"] = "Super Power",
	["Триллер"] = "Thriller",
	["Ужасы"] = "Horror",
	["Фантастика"] = "Sci-Fi",
	["Фэнтези"] = "Fantasy",
	["Хентай"] = "Hentai",
	["Школа"] = "School",
	["Экшен"] = "Action",
	["Этти"] = "Ecchi",
	["Юри"] = "Yuri",
	["Яой"] = "Yaoi"
}

local desu_api = "https://desu.me/manga/api"

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

function Desu:getManga(link, dt, is_search)
	local content = downloadContent(link)
	dt.NoPages = true
	for Name, RName, ImageLink, Link in content:gmatch('"id":%d-,"name":"(.-)","russian":"(.-)","image":.-:"(.-)".-"url":".-(manga/%S-)"') do
		dt[#dt + 1] = CreateManga(stringify((Name .. " (" .. RName .. ")"):gsub("\\", "")), "/" .. Link, ImageLink, self.ID, self.Link .. "/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function Desu:getPopularManga(page, dt)
	Desu:getManga(desu_api .. "?limit=50&order=popular&page=" .. page, dt)
end

function Desu:getAZManga(page, dt)
	Desu:getManga(desu_api .. "?limit=50&order=name&page=" .. page, dt)
end

function Desu:getLatestManga(page, dt)
	Desu:getManga(desu_api .. "?limit=50&order=updated&page=" .. page, dt)
end

function Desu:searchManga(search, page, dt, tags)
	local query = ""
	if search:gsub(" ", "") ~= "" then
		query = query .. "&search=" .. search
	end
	if tags then
		query = query .. "&order=" .. self.Keys[tags[1]]
		local types = {}
		for _, v in ipairs(tags[2]) do
			types[#types + 1] = self.Keys[v]
		end
		if #types > 0 then
			query = query .. "&kinds=" .. table.concat(types, ",")
		end
		local genres = {}
		for _, v in ipairs(tags[3]) do
			genres[#genres + 1] = self.Keys[v]
		end
		if #genres > 0 then
			query = query .. "&genres=" .. table.concat(genres, ",")
		end
	end
	Desu:getManga(desu_api .. "?limit=20&page=" .. page .. query, dt, true)
end

function Desu:getChapters(manga, dt)
	local content = downloadContent(self.Link .. manga.Link)
	local description = (content:match('itemprop="description">(.-)</div>') or ""):gsub("<.->",""):gsub("\n+","\n"):gsub("^%s+",""):gsub("%s+$","")
	dt.Description = stringify(description)
	local t = {}
	local rus_name = content:match('<span class="rus%-name"[^>]->(.-)</span>') or ""
	local org_name = content:match('<span class="name"[^>]->(.-)</span>') or manga.Name
	manga.Name = stringify(org_name .. (rus_name == "" and "" or " (" .. rus_name .. ")"))
	for Link, Name in content:gmatch('<a href="(/manga/%S-)" class="tips Tooltip"[^>]-title="([^>]-)">') do
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

function Desu:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Link)
	local dir = ((content:match('dir: "([^"]-)",') or ""):gsub("^[\\/]*", "") or ""):gsub("\\/", "/") or ""
	local images = content:match("images: %[%[(.-)%]%],") or ""
	for link in images:gmatch('"(.-)"') do
		dt[#dt + 1] = dir .. link
	end
end

function Desu:loadChapterPage(link, dt)
	dt.Link = link
end
