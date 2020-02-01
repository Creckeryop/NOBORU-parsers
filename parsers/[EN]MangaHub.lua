MangaHub = Parser:new("MangaHub", "https://mangahub.io", "ENG", "MANGAHUBEN")

function MangaHub:getManga(link, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = link,
		Table = file,
		Index = "string"
	})
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

function MangaHub:searchManga(search, page, dest_table)
	self:getManga(string.format("%s/search/page/%s?q=%s&order=POPULAR&genre=all", self.Link, page, search), dest_table)
end

function MangaHub:getChapters(manga, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = manga.Link,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
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
		dest_table[#dest_table + 1] = t[i]
	end
end

MangaHub.query = [[
		{"query":"{chapter(x:m01,slug:\"%s\",number:%s){id,title,mangaID,number,slug,date,pages,noAd,manga{id,title,slug,mainSlug,author,isWebtoon,isYaoi,isPorn,isSoftPorn,unauthFile,isLicensed}}}"}
]]

function MangaHub:prepareChapter(chapter, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = "https://api2.mangahub.io/graphql",
		Table = file,
		Index = "string",
		HttpMethod = POST_METHOD,
		PostData = string.format(MangaHub.query, chapter.Link:match(".-/chapter/(.-)/chapter%-([^/]+)")),
		ContentType = JSON
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
	local t = dest_table
	local pages = content:match('"pages":"{(.-)}","noAd"') or ""
	for link in pages:gmatch(':\\"(.-)\\"') do
		t[#t + 1] = "https://img.mghubcdn.com/file/imghub/" .. link
		Console.write("Got " .. t[#t])
	end
end

function MangaHub:loadChapterPage(link, dest_table)
	dest_table.Link = link
end
