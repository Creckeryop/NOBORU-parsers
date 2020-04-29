NudeMoon = Parser:new("Nude-Moon", "https://nude-moon.net", "RUS", "NUDEMOONRU", 2)

NudeMoon.NSFW = true

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

function NudeMoon:getManga(link, dt)
    local content = downloadContent(link)
    dt.NoPages = true
    for Link, Name, ImageLink in content:gmatch('<td colspan.-<a href="(.-)".-title="(.-)".-src="(.-)"') do
        dt[#dt + 1] = CreateManga(stringify(AnsiToUtf8(Name)), Link, ImageLink:find("^https") and ImageLink or (self.Link .. ImageLink), self.ID, self.Link .. Link)
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function NudeMoon:getLatestManga(page, dt)
    self:getManga(self.Link .. "/all_manga?rowstart=" .. ((page - 1) * 30), dt)
end

function NudeMoon:getPopularManga(page, dt)
    self:getManga(self.Link .. "/all_manga?views&rowstart=" .. ((page - 1) * 30), dt)
end

function NudeMoon:searchManga(data, page, dt)
    local stext = {}
    for c in it_utf8(data) do
        if utf8ascii[c] then
            stext[#stext + 1] = utf8ascii[c]
        else
            stext[#stext + 1] = c
        end
    end
    stext = table.concat(stext)
    self:getManga(self.Link .. "/search?stext=" .. stext .. "&rowstart=" .. ((page - 1) * 30), dt)
end

function NudeMoon:getChapters(manga, dt)
    local content = downloadContent(self.Link .. manga.Link)
    local link = content:match('"(/vse_glavy/[^"]-)"')
    if link then
        local t = {}
        self:getManga(self.Link .. link, t)
        for i = #t, 1, -1 do
            local m = t[i]
            dt[#dt + 1] = {
                Name = stringify(m.Name),
                Link = m.Link:gsub("^(/%d*)", "%1-online"),
                Pages = {},
                Manga = manga
            }
        end
    else
        dt[#dt + 1] = {
            Name = stringify(manga.Name),
            Link = manga.Link:gsub("^(/%d*)", "%1-online"),
            Pages = {},
            Manga = manga
        }
    end
end

function NudeMoon:prepareChapter(chapter, dt)
    local content = downloadContent(self.Link .. chapter.Link .. "?page=1")
    for link in content:gmatch("images%[%d-%].src = '(.-)';") do
        if link:find("^https") then
            dt[#dt + 1] = link
        else
            dt[#dt + 1] = self.Link .. link
        end
        Console.write("Got " .. dt[#dt])
    end
end

function NudeMoon:loadChapterPage(link, dt)
    dt.Link = link
end
