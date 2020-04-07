Puzzmos = Parser:new("Puzzmos", "https://www.puzzmos.com", "TUR", "PUZZMOSTUR", 1)

local function downloadContent(link)
    local file = {}
    Threads.insertTask(file, {
        Type = "StringRequest",
        Link = link,
        Table = file,
        Index = "string"
    })
    while Threads.check(file) do
        coroutine.yield(false)
    end
    return file.string or ""
end

local notify = false

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

local function stringify2(string)
    if not u8c then
        if not notify then
            Notifications.push("Please update app, to see fixed titles")
            notify = true
        end
        return string
    end
    return string:gsub("\\u(....)",function(a) return u8c(tonumber(string.format("0x%s",a))) end)
end

function Puzzmos:getManga(link, dest_table)
    local content = downloadContent(link)
    local t = dest_table
    local done = true
	for Link, ImageLink, Name in content:gmatch("<a href=\"([^\"]-)\" class=\"thumbnail\">[^>]-src='([^']-)' alt='([^']-)'>[^<]-</a>") do
		local manga = CreateManga(stringify(Name), Link:gsub("%%","%%%%"), ImageLink:gsub(" ","%%20"):gsub("%%","%%%%"), self.ID, Link)
		if manga then
			t[#t + 1] = manga
			done = false
		end
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function Puzzmos:getPopularManga(page, dest_table)
    self:getManga(self.Link.."/filterList?sortBy=views&asc=false&page="..page, dest_table)
end

function Puzzmos:getLatestManga(page, dest_table)
    local content = downloadContent(self.Link.."/latest-release?page="..page, dest_table)
    local t = dest_table
    local done = true
    for Link, Name in content:gmatch('"manga%-item">.-href="(%S-)">([^<]-)</a>') do
        local l = Link:match("/([^/]-)$") or ""
		local manga = CreateManga(stringify(Name), self.Link.."/manga/"..l:gsub(" ","%%20"):gsub("%%","%%%%"), self.Link.."//uploads/manga/"..l:gsub("%%","%%%%").."/cover/cover_250x350.jpg", self.ID, Link)
		if manga then
			t[#t + 1] = manga
			done = false
		end
		coroutine.yield(false)
	end
	if done then
		t.NoPages = true
	end
end

function Puzzmos:searchManga(search, page, dest_table)
    local old_gsub = string.gsub
    string.gsub = function(self, one, sec)
        return old_gsub(self, sec, one)
    end
    search = search:gsub("!", "%%%%21"):gsub("#", "%%%%23"):gsub("%$", "%%%%24"):gsub("&", "%%%%26"):gsub("'", "%%%%27"):gsub("%(", "%%%%28"):gsub("%)", "%%%%29"):gsub("%*", "%%%%2A"):gsub("%+", "%%%%2B"):gsub(",", "%%%%2C"):gsub("%.", "%%%%2E"):gsub("/", "%%%%2F"):gsub(" ", "%+"):gsub("%%", "%%%%25")
    Console.write(search)
    string.gsub = old_gsub
    local searchLink = self.Link.."/search?query="..search
    local content = downloadContent(searchLink)
    local t = dest_table
    for Name, Link in content:gmatch('"value":"([^"]-)","data":"([^"]-)"') do
		local manga = CreateManga(stringify2(Name), self.Link.."/manga/"..stringify2(Link):gsub(" ","%%20"):gsub("%%","%%%%"), self.Link.."//uploads/manga/"..stringify2(Link):gsub(" ","%%20"):gsub("%%","%%%%").."/cover/cover_250x350.jpg", self.ID, self.Link.."/manga/"..stringify2(Link))
        t[#t + 1] = manga
		coroutine.yield(false)
	end
    t.NoPages = true
end

function Puzzmos:getChapters(manga, dest_table)
    local content = downloadContent(manga.Link)
    local t = {}
    for Link, Name in content:gmatch("chapter%-title%-rtl\">[^<]-<a href=\"([^\"]-)\">([^<]-)</a>") do
        t[#t + 1] = {
			Name = stringify(Name),
			Link = Link:gsub(" ","%%20"):gsub("%%","%%%%"),
			Pages = {},
			Manga = manga
		}
    end
	for i = #t, 1, -1 do
		dest_table[#dest_table + 1] = t[i]
	end
end

function Puzzmos:prepareChapter(chapter, dest_table)
    local content = downloadContent(chapter.Link)
	local t = dest_table
	for Link in content:gmatch("img%-responsive\"[^>]-data%-src=' ([^']-) '") do
        t[#t + 1] = Link:gsub(" ","%%20"):gsub("%%","%%%%")
		Console.write("Got " .. t[#t])
    end
end

function Puzzmos:loadChapterPage(link, dest_table)
	dest_table.Link = link
end
