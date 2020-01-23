NudeMoon = Parser:new("Nude-Moon", "https://nude-moon.net", "RUS", 6)

NudeMoon.NSFW = true

function NudeMoon:getLatestManga(page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/all_manga?rowstart=" .. ((page - 1) * 30), file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for Link, Name, ImageLink in file.string:gmatch("<td colspan.-<a href=\"(.-)\".-title=\"(.-)\".-src=\"(.-)\"") do 
		local manga = CreateManga(AnsiToUtf8(Name), Link, self.Link..ImageLink, self.ID, self.Link..Link)
		if manga then
			t[#t + 1] = manga
		end
		coroutine.yield(false)
	end
end

function NudeMoon:getPopularManga(page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/all_manga?views&rowstart=" .. ((page - 1) * 30), file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for Link, Name, ImageLink in file.string:gmatch("<td colspan.-<a href=\"(.-)\".-title=\"(.-)\".-src=\"(.-)\"") do 
		local manga = CreateManga(AnsiToUtf8(Name), Link, self.Link..ImageLink, self.ID, self.Link..Link)
		if manga then
			t[#t + 1] = manga
		end
		coroutine.yield(false)
	end
end
local concat = table.concat
function NudeMoon:searchManga(data, page, table)
	local file = {}
	local stext = {}
	for c in it_utf8(data) do
		if utf8ascii[c] then
			stext[#stext+1] = utf8ascii[c]
		else
			stext[#stext+1] = c
		end
	end
	stext = concat(stext)
	Threads.DownloadStringAsync(self.Link..string.format("/search?stext=%s&rowstart=%s",stext,((page - 1) * 30)), file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for Link, Name, ImageLink in file.string:gmatch("<td colspan.-<a href=\"(.-)\".-title=\"(.-)\".-src=\"(.-)\"") do 
		local manga = CreateManga(AnsiToUtf8(Name), Link, self.Link..ImageLink, self.ID, self.Link..Link)
		if manga then
			t[#t + 1] = manga
		end
		coroutine.yield(false)
	end
end

function NudeMoon:getChapters(manga, table)
	table[#table + 1] = {
		Name = manga.Name,
		Link = manga.Link:gsub("^(/%d*)","%1-online"),
		Pages = {},
		Manga = manga
	}
end

function NudeMoon:prepareChapter(chapter, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link..chapter.Link.."?page=1", file, "string", true)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for link in file.string:gmatch("images%[%d-%].src = '%.(.-)';") do
		t[#t + 1] = self.Link .. link
		Console.writeLine("Got "..t[#t])
	end
end

function NudeMoon:loadChapterPage(link, table)
	table.Link = link
end
