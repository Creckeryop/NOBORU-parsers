if Settings.Version>0.35 then TruyenQQ=Parser:new("TruyenQQ","http://truyenqqvip.com","VIE","TRUYENQQVIE",4)local function a(b)return b:gsub("&#([^;]-);",function(c)local d=tonumber("0"..c)or tonumber(c)return d and u8c(d)or"&#"..c..";"end):gsub("&(.-);",function(c)return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"end)end;local e;local function f(g)local h={}Threads.insertTask(h,{Type="StringRequest",Link=g,Table=h,Index="string",Cookie=e and e.."; path=/"or""})while Threads.check(h)do coroutine.yield(false)end;if not e then e=h.string:match("document%.cookie%s-=%s-\"(.-)\"")return f(g)end;return h.string or""end;function TruyenQQ:getManga(g,i)local j=f(g)local k=i;local l=true;for m,n,o in j:gmatch('item">[^<]-<a.-href="([^"]-)".->.-<img[^>]-src="([^"]-)".-alt="([^"]-)"')do local p=CreateManga(a(o),m,{Link=n,Header1="Referer: "..g},self.ID,m)if p then k[#k+1]=p;l=false end;coroutine.yield(false)end;if l then k.NoPages=true end end;function TruyenQQ:getPopularManga(q,i)self:getManga(self.Link.."/truyen-yeu-thich/trang-"..q..".html",i)end;function TruyenQQ:getLatestManga(q,i)self:getManga(self.Link.."/truyen-moi-cap-nhat/trang-"..q..".html",i)end;function TruyenQQ:searchManga(r,q,i)self:getManga(self.Link.."/tim-kiem/trang-"..q..".html?q="..r,i)end;function TruyenQQ:getChapters(p,i)local j=f(p.Link)local s=(j:match('" itemprop="description".-p>(.-)</p>')or""):gsub("<br>","\n"):gsub("<.->",""):gsub("\n+","\n"):gsub("^%s+",""):gsub("%s+$","")i.Description=a(s)local k={}for m,o in j:gmatch('item row">.-<a.-href="([^"]-)">([^>]-)</a>')do k[#k+1]={Name=a(o):gsub("%s+",""),Link=m,Pages={},Manga=p}end;for t=#k,1,-1 do i[#i+1]=k[t]end end;function TruyenQQ:prepareChapter(u,i)local j=f(u.Link)local k=i;for m in j:gmatch('<img class="lazy".-src="([^"]-)"')do k[#k+1]=m.."\n"..u.Link end end;function TruyenQQ:loadChapterPage(g,i)i.Link={Link=g:match("^(.-)\n")or"",Header1="Referer: "..(g:match("\n(.-)$")or"")}end end