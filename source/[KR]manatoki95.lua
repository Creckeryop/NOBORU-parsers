Manatoki95 = Parser:new("마나토끼", "https://manatoki95.net", "KOR", "MANATOKI95KR", 2)

Manatoki95.Filters = {
	{
		Name = "장르",
		Type = "check",
		Tags = {
			"17",
			"BL",
			"SF",
			"TS",
			"개그",
			"게임",
			"도박",
			"드라마",
			"라노벨",
			"러브코미디",
			"먹방",
			"백합",
			"붕탁",
			"순정",
			"스릴러",
			"스포츠",
			"시대",
			"애니화",
			"액션",
			"음악",
			"이세계",
			"일상",
			"전생",
			"추리",
			"판타지",
			"학원",
			"호러"
		}
	},
	{
		Name = "정렬",
		Type = "radio",
		Tags = {
			"기본",
			"인기순",
			"추천순",
			"댓글순",
			"북마크순",
			"Update"
		}
	}
}

local SortingsKeys = {
	["기본"] = "",
	["인기순"] = "as_view",
	["추천순"] = "as_good",
	["댓글순"] = "as_comment",
	["북마크순"] = "as_bookmark",
	["Update"] = "as_update"
}

local search_url = "/comic/p%s?publish=&jaum=&tag=%s&sst=%s&sod=desc&stx=%s&artist="

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

function Manatoki95:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('img%-item">.-href="[^"]-comic/(.-)?[^"]-">[^<]-<img src="(.-)".-title white">(.-)</span>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. "/comic/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function Manatoki95:getLatestManga(page, dt)
	self:getManga(self.Link .. "/comic/p" .. page .. "?sst=as_update&sod=desc", dt)
end

function Manatoki95:getPopularManga(page, dt)
	self:getManga(self.Link .. "/comic/p" .. page .. "?sst=as_view&sod=desc", dt)
end

function Manatoki95:searchManga(search, page, dt, tags)
	local str = search_url
	if tags then
		local genres = tags["장르"]
		local sorting = tags["정렬"]
		local gnr_str = ""
		local srt_str = ""
		if genres and #genres > 0 then
			gnr_str = table.concat(genres, "%%2C")
		end
		if SortingsKeys[sorting] then
			srt_str = SortingsKeys[sorting]
		end
		str = str:format(page, gnr_str, srt_str, search)
	else
		str = str:format(page, "", "", search)
	end
	self:getManga(self.Link .. str, dt)
end

function Manatoki95:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/comic/" .. manga.Link)
	local t = {}
	for Link, Name in content:gmatch('list%-item.-href="[^"]-comic/(.-)?[^"]-".-</span>%s*(.-)%s*<span') do
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

function Manatoki95:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/comic/" .. chapter.Link .. "?spage=1")
	local str = ""
	for text in content:gmatch('html_data%+=\'(.-)\';') do
		str = str..text
	end
	str = str:gsub("(.-)%.",function(a) return string.char(tonumber("0x"..a)) end)
	for Link in str:gmatch('%.gif" data%-[^=]-="([^"]-)"') do
		dt[#dt + 1] = Link
	end
end

function Manatoki95:loadChapterPage(link, dt)
	dt.Link = link
end