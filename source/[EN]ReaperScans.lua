ReaperScans = Parser:new("Reaper Scans", "https://reaperscans.com", "ENG", "REAPERSCANSEN", 2)

ReaperScans.Disabled = true --Reason: JavaScript check

REAPERSCANS_GET_TRENDING = "/page/%s/?s&post_type=wp-manga&op&author&artist&release&adult&m_orderby=trending"
REAPERSCANS_GET_LATEST = "/page/%s/?s&post_type=wp-manga&op&author&artist&release&adult&m_orderby=latest"
REAPERSCANS_GET_SEARCH = "/page/%s/?s=%s&post_type=wp-manga"

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

function ReaperScans:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, Name, ImageLink, Genres in content:gmatch('class="row.-<a href="[^"]-/series/([^"]-)/" title="([^"]-)">.-src="([^"]-)".-Genres%s*</h5>%s*</div>(.-)</div>') do
		if Genres:find("Novel") == nil then
			dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"), self.ID, self.Link .. "/series/" .. Link .. "/")
		end
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function ReaperScans:getPopularManga(page, dt)
	self:getManga(self.Link .. REAPERSCANS_GET_TRENDING:format(page), dt)
end

function ReaperScans:getLatestManga(page, dt)
	self:getManga(self.Link .. REAPERSCANS_GET_LATEST:format(page), dt)
end

function ReaperScans:searchManga(search, page, dt)
	self:getManga(self.Link .. REAPERSCANS_GET_SEARCH:format(page, search), dt)
end

function ReaperScans:getChapters(manga, dt)
	local content = downloadContent(self.Link .. "/series/" .. manga.Link .. "/")
	local Type = content:match('Type%s*</h5>%s*</div>(.-)</div>') or ""
	if Type:find("Novel") ~= nil then
		Notifications.pushUnique("Novels not supported! Sorry :(", 800)
		return
	end
	local t = {}
	for Link, Name in content:gmatch('chapter%-link">%s*<a href=".-/([^/]-)/"[^>]->%s*<[^>]->([^<]-)</p>') do
		if Link then
			t[#t + 1] = {
				Name = Name,
				Link = Link,
				Pages = {},
				Manga = manga
			}
		end
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function ReaperScans:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/series/" .. chapter.Manga.Link .. "/" .. chapter.Link .. "/")
	for Link in content:gmatch('id="image%-[0-9]*" data%-src="%s*([^"]-)%s*"') do
		dt[#dt + 1] = Link:gsub("\\/", "/"):gsub("%%", "%%%%")
	end
end

function ReaperScans:loadChapterPage(link, dt)
	dt.Link = link
end
