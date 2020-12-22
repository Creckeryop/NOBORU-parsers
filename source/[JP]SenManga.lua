SenManga = Parser:new("SenManga", "https://raw.senmanga.com", "JAP", "SENGMANGAJAP", 1)

SenManga.Filters = {
    {
        Name = "Sort By",
        Type = "radio",
        Tags = {
            "Title",
            "Total Views",
            "Rank",
            "Last Update"
        }
    },
    {
        Name = "Genre",
        Type = "checkcross",
        Tags = {
            "Action",
            "Adult",
            "Adventure",
            "Comedy",
            "Cooking",
            "Drama",
            "Ecchi",
            "Fantasy",
            "Gender Bender",
            "Harem",
            "Historical",
            "Horror",
            "Josei",
            "Light Novel",
            "Magazine",
            "Martial Arts",
            "Mature",
            "Music",
            "Mystery",
            "Psychological",
            "Romance",
            "School Life",
            "Sci-Fi",
            "Seinen",
            "Shoujo",
            "Shoujo Ai",
            "Shounen",
            "Shounen Ai",
            "Slice of Life",
            "Smut",
            "Sports",
            "Supernatural",
            "Tragedy",
            "Webtoons",
            "Yaoi",
            "Yuri"
        }
    },
    {
        Name = "Completed",
        Type = "radio",
        Tags = {
            "Yes",
            "No"
        },
        Default = "No"
    }
}

SenManga.Sorts = {
    ["Title"] = "title",
    ["Total Views"] = "total_views",
    ["Rank"] = "rank",
    ["Last Update"] = "last_update"
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

function SenManga:getManga(link, dt, page, search)
    local content = downloadContent(link)
    local class = search and "series" or "border%-light"
    
    for Link, ImageLink, Name in content:gmatch(class .. '">.-href="(%S-)".-src="(%S-)" alt="([^"]-)"') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link:match(self.Link .. "/(.*)$"), ImageLink:gsub("%%", "%%%%"), self.ID, Link)
        coroutine.yield(false)
    end
    
    if page == tonumber(content:match('^.*page=(%d*)">.-$') or 1) then
        dt.NoPages = true
    end
end

function SenManga:getPopularManga(page, dt)
    self:getManga(self.Link .. "/directory/popular?page=" .. page, dt, page)
end

function SenManga:getLatestManga(page, dt)
    self:getManga(self.Link .. "/directory/last_update?page=" .. page, dt, page)
end

function SenManga:searchManga(search, page, dt, tags)
    local include = ""
    local exclude = ""
    local completed = 0
    local sort = "title"
    if tags then
        sort = self.Sorts[tags["Sort By"]]
        include = table.concat(tags["Genre"].include, "%%2C"):gsub(" ", "+")
        exclude = table.concat(tags["Genre"].exclude, "%%2C"):gsub(" ", "+")
        completed = tags["Completed"] == "Yes" and 1 or 0
    end
    self:getManga(self.Link .. "/search?s=" .. search .. "&author=&artist=&genre=" .. include .. "&nogenre=" .. exclude .. "&completed=" .. completed .. "&released=&page=" .. page .. "&sort=" .. sort, dt, page, true)
end

function SenManga:getChapters(manga, dt)
    local content = downloadContent(self.Link .. "/" .. manga.Link)
    local t = {}
    for Link, Name in content:gmatch('class="element">[^>]-class="title">[^<]-<a href="(%S-)">[\n%s]*(.-)[\n%s]*</a>') do
        t[#t + 1] = {
            Name = stringify(Name),
            Link = Link:match(self.Link .. "/(.*)"),
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function SenManga:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/" .. chapter.Link)
    for i = 1, tonumber(content:match(" of (%d*)") or 0) do
        dt[#dt + 1] = self.Link .. "/viewer/" .. chapter.Link .. "/" .. i
    end
end

function SenManga:loadChapterPage(link, dt)
    dt.Link = link
end
