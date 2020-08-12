MangaReader = Parser:new("MangaReader", "https://www.mangareader.net", "ENG", "MANGAREADEREN", 2)

MangaReader.Tags = {"Action", "Adventure", "Comedy", "Demons", "Drama", "Ecchi", "Fantasy", "Gender Bender", "Harem", "Historical", "Horror", "Josei", "Magic", "Martial Arts", "Mature", "Mecha", "Military", "Mystery", "One Shot", "Psychological", "Romance", "School Life", "Sci-Fi", "Seinen", "Shoujo", "Shoujoai", "Shounen", "Shounenai", "Slice of Life", "Smut", "Sports", "Super Power", "Supernatural", "Tragedy", "Vampire", "Yaoi", "Yuri"}
MangaReader.TagValues = {
    ["Action"] = "action",
    ["Adventure"] = "adventure",
    ["Comedy"] = "comedy",
    ["Demons"] = "demons",
    ["Drama"] = "drama",
    ["Ecchi"] = "ecchi",
    ["Fantasy"] = "fantasy",
    ["Gender Bender"] = "gender-bender",
    ["Harem"] = "harem",
    ["Historical"] = "historical",
    ["Horror"] = "horror",
    ["Josei"] = "josei",
    ["Magic"] = "magic",
    ["Martial Arts"] = "martial-arts",
    ["Mature"] = "mature",
    ["Mecha"] = "mecha",
    ["Military"] = "military",
    ["Mystery"] = "mystery",
    ["One Shot"] = "one-shot",
    ["Psychological"] = "psychological",
    ["Romance"] = "romance",
    ["School Life"] = "school-life",
    ["Sci-Fi"] = "sci-fi",
    ["Seinen"] = "seinen",
    ["Shoujo"] = "shoujo",
    ["Shoujoai"] = "shoujoai",
    ["Shounen"] = "shounen",
    ["Shounenai"] = "shounenai",
    ["Slice of Life"] = "slice-of-life",
    ["Smut"] = "smut",
    ["Sports"] = "sports",
    ["Super Power"] = "super-power",
    ["Supernatural"] = "supernatural",
    ["Tragedy"] = "tragedy",
    ["Vampire"] = "vampire",
    ["Yaoi"] = "yaoi",
    ["Yuri"] = "yuri",
}
MangaReader.Filters = {
    {
        Name = "Genre",
        Type = "checkcross",
        Tags = {
            "Action",
            "Adventure",
            "Comedy",
            "Demons",
            "Drama",
            "Ecchi",
            "Fantasy",
            "Gender Bender",
            "Harem",
            "Historical",
            "Horror",
            "Josei",
            "Magic",
            "Martial Arts",
            "Mature",
            "Mecha",
            "Military",
            "Mystery",
            "One Shot",
            "Psychological",
            "Romance",
            "School Life",
            "Sci-Fi",
            "Seinen",
            "Shoujo",
            "Shoujoai",
            "Shounen",
            "Shounenai",
            "Slice of Life",
            "Smut",
            "Sports",
            "Super Power",
            "Supernatural",
            "Tragedy",
            "Vampire",
            "Yaoi",
            "Yuri"
        }
    }
}

MangaReader.GenreKeys = {
    ["Action"] = 1,
    ["Adventure"] = 2,
    ["Comedy"] = 3,
    ["Demons"] = 4,
    ["Drama"] = 5,
    ["Ecchi"] = 6,
    ["Fantasy"] = 7,
    ["Gender Bender"] = 8,
    ["Harem"] = 9,
    ["Historical"] = 10,
    ["Horror"] = 11,
    ["Josei"] = 12,
    ["Magic"] = 13,
    ["Martial Arts"] = 14,
    ["Mature"] = 15,
    ["Mecha"] = 16,
    ["Military"] = 17,
    ["Mystery"] = 18,
    ["One Shot"] = 19,
    ["Psychological"] = 20,
    ["Romance"] = 21,
    ["School Life"] = 22,
    ["Sci-Fi"] = 23,
    ["Seinen"] = 24,
    ["Shoujo"] = 25,
    ["Shoujoai"] = 26,
    ["Shounen"] = 27,
    ["Shounenai"] = 28,
    ["Slice of Life"] = 29,
    ["Smut"] = 30,
    ["Sports"] = 31,
    ["Super Power"] = 32,
    ["Supernatural"] = 33,
    ["Tragedy"] = 34,
    ["Vampire"] = 35,
    ["Yaoi"] = 36,
    ["Yuri"] = 37
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

function MangaReader:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for ImageLink, Link, Name in content:gmatch('<div data%-src="//([^"]-)" class=".-href="([^"]-)">(.-)</a>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, "https://" .. ImageLink, self.ID, self.Link .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function MangaReader:getPopularManga(page, dt)
    self:getManga(self.Link .. "/popular/" .. ((page - 1) * 30), dt)
end

function MangaReader:getTagManga(page, dt, tag)
    self:getManga(self.Link .. "/popular/" .. (self.TagValues[tag] or "") .. "/" .. ((page - 1) * 30), dt)
end

function MangaReader:searchManga(search, page, dt, tags)
    local SearchLink = self.Link .. "/search/?w="..search.."&rd=0&status=0&order=0&p=" .. ((page - 1) * 30)
    if tags then
        SearchLink = SearchLink .. "&genre="
        Tags = {}
        for i = 1, #self.Filters[1].Tags do
            Tags[i] = 0
        end
        Genres = tags["Genre"]
        if Genres then
            for _, v in ipairs(Genres.include) do
                Tags[self.GenreKeys[v] or -1] = 1
            end
            for _, v in ipairs(Genres.exclude) do
                Tags[self.GenreKeys[v] or -1] = 2
            end
        end
        SearchLink = SearchLink .. table.concat(Tags)
    end
    local content = downloadContent(SearchLink):match("^(.-)Author/Artist Results") or ""
    dt.NoPages = true
    for ImageLink, Link, Name in content:gmatch('<div data%-src="//([^"]-)" class=".-href="([^"]-)">(.-)</a>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, "https://" .. ImageLink, self.ID, self.Link .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function MangaReader:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link):match('<td>Date Added</td>(.+)$') or ""
    for Link, Name, subName in content:gmatch('<i class.-<a href%="/.-(/%S-)">(.-)</a>(.-)</td>') do
        dt[#dt + 1] = {
            Name = stringify(Name .. subName),
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
end

function MangaReader:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. chapter.Manga.Link .. chapter.Link)
    for Link in content:gmatch('"u" ?: ?"([^"]-)"') do
        dt[#dt + 1] = "https:" .. Link:gsub("\\/", "/")
    end
end

function MangaReader:loadChapterPage(link, dest_table)
    dest_table.Link = link
end

MangaPanda = MangaReader:new("MangaPanda", "https://www.mangapanda.com", "ENG", "MANGAPANDAEN", 1)

MangaPanda.Filters = nil

function MangaPanda:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for ImageLink, Link, Name in content:gmatch('image:url%(\'(%S-)\'.-<div class="manga_name">.-<a href="(%S-)">(.-)</a>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function MangaPanda:searchManga(search, page, dt)
    self:getManga(self.Link .. "/search/?w=" .. search .. "&rd=&status=&order=&genre=&p=" .. ((page - 1) * 30), dt)
end

function MangaPanda:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link):match('id="chapterlist"(.+)$') or ""
    for Link, Name, subName in content:gmatch('chico_manga.-<a href%="/.-(/%S-)">(.-)</a>(.-)</td>') do
        dt[#dt + 1] = {
            Name = stringify(Name .. subName),
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
end

function MangaPanda:prepareChapter(chapter, dt)
    local count = downloadContent(self.Link .. chapter.Manga.Link .. chapter.Link .. "#"):match("</select> of (.-)<") or 0
    for i = 1, count do
        dt[i] = self.Link .. chapter.Manga.Link .. chapter.Link .. "/" .. i
    end
end

function MangaPanda:loadChapterPage(link, dest_table)
    dest_table.Link = downloadContent(link):match('id="img".-src="(.-)"')
end
