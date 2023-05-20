Onma=Parser:new("Onma","https://onma.me","ARA","ONMAARA",1)Onma.Tags={"أكشن","مغامرة","كوميدي","شياطين","دراما","إيتشي","خيال","انحراف جنسي","حريم","تاريخي","رعب","جوسي","فنون قتالية","ناضج","ميكا","غموض","وان شوت","نفسي","رومنسي","حياة مدرسية","خيال علمي","سينين","شوجو","شوجو أي","شونين","شونين أي","شريحة من الحياة","رياضة","خارق للطبيعة","مأساة","مصاصي الدماء","سحر","ويب تون","دوجينشي"}Onma.TagValues={["أكشن"]=1,["مغامرة"]=2,["كوميدي"]=3,["شياطين"]=4,["دراما"]=5,["إيتشي"]=6,["خيال"]=7,["انحراف جنسي"]=8,["حريم"]=9,["تاريخي"]=10,["رعب"]=11,["جوسي"]=12,["فنون قتالية"]=13,["ناضج"]=14,["ميكا"]=15,["غموض"]=16,["وان شوت"]=17,["نفسي"]=18,["رومنسي"]=19,["حياة مدرسية"]=20,["خيال علمي"]=21,["سينين"]=22,["شوجو"]=23,["شوجو أي"]=24,["شونين"]=25,["شونين أي"]=26,["شريحة من الحياة"]=27,["رياضة"]=28,["خارق للطبيعة"]=29,["مأساة"]=30,["مصاصي الدماء"]=31,["سحر"]=32,["ويب تون"]=35,["دوجينشي"]=36}local function a(b)return b:gsub("&#([^;]-);",function(c)local d=tonumber("0"..c)or tonumber(c)return d and u8c(d)or"&#"..c..";"end):gsub("&(.-);",function(c)return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"end)end;local function e(b)return b:gsub("\\u(....)",function(c)return u8c(tonumber("0x"..c))end)end;local function f(g)local h={}Threads.insertTask(h,{Type="StringRequest",Link=g,Table=h,Index="text"})while Threads.check(h)do coroutine.yield(false)end;return h.text or""end;function Onma:getManga(g,i)local j=f(g)i.NoPages=true;for k,l,m in j:gmatch('<a href="[^"]-/manga/([^"]-)"[^>]->[^>]-src=\'([^\']-)\'[^>]*alt=\'([^\']-)\'>[^<]-</a>')do i[#i+1]=CreateManga(a(m),k,l,self.ID,self.Link.."/manga/"..k,self.Link.."/manga/"..k)i.NoPages=false;coroutine.yield(false)end end;function Onma:getPopularManga(n,i)self:getManga(self.Link.."/filterList?sortBy=views&asc=false&page="..n,i)end;function Onma:getAZManga(n,i)self:getManga(self.Link.."/filterList?sortBy=name&asc=true&page="..n,i)end;function Onma:getTagManga(n,i,o)self:getManga(self.Link.."/filterList?alpha=&cat="..(self.TagValues[o]or"0").."&sortBy=name&asc=true&page="..n,i)end;function Onma:searchManga(p,n,i)local j=f(self.Link.."/search?query="..p)i.NoPages=true;for q,r in j:gmatch('{"value":"(.-)","data":"(.-)"}')do i[#i+1]=CreateManga(e(q),r,self.Link.."/uploads/manga/"..r.."/cover/cover_250x350.jpg",self.ID,self.Link.."/manga/"..r,self.Link.."/manga/"..r)coroutine.yield(false)end end;function Onma:getChapters(s,i)local j=f(self.Link.."/manga/"..s.Link)local t=j:match('class="well">.-<p[^>]->(.-)</div>')or""i.Description=a(t:gsub("<.->",""):gsub("^%s+",""):gsub("%s+$",""))local u={}for k,m,v in j:gmatch('chapter%-title%-rtl">[^<]-<a href="[^"]-/manga/([^"]-)">([^<]-)</a>(.-)</h5>')do v=v:match("<em>([^<]-)</em>")u[#u+1]={Name=a(m..(v and": "..v or"")),Link=k,Pages={},Manga=s}end;for w=#u,1,-1 do i[#i+1]=u[w]end end;function Onma:prepareChapter(x,i)local j=f(self.Link.."/manga/"..x.Link)for k in j:gmatch('img%-responsive"[^>]-data%-src=\' ([^\']-) \'')do i[#i+1]=k end end;function Onma:loadChapterPage(g,i)i.Link=g end