MangaDex = Parser:new("MangaDex", "https://mangadex.org", "DIF", "MANGADEX", 1)
local api_manga = "/api/manga/"
local api_chapters = "/api/chapter/"
local Lang_codes = {
    ["bg"] = "Bulgaria",
    ["br"] = "Brazil",
    ["ct"] = "Catalan",
    ["de"] = "German",
    ["es"] = "Spanish",
    ["fr"] = "French",
    ["gb"] = "English",
    ["id"] = "Indonesian",
    ["it"] = "Italian",
    ["mx"] = "Mexican",
    ["pl"] = "PL",
    ["ru"] = "Russian",
    ["sa"] = "SA",
    ["vn"] = "Vietnamese"
}

local LtoL = {
    ["bg"] = "BGR",
    ["br"] = "BRA",
    ["ct"] = "CAT",
    ["de"] = "DEU",
    ["es"] = "SPA",
    ["fr"] = "FRA",
    ["gb"] = "ENG",
    ["id"] = "IND",
    ["it"] = "ITA",
    ["mx"] = "MEX",
    ["pl"] = "PL",
    ["ru"] = "RUS",
    ["sa"] = "SA",
    ["vn"] = "VIE"
}
function MangaDex:getPopularManga(page, dest_table)
    local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link.."/titles/7/"..page.."/",
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
	local t = dest_table
    local done = true
    for Link, ImageLink, Name in content:gmatch('<a href="([^"]-)"><img.-src="([^"]-)".-class.->([^>]-)</a>') do
        t[#t + 1] = CreateManga(Name, Link:match("/(%d-)/"), self.Link..ImageLink, self.ID, self.Link .. Link)
		done = false
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function MangaDex:getLatestManga(page, dest_table)
    local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link.."/titles/0/"..page.."/",
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
	local t = dest_table
    local done = true
    for Link, ImageLink, Name in content:gmatch('<a href="([^"]-)"><img.-src="([^"]-)".-class.->([^>]-)</a>') do
        t[#t + 1] = CreateManga(Name, Link:match("/(%d-)/"), self.Link..ImageLink, self.ID, self.Link .. Link)
		done = false
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function MangaDex:searchManga(search, page, dest_table)
    if tonumber(search)== nil then
        Notifications.push("Search in this parser is unavailable\nbut you can write id (number value) of manga")
		dest_table.NoPages = true
    end
    local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link..api_manga..search,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
    content = content:gsub("\\/","/")
    local manga_imgurl, title = content:match('"cover_url":"(.-)",.-"title":"(.-)",')
    if title then
        local manga = CreateManga(title, search, self.Link..manga_imgurl, self.ID, self.Link .. "/title/"..search)
        if manga then
            dest_table[#dest_table+1] = manga
        end
    end
    dest_table.NoPages = true
end

function MangaDex:getChapters(manga, dest_table)
    local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link..api_manga..manga.Link,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
    local t = {}
    local i = 0
    local prefLang = false
    if Settings.ParserLanguage and Settings.ParserLanguage ~= "DIF" then
        prefLang = Settings.ParserLanguage
    end
    local found = false
    for Id, Count, Title, Lang in content:gmatch('"(%d-)":{[^}]-"chapter":"(.-)","title":"(.-)","lang_code":"([^,]-)",.-}') do
        if prefLang and LtoL[Lang] == prefLang or not prefLang then
            t[#t + 1] = {Id = Id, Count = Count, Title = Title, Lang = Lang}
            if i > 100 then
                coroutine.yield(false)
                i = 0
            else
                i = i + 1
            end
        end
        found = true
    end
    if found and #t == 0 and prefLang then
        Notifications.push("No chapters for preferred Language")
    end
    table.sort(t, function(a, b)
        if a.Lang == b.Lang then
            local c_a, c_b = tonumber(a.Count), tonumber(b.Count)
            if c_a and c_b then
                return c_a > c_b
            elseif c_a then
                return true
            elseif c_b then
                return false
            end
        else
            return a.Lang > b.Lang
        end
    end)
    if not u8c then
        Notifications.push("Download Latest version to support \\u chars")
    end
    for k = #t, 1,-1 do
        local new_title = t[k].Title:gsub('\\"','"')
        if u8c then
            new_title = new_title:gsub("\\u(....)",function(a) return u8c(tonumber(string.format("0x%s",a))) end)
        end
        dest_table[#dest_table + 1] = {Name = "["..(Lang_codes[t[k].Lang] or t[k].Lang).."] "..t[k].Count..": "..new_title, Link = t[k].Id, Pages = {}, Manga = manga}
    end
end

function MangaDex:prepareChapter(chapter, dest_table)
    local file = {}
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link..api_chapters..chapter.Link,
		Table = file,
		Index = "string"
	})
	while Threads.check(file) do
		coroutine.yield(false)
    end
    local content = file.string or ""
    local t = dest_table
    for hash, server, array in content:gmatch('"hash":"(.-)",.-"server":"(.-)","page_array":%[(.-)%]') do
        server = server:gsub("\\/","/")
        for pic in array:gmatch('"(.-)"') do
            t[#t + 1] = server..hash.."/"..pic
            Console.write("Got " .. t[#t])
        end
    end
end

function MangaDex:loadChapterPage(link, dest_table)
    dest_table.Link = link
end