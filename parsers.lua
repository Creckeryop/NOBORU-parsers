MangaReader = Parser:new("MangaReader", "https://www.mangareader.net/", "ENG")

function MangaReader:getManga (i)
    local file = Net.downloadString ('https://www.mangareader.net/popular/'..((i - 1) * 30))
    local list = {}
	for img_link, link, name in file:gmatch ("image:url%('(%S-)'.-<div class=\"manga_name\">.-<a href=\"(%S-)\">(.-)</a>") do
        list[#list + 1] = Manga:new (name, link, img_link, self)
	end
	return list
end

ReadManga = Parser:new("ReadManga", "https://readmanga.me/", "RUS")

function ReadManga:getManga (i)
	local file = Net.downloadString("http://readmanga.me/list?sortType=rate&offset="..((i - 1) * 70))
	local list = {}
	for link, img_link, name in file:gmatch("<a href=\"(/%S-)\" class=\"non%-hover\".-original='(%S-)' title='(.-)'") do
		if link:match("^/") then
			list[#list + 1] = Manga:new(name, link, img_link, self)
		end
	end
	return list
end

function ReadManga:getChapters (manga)
	local file = Net.downloadString("http://readmanga.me"..manga.link)
	local list = {}
	for link, name in file:gmatch("<td class%=.-<a href%=\""..manga.link.."(/vol%S-)\".->(.-)</a>") do
		list[#list + 1] = {name = name:gsub("%s+"," "), link = link, pages = {}}
		Console.addLine("got chapter\""..list[#list].name.."\" ("..list[#list].link..")", LUA_COLOR_RED)
	end
	return list
end