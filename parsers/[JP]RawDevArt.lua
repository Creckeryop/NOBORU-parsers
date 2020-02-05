RawDevArt = Parser:new("RawDevArt", "https://rawdevart.com", "JAP", "RAWDEVARTJP")

---NSFW variable, if parser SFW you can skip this line
RawDevArt.NSFW = nil

local notify = false

---@param string string
---@return string
---Transfers string with unicode codes to string with unicode chars (for parser use)
local function stringify(string)
    if not u8c then
        if not notify then
            Notifications.push("Please update app, to see fixed titles")
            notify = true
        end
        return string
    end
    return string:gsub("&#([^;]-);", function(a)
        local number = tonumber("0" .. a) or tonumber(a)
        return number and u8c(number) or "&#" .. a .. ";"
    end)
end

---@param link string
---@return string
---Function to download content from link, gives content (for parser use)
local function downloadContent(link)
    local file = {}
    Threads.insertTask(file, {
        Type = "StringRequest",
        Link = link,    --Link to the site
        Table = file,   --table where StringRequest will save data
        Index = "string"--index of table where StringRequest should write data
    --- HttpMethod = --GET_METHOD|POST_METHOD|HEAD_METHOD|OPTIONS_METHOD|PUT_METHOD|DELETE_METHOD|TRACE_METHOD|CONNECT_METHOD
    --- PostData = "" --Some post data that you need
    --- ContentType = --XWWW(default) | JSON
    --- Cookie = "" --Cookie string
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
    local t = dest_table
    ---Parsing page for `ImageLink`, `Name`, `Link`
    for ImageLink, Name, Link in content:gmatch('hovereffect.-img%-fluid" src="(%S-)".-d%-block">\n(.-)\n.-href="(%S-)"') do
        if not ImageLink:find("^http") then
            ImageLink = self.Link .. ImageLink
        end
        ---CreateManga(Name(string), Link(ID|LINK|UNIQUEKEY|HALFLINK), ImageLink("https://.../...(jpg/png/bmp)"(if no format on the end, but this link will download image, it will also works)), ParserID, (RawLink) string that written under Title in Selected Manga Menu)
        ---Gives Manga table or nil (if something not defined (excluding RawLink))
        t[#t + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. Link)
        ---We need to update app, or it will be very laggy while getting manga
        coroutine.yield(false)
    end
    ---You need to come up how to make t.NoPage equal true if page is latest or app will be always updating manga list
    local pages = tonumber(content:match(" of (%d+) Pages"))
    if pages then
        t.NoPages = pages == page
    else
        t.NoPages = true
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
function RawDevArt:searchManga(search, page, dest_table)
    self:getManga(self.Link .. "/search/?title=" .. search, page, dest_table)
end

--[[
---if your parser don't support search you should write this
if not u8c then
    function ParserName:searchManga(search, page, dest_table)
        Notifications.push("Parser don't support search feature")
        Notifications.push("Please update App")
    end
end
]]

---Function that gives all chapters in manga
---You should add them in dest_table in 1->N order
---dest_table[#dest_table + 1] = {Pages = {}, Manga = manga, Name = "Name", Link = "ID|LINK|UNIQUEKEY|HALFLINK"}
function RawDevArt:getChapters(manga, dest_table)
    ---You can see that i concatinate self.Link with manga.Link, because manga.Link is HALFLINK in this way
    local content = downloadContent(self.Link .. manga.Link)
    local t = dest_table
    ---Parsing chapters from manga link
    for Link, Name in content:gmatch('rounded%-0".-<a href="(/comic/%S-)".-text%-truncate">(.-)</span>') do
        t[#t + 1] = {
            Name = stringify(Name),
            Link = Link,
            Pages = {},     --Should be defined
            Manga = manga   --Should be defined
        }
    end
    table.reverse(t) --to make 1->N order
end

---This function is needed to get all chapter pages or all chapter images
function RawDevArt:prepareChapter(chapter, dest_table)
    local content = downloadContent(self.Link .. chapter.Link)
    local t = dest_table
    ---Parsing page image links
    local pages = content:match("const pages = %[([^%]]-)%]") or ""
    for link in pages:gmatch('"(%S-)"') do
        t[#t + 1] = link
    end
end

---This function is needed to get link to image
---If this link is already https://.../...(jpg/png/bmp) link you can do it like this
function RawDevArt:loadChapterPage(link, dest_table)
    dest_table.Link = link
end

---If its not, you can make smth like this
--[[
function ParserName:loadChapterPage(link, dest_table)
    local content = downloadContent(link)
    dest_table.Link = content:match("<img src="(%S-)")
end
]]
