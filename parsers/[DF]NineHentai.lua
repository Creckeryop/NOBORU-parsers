NineHentai = Parser:new("NineHentai", "https://9hentai.com","DIF",5)

NineHentai.NSFW = true

NineHentai.query = [[
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

function NineHentai:getLatestManga(page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/api/getBook", file, "string", true, POST_METHOD, string.format(self.query,"",page - 1,0), JSON)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for id, title, count, link in file.string:gmatch('"id":(%d-),"title":"(.-)",.-"total_page":(.-),.-"image_server":"(.-)"') do
		local server = link:gsub("\\/","/")..id.."/"
		local manga = CreateManga(title, id, server.."cover-small.jpg", self.ID, self.Link.."/g/"..id)
		if manga then
			manga.Count = count
			manga.NineHentaiServer = server
			t[#t + 1] = manga
		end
		coroutine.yield(false)
	end
end

function NineHentai:getPopularManga(page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/api/getBook", file, "string", true, POST_METHOD, string.format(self.query,"",page - 1,1), JSON)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for id, title, count, link in file.string:gmatch('"id":(%d-),"title":"(.-)",.-"total_page":(.-),.-"image_server":"(.-)"') do
		local server = link:gsub("\\/","/")..id.."/"
		local manga = CreateManga(title, id, server.."cover-small.jpg", self.ID, self.Link.."/g/"..id)
		if manga then
			manga.Count = count
			manga.NineHentaiServer = server
			t[#t + 1] = manga
		end
		coroutine.yield(false)
	end
end

function NineHentai:searchManga(data, page, table)
	local file = {}
	Threads.DownloadStringAsync(self.Link.."/api/getBook", file, "string", true, POST_METHOD, string.format(self.query,data:gsub("%%","%*"),page - 1,0), JSON)
	while file.string == nil do
		coroutine.yield(false)
	end
	local t = table
	for id, title, count, link in file.string:gmatch('"id":(%d-),"title":"(.-)",.-"total_page":(.-),.-"image_server":"(.-)"') do
		local server = link:gsub("\\/","/")..id.."/"
		local manga = CreateManga(title, id, server.."cover-small.jpg", self.ID, self.Link.."/g/"..id)
		if manga then
			manga.Count = count
			manga.NineHentaiServer = server
			t[#t + 1] = manga
		end
		coroutine.yield(false)
	end
end

function NineHentai:getChapters(manga, table)
	table[#table + 1] = {
		Name = manga.Name,
		Link = manga.Link,
		Pages = {},
		Manga = manga
	}
end

function NineHentai:prepareChapter(chapter, table)
	local t = table
	for i = 1, chapter.Manga.Count do
		t[i] = chapter.Manga.NineHentaiServer..i..".jpg"
		Console.writeLine("Got "..t[i])
	end
end

function NineHentai:loadChapterPage(link, table)
	table.Link = link
end