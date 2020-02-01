NineHentai = Parser:new("NineHentai", "https://9hentai.com", "ENG", "NINEHENTAIEN")

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

function NineHentai:getManga(mode, page, dest_table, search)
	local file = {}
	local PostData = ""
	if mode == 0 then
		PostData = string.format(self.query, "", page - 1, 0)
	elseif mode == 1 then
		PostData = string.format(self.query, "", page - 1, 1)
	elseif mode == 2 then
		PostData = string.format(self.query, search:gsub("%%", "%*"), page - 1, 0)
	end
	Threads.insertTask(file, {
		Type = "StringRequest",
		Link = self.Link .. "/api/getBook",
		Table = file,
		Index = "string",
		HttpMethod = POST_METHOD,
		PostData = PostData,
		ContentType = JSON
	})
	while Threads.check(file) do
		coroutine.yield(false)
	end
	local content = file.string or ""
	local t = dest_table
	local done = true
	for id, title, count, link in content:gmatch('"id":(%d-),"title":"(.-)",.-"total_page":(.-),.-"image_server":"(.-)"') do
		local server = link:gsub("\\/", "/") .. id .. "/"
		local manga = CreateManga(title, id, server .. "cover-small.jpg", self.ID, self.Link .. "/g/" .. id)
		if manga then
			manga.Data.Count = count
			manga.Data.NineHentaiServer = server
			t[#t + 1] = manga
			done = false
		end
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function NineHentai:getLatestManga(page, dest_table)
	self:getManga(0, page, dest_table)
end

function NineHentai:getPopularManga(page, dest_table)
	self:getManga(1, page, dest_table)
end

function NineHentai:searchManga(search, page, dest_table)
	self:getManga(2, page, dest_table, search)
end

function NineHentai:getChapters(manga, dest_table)
	dest_table[#dest_table + 1] = {
		Name = manga.Name,
		Link = manga.Link,
		Pages = {},
		Manga = manga
	}
end

function NineHentai:prepareChapter(chapter, dest_table)
	local t = dest_table
	for i = 1, chapter.Manga.Data.Count do
		t[i] = chapter.Manga.Data.NineHentaiServer .. i .. ".jpg"
		Console.write("Got " .. t[i])
	end
end

function NineHentai:loadChapterPage(link, dest_table)
	dest_table.Link = link
end
