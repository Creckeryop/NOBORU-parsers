MangaDex = Parser:new("MangaDex", "https://mangadex.org", "DIF", "MANGADEX", 10)

MangaDex.Filters = {
	{
		Name = "Original Language",
		Type = "radio",
		Tags = {
			"All languages",
			"Japanese",
			"English",
			"Polish",
			"Russian",
			"German",
			"French",
			"Vietnamese",
			"Chinese",
			"Indonesian",
			"Korean",
			"Spanish (LATAM)",
			"Thai",
			"Filipino",
			"Chinese (Trad)"
		}
	},
	{
		Name = "Demographic",
		Type = "check",
		Tags = {
			"Shounen",
			"Shoujo",
			"Seinen",
			"Josei"
		},
		Default = {
			"Shounen",
			"Shoujo",
			"Seinen",
			"Josei"
		}
	},
	{
		Name = "Publication Status",
		Type = "check",
		Tags = {
			"Ongoing",
			"Completed",
			"Cancelled",
			"Hiatus"
		},
		Default = {
			"Ongoing",
			"Completed",
			"Cancelled",
			"Hiatus"
		}
	},
	{
		Name = "Content",
		Type = "checkcross",
		Tags = {
			"Ecchi",
			"Gore",
			"Sexual Violence",
			"Smut"
		}
	},
	{
		Name = "Format",
		Type = "checkcross",
		Tags = {
			"4-Koma",
			"Adaptation",
			"Anthology",
			"Award Winning",
			"Doujinshi",
			"Fan Colored",
			"Full Color",
			"Long Strip",
			"Official Colored",
			"Oneshot",
			"User Created",
			"Web Comic"
		}
	},
	{
		Name = "Genre",
		Type = "checkcross",
		Tags = {
			"Action",
			"Adventure",
			"Comedy",
			"Crime",
			"Drama",
			"Fantasy",
			"Historical",
			"Horror",
			"Isekai",
			"Magical Girls",
			"Mecha",
			"Medical",
			"Mystery",
			"Philosophical",
			"Psychological",
			"Romance",
			"Sci-Fi",
			"Shoujo Ai",
			"Shounen Ai",
			"Slice of Life",
			"Sports",
			"Superhero",
			"Thriller",
			"Tragedy",
			"Wuxia",
			"Yaoi",
			"Yuri"
		}
	},
	{
		Name = "Theme",
		Type = "checkcross",
		Tags = {
			"Aliens",
			"Animals",
			"Cooking",
			"Crossdressing",
			"Delinquents",
			"Demons",
			"Genderswap",
			"Ghosts",
			"Gyaru",
			"Harem",
			"Incest",
			"Loli",
			"Mafia",
			"Magic",
			"Martial Arts",
			"Military",
			"Monster Girls",
			"Monsters",
			"Music",
			"Ninja",
			"Office Workers",
			"Police",
			"Post-Apocalyptic",
			"Reincarnation",
			"Reverse Harem",
			"Samurai",
			"School Life",
			"Shota",
			"Supernatural",
			"Survival",
			"Time Travel",
			"Traditional Games",
			"Vampires",
			"Video Games",
			"Virtual Reality",
			"Zombies"
		}
	},
	{
		Name = "Tag inclusion mode",
		Type = "radio",
		Tags = {
			"All (AND)",
			"Any (OR)"
		},
		Default = "All (AND)"
	},
	{
		Name = "Tag exclusion mode",
		Type = "radio",
		Tags = {
			"All (AND)",
			"Any (OR)"
		},
		Default = "Any (OR)"
	}
}

MangaDex.LangKeys = {
	["All languages"] = "",
	["Japanese"] = "2",
	["English"] = "1",
	["Polish"] = "3",
	["Russian"] = "7",
	["German"] = "8",
	["French"] = "10",
	["Vietnamese"] = "12",
	["Chinese"] = "21",
	["Indonesian"] = "27",
	["Korean"] = "28",
	["Spanish (LATAM)"] = "29",
	["Thai"] = "32",
	["Filipino"] = "34",
	["Chinese (Trad)"] = "35"
}

MangaDex.DemoKeys = {
	["Shounen"] = "1",
	["Shoujo"] = "2",
	["Seinen"] = "3",
	["Josei"] = "4"
}

MangaDex.PSKeys = {
	["Ongoing"] = "1",
	["Completed"] = "2",
	["Cancelled"] = "3",
	["Hiatus"] = "4"
}

MangaDex.Keys = {
	["Ecchi"] = "9",
	["Gore"] = "49",
	["Sexual Violence"] = "50",
	["Smut"] = "32",
	["4-Koma"] = "1",
	["Adaptation"] = "42",
	["Anthology"] = "43",
	["Award Winning"] = "4",
	["Doujinshi"] = "7",
	["Fan Colored"] = "48",
	["Full Color"] = "45",
	["Long Strip"] = "36",
	["Official Colored"] = "47",
	["Oneshot"] = "21",
	["User Created"] = "46",
	["Web Comic"] = "44",
	["Action"] = "2",
	["Adventure"] = "3",
	["Comedy"] = "5",
	["Crime"] = "51",
	["Drama"] = "8",
	["Fantasy"] = "10",
	["Historical"] = "13",
	["Horror"] = "14",
	["Isekai"] = "41",
	["Magical Girls"] = "52",
	["Mecha"] = "17",
	["Medical"] = "18",
	["Mystery"] = "20",
	["Philosophical"] = "53",
	["Psychological"] = "22",
	["Romance"] = "23",
	["Sci-Fi"] = "25",
	["Shoujo Ai"] = "28",
	["Shounen Ai"] = "30",
	["Slice of Life"] = "31",
	["Sports"] = "33",
	["Superhero"] = "54",
	["Thriller"] = "55",
	["Tragedy"] = "35",
	["Wuxia"] = "56",
	["Yaoi"] = "37",
	["Yuri"] = "38",
	["Aliens"] = "57",
	["Animals"] = "58",
	["Cooking"] = "6",
	["Crossdressing"] = "59",
	["Delinquents"] = "61",
	["Demons"] = "60",
	["Genderswap"] = "62",
	["Ghosts"] = "63",
	["Gyaru"] = "11",
	["Harem"] = "12",
	["Incest"] = "83",
	["Loli"] = "65",
	["Mafia"] = "84",
	["Magic"] = "66",
	["Martial Arts"] = "16",
	["Military"] = "67",
	["Monster Girls"] = "64",
	["Monsters"] = "68",
	["Music"] = "19",
	["Ninja"] = "69",
	["Office Workers"] = "70",
	["Police"] = "71",
	["Post-Apocalyptic"] = "72",
	["Reincarnation"] = "73",
	["Reverse Harem"] = "74",
	["Samurai"] = "75",
	["School Life"] = "24",
	["Shota"] = "76",
	["Supernatural"] = "34",
	["Survival"] = "77",
	["Time Travel"] = "78",
	["Traditional Games"] = "80",
	["Vampires"] = "79",
	["Video Games"] = "40",
	["Virtual Reality"] = "81",
	["Zombies"] = "82"
}

MangaDex.TagMode = {
	["All (AND)"] = "all",
	["Any (OR)"] = "any"
}

local api_manga = "https://api.mangadex.org/v2/manga/"
local api_chapters = "https://api.mangadex.org/v2/chapter/"
local Lang_codes = {
	["bg"] = "Bulgaria",
	["br"] = "Brazil",
	["ct"] = "Catalan",
	["de"] = "German",
	["es"] = "Spanish",
	["fr"] = "French",
	["gb"] = "English",
	["id"] = "Indonesian",
	["it"] = "Italian",
	["mx"] = "Mexican",
	["pl"] = "PL",
	["ru"] = "Russian",
	["sa"] = "SA",
	["vn"] = "Vietnamese",
	["tr"] = "Turkish",
	["ua"] = "Ukrainian"
}

local LtoL = {
	["bg"] = "BGR",
	["br"] = "BRA",
	["ct"] = "CAT",
	["de"] = "DEU",
	["es"] = "SPA",
	["fr"] = "FRA",
	["gb"] = "ENG",
	["id"] = "IND",
	["it"] = "ITA",
	["mx"] = "MEX",
	["pl"] = "PL",
	["ru"] = "RUS",
	["sa"] = "SA",
	["vn"] = "VIE",
	["tr"] = "TUR",
	["ua"] = "UKR"
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

function MangaDex:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('<a href="([^"]-)"><img.-src="([^"]-)".-class.->([^>]-)</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link:match("/(%d-)/"), self.Link .. ImageLink, self.ID, self.Link .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaDex:getPopularManga(page, dt)
	self:getManga(self.Link .. "/titles/7/" .. page .. "/", dt)
end

function MangaDex:getLatestManga(page, dt)
	self:getManga(self.Link .. "/titles/0/" .. page .. "/", dt)
end

local cookies = {}

function MangaDex:searchManga(search, page, dt, tags)
	local id = search:match("^id%+?:%+?(%d-)$")
	if Browser == nil or id then
		if Browser == nil and not id then
			Notifications.push("Search isn't supported in your NOBORU version\nbut you can write and id to search type 'id:12345'", 2000)
			dt.NoPages = true
		end
		if id then
			local content = downloadContent(api_manga .. id .. "?include=chapters"):gsub("\\/", "/")
			local manga_imgurl, title = content:match('"cover_url":"(.-)",.-"title":"(.-)",')
			if title and manga_imgurl then
				dt[#dt + 1] = CreateManga(stringify(title), id, self.Link .. manga_imgurl, self.ID, self.Link .. "/title/" .. search)
			end
		end
		dt.NoPages = true
	else
		cookies = Browser.getCookies("mangadex.org")
		if
			downloadContent(
				{
					Link = self.Link .. "/search?p=0&title=ABADBEEFISMAGIC",
					Cookie = cookies["@"],
					Header1 = "User-Agent: " .. Browser.getUserAgent()
				}
			):find('id="login_button".-id="forgot_button"')
		 then
			cookies = {}
		end
		if #cookies == 0 then
			Browser.open(self.Link .. "/login")
			coroutine.yield(false)
		end
		cookies = Browser.getCookies("mangadex.org")
		if #cookies ~= 0 then
			local query = ""
			if tags then
				local language = self.LangKeys[tags["Original Language"]]
				local demographic = tags["Demographic"]
				local ps = tags["Publication Status"]
				local content = tags["Content"]
				local format = tags["Format"]
				local genre = tags["Genre"]
				local theme = tags["Theme"]
				local tag_inc = tags["Tag inclusion mode"]
				local tag_exc = tags["Tag exclusion mode"]
				if language ~= "" then
					query = query .. "&lang_id=" .. language
				end
				if demographic and #demographic < 4 then
					query = query .. "&demos="
					local demos = {}
					for _, v in ipairs(demographic) do
						demos[#demos + 1] = self.DemoKeys[v]
					end
					query = query .. table.concat(demos, ",")
				end
				if ps and #ps < 4 then
					query = query .. "&statuses="
					local statuses = {}
					for _, v in ipairs(ps) do
						statuses[#statuses + 1] = self.PSKeys[v]
					end
					query = query .. table.concat(statuses, ",")
				end
				local _tags = {}
				for k, v in ipairs({content, format, genre, theme}) do
					for i, t in ipairs(v.include) do
						_tags[#_tags + 1] = self.Keys[t]
					end
					for i, t in ipairs(v.exclude) do
						_tags[#_tags + 1] = "-" .. self.Keys[t]
					end
				end
				query = query .. "&tags=" .. table.concat(_tags, ",")
				query = query .. "&tag_mode_exc=" .. self.TagMode[tag_exc] .. "&tag_mode_inc=" .. self.TagMode[tag_inc]
			end
			self:getManga(
				{
					Link = self.Link .. "/search?p=" .. page .. "&title=" .. search .. query,
					Cookie = cookies["@"],
					Header1 = "User-Agent: " .. Browser.getUserAgent()
				},
				dt
			)
		else
			dt.NoPages = true
		end
	end
end

function MangaDex:getChapters(manga, dt)
	local content = downloadContent(api_manga .. manga.Link.."?include=chapters")
	local description = (content:match('"description":"(.-)","') or ""):gsub("\\/", "/"):gsub("%[.+%]",""):gsub("\\r",""):gsub("\\n","\n"):gsub("\n+","\n"):gsub("\n*$","")
	manga.NewImageLink = self.Link..(content:match('"cover_url":"(.-)"') or ""):gsub("\\/", "/")
	dt.Description = stringify(description)
	local t = {}
	local i = 0
	local prefLang = false
	manga.Name = stringify(content:match('<span class="mx%-1">(.-)</span>') or manga.Name)
	if Settings.ParserLanguage and Settings.ParserLanguage ~= "DIF" then
		prefLang = Settings.ParserLanguage
	end
	local found = false
	for Id, Volume, Count, Title, Lang in content:gmatch('{"id":(%d-),[^}]+"volume":"(.-)","chapter":"(.-)","title":"(.-)",[^}]-"language":"([^"]-)",.-}') do
		if prefLang and LtoL[Lang] == prefLang or not prefLang then
			t[#t + 1] = {Id = Id, Count = Count, Title = Title, Lang = Lang}
			t[#t].Volume = tonumber(Volume) or 0
			if i > 100 then
				coroutine.yield(false)
				i = 0
			else
				i = i + 1
			end
		end
		found = true
	end
	if found and #t == 0 and prefLang then
		Notifications.push("No chapters for preferred Language")
	end
	table.sort(
		t,
		function(a, b)
			if a.Lang == b.Lang then
				local c_a, c_b = tonumber(a.Count), tonumber(b.Count)
				if c_a and c_b then
					return c_a > c_b
				elseif c_a then
					return true
				elseif c_b then
					return false
				end
			else
				return a.Lang > b.Lang
			end
		end
	)
	if not u8c then
		Notifications.push("Download Latest version to support \\u chars")
	end
	for k = #t, 1, -1 do
		local new_title = t[k].Title:gsub('\\"', '"')
		if u8c then
			new_title =
				new_title:gsub(
				"\\u(....)",
				function(a)
					return u8c(tonumber(string.format("0x%s", a)))
				end
			)
		end
		dt[#dt + 1] = {
			Name = stringify("[" .. (Lang_codes[t[k].Lang] or t[k].Lang) .. "] " .. t[k].Volume .. "-" .. t[k].Count .. ": " .. new_title),
			Link = t[k].Id,
			Pages = {},
			Manga = manga
		}
	end
end

function MangaDex:prepareChapter(chapter, dt)
	local content = downloadContent(api_chapters .. chapter.Link)
	for hash, array, server in content:gmatch('"hash":"(.-)",.-"pages":%[(.-)%].-"server":"(.-)"') do
		server = server:gsub("\\/", "/")
		for pic in array:gmatch('"(.-)"') do
			dt[#dt + 1] = server .. hash .. "/" .. pic
		end
	end
end

function MangaDex:loadChapterPage(link, dt)
	dt.Link = link
end
