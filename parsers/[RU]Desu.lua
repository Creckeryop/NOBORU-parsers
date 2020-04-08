Desu = Parser:new("Desu", "https://desu.me", "RUS", "DESURU", 2)

function Desu:getManga(is_search, link, dest_table)
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
	local pattern
	if is_search then
		pattern = '<a href="(manga/%S-)".-src="(.-)".-SubTitle">(.-)</div>'
	else
		pattern = 'memberListItem.-<a href="(manga/%S-)".-url%(\'([^\']-)\'%);.-title="([^"]-)"'
	end
	for Link, ImageLink, Name  in content:gmatch(pattern) do
		ImageLink = "https://desu.me/data/manga/covers/x225/"..(Link:match("%.([^%.]-)/?$") or "")..".jpg"
		local manga = CreateManga(Name, "/"..Link, ImageLink, self.ID, self.Link .. "/" .. Link)
		if manga then
			t[#t + 1] = manga
			if not is_search then
				done = false
			end
		end
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function Desu:getPopularManga(page, dest_table)
    Desu:getManga(false, string.format("%s/manga/?order_by=popular&page=%s", self.Link, page), dest_table)
end

function Desu:getLatestManga(page, dest_table)
    Desu:getManga(false, string.format("%s/manga/?page=%s", self.Link, page), dest_table)
end

function Desu:searchManga(search, page, dest_table)
    Desu:getManga(true, string.format("%s/manga/search?q=%s", self.Link, search, page), dest_table)
end

function Desu:getChapters(manga, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link .. manga.Link,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	local t = {}
	for Link, Name in content:gmatch('<a href="(/manga/%S-)" class="tips Tooltip"[^>]-title="([^>]-)">') do
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

function Desu:prepareChapter(chapter, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link .. chapter.Link,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
    local t = dest_table
    local dir = content:match('dir: "\\/\\/([^"]-)",'):gsub("\\/","/") or ""
    local images = content:match('images: %[%[(.-)%]%],') or ""
	for link in images:gmatch('"(.-)"') do
		if not link:find("%.gif") then
			t[#t + 1] = dir .. link
			Console.write("Got " .. t[#t])
		else
			Console.write("Skipping " .. link)
		end
	end
end

function Desu:loadChapterPage(link, dest_table)
    dest_table.Link = link
end