UnionMangas=Parser:new("UnionMangas","https://unionmangas.top","PRT","UNIONMANGASPT",3)local function a(b)return b:gsub("&#([^;]-);",function(c)local d=tonumber("0"..c)or tonumber(c)return d and u8c(d)or"&#"..c..";"end):gsub("&(.-);",function(c)return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"end)end;local function e(f)local g={}Threads.insertTask(g,{Type="StringRequest",Link=f,Table=g,Index="text"})while Threads.check(g)do coroutine.yield(false)end;return g.text or""end;function UnionMangas:getManga(f,h)local i=e(f)local j=h;local k=true;for l,m,n in i:gmatch('media lancamento%-linha">[^>]-href="([^"]-)">[^>]-src="([^"]-)".->%s+([^<]-)</a>')do j[#j+1]=CreateManga(a(n),l:match(".+/(.-)$"),m,self.ID,l)k=false;coroutine.yield(false)end;if k then j.NoPages=true end end;function UnionMangas:getPopularManga(o,h)self:getManga(self.Link.."/lista-mangas/visualizacoes/"..o,h)end;function UnionMangas:searchManga(p,q,h)local i=e(self.Link.."/assets/busca.php?nomeManga="..p)for m,n,l in i:gmatch('"imagem":"([^"]-)","titulo":"([^"]-)","url":"([^"]-)"')do h[#h+1]=CreateManga(n,l,m:gsub("\\/","/"),self.ID,self.Link.."/perfil-manga/"..l)coroutine.yield(false)end;h.NoPages=true end;function UnionMangas:getChapters(r,h)local i=e(self.Link.."/perfil-manga/"..r.Link)local s=(i:match('class="panel%-body">(.-)</div>')or""):gsub("^%s+",""):gsub("%s+$","")h.Description=a(s)local j={}for l,n in i:gmatch('row capitulos".-href="([^"]-)">([^<]-)</a>')do j[#j+1]={Name=a(n),Link=l,Pages={},Manga=r}end;for t=#j,1,-1 do h[#h+1]=j[t]end end;function UnionMangas:prepareChapter(u,h)local i=e(u.Link)local j=h;for l in i:gmatch('img src="([^"]-/leitor/[^"]-)"')do j[#j+1]=l:gsub("%s","%%%%20")end end;function UnionMangas:loadChapterPage(f,h)h.Link=f end