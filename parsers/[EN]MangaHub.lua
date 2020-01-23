MangaHub = Parser:new("MangaHub", "https://mangahub.io", "ENG", 7)

function MangaHub:getLatestManga(page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/updates/page/" .. page, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for Link, ImageLink, Name in file.string:gmatch("media%-left\">.-<a href=\"([^\"]-/manga/[^\"]-)\">.-src=\"([^\"]-)\" alt=\"(.-)\"") do
		local manga = CreateManga(Name:gsub("&#x27;","'"), Link, ImageLink, self.ID, Link)
		if manga then
			t[#t + 1] = manga
		end
		coroutine.yield(false)
	end
end

function MangaHub:getPopularManga(page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/popular/page/" .. page, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for Link, ImageLink, Name in file.string:gmatch("media%-left\">.-<a href=\"([^\"]-/manga/[^\"]-)\">.-src=\"([^\"]-)\" alt=\"(.-)\"") do
		local manga = CreateManga(Name:gsub("&#x27;","'"), Link, ImageLink, self.ID, Link)
		if manga then
			t[#t + 1] = manga
		end
		coroutine.yield(false)
	end
end

function MangaHub:getChapters(manga, table)
	local file = {}
	Threads.DownloadStringAsync(manga.Link, file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = {}
	for Link, Name in file.string:gmatch("<li.-<a href=\"([^\"]-/chapter.-chapter[^\"]-)\".-([^>]+)</span>") do
		t[#t + 1] = {
			Name = Name,
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		table[#table + 1] = t[i]
	end
end

MangaHub.query = [[
		{"query":"{chapter(x:m01,slug:\"%s\",number:%s){id,title,mangaID,number,slug,date,pages,noAd,manga{id,title,slug,mainSlug,author,isWebtoon,isYaoi,isPorn,isSoftPorn,unauthFile,isLicensed}}}"}
]]

function MangaHub:prepareChapter(chapter, table)
	local file = {}
	Threads.DownloadStringAsync("https://api2.mangahub.io/graphql", file, "string", true, POST_METHOD, string.format(MangaHub.query,chapter.Link:match(".-/chapter/(.-)/chapter%-([^/]+)")),JSON)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	local pages = file.string:match("\"pages\":\"{(.-)}\",\"noAd\"")
	for link in pages:gmatch(":\\\"(.-)\\\"") do
		t[#t + 1] = "https://cdn.mangahub.io/file/imghub/"..link
		Console.writeLine("Got "..t[#t])
	end
end

function MangaHub:loadChapterPage(link, table)
	table.Link = link
end
