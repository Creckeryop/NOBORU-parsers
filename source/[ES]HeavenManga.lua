HeavenManga = Parser:new("HeavenManga", "https://heavenmanga.com", "ESP", "HEAVENMANGAESP", 2)

HeavenManga.Tags = {
	"Accion",
	"Adulto",
	"Artes Marciales",
	"Acontesimientos de la Vida",
	"Bakunyuu",
	"Gore",
	"Gender Bender",
	"Humor",
	"Harem",
	"Hentai",
	"Horror",
	"Historico",
	"Josei",
	"Loli",
	"Light",
	"Lucha Libre",
	"Manga",
	"Mecha",
	"Magia",
	"Manhwa",
	"Manhua",
	"Mature",
	"Misterio",
	"Mutantes",
	"Novela",
	"OneShot",
	"Psicologico",
	"Romance",
	"Recuentos de la vida",
	"Smut",
	"Shojo",
	"Shonen",
	"Seinen",
	"Shoujo",
	"Shounen",
	"Suspenso",
	"School Life",
	"SuperHeroes",
	"Supernatural",
	"Slice of Life",
	"Super Poderes",
	"Torneo",
	"Tragedia",
	"Transexual",
	"Vampiros",
	"Violencia",
	"Vida Pasadas",
	"Vida Cotidiana",
	"vida de escuela",
	"Webtoon",
	"Yaoi",
	"Yuri",
	"Sobrenatural",
	"hola",
	"Drama",
	"ecchi",
	"comedia",
	"Aventura",
	"Fantasia",
	"Demonios",
	"Superpoderes",
	"Deporte",
	"Ciencia Ficción",
	"Supervivencia",
	"Crimen",
	"Reencarnación",
	"Género Bender",
	"Apocalíptico",
	"Familia",
	"Militar",
	"Guerra",
	"Realidad",
	"Animación",
	"Musica"
}

HeavenManga.Keys = {
	["Accion"] = "/genero/accion.html",
	["Adulto"] = "/genero/adulto.html",
	["Artes Marciales"] = "/genero/artes-marciales.html",
	["Acontesimientos de la Vida"] = "/genero/acontesimientos-de-la-vida.html",
	["Bakunyuu"] = "/genero/bakunyuu.html",
	["Gore"] = "/genero/gore.html",
	["Gender Bender"] = "/genero/gender-bender.html",
	["Humor"] = "/genero/humor.html",
	["Harem"] = "/genero/harem.html",
	["Hentai"] = "/genero/hentai.html",
	["Horror"] = "/genero/horror.html",
	["Historico"] = "/genero/historico.html",
	["Josei"] = "/genero/josei.html",
	["Loli"] = "/genero/loli.html",
	["Light"] = "/genero/light.html",
	["Lucha Libre"] = "/genero/lucha-libre.html",
	["Manga"] = "/genero/manga.html",
	["Mecha"] = "/genero/mecha.html",
	["Magia"] = "/genero/magia.html",
	["Manhwa"] = "/genero/manhwa.html",
	["Manhua"] = "/genero/manhua.html",
	["Mature"] = "/genero/mature.html",
	["Misterio"] = "/genero/misterio.html",
	["Mutantes"] = "/genero/mutantes.html",
	["Novela"] = "/genero/novela.html",
	["OneShot"] = "/genero/oneshot.html",
	["Psicologico"] = "/genero/psicologico.html",
	["Romance"] = "/genero/romance.html",
	["Recuentos de la vida"] = "/genero/recuentos-de-la-vida.html",
	["Smut"] = "/genero/smut.html",
	["Shojo"] = "/genero/shojo.html",
	["Shonen"] = "/genero/shonen.html",
	["Seinen"] = "/genero/seinen.html",
	["Shoujo"] = "/genero/shoujo.html",
	["Shounen"] = "/genero/shounen.html",
	["Suspenso"] = "/genero/suspenso.html",
	["School Life"] = "/genero/school-life.html",
	["SuperHeroes"] = "/genero/superheroes.html",
	["Supernatural"] = "/genero/supernatural.html",
	["Slice of Life"] = "/genero/slice-of-life.html",
	["Super Poderes"] = "/genero/super-poderes.html",
	["Torneo"] = "/genero/torneo.html",
	["Tragedia"] = "/genero/tragedia.html",
	["Transexual"] = "/genero/transexual.html",
	["Vampiros"] = "/genero/vampiros.html",
	["Violencia"] = "/genero/violencia.html",
	["Vida Pasadas"] = "/genero/vida-pasadas.html",
	["Vida Cotidiana"] = "/genero/vida%20-cotidiana.html",
	["vida de escuela"] = "/genero/vida-de-escuela.html",
	["Webtoon"] = "/genero/webtoon.html",
	["Yaoi"] = "/genero/yaoi.html",
	["Yuri"] = "/genero/yuri.html",
	["Sobrenatural"] = "/genero/sobrenatural.html",
	["hola"] = "/genero/hola.html",
	["Drama"] = "/genero/drama.html",
	["ecchi"] = "/genero/ecchi.html",
	["comedia"] = "/genero/comedia.html",
	["Aventura"] = "/genero/aventura.html",
	["Fantasia"] = "/genero/fantasia.html",
	["Demonios"] = "/genero/demonios.html",
	["Superpoderes"] = "/genero/superpoderes.html",
	["Deporte"] = "/genero/deporte.html",
	["Ciencia Ficción"] = "/genero/ciencia-ficcion.html",
	["Supervivencia"] = "/genero/supervivencia.html",
	["Crimen"] = "/genero/crimen.html",
	["Reencarnación"] = "/genero/reencarnacion.html",
	["Género Bender"] = "/genero/genero-bender.html",
	["Apocalíptico"] = "/genero/apocaliptico.html",
	["Familia"] = "/genero/familia.html",
	["Militar"] = "/genero/militar.html",
	["Guerra"] = "/genero/guerra.html",
	["Realidad"] = "/genero/realidad.html",
	["Animación"] = "/genero/animacion.html",
	["Musica"] = "/genero/musica.html"
}

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

function HeavenManga:getManga(post, dt)
	local content = downloadContent(post)
	dt.NoPages = true
	for Name, Link, ImageLink in content:gmatch('"manga%-name">[\n%s]+(.-)[\n%s]+</div>.-href=".-%.com(/[^"]-)".-src=\'([^\']-)\'') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function HeavenManga:getPopularManga(page, dt)
	self:getManga(self.Link .. "/top?page=" .. page, dt)
end

function HeavenManga:getTagManga(page, dt, tag)
	self:getManga(self.Link .. tostring(self.Keys[tag]) .. "?page=" .. page, dt)
end

function HeavenManga:searchManga(search, page, dt)
	local content = downloadContent(self.Link .. "/buscar?query=" .. search)
	dt.NoPages = true
	for ImageLink, Link, Name in content:gmatch('item__content">.-src=\'([^\']-)\'.-<a href=".-%.com(/[^"]-)">(.-)</a>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link, self.Link .. Link)
	end
end

function HeavenManga:getChapters(manga, dt)
	local content = downloadContent(self.Link .. manga.Link)
	local t = {}
	for Link, Name in content:gmatch('a href="[^"]+(/[^"]-)" class="text%-warning"><i>([^<]-)</i>') do
		t[#t + 1] = {
			Name = Name,
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	table.sort(
		t,
		function(a, b)
			return (a.Name < b.Name)
		end
	)
	for i = 1, #t do
		dt[#dt + 1] = t[i]
	end
end

function HeavenManga:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Manga.Link .. chapter.Link)
	local leer = content:match('leer" rel="nofollow" href="[^"]-(/manga/leer/[^"]-)"') or ""
	content = downloadContent(self.Link .. leer)
	for Link in content:gmatch('"imgURL":"([^"]-)%s-"') do
		dt[#dt + 1] = Link
	end
end

function HeavenManga:loadChapterPage(link, dt)
	dt.Link = link
end
