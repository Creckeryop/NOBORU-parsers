MangaHub = Parser:new("MangaHub", "https://mangahub.io", "ENG", "MANGAHUBEN", 3)
MangaHub.Filters = {
	{
		Name = "Genre",
		Type = "radio",
		Tags = {
			"All Genres",
			"Action",
			"Adventure",
			"Comedy",
			"Adult",
			"Drama",
			"Historical",
			"Martial arts",
			"Romance",
			"Ecchi",
			"Supernatural",
			"Webtoons",
			"Manhwa",
			"Fantasy",
			"Harem",
			"Shounen",
			"Manhua",
			"Mature",
			"Seinen",
			"Sports",
			"School life",
			"Smut",
			"Mystery",
			"Psychological",
			"Shounen ai",
			"Slice of life",
			"Shoujo ai",
			"Cooking",
			"Horror",
			"Tragedy",
			"Doujinshi",
			"Sci fi",
			"Yuri",
			"Yaoi",
			"Shoujo",
			"Gender bender",
			"Josei",
			"Mecha",
			"Medical",
			"One shot",
			"Magic",
			"Shounenai",
			"Shoujoai",
			"4-Koma",
			"Music",
			"Webtoon",
			"Isekai",
			"[no chapters]",
			"Game",
			"Award Winning",
			"Oneshot",
			"Demons",
			"Parody",
			"Vampire",
			"Military",
			"Police",
			"Super Power",
			"Food",
			"Kids",
			"Magical Girls",
			"Space",
			"Shotacon",
			"Wuxia",
			"Superhero",
			"Thriller",
			"Crime",
			"Philosophical"
		}
	}
}

MangaHub.Keys = {
	["All Genres"] = "all",
	["Action"] = "action",
	["Adventure"] = "adventure",
	["Comedy"] = "comedy",
	["Adult"] = "adult",
	["Drama"] = "drama",
	["Historical"] = "historical",
	["Martial arts"] = "martial-arts",
	["Romance"] = "romance",
	["Ecchi"] = "ecchi",
	["Supernatural"] = "supernatural",
	["Webtoons"] = "webtoons",
	["Manhwa"] = "manhwa",
	["Fantasy"] = "fantasy",
	["Harem"] = "harem",
	["Shounen"] = "shounen",
	["Manhua"] = "manhua",
	["Mature"] = "mature",
	["Seinen"] = "seinen",
	["Sports"] = "sports",
	["School life"] = "school-life",
	["Smut"] = "smut",
	["Mystery"] = "mystery",
	["Psychological"] = "psychological",
	["Shounen ai"] = "shounen-ai",
	["Slice of life"] = "slice-of-life",
	["Shoujo ai"] = "shoujo-ai",
	["Cooking"] = "cooking",
	["Horror"] = "horror",
	["Tragedy"] = "tragedy",
	["Doujinshi"] = "doujinshi",
	["Sci fi"] = "sci-fi",
	["Yuri"] = "yuri",
	["Yaoi"] = "yaoi",
	["Shoujo"] = "shoujo",
	["Gender bender"] = "gender-bender",
	["Josei"] = "josei",
	["Mecha"] = "mecha",
	["Medical"] = "medical",
	["One shot"] = "one-shot",
	["Magic"] = "magic",
	["Shounenai"] = "shounenai",
	["Shoujoai"] = "shoujoai",
	["4-Koma"] = "4-koma",
	["Music"] = "music",
	["Webtoon"] = "webtoon",
	["Isekai"] = "isekai",
	["[no chapters]"] = "no-chapters",
	["Game"] = "game",
	["Award Winning"] = "award-winning",
	["Oneshot"] = "oneshot",
	["Demons"] = "demons",
	["Parody"] = "parody",
	["Vampire"] = "vampire",
	["Military"] = "military",
	["Police"] = "police",
	["Super Power"] = "super-power",
	["Food"] = "food",
	["Kids"] = "kids",
	["Magical Girls"] = "magical-girls",
	["Space"] = "space",
	["Shotacon"] = "shotacon",
	["Wuxia"] = "wuxia",
	["Superhero"] = "superhero",
	["Thriller"] = "thriller",
	["Crime"] = "crime",
	["Philosophical"] = "philosophical"
}

function MangaHub:getManga(link, dest_table)
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
	local content = file.string or ""
	local t = dest_table
	local done = true
	for Link, ImageLink, Name in content:gmatch('media%-left">.-<a href="([^"]-/manga/[^"]-)">.-src="([^"]-)" alt="(.-)"') do
		local manga = CreateManga(Name:gsub("&#x27;", "'"), Link, ImageLink, self.ID, Link)
		if manga then
			t[#t + 1] = manga
			done = false
		end
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function MangaHub:getLatestManga(page, dest_table)
	self:getManga(string.format("%s/updates/page/%s", self.Link, page), dest_table)
end

function MangaHub:getPopularManga(page, dest_table)
	self:getManga(string.format("%s/popular/page/%s", self.Link, page), dest_table)
end

function MangaHub:searchManga(search, page, dest_table, tag)
	self:getManga(string.format("%s/search/page/%s?q=%s&order=POPULAR&genre=" .. (self.Keys[tag and tag["Genre"]] or "all"), self.Link, page, search), dest_table)
end

function MangaHub:getChapters(manga, dt)
	local file = {}
	Threads.insertTask(
		file,
		{
			Type = "StringRequest",
			Link = manga.Link,
			Table = file,
			Index = "string"
		}
	)
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	local description = content:match('<p class="ZyMp7">([^<]-)</p>') or ""
	dt.Description = description:gsub("\n+","\n")
	local t = {}
	for Link, Name in content:gmatch('<li.-<a href="([^"]-/chapter.-chapter[^"]-)".-([^>]+)</span>') do
		t[#t + 1] = {
			Name = Name,
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

MangaHub.query = [[
		{"query":"{chapter(x:m01,slug:\"%s\",number:%s){id,title,mangaID,number,slug,date,pages,noAd,manga{id,title,slug,mainSlug,author,isWebtoon,isYaoi,isPorn,isSoftPorn,unauthFile,isLicensed}}}"}
]]

function MangaHub:prepareChapter(chapter, dest_table)
	local file = {}
	Threads.insertTask(
		file,
		{
			Type = "StringRequest",
			Link = "https://api.mghubcdn.com/graphql",
			Table = file,
			Index = "string",
			HttpMethod = POST_METHOD,
			PostData = string.format(MangaHub.query, chapter.Link:match(".-/chapter/(.-)/chapter%-([^/]+)")),
			ContentType = JSON
		}
	)
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	local t = dest_table
	local pages = content:match('"pages":"{(.-)}","noAd"') or ""
	for link in pages:gmatch(':\\"(.-)\\"') do
		t[#t + 1] = "https://img.mghubcdn.com/file/imghub/" .. link
	end
end

function MangaHub:loadChapterPage(link, dest_table)
	dest_table.Link = link
end
