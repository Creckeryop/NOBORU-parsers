--[[
	Links structure
	https://raw.senmanga.com/Kingdom 		=>	Manga.Link = Kingdom
	https://raw.senmanga.com/Kingdom/VOLUME_28 	=>	Chapter.Link = VOLUME_28
--]]

SenManga = Parser:new("SenManga", "https://raw.senmanga.com", "JAP", "SENGMANGAJAP", 3)

SenManga.Filters = {
	{
		Name = "Status",
		Type = "radio",
		Tags = {
			"All",
			"Ongoing",
			"Completed"
		},
		Default = "All"
	},
	{
		Name = "Type",
		Type = "radio",
		Tags = {
			"All",
			"Manga",
			"Manhwa",
			"Manhua",
			"Novel"
		},
		Default = "All"
	},
	{
		Name = "Order by",
		Type = "radio",
		Tags = {
			"A-Z",
			"Z-A",
			"Latest Update",
			"Latest Added",
			"Popular"
		}
	},
	{
		Name = "Genre",
		Type = "check",
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
	}
}

SenManga.Orders = {
	["A-Z"] = "titleasc",
	["Z-A"] = "titlereverse",
	["Latest Update"] = "update",
	["Latest Added"] = "latest",
	["Popular"] = "popular",
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

function SenManga:getManga(link, dt, page, search)
	local content = downloadContent(link)
	local class = search and "series" or "border%-light"
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('class="item">.-href="[^"]-/([^/"]-)">.-src="([^"]-)".-series%-title">(.-)</div>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link.."/"..Link)
		coroutine.yield(false)
		dt.NoPages = false
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
	local status = ""
	local order = ""
	local type = ""
	if tags then
		order = self.Orders[tags["Order by"]] == "All" and "" or self.Orders[tags["Order by"]]
		for _, v in ipairs(tags["Genre"]) do
			include = include .. "&genre%%5B%%5D=" .. v:gsub(" ", "+")
		end
		status = tags["Status"] == "All" and "" or tags["Status"]
		type = tags["Type"] == "All" and "" or tags["Type"]
	end
	self:getManga(self.Link .. "/search?s=" .. search .. "&author=&artist=" .. include .. "&status=" .. status .. "&released=&type="..type.."&page=" .. page .. "&order=" .. order, dt, page, true)
end

function SenManga:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/" .. manga.Link)
	local description = (content:match('<div class="summary">(.-)</div>') or ""):gsub("<br>","\n"):gsub("<.->",""):gsub("\n+","\n"):gsub("^%s+",""):gsub("%s+$","")
	dt.Description = stringify(description)
	local t = {}
	for Link, Name in content:gmatch('<li class="">.-href="[^"]-/([^/"]-)" class="series">%s*(.-)%s*</a>') do
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

function SenManga:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/" .. chapter.Manga.Link .. "/" .. chapter.Link)
	for i = 1, tonumber(content:match("</select> of (%d*)") or 0) do
		dt[#dt + 1] = self.Link .. "/viewer/" .. chapter.Manga.Link .. "/"  .. chapter.Link .. "/" .. i
	end
end

function SenManga:loadChapterPage(link, dt)
	dt.Link = link
end
