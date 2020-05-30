Animeregia = Parser:new("Animeregia", "https://animaregia.net", "PRT", "ANIMEREGIAPTG", 2)

Animeregia.Letters = {"#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
Animeregia.Tags = {"Action", "Adventure", "Comedy", "Doujinshi", "Drama", "Ecchi", "Fantasy", "Gender Bender", "Harem", "Historical", "Horror", "Josei", "Martial Arts", "Mature", "Mecha", "Mystery", "One Shot", "Psychological", "Romance", "School Life", "Sci-fi", "Seinen", "Shoujo", "Shoujo Ai", "Shounen", "Shounen Ai", "Slice of Life", "Sports", "Supernatural", "Tragedy", "Yaoi", "Yuri", }

Animeregia.TagValues = {
    ["Action"] = "1",
    ["Adventure"] = "2",
    ["Comedy"] = "3",
    ["Doujinshi"] = "4",
    ["Drama"] = "5",
    ["Ecchi"] = "6",
    ["Fantasy"] = "7",
    ["Gender Bender"] = "8",
    ["Harem"] = "9",
    ["Historical"] = "10",
    ["Horror"] = "11",
    ["Josei"] = "12",
    ["Martial Arts"] = "13",
    ["Mature"] = "14",
    ["Mecha"] = "15",
    ["Mystery"] = "16",
    ["One Shot"] = "17",
    ["Psychological"] = "18",
    ["Romance"] = "19",
    ["School Life"] = "20",
    ["Sci-fi"] = "21",
    ["Seinen"] = "22",
    ["Shoujo"] = "23",
    ["Shoujo Ai"] = "24",
    ["Shounen"] = "25",
    ["Shounen Ai"] = "26",
    ["Slice of Life"] = "27",
    ["Sports"] = "28",
    ["Supernatural"] = "29",
    ["Tragedy"] = "30",
    ["Yaoi"] = "31",
    ["Yuri"] = "32"
}

local function stringify(string)
    return string:gsub("&#([^;]-);", function(a)
        local number = tonumber("0" .. a) or tonumber(a)
        return number and u8c(number) or "&#" .. a .. ";"
    end):gsub("&(.-);", function(a) return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";" end)
end

local function downloadContent(link)
    local f = {}
    Threads.insertTask(f, {
        Type = "StringRequest",
        Link = link,
        Table = f,
        Index = "text"
    })
    while Threads.check(f) do
        coroutine.yield(false)
    end
    return f.text or ""
end

function Animeregia:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch("<a href=\"([^\"]-)\" class=\"thumbnail\">[^>]-src='([^']-)' alt='([^']-)'>[^<]-</a>") do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, self.Link .. ImageLink, self.ID, Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function Animeregia:getPopularManga(page, dt)
    self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function Animeregia:getLetterManga(page, dt, letter)
    self:getManga(self.Link .. "/filterList?alpha=" .. letter:gsub("#", "Other") .. "&sortBy=name&asc=true&page=" .. page, dt)
end

function Animeregia:getTagManga(page, dt, tag)
    self:getManga(self.Link .. "/filterList?alpha=&cat=" .. (self.TagValues[tag] or "0") .. "&sortBy=name&asc=true&page=" .. page, dt)
end

function Animeregia:getLatestManga(page, dt)
    local content = downloadContent(self.Link .. "/latest-release?page=" .. page)
    dt.NoPages = true
    for Link, Name in content:gmatch('manga%-item.-href="([^"]-)">(.-)</a>') do
        local key = Link:match("manga/(.*)/?") or ""
        dt[#dt + 1] = CreateManga(stringify(Name), Link, self.Link .. "/uploads/manga/" .. key .. "/cover/cover_250x350.jpg", self.ID, Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function Animeregia:searchManga(search, page, dt)
    self:getManga(self.Link .. "/filterList?alpha=" .. search .. "&sortBy=views&asc=false&page=" .. page, dt)
end

function Animeregia:getChapters(manga, dt)
    local content = downloadContent(manga.Link)
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
        dt[#dt + 1] = t[i]
    end
end

function Animeregia:prepareChapter(chapter, dt)
    local content = downloadContent(chapter.Link)
    for Link in content:gmatch("img%-responsive\"[^>]-data%-src=' ([^']-) '") do
        dt[#dt + 1] = Link
    end
end

function Animeregia:loadChapterPage(link, dt)
    dt.Link = link
end
