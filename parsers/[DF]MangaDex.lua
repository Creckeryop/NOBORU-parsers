MangaDex = Parser:new("MangaDex", "https://mangadex.org", "DIF", "MANGADEX", 5)
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
    ["vn"] = "Vietnamese",
    ["tr"] = "Turkish"
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
    ["vn"] = "VIE",
    ["tr"] = "TUR"
}

local function stringify(string)
    return string:gsub("&#([^;]-);", function(a)
        local number = tonumber("0" .. a) or tonumber(a)
        return number and u8c(number) or "&#" .. a .. ";"
    end):gsub("&(.-);", function(a) return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&"..a..";" end)
end

local function downloadContent(link)
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
    return file.string or ""
end

function MangaDex:getManga(link, dest_table)
    local content = downloadContent(link)
    local t = dest_table
    t.NoPages = true
    for Link, ImageLink, Name in content:gmatch('<a href="([^"]-)"><img.-src="([^"]-)".-class.->([^>]-)</a>') do
        t[#t + 1] = CreateManga(stringify(Name), Link:match("/(%d-)/"), self.Link..ImageLink, self.ID, self.Link .. Link)
        t.NoPages = false
		coroutine.yield(false)
	end
end

function MangaDex:getPopularManga(page, dest_table)
    self:getManga(self.Link.."/titles/7/"..page.."/", dest_table)
end

function MangaDex:getLatestManga(page, dest_table)
    self:getManga(self.Link.."/titles/0/"..page.."/", dest_table)
end

local cookies = {}

function MangaDex:searchManga(search, page, dest_table)
    local id = search:match("^id%+?:%+?(%d-)$")
    if Browser == nil or id then
        if Browser == nil and not id then
            Notifications.push("Search isn't supported in your NOBORU version\nbut you can write and id to search type 'id:12345'", 2000)
            dest_table.NoPages = true
        end
        if id then
            local content = downloadContent(self.Link..api_manga..id):gsub("\\/","/")
            local manga_imgurl, title = content:match('"cover_url":"(.-)",.-"title":"(.-)",')
            if title and manga_imgurl then
                dest_table[#dest_table + 1] = CreateManga(stringify(title), id, self.Link..manga_imgurl, self.ID, self.Link .. "/title/"..search)
            end
        end
        dest_table.NoPages = true
    else
        cookies = Browser.getCookies("mangadex.org")
        if downloadContent({
            Link = self.Link.."/search?p=0&title=ABADBEEFISMAGIC",
            Cookie = cookies['@'],
            Header1 = "User-Agent: "..Browser.getUserAgent()
        }):find('id="login_button".-id="forgot_button"') then
            cookies = {}
        end
        if #cookies == 0 then
            Browser.open(self.Link.."/login")
            coroutine.yield(false)
        end
        cookies = Browser.getCookies("mangadex.org")
        if #cookies ~= 0 then
            Console.write(Browser.getUserAgent())
            self:getManga({
                Link = self.Link.."/search?p="..page.."&title="..search,
                Cookie = cookies['@'],
                Header1 = "User-Agent: "..Browser.getUserAgent()
            }, dest_table)
        else
            dest_table.NoPages = true
        end
    end
end

function MangaDex:getChapters(manga, dest_table)
    local content = downloadContent(self.Link..api_manga..manga.Link)
    local t = {}
    local i = 0
    local prefLang = false
    manga.Name = stringify(content:match('<span class="mx%-1">(.-)</span>') or manga.Name)
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
        dest_table[#dest_table + 1] = {
            Name = stringify("["..(Lang_codes[t[k].Lang] or t[k].Lang).."] "..t[k].Count..": "..new_title),
            Link = t[k].Id,
            Pages = {},
            Manga = manga
        }
    end
end

function MangaDex:prepareChapter(chapter, dest_table)
    local content = downloadContent(self.Link..api_chapters..chapter.Link)
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