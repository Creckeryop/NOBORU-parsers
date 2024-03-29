if Settings.Version > 0.35 then
	TruyenQQ = Parser:new("TruyenQQ", "http://truyenqqpro.com", "VIE", "TRUYENQQVIE", 5)

	local function stringify(string)
		return string:gsub(
			"&#([^;]-);",
			function(a)
				local x = tonumber("0" .. a) or tonumber(a)
				return x and u8c(x) or "&#" .. a .. ";"
			end
		):gsub(
			"&(.-);",
			function(a)
				return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
			end
		)
	end

	local cookie
	local function downloadContent(link)
		local file = {}
		Threads.insertTask(
			file,
			{
				Type = "StringRequest",
				Link = link,
				Table = file,
				Index = "string",
				Cookie = cookie and (cookie .. "; path=/") or ""
			}
		)
		while Threads.check(file) do
			coroutine.yield(false)
		end
		if not cookie then
			cookie = file.string:match('document%.cookie%s-=%s-"(.-)"')
			return downloadContent(link)
		end
		return file.string or ""
	end

	function TruyenQQ:getManga(link, dt)
		local content = downloadContent(link)
		local t = dt
		local done = true
		for ImageLink, Link, Name in content:gmatch('"book_avatar">.-src="([^"]-)".-book_info">.-<a.-href="[^"]-/truyen%-tranh/([^"]-)">([^>]-)</a>') do
			local manga = CreateManga(stringify(Name), Link, {Link = ImageLink, Header1 = "Referer: " .. link}, self.ID, self.Link .. "/truyen-tranh/" .. Link)
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

	function TruyenQQ:getPopularManga(page, dt)
		self:getManga(self.Link .. "/truyen-yeu-thich/trang-" .. page .. ".html", dt)
	end

	function TruyenQQ:getLatestManga(page, dt)
		self:getManga(self.Link .. "/truyen-moi-cap-nhat/trang-" .. page .. ".html", dt)
	end

	function TruyenQQ:searchManga(search, page, dt)
		self:getManga(self.Link .. "/tim-kiem/trang-" .. page .. ".html?q=" .. search, dt)
	end

	function TruyenQQ:getChapters(manga, dt)
		local content = downloadContent(self.Link .. "/truyen-tranh/" .. manga.Link)
		local description = (content:match('class="story%-detail%-info.-p>(.-)</p>') or ""):gsub("<br>", "\n"):gsub("<.->", ""):gsub("\n+", "\n"):gsub("^%s+", ""):gsub("%s+$", "")
		dt.Description = stringify(description)
		local t = {}
		for Link, Name in content:gmatch('chapter%-item">.-<a[^>]-href="[^"]-/truyen%-tranh/([^"]-)">([^>]-)</a>') do
			t[#t + 1] = {
				Name = stringify(Name):gsub("%s+", ""),
				Link = Link,
				Pages = {},
				Manga = manga
			}
		end
		for i = #t, 1, -1 do
			dt[#dt + 1] = t[i]
		end
	end

	function TruyenQQ:prepareChapter(chapter, dt)
		local content = downloadContent(self.Link .. "/truyen-tranh/" .. chapter.Link)
		local t = dt
		for Link in content:gmatch('<img class="lazy".-src="([^"]-)"') do
			t[#t + 1] = Link .. "\n" .. self.Link .. "/truyen-tranh/" .. chapter.Link
		end
	end

	function TruyenQQ:loadChapterPage(link, dt)
		dt.Link = {
			Link = link:match("^(.-)\n") or "",
			Header1 = "Referer: " .. (link:match("\n(.-)$") or "")
		}
	end
end
