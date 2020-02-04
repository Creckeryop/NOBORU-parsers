InManga = Parser:new("InManga", "https://inmanga.com", "ESP", "INMANGASPA")

function InManga:getManga(post, dest_table)
    local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link.."/manga/getMangasConsultResult",
		Table = file,
        Index = "string",
        HttpMethod = POST_METHOD,
        PostData = post:gsub("%%","%%%%"),
        ContentType = XWWW
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
    local t = dest_table
    local done = true
    Console.write(content)
	for Link,  Name, ImageLink in content:gmatch('href="(/ver/manga/[^"]-)".-</em> (.-)</h4>.-data%-src="([^"]-)"') do
        local link, id = Link:match("(.+)/(.-)$")
        local manga = CreateManga(Name, link, self.Link..ImageLink, self.ID, self.Link..Link)
        if manga then
            manga.Data = {
                id = id
            }
			t[#t + 1] = manga
			done = false
		end
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function InManga:getLatestManga(page, dest_table)
    self:getManga("filter%5Bgeneres%5D%5B%5D=-1&filter%5BqueryString%5D=&filter%5Bskip%5D="..((page-1) * 10).."&filter%5Btake%5D=10&filter%5Bsortby%5D=3&filter%5BbroadcastStatus%5D=0&filter%5BonlyFavorites%5D=false&d=", dest_table)
end

function InManga:getPopularManga(page, dest_table)
    self:getManga("filter%5Bgeneres%5D%5B%5D=-1&filter%5BqueryString%5D=&filter%5Bskip%5D="..((page-1) * 10).."&filter%5Btake%5D=10&filter%5Bsortby%5D=1&filter%5BbroadcastStatus%5D=0&filter%5BonlyFavorites%5D=false&d=", dest_table)
end

function InManga:searchManga(search, page, dest_table)
    self:getManga("filter%5Bgeneres%5D%5B%5D=-1&filter%5BqueryString%5D="..search.."&filter%5Bskip%5D="..((page-1) * 10).."&filter%5Btake%5D=10&filter%5Bsortby%5D=1&filter%5BbroadcastStatus%5D=0&filter%5BonlyFavorites%5D=false&d=", dest_table)
end

function InManga:getChapters(manga, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link.."/chapter/getall?mangaIdentification="..manga.Data.id,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
    local t = {}
    for Id, Num in content:gmatch('\\"Identification\\":\\"(.-)\\".-Number\\":\\"(.-)\\"') do
        Num = tonumber(Num)
        t[#t + 1] = {
			Name = Num,
			Link = Id,
			Pages = {},
			Manga = manga
		}
    end
    table.sort(t, function(a, b) return (a.Name < b.Name) end)
	for i = 1, #t do
		dest_table[#dest_table + 1] = t[i]
	end
end

function InManga:prepareChapter(chapter, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link.."/chapter/chapterIndexControls?identification="..chapter.Link,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
    local t = dest_table
    local manga_title = chapter.Manga.Link:match(".+/(.-)$")
    content = content:match("<select[^>]-PageList.-</select>") or ""
    for Link, Num in content:gmatch('value=\"([^"]-)\">(.-)<') do
        t[#t + 1] = self.Link.."/images/manga/"..manga_title.."/chapter/"..chapter.Name.."/page/"..Num.."/"..Link
		Console.write("Got " .. t[#t])
    end
end

function InManga:loadChapterPage(link, dest_table)
	dest_table.Link = link
end
