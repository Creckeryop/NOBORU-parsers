NiceOppai=Parser:new("NiceOppai","https://www.niceoppai.net","THA","NICEOPPAITHA",1)local function a(b)return b:gsub("&#([^;]-);",function(c)local d=tonumber("0"..c)or tonumber(c)return d and u8c(d)or"&#"..c..";"end):gsub("&(.-);",function(c)return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"end)end;local function e(f)local g={}Threads.insertTask(g,{Type="StringRequest",Link=f,Table=g,Index="text"})while Threads.check(g)do coroutine.yield(false)end;return g.text or""end;function NiceOppai:getManga(f,h)local i=e(f)h.NoPages=true;for j,k,l in i:gmatch('"cvr">.-href="[^"]-/([^/"]-)/"><img src="([^"]-)" alt="([^"]-)"')do h[#h+1]=CreateManga(a(l),j,k,self.ID,self.Link.."/"..j.."/")h.NoPages=false;coroutine.yield(false)end end;function NiceOppai:getAZManga(m,h)self:getManga(self.Link.."/manga_list/all/any/name-az/"..m.."/",h)end;function NiceOppai:getLatestManga(m,h)self:getManga(self.Link.."/manga_list/all/any/last-updated/"..m.."/",h)end;function NiceOppai:getPopularManga(m,h)self:getManga(self.Link.."/manga_list/all/any/most-popular/"..m.."/",h)end;function NiceOppai:searchManga(n,m,h)self:getManga(self.Link.."/manga_list/search/"..n.."/most-popular/"..m.."/",h)end;function NiceOppai:getChapters(o,h)local p={}local q=1;while true do local i=e(self.Link.."/"..o.Link.."/chapter-list/"..q.."/")q=q+1;local r=true;for j,l in i:gmatch('"lst" href="[^"]-/([^/"]-)/".-"val">([^<]-)</b>')do r=false;p[#p+1]={Name=a(l),Link=j,Pages={},Manga=o}end;if r then break end end;for s=#p,1,-1 do h[#h+1]=p[s]end end;function NiceOppai:prepareChapter(t,h)local i=e(self.Link.."/"..t.Manga.Link.."/"..t.Link.."/")for j in i:gmatch('<center><img rel="noreferrer" src="([^"]-)"')do h[#h+1]=j:gsub("\\/","/")end end;function NiceOppai:loadChapterPage(f,h)h.Link=f end