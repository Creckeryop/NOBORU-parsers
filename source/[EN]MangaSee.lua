MangaSee = Parser:new("MangaSee", "https://mangaseeonline.us", "ENG", "MANGASEE", 2)
MangaSee.Disabled = true
MangaSee.Filters = {
	{
		Name = "Sort By",
		Type = "radio",
		Tags = {
			"Alphabetical A-Z",
			"Alphabetical Z-A",
			"Newest",
			"Oldest",
			"Most Popular",
			"Least Popular"
		}
	},
	{
		Name = "Type",
		Type = "radio",
		Tags = {
			"Any",
			"Doujinshi",
			"Manga",
			"Manhua",
			"Manhwa",
			"OEL",
			"One-shot"
		}
	},
	{
		Name = "Genre",
		Type = "checkcross",
		Tags = {
			"Action",
			"Adult",
			"Adventure",
			"Comedy",
			"Doujinshi",
			"Drama",
			"Ecchi",
			"Fantasy",
			"Gender Bender",
			"Harem",
			"Hentai",
			"Historical",
			"Horror",
			"Isekai",
			"Josei",
			"Lolicon",
			"Martial Arts",
			"Mature",
			"Mecha",
			"Mystery",
			"Psychological",
			"Romance",
			"School Life",
			"Sci-fi",
			"Seinen",
			"Shotacon",
			"Shoujo",
			"Shoujo Ai",
			"Shounen",
			"Shounen Ai",
			"Slice of Life",
			"Smut",
			"Sports",
			"Supernatural",
			"Tragedy",
			"Yaoi",
			"Yuri"
		}
	},
	{
		Name = "Publish Status",
		Type = "radio",
		Tags = {
			"Any",
			"Cancelled",
			"Complete",
			"Discontinued",
			"Hiatus",
			"Ongoing"
		}
	}
}

MangaSee.SortKeys = {
	["Alphabetical A-Z"] = "",
	["Alphabetical Z-A"] = "&sortOrder=descending",
	["Newest"] = "&sortBy=dateUpdated&sortOrder=descending",
	["Oldest"] = "&sortBy=dateUpdated",
	["Most Popular"] = "&sortBy=popularity&sortOrder=descending",
	["Least Popular"] = "&sortBy=popularity"
}

local mangasee_api = "https://mangaseeonline.us/search/request.php"
local query = "page=%s&keyword=%s&year=&author=&sortBy=%s&sortOrder=descending&status=&pstatus=&type=%s&genre=%s&genreNo=%s"

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

function MangaSee:getManga(data, dt)
	local content =
		downloadContent(
		{
			Link = mangasee_api,
			HttpMethod = POST_METHOD,
			PostData = data,
			ContentType = XWWW
		}
	)
	dt.NoPages = true
	for ImageLink, Link, Name in content:gmatch('class="requested">.-src="([^"]-)".-href="([^"]-)">([^<]-)</a>') do
		local manga = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
		dt[#dt + 1] = manga
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MangaSee:getLatestManga(page, dt)
	self:getManga(query:format(page, "", "dateUpdated", "", "", ""), dt)
end

function MangaSee:getPopularManga(page, dt)
	self:getManga(query:format(page, "", "popularity", "", "", ""), dt)
end

function MangaSee:searchManga(search, page, dt, tags)
	local _query = "page=%s&keyword=%s&year=&author=%s&status=&pstatus=%s&type=%s&genre=%s&genreNo=%s"
	local ingenres = ""
	local exgenres = ""
	local sort = "&sortBy=popularity&sortOrder=descending"
	local type = ""
	local pstatus = ""
	if tags then
		local Genres = tags["Genre"]
		if Genres then
			ingenres = table.concat(Genres.include or {}, ","):gsub(" ", "%%20")
			exgenres = table.concat(Genres.exclude or {}, ","):gsub(" ", "%%20")
		end
		type = tags["Type"] == "Any" and "" or tags["Type"] or ""
		pstatus = tags["Publish Status"] == "Any" and "" or tags["Publish Status"] or ""
		local Sort = tags["Sort By"]
		if Sort and self.SortKeys[Sort] then
			sort = self.SortKeys[Sort]
		end
	end
	self:getManga(_query:format(page, search, sort, pstatus, type, ingenres, exgenres), dt)
end

function MangaSee:getChapters(manga, dt)
	local content = downloadContent(self.Link .. manga.Link)
	local t = {}
	for Link, Name in content:gmatch('class="list%-group%-item".-href="(.-)".-chapterLabel">(.-)</span>') do
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

function MangaSee:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Link)
	for Link in content:gmatch('"%d-":"([^"]-)"') do
		dt[#dt + 1] = Link:gsub("\\/", "/")
	end
end

function MangaSee:loadChapterPage(link, dt)
	dt.Link = link
end
