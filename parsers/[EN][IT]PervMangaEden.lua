MangaEdenIt = Parser:new("MangaEden Italy", "https://www.mangaeden.com", "ITA", "MAEDENITA")

MangaEdenIt.API = "/api/list/1/"
MangaEdenIt.Site = "mangaeden"
local notify = false

local function stringify(string)
    if not u8c then
        if not notify then
            Notifications.push("Please update app, to see fixed titles")
            notify = true
        end
        return string
    end
    return string:gsub("\\u(....)", function(a) return u8c(tonumber(string.format("0x%s", a))) end)
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

function MangaEdenIt:getManga(dest_table, sort, filter)
    local content = downloadContent(self.Link .. self.API)
    local t = {}
    for h, id, img, ld, Name in content:gmatch('"h": (%d-),[^}]-"i": "(%S-)",[^}]-"im": (%S-),[^}]-"ld": (%S-),[^}]-"t": "([^"]-)"') do
        t[#t + 1] = {h = tonumber(h), id = id, img = img == "null" and "" or "cdn." .. self.Site .. ".com/mangasimg/" .. (img:match('"(%S-)"') or "") or "", ld = tonumber(ld), Name = Name}
        if #t % 50 == 0 then
            coroutine.yield(false)
        end
    end
    table.sort(t, sort)
    for _, m in ipairs(t) do
        local name = stringify(m.Name)
        if filter and name:upper():find(filter:upper()) or not filter then
            dest_table[#dest_table + 1] = CreateManga(name, m.id, m.img, self.ID, m.id)
        end
        if _ % 50 == 0 then
            coroutine.yield(false)
        end
    end
end

function MangaEdenIt:getPopularManga(page, dest_table)
    self:getManga(dest_table, function(a, b) return a.h > b.h end)
    dest_table.NoPages = true
end

function MangaEdenIt:getLatestManga(page, dest_table)
    self:getManga(dest_table, function(a, b) return a.ld > b.ld end)
    dest_table.NoPages = true
end

function MangaEdenIt:searchManga(search, page, dest_table)
    local old_gsub = string.gsub
    string.gsub = function(self, one, sec)
        return old_gsub(self, sec, one)
    end
    search = search:gsub("!", "%%%%21"):gsub("#", "%%%%23"):gsub("%$", "%%%%24"):gsub("&", "%%%%26"):gsub("'", "%%%%27"):gsub("%(", "%%%%28"):gsub("%)", "%%%%29"):gsub("%*", "%%%%2A"):gsub("%+", "%%%%2B"):gsub(",", "%%%%2C"):gsub("%.", "%%%%2E"):gsub("/", "%%%%2F"):gsub(" ", "%+"):gsub("%%", "%%%%25")
    string.gsub = old_gsub
    self:getManga(dest_table, function(a, b) return a.ld > b.ld end, search)
    dest_table.NoPages = true
end

function MangaEdenIt:getChapters(manga, dest_table)
    local content = downloadContent(self.Link .. "/api/manga/" .. manga.Link):match('"chapters"(.-)"chapters_len"') or ""
    local t = {}
    for num, title, id in content:gmatch('%[%s-(%S-),[^,%]]-,([^,]-),[^%]]-"([^"]-)"[^%]]-%]') do
        t[#t + 1] = {
            Name = num .. " : " .. stringify(title:match('"([^"]-)"') or manga.Name),
            Link = id,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dest_table[#dest_table + 1] = t[i]
    end
end

function MangaEdenIt:prepareChapter(chapter, dest_table)
    local content = downloadContent(self.Link .. "/api/chapter/" .. chapter.Link):match('images"(.-)$')
    local t = {}
    for link in content:gmatch('"(%S-)"') do
        t[#t + 1] = "cdn." .. self.Site .. ".com/mangasimg/" .. link
    end
    for i = #t, 1, -1 do
        dest_table[#dest_table + 1] = t[i]
    end
end

function MangaEdenIt:loadChapterPage(link, dest_table)
    dest_table.Link = link
end

MangaEdenEn = MangaEdenIt:new("MangaEden English", "https://www.mangaeden.com", "ENG", "MAEDENENG")

MangaEdenEn.API = "/api/list/0/"

PervEdenIt = MangaEdenIt:new("PervEden Italy", "http://www.perveden.com", "ITA", "PVEDENITA")

PervEdenIt.Site = "perveden"
PervEdenIt.NSFW = true

PervEdenEn = MangaEdenEn:new("PervEden English", "http://www.perveden.com", "ENG", "PVEDENENG")

PervEdenEn.Site = "perveden"
PervEdenEn.NSFW = true
