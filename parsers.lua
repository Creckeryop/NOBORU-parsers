MangaReader = Parser:new("MangaReader", "https://www.mangareader.net", "ENG")

function MangaReader:getManga (i, table, index)
	local file = {}
    Net.downloadStringAsync ('https://www.mangareader.net/popular/'..((i - 1) * 30), file, 'string')
	while file.string == nil do
		coroutine.yield()
	end
	for img_link, link, name in file.string:gmatch ("image:url%('(%S-)'.-<div class=\"manga_name\">.-<a href=\"(%S-)\">(.-)</a>") do
        table[index][#table[index] + 1] = Manga:new (name, link, img_link, self)
		coroutine.yield()
	end
end

function MangaReader:getChapters (manga)
	local file = Net.downloadString ("https://www.mangareader.net"..manga.link)
	local list = {}
	for link, name, subName in file:gmatch ("<td>.-<a href%=\""..manga.link.."(/%S-)\">(.-)</a>.-\"(.-)") do
		local chapter = {name = name..subName, link = link, pages = {}, manga = manga}
		list[#list + 1] = chapter
		--Console.addLine ("Parser: Got chapter \""..chapter.name.."\" ("..chapter.link..")", LUA_COLOR_GREEN)
	end
	return list
end

function MangaReader:getChapterInfo (chapter, index)
	local file = {}
	Net.downloadStringAsync ("https://www.mangareader.net"..chapter.manga.link..chapter.link.."#",file,'string')
	while file.string == nil do
		coroutine.yield()
	end
	local count = file.string:match ("\" of (.-)\"")
	for i = 1, count do
		file = {}
		Net.downloadStringAsync ("https://www.mangareader.net"..chapter.manga.link..chapter.link.."/"..i,file,'string')
		while file.string == nil do
			coroutine.yield()
		end
		chapter[index][i] = file.string:match ("id=\"img\".-src=\"(.-)\"")
		Console.addLine("Got "..chapter[index][i])
	end
end

ReadManga = Parser:new ("ReadManga", "https://readmanga.me", "RUS")

function ReadManga:getManga (i, table, index)
	local file = {}
	Net.downloadStringAsync ("http://readmanga.me/list?sortType=rate&offset="..((i - 1) * 70), file, 'string')
	while file.string == nil do
		coroutine.yield()
	end
	for link, img_link, name in file.string:gmatch ("<a href=\"(/%S-)\" class=\"non%-hover\".-original='(%S-)' title='(.-)'") do
		if link:match ("^/") then
			table[index][#table[index] + 1] = Manga:new (name, link, img_link, self)
		end
		coroutine.yield()
	end
end

function ReadManga:getChapters (manga)
	local file = Net.downloadString ("http://readmanga.me"..manga.link)
	local list = {}
	for link, name in file:gmatch ("<td class%=.-<a href%=\""..manga.link.."(/vol%S-)\".->(.-)</a>") do
		local chapter = {name = name:gsub ("%s+"," "), link = link, pages = {}, manga = manga}
		list[#list + 1] = chapter
	end
	return TableReverse (list)
end

function ReadManga:getChapterInfo (chapter, index)
	local file = {}
	Net.downloadStringAsync ("http://readmanga.me"..chapter.manga.link..chapter.link.."#", file, 'string')
	while file.string == nil do
		coroutine.yield()
	end
	local text = file.string:match ("rm_h.init%((.-%]%])")
	if text ~= nil then
		chapter[index] = load ("return "..text:gsub("%[","{"):gsub("%]","}"))()
		for i = 1, #chapter[index] do
			chapter[index][i] = chapter[index][2]..chapter[index][3]
			Console.addLine("Got "..chapter[index][i])
		end
	end
end