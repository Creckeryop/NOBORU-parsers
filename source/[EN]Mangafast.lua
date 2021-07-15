Mangafast = Parser:new("Mangafast", "https://mangafast.net", "ENG", "MANGAFAST", 1)

local API_search = 'https://search.mangafast.net/comics/ms'

Mangafast.Tags = {"Manga", "Manhua", "Manhwa"}
Mangafast.TagValues = {
    ["Manga"] = "list-manga",
    ["Manhua"] = "list-manhua",
    ["Manhwa"] = "list-manhwa"
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

function Mangafast:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
    for Link, Name, ImageLink in content:gmatch('class=\'ls4v\'>.-<a href=[\'"]/read/(%S-)[\'"][^>]-title="([^"]-)".-src=\'([^\']-)\'') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/read/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function Mangafast:getTagManga(page, dt, tag)
	self:getManga(self.Link .. "/" .. self.TagValues[tag] .. (page == 1 and "" or ("/" .. page)), dt)
end

function Mangafast:getLatestManga(_, dt)
	self:getManga(self.Link, dt)
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
    dt.Description = stringify(content:match("class=\"desc\">%s*(.-)%s*</p>"):gsub("<br>","\n"):gsub("<[^>]->","")):gsub("^%l", string.upper):gsub("%.%s*%l", string.upper)
    for Link, Name in content:gmatch('chapter%-link".-href="/([^"]-)".-left">%s*(.-)%s*</span>') do
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

function Mangafast:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/" .. chapter.Link)
    for link in content:gmatch('img loading="lazy" [^>]-Page %d*" src="(%S+)"') do
		dt[#dt + 1] = {
            Link = link:gsub("\\/", "/"):gsub("%%", "%%%%"),
            Header1 = "Referer:"..self.Link .. "/"
        }
	end
end

function Mangafast:loadChapterPage(link, dt)
	dt.Link = link
end
