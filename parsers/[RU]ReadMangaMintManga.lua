ReadManga = Parser:new("ReadManga", "https://readmanga.me", "RUS", "READMANGARU")

function ReadManga:getManga(dest_table, content)
	local t = dest_table
	local done = true
	for Link, ImageLink, Name in content:gmatch('<a href="(/%S-)" class="non%-hover".-original=\'(%S-)\' title=\'(.-)\' alt') do
		if Link:match("^/") then
			t[#t + 1] = CreateManga(Name, Link, ImageLink, self.ID, self.Link .. Link)
			done = false
		end
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function ReadManga:getLatestManga(page, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = string.format("%s/list?sortType=updated&offset=%s", self.Link, (page - 1) * 70),
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	self:getManga(dest_table, content)
end

function ReadManga:getPopularManga(page, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = string.format("%s/list?sortType=rate&offset=%s", self.Link, (page - 1) * 70),
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	self:getManga(dest_table, content)
end

function ReadManga:searchManga(data, page, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = string.format("%s/search", self.Link),
		Table = file,
		Index = "string",
		HttpMethod = POST_METHOD,
		PostData = string.format("q=%s&offset=%s", data, (page - 1) * 50)
	})
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	self:getManga(dest_table, content)
end

function ReadManga:getChapters(manga, dest_table)
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
	for Link, Name in content:gmatch('<td class%=.-<a href%="/.-(/vol%S-)".->%s*(.-)</a>') do
		t[#t + 1] = {
			Name = Name:gsub("%s+", " "):gsub("<sup>.-</sup>", ""):gsub("&quot;", '"'):gsub("&amp;", "&"):gsub("&#92;", "\\"):gsub("&#39;", "'"),
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dest_table[#dest_table + 1] = t[i]
	end
end

function ReadManga:prepareChapter(chapter, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link .. chapter.Manga.Link .. chapter.Link .. "?mtr=1",
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	local text = content:match("rm_h.init%( %[%[(.-)%]%]") or ""
	local t = dest_table
	if text ~= nil then
		local list = load("return {{" .. text:gsub("%],%[", "},{") .. "}}")()
		for i = 1, #list do
			t[i] = list[i][2] .. list[i][3]
			Console.write("Got " .. t[i])
		end
	end
end

function ReadManga:loadChapterPage(link, dest_table)
	dest_table.Link = link
end

MintManga = ReadManga:new("MintManga", "https://mintmanga.live", "RUS", "MINTMANGARU")
