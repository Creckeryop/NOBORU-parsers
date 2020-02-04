Animeregia = Parser:new("Animeregia", "https://animaregia.net", "PRT", "ANIMEREGIAPTG")

local pt = {
    ["&Agrave;"] = "À",
    ["&Aacute;"] = "Á",
    ["&Acirc;"] = "Â",
    ["&Atilde;"] = "Ã",
    ["&Ccedil;"] = "Ç",
    ["&Egrave;"] = "È",
    ["&Eacute;"] = "É",
    ["&Ecirc;"] = "Ê",
    ["&Igrave;"] = "Ì",
    ["&Iacute;"] = "Í",
    ["&Iuml;"] = "Ï",
    ["&Ograve;"] = "Ò",
    ["&Oacute;"] = "Ó",
    ["&Otilde;"] = "Õ",
    ["&Ugrave;"] = "Ù",
    ["&Uacute;"] = "Ú",
    ["&Uuml;"] = "Ü",
    ["&agrave;"] = "à",
    ["&aacute;"] = "á",
    ["&acirc;"] = "â",
    ["&atilde;"] = "ã",
    ["&ccedil;"] = "ç",
    ["&egrave;"] = "è",
    ["&eacute;"] = "é",
    ["&ecirc;"] = "ê",
    ["&igrave;"] = "ì",
    ["&iacute;"] = "í",
    ["&iuml;"] = "ï",
    ["&ograve;"] = "ò",
    ["&oacute;"] = "ó",
    ["&otilde;"] = "õ",
    ["&ugrave;"] = "ù",
    ["&uacute;"] = "ú",
    ["&uuml;"] = "ü",
    ["&ordf;"] = "ª",
    ["&ordm;"] = "º",

}
local function stringify(str)
    for k, v in pairs(pt) do
        str = str:gsub(k, v)
    end
    return str
end

function Animeregia:getManga(link, dest_table)
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
	for Link, ImageLink, Name in content:gmatch("<a href=\"([^\"]-)\" class=\"thumbnail\">[^>]-src='([^']-)' alt='([^']-)'>[^<]-</a>") do
		local manga = CreateManga(Name, Link, self.Link..ImageLink, self.ID, Link)
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

function Animeregia:getPopularManga(page, dest_table)
    self:getManga(self.Link.."/filterList?sortBy=views&page="..page, dest_table)
end

function Animeregia:searchManga(search, page, dest_table)
    self:getManga(self.Link.."/filterList?alpha="..search.."&sortBy=views&page="..page, dest_table)
end

function Animeregia:getChapters(manga, dest_table)
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
    for Link, Name in content:gmatch("chapter%-title%-rtl\">[^<]-<a href=\"([^\"]-)\">([^<]-)</a>") do
        t[#t + 1] = {
			Name = stringify(Name),
			Link = Link,
			Pages = {},
			Manga = manga
		}
    end
	for i = #t, 1, -1 do
		dest_table[#dest_table + 1] = t[i]
	end
end

function Animeregia:prepareChapter(chapter, dest_table)
	local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = chapter.Link,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
	local t = dest_table
	for Link in content:gmatch("img%-responsive\"[^>]-data%-src=' ([^']-) '") do
        t[#t + 1] = Link
		Console.write("Got " .. t[#t])
    end
end

function Animeregia:loadChapterPage(link, dest_table)
	dest_table.Link = link
end
