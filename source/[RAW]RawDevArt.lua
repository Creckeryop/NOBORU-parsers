RawDevArt = Parser:new("RawDevArt", "https://rawdevart.com", "RAW", "RAWDEVARTJP", 3)

RawDevArt.Filters = {
    {
        Name = "Types",
        Type = "checkcross",
        Tags = {
            "Manga",
            "Webtoon - Korean",
            "Webtoon - Chinese",
            "Webtoon - Japanese",
            "Manhwa - Korean",
            "Manhua - Chinese",
            "Comic",
            "Doujinshi"
        }
    },
    {
        Name = "Status",
        Type = "checkcross",
        Tags = {
            "Ongoing",
            "Haitus",
            "Axed",
            "Unknown",
            "Finished"
        }
    },
    {
        Name = "Genre",
        Type = "checkcross",
        Tags = {
            "4-koma",
            "Action",
            "Adult",
            "Adventure",
            "Comedy",
            "Cooking",
            "Crime",
            "Drama",
            "Ecchi",
            "Fantasy",
            "Gender Bender",
            "Gore",
            "Harem",
            "Historical",
            "Horror",
            "Isekai",
            "Josei",
            "Lolicon",
            "Martial Arts",
            "Mature",
            "Mecha",
            "Medical",
            "Music",
            "Mystery",
            "Philosophical",
            "Psychological",
            "Romance",
            "School Life",
            "Sci-Fi",
            "Seinen",
            "Shotacon",
            "Shoujo",
            "Shoujo Ai",
            "Shounen",
            "Shounen Ai",
            "Slice of Life",
            "Smut",
            "Sports",
            "Supernatural",
            "Super Powers",
            "Thriller",
            "Tragedy",
            "Wuxia",
            "Yaoi",
            "Yuri"
        }
    }
}

RawDevArt.Keys = {
    ["Manga"] = "0",
    ["Webtoon - Korean"] = "1",
    ["Webtoon - Chinese"] = "6",
    ["Webtoon - Japanese"] = "7",
    ["Manhwa - Korean"] = "2",
    ["Manhua - Chinese"] = "3",
    ["Comic"] = "4",
    ["Doujinshi"] = "5",
    ["Ongoing"] = "0",
    ["Haitus"] = "1",
    ["Axed"] = "2",
    ["Unknown"] = "3",
    ["Finished"] = "4",
    ["4-koma"] = "29",
    ["Action"] = "1",
    ["Adult"] = "37",
    ["Adventure"] = "2",
    ["Comedy"] = "3",
    ["Cooking"] = "33",
    ["Crime"] = "4",
    ["Drama"] = "5",
    ["Ecchi"] = "30",
    ["Fantasy"] = "6",
    ["Gender Bender"] = "34",
    ["Gore"] = "31",
    ["Harem"] = "39",
    ["Historical"] = "7",
    ["Horror"] = "8",
    ["Isekai"] = "9",
    ["Josei"] = "42",
    ["Lolicon"] = "48",
    ["Martial Arts"] = "35",
    ["Mature"] = "36",
    ["Mecha"] = "10",
    ["Medical"] = "11",
    ["Music"] = "38",
    ["Mystery"] = "12",
    ["Philosophical"] = "13",
    ["Psychological"] = "14",
    ["Romance"] = "15",
    ["School Life"] = "40",
    ["Sci-Fi"] = "16",
    ["Seinen"] = "41",
    ["Shotacon"] = "49",
    ["Shoujo"] = "28",
    ["Shoujo Ai"] = "17",
    ["Shounen"] = "27",
    ["Shounen Ai"] = "18",
    ["Slice of Life"] = "19",
    ["Smut"] = "32",
    ["Sports"] = "20",
    ["Supernatural"] = "43",
    ["Super Powers"] = "21",
    ["Thriller"] = "22",
    ["Tragedy"] = "23",
    ["Wuxia"] = "24",
    ["Yaoi"] = "25",
    ["Yuri"] = "26"
}
---NSFW variable, if parser SFW you can skip this line
RawDevArt.NSFW = false

---@param string string
---@return string
---Transfers string with unicode codes to string with unicode chars (for parser use)
local function stringify(string)
    return string:gsub("&#([^;]-);", function(a)
        local number = tonumber("0" .. a) or tonumber(a)
        return number and u8c(number) or "&#" .. a .. ";"
    end):gsub("&(.-);", function(a) return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";" end)
end

---@param link string
---@return string
---Function to download content from link, gives content (for parser use)
local function downloadContent(link)
    local file = {}
    Threads.insertTask(file, {
        Type = "StringRequest",
        Link = link, --Link to the site
        Table = file, --table where StringRequest will save data
        Index = "string" --index of table where StringRequest should write data
    --- HttpMethod = --GET_METHOD|POST_METHOD|HEAD_METHOD|OPTIONS_METHOD|PUT_METHOD|DELETE_METHOD|TRACE_METHOD|CONNECT_METHOD
    --- PostData = "" --Some post data that you need
    --- ContentType = --XWWW(default) | JSON
    --- Cookie = "" --Cookie string
    --- Header1 = "" --Header slot 1 of 4
    --- Header2 = "" --Header slot 2 of 4
    --- Header3 = "" --Header slot 3 of 4
    --- Header4 = "" --Header slot 4 of 4
    --- That is okay if not all of commented table vars will be defined
    })
    
    ---In two words: While downloading, update app `file` is the table where StringRequest writes data
    while Threads.check(file) do
        coroutine.yield(false)
    end
    ---Return string shouldn't be nil or it will be unsafe
    return file.string or ""
end

---@param link string
---@param page integer
---@param dest_table table
---Gets manga from given link and page
---(this function isn't important, it's needed for parser to simplify code not for App) (for parser use)
function RawDevArt:getManga(link, page, dest_table)
    ---Downloading page where table of manga can be founded
    local content = downloadContent(link .. "&page=" .. page)
    ---Parsing page for `ImageLink`, `Name`, `Link`
    for ImageLink, Name, Link in content:gmatch('hovereffect.-img%-fluid" src="(%S-)".-d%-block">\n(.-)\n.-href="(%S-)"') do
        if not ImageLink:find("^http") then
            ImageLink = self.Link .. ImageLink
        end
        ---CreateManga(Name(string), Link(ID|LINK|UNIQUEKEY|HALFLINK), ImageLink("https://.../...(jpg/png/bmp)"(if no format on the end, but this link will download image, it will also works)), ParserID, (RawLink) string that written under Title in Selected Manga Menu)
        ---Gives Manga table or nil (if something not defined (excluding RawLink))
        dest_table[#dest_table + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. Link)
        ---We need to update app, or it will be very laggy while getting manga
        coroutine.yield(false)
    end
    ---You need to come up how to make t.NoPage equal true if page is latest or app will be always updating manga list
    local pages = tonumber(content:match(" of (%d+) Pages"))
    if pages then
        dest_table.NoPages = pages == page
    else
        dest_table.NoPages = true
    end
end

---SHOULD BE DEFINED, or it will give error if there only getLatest supported, use this function to give Latest
function RawDevArt:getPopularManga(page, dest_table)
    self:getManga(self.Link .. "/comic/?lister=5", page, dest_table)
end

---You could skip this function if your Parser doesn't have ability to get Latest manga
function RawDevArt:getLatestManga(page, dest_table)
    self:getManga(self.Link .. "/comic/?lister=0", page, dest_table)
end

---@param search string
---@param page integer
---@param dest_table table
---Function to searchManga `search` variable already consist of %20, + and other chars
---But if site doesn't support widechars like `Фывйцучя`, and you want to translate them to % chars, translate them by yourself
function RawDevArt:searchManga(search, page, dest_table, tags)
    local query = ""
    if tags then
        for k, f in ipairs({tags[1], tags[2], tags[3]}) do
            local str = ""
            if k == 1 then
                str = "ctype"
            elseif k == 2 then
                str = "status"
            elseif k == 3 then
                str = "genre"
            end
            if #f.exclude > 0 then
                query = query .. "&" .. str .. "_exc="
                local types = {}
                for p, t in ipairs(f.exclude) do
                    types[#types + 1] = self.Keys[t]
                end
                query = query .. table.concat(types, ",")
            end
            if #f.include > 0 then
                query = query .. "&" .. str .. "_inc="
                local types = {}
                for p, t in ipairs(f.include) do
                    types[#types + 1] = self.Keys[t]
                end
                query = query .. table.concat(types, ",")
            end
        end
    end
    self:getManga(self.Link .. "/search/?title=" .. search..query, page, dest_table)
end

---Function that gives all chapters in manga
---You should add them in dest_table in 1->N order
---dest_table[#dest_table + 1] = {Pages = {}, Manga = manga, Name = "Name", Link = "ID|LINK|UNIQUEKEY|HALFLINK"}
function RawDevArt:getChapters(manga, dest_table)
    ---You can see that i concatinate self.Link with manga.Link, because manga.Link is HALFLINK in this way
    local page = 1
    local t = {}
    while true do
        local content = downloadContent(self.Link .. manga.Link.."?page="..page)
        ---Parsing chapters from manga link
        for Link, Name in content:gmatch('rounded%-0".-<a href="(/comic/%S-)".-text%-truncate">(.-)</span>') do
            t[#t + 1] = {
                Name = stringify(Name),
                Link = Link,
                Pages = {},     --Should be defined
                Manga = manga   --Should be defined
            }
        end
        local last_page = content:match("of (%d+) Pages")
        if not last_page or last_page == tostring(page) then
            break
        else
            page = page + 1
        end
    end
    table.reverse(t) --to make 1->N order
    for k, v in pairs(t) do
        dest_table[k] = v
    end
end

---This function is needed to get all chapter pages or all chapter images
function RawDevArt:prepareChapter(chapter, dest_table)
    local content = downloadContent(self.Link .. chapter.Link)
    ---Parsing page image links
    for link in content:gmatch('not%-lazy"[^>]-data%-src="([^"]-)"') do
        dest_table[#dest_table + 1] = link
    end
end

---This function is needed to get link to image
---If this link is already https://.../...(jpg/png/bmp) link you can do it like this
function RawDevArt:loadChapterPage(link, dest_table)
    dest_table.Link = link
    --If link accessible only with cookies or someting, you can write like this:
    --dest_table.Link = {Link = link, Cookie = "age=18", Header1 = "X-Requested-With: XMLHttpRequest"}
end

---If its not, you can make smth like this
--[[
function ParserName:loadChapterPage(link, dest_table)
    local content = downloadContent(link)
    dest_table.Link = content:match("<img src="(%S-)")
end
]]

