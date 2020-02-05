nhentai = Parser:new("nhentai", "https://nhentai.net", "DIF", "NHENTAI")

nhentai.NSFW = true

function nhentai:getPopularManga(page, dest_table)
    local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link.."/?page="..page,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
	local t = dest_table
    local done = true
    for Link, ImageLink, Name in content:gmatch('class="gallery".-href="(%S-)".-data%-src="(%S-)".->([^<]-)</div>') do
        t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link .. Link)
		done = false
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function nhentai:searchManga(search, page, dest_table)
    local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link.."/search/?q="..search.."&page="..page,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
	local t = dest_table
    local done = true
    for Link, ImageLink, Name in content:gmatch('class="gallery".-href="(%S-)".-data%-src="(%S-)".->([^<]-)</div>') do
        t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link .. Link)
		done = false
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function nhentai:getChapters(manga, dest_table)
    dest_table[#dest_table+1] = {
        Name = manga.Name,
        Link = manga.Link,
        Pages = {},
        Manga = manga
    }
end

function nhentai:prepareChapter(chapter, dest_table)
    local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link..chapter.Link,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
    local t = dest_table
    for link in content:gmatch('class="gallerythumb".-href="(%S-)"') do
        t[#t+1] = self.Link..link
        Console.write("Got " .. t[#t])
    end
end

function nhentai:loadChapterPage(link, dest_table)
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
    dest_table.Link = content:match('image%-container">.-src="(%S-)"')
end