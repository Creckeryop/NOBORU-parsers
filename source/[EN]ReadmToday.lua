ReadmToday = Parser:new("Readm", "https://readm.today", "ENG", "READMTODAYENG", 1)

ReadmToday.Tags = {
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
	"Isekai",
	"Josei",
	"Lolicon",
	"Magic",
	"Manga",
	"Manhua",
	"Manhwa",
	"Martial Arts",
	"Mature",
	"Mecha",
	"Mind Game",
	"Mystery",
	"None",
	"One shot",
	"Psychological",
	"Reincarnation",
	"Romance",
	"School Life",
	"Sci fi",
	"Seinen",
	"Shotacon",
	"Shoujo",
	"Shoujo Ai",
	"Shounen",
	"Shounen Ai",
	"Slice of Life",
	"Sports",
	"Supernatural",
	"Time Travel",
	"Tragedy",
	"Uncategorized",
	"Yaoi",
	"Yuri"
}

ReadmToday.TagValues = {
	["Action"] = "action",
	["Adventure"] = "adventure",
	["Comedy"] = "comedy",
	["Cooking"] = "cooking",
	["Doujinshi"] = "doujinshi",
	["Drama"] = "drama",
	["Ecchi"] = "ecchi",
	["Fantasy"] = "fantasy",
	["Gender Bender"] = "gender-bender",
	["Harem"] = "harem",
	["Historical"] = "historical",
	["Horror"] = "horror",
	["Isekai"] = "isekai",
	["Josei"] = "josei",
	["Lolicon"] = "lolicon",
	["Magic"] = "magic",
	["Manga"] = "manga",
	["Manhua"] = "manhua",
	["Manhwa"] = "manhwa",
	["Martial Arts"] = "martial-arts",
	["Mature"] = "mature",
	["Mecha"] = "mecha",
	["Mind Game"] = "mind-game",
	["Mystery"] = "mystery",
	["None"] = "none",
	["One shot"] = "one-shot",
	["Psychological"] = "psychological",
	["Reincarnation"] = "reincarnation",
	["Romance"] = "romance",
	["School Life"] = "school-life",
	["Sci fi"] = "sci-fi",
	["Seinen"] = "seinen",
	["Shotacon"] = "shotacon",
	["Shoujo"] = "shoujo",
	["Shoujo Ai"] = "shoujo-ai",
	["Shounen"] = "shounen",
	["Shounen Ai"] = "shounen-ai",
	["Slice of Life"] = "slice-of-life",
	["Sports"] = "sports",
	["Supernatural"] = "supernatural",
	["Time Travel"] = "time-travel",
	["Tragedy"] = "tragedy",
	["Uncategorized"] = "uncategorized",
	["Yaoi"] = "yaoi",
	["Yuri"] = "yuri"
}

function ReadmToday:_getPopularUrl(page)
	page = page or 1
	return self.Link .. '/popular-manga/' .. page
end

function ReadmToday:_getSearchUrl(query)
	query = query or ''
	return self.Link .. '/searchController/index?search=' .. query
end

function ReadmToday:_getLatestUrl(page)
	page = page or 1
	return self.Link .. '/latest-releases/' .. page
end

function ReadmToday:_getTagUrl(page, tag)
	page = page or 1
	tag = tag or self.Tags[1] or ''
	local tagValue = self.TagValues[tag]
	if tag == nil then
		Notifications.push("Error while getting tag value")
		return
	end

	return self.Link .. '/category/' .. tagValue .. '/watch/' .. page
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

function ReadmToday:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('article.-href=".-/(%d-)".-src="(%S-)".-entry%-title">.-<a href.->(.-)</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name:gsub("<[^>]->", "")), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/hc.fyi/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function ReadmToday:getLatestManga(page, dt)
	local link = self:_getLatestUrl(page)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, Name, ImageLink in content:gmatch('truncate">%s*<a href="([^"]*)"[^>]*>%s-(.-)%s-</a>.-data%-src="([^"]*)"') do
		dt[#dt + 1] = CreateManga(stringify(Name:gsub("<[^>]->", "")), Link, self.Link .. ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function ReadmToday:getPopularManga(page, dt)
	local link = self:_getPopularUrl(page)
	local content = downloadContent(link)
	dt.NoPages = true
	for ImageLink, Link, Name in content:gmatch('poster%-with%-subject">.-src="([^"]*)".-href="(/manga/[^"]-)".-class="truncate">%s*(.-)%s*</h2>') do
		dt[#dt + 1] = CreateManga(stringify(Name:gsub("<[^>]->", "")), Link, self.Link .. ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function ReadmToday:searchManga(search, page, dt)
	local link = self:_getSearchUrl(search)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, Name, ImageLink in content:gmatch('href="(/manga/[^"]*)".-poster%-subject.-truncate">%s*(.-)%s*</h2.-data%-src="(/uploads/chapter_files/[^"]*)"') do
		dt[#dt + 1] = CreateManga(stringify(Name:gsub("<[^>]->", "")), Link, self.Link .. ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function ReadmToday:getTagManga(page, dt, tag)
	local link = self:_getTagUrl(page, tag)
	if link == nil then
		return
	end
	local content = downloadContent(link)
	dt.NoPages = true
	for ImageLink, Link, Name in content:gmatch('poster%-with%-subject">.-data%-src="([^"]*)".-href="(/manga/[^"]-)".-class="truncate">%s*(.-)%s*</h2>') do
		dt[#dt + 1] = CreateManga(stringify(Name:gsub("<[^>]->", "")), Link, self.Link .. ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function ReadmToday:getChapters(manga, dt)
	local content = downloadContent(self.Link .. manga.Link)
	local description = content:match('desc">%s*<p>(.*)</p>.-media%-meta') or ""
	manga.NewImageLink = self.Link .. (content:match('series%-profile%-thumb" src="([^"]-)" alt') or '')
	dt.Description = stringify(description):match('^%s*(.*)%s*$'):gsub('<[^>]->', '') or ""

	for link, name in content:gmatch('truncate"><a href="([^"]-)/all%-pages"[^>]*>%s*(.-)%s*</a>') do
		dt[#dt + 1] = {
			Name = name,
			Link = link,
			Pages = {},
			Manga = manga
		}
	end
end

function ReadmToday:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Link .. "/all-pages")
	for link in content:gmatch('img src="(/uploads/chapter_files/[^"]-)"') do
		dt[#dt + 1] = self.Link .. link:gsub("\\/", "/"):gsub("%%", "%%%%")
	end
end

function ReadmToday:loadChapterPage(link, dt)
	dt.Link = link
end
