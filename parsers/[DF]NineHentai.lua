NineHentai = Parser:new("NineHentai", "https://9hentai.com", "DIF", "NINEHENTAIEN", 4)

NineHentai.NSFW = true

local query = [[
	{
		"search":{
			"text":"%s",
			"page":%s,
			"sort":%s,
			"pages":{
				"range":[0,100000]
			},
			"tag":{
				"text":"",
				"type":1,
				"tags":[],
				"items":{
					"included":[],
					"excluded":[]
				}
			}
		}
	}
]]


local function stringify(string)
    return string:gsub("\\u(....)", function(a)
        local x = tonumber("0x" .. a)
        return x and u8c(x) or "\\" .. a
    end):gsub("\\", "")
end

function NineHentai:getManga(mode, page, dt, search)
    local PostData = ""
    if mode == 0 then
        PostData = string.format(query, "", page - 1, 0)
    elseif mode == 1 then
        PostData = string.format(query, "", page - 1, 1)
    elseif mode == 2 then
        PostData = string.format(query, search:gsub("%%", "%*"), page - 1, 0)
    end
    local f = {}
    Threads.insertTask(f, {
        Type = "StringRequest",
        Link = self.Link .. "/api/getBook",
        Table = f,
        Index = "text",
        HttpMethod = POST_METHOD,
        PostData = PostData,
        ContentType = JSON
    })
    while Threads.check(f) do
        coroutine.yield(false)
    end
    local content = f.text or ""
    dt.NoPages = true
    for id, title, count, link in content:gmatch('"id":(%d-),"title":"(.-)",.-"total_page":(.-),.-"image_server":"(.-)"') do
        local server = link:gsub("\\/", "/") .. id .. "/"
        local manga = CreateManga(stringify(title), id, server .. "cover-small.jpg", self.ID, self.Link .. "/g/" .. id)
        if manga then
            manga.Data.Count = count
            manga.Data.NineHentaiServer = server
            dt[#dt + 1] = manga
        end
        dt.NoPages = false
        coroutine.yield(false)
    end
end

function NineHentai:getLatestManga(page, dt)
    self:getManga(0, page, dt)
end

function NineHentai:getPopularManga(page, dt)
    self:getManga(1, page, dt)
end

function NineHentai:searchManga(search, page, dt)
    self:getManga(2, page, dt, search)
end

function NineHentai:getChapters(manga, dt)
    dt[#dt + 1] = {
        Name = "Read chapter",
        Link = manga.Link,
        Pages = {},
        Manga = manga
    }
end

function NineHentai:prepareChapter(chapter, dt)
    for i = 1, chapter.Manga.Data.Count do
        dt[i] = chapter.Manga.Data.NineHentaiServer .. i .. ".jpg"
        Console.write("Got " .. dt[i])
    end
end

function NineHentai:loadChapterPage(link, dt)
    dt.Link = link
end
