MangaTown = Parser:new("MangaTown", "https://www.mangatown.com", "ENG", "MANGATOWNEN", 2)

MangaTown.Filters = {
	{
		Name = "Demographic",
		Type = "radio",
		Tags = {
			"Show All",
			"Shounen",
			"Seinen",
			"Shoujo",
			"Yaoi",
			"Shoujo Ai",
			"Josei",
			"Shounen Ai",
			"Yuri"
		}
	},
	{
		Name = "Genres",
		Type = "checkcross",
		Tags = {
			"4 Koma",
			"Action",
			"Adventure",
			"Comedy",
			"Cooking",
			"Doujinshi",
			"Drama",
			"Ecchi",
			"Fantasy",
			"Gender Bender",
			"Harem",
			"Historical",
			"Horror",
			"Josei",
			"Lolicon",
			"Martial Arts",
			"Mature",
			"Mecha",
			"Music",
			"Mystery",
			"One Shot",
			"Psychological",
			"Reverse Harem",
			"Romance",
			"School Life",
			"Sci Fi",
			"Sci-fi",
			"Seinen",
			"Shotacon",
			"Shoujo",
			"Shoujo Ai",
			"Shounen",
			"Shounen Ai",
			"Slice Of Life",
			"Smut",
			"Sports",
			"Supernatural",
			"Suspense",
			"Tragedy",
			"Vampire",
			"Webtoons",
			"Youkai",
			"4 Koma",
			"Action",
			"Adventure",
			"Comedy",
			"Cooking",
			"Doujinshi",
			"Drama",
			"Ecchi",
			"Fantasy",
			"Gender Bender",
			"Harem",
			"Historical",
			"Horror",
			"Josei",
			"Lolicon",
			"Martial Arts",
			"Mature",
			"Mecha",
			"Music",
			"Mystery",
			"One Shot",
			"Psychological",
			"Reverse Harem",
			"Romance",
			"School Life",
			"Sci Fi",
			"Sci-fi",
			"Seinen",
			"Shotacon",
			"Shoujo",
			"Shoujo Ai",
			"Shounen",
			"Shounen Ai",
			"Slice Of Life",
			"Smut",
			"Sports",
			"Supernatural",
			"Suspense",
			"Tragedy",
			"Vampire",
			"Webtoons",
			"Youkai"
		}
	},
	{
		Name = "Completed Series",
		Type = "radio",
		Tags = {
			"Show All",
			"Yes",
			"No"
		}
	}
}

MangaTown.DemogKeys = {
	["Shounen"] = "SHOUNEN",
	["Seinen"] = "SEİNEN",
	["Shoujo"] = "SHOUJO",
	["Yaoi"] = "YAOİ",
	["Shoujo Ai"] = "SHOUJO Aİ",
	["Josei"] = "JOSEİ",
	["Shounen Ai"] = "SHOUNEN Aİ",
	["Yuri"] = "YURİ",
	["Show All"] = ""
}

MangaTown.Completed = {
	["Yes"] = "1",
	["No"] = "0",
	["Show All"] = ""
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

function MangaTown:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for ImageLink, Link, Name in content:gmatch('cover".-src="([^"]-)".-href="([^"]-)" title="([^>]-)">') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaTown:getPopularManga(page, dt)
	self:getManga(self.Link .. "/hot/" .. page .. ".htm", dt)
end

function MangaTown:getLatestManga(page, dt)
	self:getManga(self.Link .. "/new/" .. page .. ".htm", dt)
end

function MangaTown:searchManga(search, page, dt, tags)
	local query = "page=" .. page .. "&name=" .. search
	if tags then
		local Genres = tags["Genres"]
		local Demographic = tags["Demographic"]
		local isCompleted = tags["Completed Series"]
		if Genres then
			for _, v in ipairs(Genres.include) do
				query = query .. "&" .. "genres%5B" .. v:gsub(" ", "+") .. "%5D=1"
			end
			for _, v in ipairs(Genres.exclude) do
				query = query .. "&" .. "genres%5B" .. v:gsub(" ", "+") .. "%5D=2"
			end
		end
		if Demographic and self.DemogKeys[Demographic] ~= "" then
			query =
				query ..
				"&" ..
					"demographic=" ..
						self.DemogKeys[Demographic]:gsub(
							"[^a-zA-Z]",
							function(a)
								return string.format("%%%x", string.byte(a))
							end
						)
		end
		if isCompleted and self.Completed[isCompleted] ~= "" then
			query = query .. "&" .. "is_completed=" .. self.Completed[isCompleted]
		end
	end
	self:getManga(self.Link .. "/search?" .. query, dt)
end

function MangaTown:getChapters(manga, dt)
	local content = downloadContent(self.Link .. manga.Link)
	local t = {}
	for Link, Name, SubName in content:gmatch('href="([^"]-)" name=".-">%s*(.-)%s*</a>(.-)</li>') do
		SubName = SubName:gsub('<span class="time">(.-)</span>', ""):gsub("<[^>]->", ""):gsub(" +", " ")
		if SubName ~= " " and SubName ~= "" then
			Name = Name .. " -" .. SubName
		end
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

function MangaTown:prepareChapter(chapter, dt)
	local count = downloadContent(self.Link .. chapter.Link .. "1.html"):match("total_pages = (.-);") or 0
	for i = 1, count do
		dt[i] = self.Link .. chapter.Link .. i .. ".html"
	end
end

function MangaTown:loadChapterPage(link, dt)
	dt.Link = downloadContent(link):match('img src="//([^"]-)"')
end
