MangaReader = Parser:new("MangaReader", "https://www.mangareader.net", "ENG")

function MangaReader:getManga (i)
    local file = Net.downloadString ('https://www.mangareader.net/popular/'..((i - 1) * 30))
    local list = {}
	for img_link, link, name in file:gmatch ("image:url%('(%S-)'.-<div class=\"manga_name\">.-<a href=\"(%S-)\">(.-)</a>") do
        list[#list + 1] = Manga:new (name, link, img_link, self)
	end
	return list
end

function MangaReader:getChapters (manga)
	local file = Net.downloadString ("https://www.mangareader.net"..manga.link)
	local list = {}
	for link, name, subName in file:gmatch ("<td>.-<a href%=\""..manga.link.."(/%S-)\">(.-)</a>.-\"(.-)") do
		local chapter = {name = name..subName, link = link, pages = {}, manga = manga}
		list[#list + 1] = chapter
		Console.addLine ("Parser: Got chapter \""..chapter.name.."\" ("..chapter.link..")", LUA_COLOR_GREEN)
	end
	return list
end

function MangaReader:getPagesCount (chapter)
	local file = Net.downloadString ("https://www.mangareader.net"..chapter.manga.link..chapter.link.."#")
	for count in file:gmatch ("\" of (.-)\"") do
		return count
	end
	return 0
end

ReadManga = Parser:new ("ReadManga", "https://readmanga.me", "RUS")

function ReadManga:getManga (i)
	local file = Net.downloadString ("http://readmanga.me/list?sortType=rate&offset="..((i - 1) * 70))
	local list = {}
	for link, img_link, name in file:gmatch ("<a href=\"(/%S-)\" class=\"non%-hover\".-original='(%S-)' title='(.-)'") do
		if link:match ("^/") then
			list[#list + 1] = Manga:new (name, link, img_link, self)
		end
	end
	return list
end

function ReadManga:getChapters (manga)
	local file = Net.downloadString ("http://readmanga.me"..manga.link)
	local list = {}
	for link, name in file:gmatch ("<td class%=.-<a href%=\""..manga.link.."(/vol%S-)\".->(.-)</a>") do
		local chapter = {name = name:gsub ("%s+"," "), link = link, pages = {}, manga = manga}
		list[#list + 1] = chapter
		Console.addLine ("Parser: Got chapter \""..chapter.name.."\" ("..chapter.link..")", LUA_COLOR_GREEN)
	end
	return TableReverse (list)
end

function ReadManga:getPagesCount (chapter)
	Console.addLine("http://readmanga.me"..chapter.manga.link..chapter.link.."#")
	Net.downloadFile ("http://readmanga.me"..chapter.manga.link..chapter.link.."#","ux0:data\vsKoob\lol.php")
	--[[for count in file:gmatch ("<span class=\"pages-count\">(.-)</span>") do
		return count
	end]]
	return 0
end