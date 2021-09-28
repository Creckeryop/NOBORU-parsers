--[[
	Links structure
	https://mangafast.org/read/the-making-of-a-princess 		=>	Manga.Link = the-making-of-a-princess
	https://mangafast.org/the-making-of-a-princess-chapter-46 	=>	Chapter.Link = the-making-of-a-princess-chapter-46
--]]

Mangafast = Parser:new("Mangafast", "https://mangafast.org", "ENG", "MANGAFAST", 2)

local API_search = 'https://search.mangafast.net/comics/ms'

Mangafast.Tags = {"Manga", "Manhua", "Manhwa"}
Mangafast.TagValues = {
    ["Manga"] = "manga",
    ["Manhua"] = "manhua",
    ["Manhwa"] = "manhwa"
}

local function stringify(string)
	if u8c then
		return string:gsub(
			"&#([^;]-);",
			function(a)
				local number = tonumber("0" .. a) or tonumber(a)
				return number and u8c(number) or "&#" .. a .. ";"
			end
		):gsub(
			"&([^;]-);",
			function(a)
				return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
			end
		)
	else
		return string
	end
end

local function downloadContent(link)
	local file = {}
	Threads.insertTask(
		file,
		{
			Type = "StringRequest",
			Link = link,
			Table = file,
			Index = "string"
		}
	)
	while Threads.check(file) do
		coroutine.yield(false)
	end
	return file.string or ""
end

function Mangafast:getTagManga(page, dt, tag)
	local content = downloadContent(self.Link .. "/list-manga?cat=" .. self.TagValues[tag] .. (page == 1 and "" or ("/" .. page)))
	for Link, ImageLink, Name in content:gmatch('"ranking1">.-href="/read/([^"]-)".-data%-src="([^"]-)".-<h4>%s*([^<]-)%s*</h4>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/read/" .. Link)
		coroutine.yield(false)
	end
	dt.NoPages = true
end

function Mangafast:getLatestManga(_, dt)
	local content = downloadContent(self.Link.."/read")
    for Link, ImageLink, Name in content:gmatch('"ls5">.-href="/read/([^"]-)".-data%-src="([^"]-)".-<h3>%s*([^<]-)%s*</h3>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/read/" .. Link)
		coroutine.yield(false)
	end
	dt.NoPages = true
end

function Mangafast:searchManga(search, _, dt)
	local content = downloadContent({
        Link = API_search,
        HttpMethod = POST_METHOD,
        PostData = '{"q":"'..search..'","limit":6}',
        ContentType = JSON,
        Header1 = 'mangafast:mangafast'
    })
    for Name, Link, ImageLink in content:gmatch('"title":"([^"]-)","slug":"([^"]-)"[^}]-"thumbnail":"([^"]-)"') do
		dt[#dt + 1] = CreateManga(stringify(Name):gsub("^%l", string.upper), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/read/" .. Link)
		coroutine.yield(false)
	end
	dt.NoPages = true
end

function Mangafast:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/read/" .. manga.Link)
    local t = {}
    --dt.Description = stringify((content:match("class=\"desc\">%s*(.-)%s*</p>") or ""):gsub("<br>","\n"):gsub("<[^>]->","")):gsub("^%l", string.upper):gsub("%.%s*%l", string.upper)
	for Link, Name in content:gmatch('"jds">.-href="/([^"]-)"[^>]->%s*(.-)%s*</a>') do
        t[#t + 1] = {
            Name = stringify(Name:gsub("<[^>]->","")),
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dt[#dt + 1] = t[i]
    end
end

function Mangafast:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/" .. chapter.Link)
    for link in content:gmatch('<img[^<]-loading="lazy"[^<]-data%-src="([^"]-)"') do
		dt[#dt + 1] = {
            Link = link:gsub("\\/", "/"):gsub("%%", "%%%%"),
            Header1 = "Referer:"..self.Link .. "/"
        }
	end
end

function Mangafast:loadChapterPage(link, dt)
	dt.Link = link
end
