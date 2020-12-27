BatoTo = Parser:new("Bato.TO", "https://bato.to", "DIF", "BATODIF", 2)

BatoTo.Disabled = true

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

local langs = {
	RUS = "russian",
	ENG = "english",
	BRA = "brazilian",
	FRA = "french",
	POL = "polish",
	DEU = "german",
	SPA = "spanish",
	TUR = "turkish",
	ITA = "italian",
	VIE = "vietnamese",
	PRT = "portuguese"
}

local cntrys = {
	russia = "RUS",
	england = "ENG",
	mexico = "MEX",
	brazil = "BRA",
	france = "FRA",
	poland = "POL",
	spain = "SPA",
	germany = "DEU",
	turkey = "TUR",
	italy = "ITA",
	vietnam = "VIE",
	portugal = "PRT"
}

function BatoTo:getManga(link, dt)
	local content
	if link:find("latest") then
		content = downloadContent(link):match('id="series%-list"(.-)class="footer') or ""
	else
		content = downloadContent(link):match('id="series%-list"(.-)class="browse%-pager"') or ""
	end
	dt.NoPages = true
	for block in content:gmatch(' item (.-)class="col%-24') do
		local flag = not block:find("no%-flag")
		local cntry = "england"
		if flag then
			cntry = block:match('flag_(.-)"')
		end
		ImageLink, Link, Name = block:match('cover.-src="//([^"]-)".-item%-text.-href="([^"]-)"[^>]->(.-)</a>')
		Name = Name:gsub("<.->", "")
		local manga = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
		if manga and (cntrys[cntry] == Settings.ParserLanguage or Settings.ParserLanguage == "DIF") then
			if Settings.ParserLanguage == "DIF" then
				manga.Name = "[" .. (cntrys[cntry] or (cntry:sub(0, 3):upper())) .. "] " .. manga.Name
			end
			dt[#dt + 1] = manga
		end
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function BatoTo:getLatestManga(page, dt)
	local addition = ""
	if Settings.ParserLanguage ~= "DIF" and langs[Settings.ParserLanguage] then
		addition = "&langs=" .. langs[Settings.ParserLanguage]
	end
	self:getManga(self.Link .. "/latest?page=" .. page .. addition, dt)
end

function BatoTo:getPopularManga(page, dt)
	local addition = ""
	if Settings.ParserLanguage ~= "DIF" and langs[Settings.ParserLanguage] then
		addition = "&langs=" .. langs[Settings.ParserLanguage]
	end
	self:getManga(self.Link .. "/browse?page=" .. page .. addition, dt)
end

function BatoTo:searchManga(search, page, dt)
	self:getManga(self.Link .. "/search?q=" .. search .. "&p=" .. page, dt)
end

function BatoTo:getChapters(manga, dt)
	local content = downloadContent(self.Link .. manga.Link)
	local t = {}
	for Link, Name in content:gmatch('chapt" href="([^"]-)">.-<b>(.-)</a>') do
		Name = Name:gsub("\n%s*(.-)\n%s*", " %1")
		Name = stringify(Name):gsub("<.->", "")
		t[#t + 1] = {
			Name = Name:gsub(" %- Read Online", ""),
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function BatoTo:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Link)
	for Link in content:gmatch('"%d-":"([^"]-)"') do
		dt[#dt + 1] = Link
	end
end

function BatoTo:loadChapterPage(link, dt)
	dt.Link = link
end
