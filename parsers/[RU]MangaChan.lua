MangaChan=Parser:new("Манга-Тян!","https://manga-chan.me","RUS","MANGACHANRU",2)local function a(b)if u8c then return b:gsub("&#([^;]-);",function(c)local d=tonumber("0"..c)or tonumber(c)return d and u8c(d)or"&#"..c..";"end):gsub("&([^;]-);",function(c)return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"end)else return b end end;local function e(f)local g={}Threads.insertTask(g,{Type="StringRequest",Link=f,Table=g,Index="string"})while Threads.check(g)do coroutine.yield(false)end;return g.string or""end;function MangaChan:getManga(f,h)local i=e(f)h.NoPages=true;for j,k,l in i:gmatch('content_row" title=".-href="/manga/([^"]-)%.html"><img src="([^"]-)".-manga_row1.-title_link">(.-)</a>')do h[#h+1]=CreateManga(a(l),j,k:gsub("%%","%%%%"),self.ID,self.Link.."/manga/"..j..".html",self.Link.."/manga/"..j..".html")h.NoPages=false;coroutine.yield(false)end end;function MangaChan:getPopularManga(m,h)self:getManga(self.Link.."/mostfavorites?offset="..(m-1)*20,h)end;function MangaChan:getLatestManga(m,h)self:getManga(self.Link.."/manga/new?offset="..(m-1)*20,h)end;function MangaChan:searchManga(n,m,h)local i=e(self.Link.."/index.php?do=search&subaction=search&search_start=1&full_search=0&result_from="..1+(m-1)*40 .."&result_num=40&story="..n.."&need_sort_date=false")h.NoPages=true;for k,j,l in i:gmatch('content_row" title=".-<img src="([^"]-)".-href="[^"]*/manga/([^"]-)%.html[^>]->(.-)</a>')do h[#h+1]=CreateManga(a(l),j,k:gsub("%%","%%%%"),self.ID,self.Link.."/manga/"..j..".html",self.Link.."/manga/"..j..".html")h.NoPages=false;coroutine.yield(false)end end;function MangaChan:getChapters(o,h)local i=e(self.Link.."/manga/"..o.Link..".html")local p=(i:match('id="description" style.->(.-)<div')or""):gsub("<br[^>]->","\n"):gsub("<.->",""):gsub("\n+","\n"):gsub("^%s+",""):gsub("%s+$","")h.Description=a(p)local q={}for j,l in i:gmatch("href='/online/([^']-).html' title='[^']-'>(.-)</span>")do q[#q+1]={Name=a(l),Link=j,Pages={},Manga=o}end;for r=#q,1,-1 do h[#h+1]=q[r]end end;function MangaChan:prepareChapter(s,h)local i=e(self.Link.."/online/"..s.Link..".html"):match('"fullimg"%s*:%s*%[(.-)%]')or""for f in i:gmatch('"([^"]-)"')do h[#h+1]=f:gsub("\\/","/"):gsub("%%","%%%%")end end;function MangaChan:loadChapterPage(f,h)h.Link=f end;YaoiChan=MangaChan:new("Яой-Тян!","https://yaoi-chan.me","RUS","YAOICHANRU",2)YaoiChan.NSFW=true;HentaiChan=MangaChan:new("Хентай-Тян!","https://hentaichan.live","RUS","HENTAICHANRU",4)HentaiChan.NSFW=true;local function t(f)local g={}Threads.insertTask(g,{Type="StringRequest",Link=f,Table=g,Index="string",Header1="Cookie:dle_restore_pass11=1"})while Threads.check(g)do coroutine.yield(false)end;return g.string or""end;local u="http://exhentai-dono.me"function HentaiChan:getManga(f,h)local i=t(f)h.NoPages=true;for k,j,l in i:gmatch('content_row" title=".-src="([^"]-)".-href="[^"]*/manga/([^"]-)%.html[^>]->(.-)<')do h[#h+1]=CreateManga(a(l),j,k:gsub("%%","%%%%"):gsub("manganew_thumbs_blur","manganew_thumbs"),self.ID,self.Link.."/manga/"..j..".html",self.Link.."/manga/"..j..".html")h.NoPages=false;coroutine.yield(false)end end;function HentaiChan:getPopularManga(m,h)self:getManga(self.Link.."/manga/new&n=favdesc?offset="..(m-1)*20,h)end;function HentaiChan:getLatestManga(m,h)self:getManga(self.Link.."/manga/new?offset="..(m-1)*20,h)end;function HentaiChan:searchManga(n,m,h)self:getManga(self.Link.."/?do=search&subaction=search&story="..n.."&search_start="..1+(m-1)*40 .."&result_num=20",h)end;function HentaiChan:getChapters(o,h)local i=t(self.Link.."/related/"..o.Link..".html")o.NewImageLink=i:match('<img id="cover" src="(.-)"')or""if o.NewImageLink==""then o.NewImageLink=nil end;if i:match('<p class="extra_on">Все главы</p>')or i:match('<p class="extra_on">Все части</p>')then local q={}local v=0;while true do local w=false;for j,l in i:gmatch('related_info">.-href="[^"]*/manga/([^"]-)%.html"[^>]->(.-)<')do w=true;q[#q+1]={Name=a(l),Link=j,Pages={},Manga=o}end;coroutine.yield(true)if not w then break end;v=v+20;i=t(self.Link.."/related/"..o.Link..".html?offset="..v)end;for r=1,#q do h[r]=q[r]end else local x={Name=a(o.Name),Link=o.Link,Pages={},Manga=o}h[#h+1]=x end end;function HentaiChan:prepareChapter(s,h)local i=t(u.."/online/"..s.Link..".html?development_access=true"):match('"fullimg"%s*:%s*%[(.-)%]')or""for f in i:gmatch("'([^']-)'")do h[#h+1]=f:gsub("\\/","/"):gsub("%%","%%%%")end end;function HentaiChan:loadChapterPage(f,h)h.Link=f end