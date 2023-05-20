Onma = Parser:new("Onma", "https://onma.top", "ARA", "ONMAARA", 2)

Onma.Tags = {
    "أكشن",
    "مغامرة",
    "كوميدي",
    "شياطين",
    "دراما",
    "إيتشي",
    "خيال",
    "انحراف جنسي",
    "حريم",
    "تاريخي",
    "رعب",
    "جوسي",
    "فنون قتالية",
    "ناضج",
    "ميكا",
    "غموض",
    "وان شوت",
    "نفسي",
    "رومنسي",
    "حياة مدرسية",
    "خيال علمي",
    "سينين",
    "شوجو",
    "شوجو أي",
    "شونين",
    "شونين أي",
    "شريحة من الحياة",
    "رياضة",
    "خارق للطبيعة",
    "مأساة",
    "مصاصي الدماء",
    "سحر",
    "ويب تون",
    "دوجينشي"
}

Onma.TagValues = {
    ["أكشن"] = 1,
    ["مغامرة"] = 2,
    ["كوميدي"] = 3,
    ["شياطين"] = 4,
    ["دراما"] = 5,
    ["إيتشي"] = 6,
    ["خيال"] = 7,
    ["انحراف جنسي"] = 8,
    ["حريم"] = 9,
    ["تاريخي"] = 10,
    ["رعب"] = 11,
    ["جوسي"] = 12,
    ["فنون قتالية"] = 13,
    ["ناضج"] = 14,
    ["ميكا"] = 15,
    ["غموض"] = 16,
    ["وان شوت"] = 17,
    ["نفسي"] = 18,
    ["رومنسي"] = 19,
    ["حياة مدرسية"] = 20,
    ["خيال علمي"] = 21,
    ["سينين"] = 22,
    ["شوجو"] = 23,
    ["شوجو أي"] = 24,
    ["شونين"] = 25,
    ["شونين أي"] = 26,
    ["شريحة من الحياة"] = 27,
    ["رياضة"] = 28,
    ["خارق للطبيعة"] = 29,
    ["مأساة"] = 30,
    ["مصاصي الدماء"] = 31,
    ["سحر"] = 32,
    ["ويب تون"] = 35,
    ["دوجينشي"] = 36,
}


local function stringify(string)
    return string:gsub(
        "&#([^;]-);",
        function(a)
            local number = tonumber("0" .. a) or tonumber(a)
            return number and u8c(number) or "&#" .. a .. ";"
        end
    ):gsub(
        "&(.-);",
        function(a)
            return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
        end
    )
end

local function stringify2(string)
    return string:gsub(
        "\\u(....)",
        function(a)
            return u8c(tonumber("0x" .. a))
        end
    )
end

local function downloadContent(link)
    local f = {}
    Threads.insertTask(
        f,
        {
            Type = "StringRequest",
            Link = link,
            Table = f,
            Index = "text"
        }
    )
    while Threads.check(f) do
        coroutine.yield(false)
    end
    return f.text or ""
end

function Onma:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, ImageLink, Name in content:gmatch('<a href="[^"]-/manga/([^"]-)"[^>]->[^>]-src=\'([^\']-)\'[^>]*alt=\'([^\']-)\'>[^<]-</a>') do
        dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/manga/" .. Link, self.Link .. "/manga/" .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function Onma:getPopularManga(page, dt)
    self:getManga(self.Link .. "/filterList?sortBy=views&asc=false&page=" .. page, dt)
end

function Onma:getAZManga(page, dt)
    self:getManga(self.Link .. "/filterList?sortBy=name&asc=true&page=" .. page, dt)
end

function Onma:getTagManga(page, dt, tag)
    self:getManga(self.Link .. "/filterList?alpha=&cat=" .. (self.TagValues[tag] or "0") .. "&sortBy=name&asc=true&page=" .. page, dt)
end

function Onma:searchManga(search, page, dt)
    local content = downloadContent(self.Link .. "/search?query=" .. search)
    dt.NoPages = true
    for value, data in content:gmatch('{"value":"(.-)","data":"(.-)"}') do
        dt[#dt + 1] = CreateManga(stringify2(value), data, self.Link .. "/uploads/manga/" .. data .. "/cover/cover_250x350.jpg", self.ID, self.Link .. "/manga/" .. data, self.Link .. "/manga/" .. data)
        coroutine.yield(false)
    end
end

function Onma:getChapters(manga, dt)
    local content = downloadContent(self.Link .. "/manga/" .. manga.Link)
    local description = content:match('class="well">.-<p[^>]->(.-)</div>') or ""
    dt.Description = stringify(description:gsub("<.->", ""):gsub("^%s+", ""):gsub("%s+$", ""))
    local t = {}
    for Link, Name, SubName in content:gmatch('chapter%-title%-rtl">[^<]-<a href="[^"]-/manga/([^"]-)">([^<]-)</a>(.-)</h5>') do
        SubName = SubName:match("<em>([^<]-)</em>")
        t[#t + 1] = {
            Name = stringify(Name .. (SubName and (": " .. SubName) or "")),
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function Onma:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. "/manga/" .. chapter.Link)
    for Link in content:gmatch('img%-responsive"[^>]-data%-src=\' ([^\']-) \'') do
        dt[#dt + 1] = Link
    end
end

function Onma:loadChapterPage(link, dt)
    dt.Link = link
end
