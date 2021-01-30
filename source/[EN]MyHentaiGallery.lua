MyHentaiGallery = Parser:new("MyHentaiGallery", "https://myhentaigallery.com", "ENG", "MYHENTAIGALLERYEN", 1)

MyHentaiGallery.NSFW = true
MyHentaiGallery.Tags = {
	"3D Comic",
	"Ahegao",
	"Anal",
	"Asian",
	"Ass Expansion",
	"Aunt",
	"BBW",
	"Beastiality",
	"Bimbofication",
	"Bisexual",
	"Black | Interracial",
	"Body Swap",
	"Bondage",
	"Breast Expansion",
	"Brother",
	"Bukakke",
	"Catgirl",
	"Cheating",
	"Cousin",
	"Crossdressing",
	"Dad | Father",
	"Daughter",
	"Dick Growth",
	"Ebony",
	"Elf",
	"Exhibitionism",
	"Femdom",
	"Foot Fetish",
	"Furry",
	"Futanari X Female",
	"Futanari X Futanari",
	"Futanari X Male",
	"Futanari | Shemale | Dickgirl",
	"Gangbang",
	"Gay | Yaoi",
	"Gender Bending",
	"Giantess",
	"Gloryhole",
	"Group",
	"Hairy Female",
	"Hardcore",
	"Harem",
	"Incest",
	"Inflation | Stomach Bulge",
	"Inseki",
	"Kemonomimi",
	"Lactation",
	"Lesbian | Yuri | Girls Only",
	"Milf",
	"Mind Break",
	"Mind Control | Hypnosis",
	"Mom | Mother",
	"Most Popular",
	"Muscle Girl",
	"Muscle Growth",
	"Nephew",
	"Niece",
	"Pegging",
	"Possession",
	"Pregnant | Impregnation",
	"Rape",
	"Sister",
	"Solo",
	"Son",
	"Spanking",
	"Strap-On",
	"Superheroes",
	"Tentacles",
	"Threesome",
	"Tickling",
	"Transformation",
	"Uncle",
	"Urination",
	"Vore | Unbirth",
	"Weight Gain"
}
MyHentaiGallery.TagValues = {
	["3D Comic"] = 3,
	["Ahegao"] = 2740,
	["Anal"] = 2741,
	["Asian"] = 4,
	["Ass Expansion"] = 5,
	["Aunt"] = 6,
	["BBW"] = 7,
	["Beastiality"] = 8,
	["Bimbofication"] = 3430,
	["Bisexual"] = 9,
	["Black | Interracial"] = 10,
	["Body Swap"] = 11,
	["Bondage"] = 12,
	["Breast Expansion"] = 13,
	["Brother"] = 14,
	["Bukakke"] = 15,
	["Catgirl"] = 2742,
	["Cheating"] = 16,
	["Cousin"] = 17,
	["Crossdressing"] = 18,
	["Dad | Father"] = 19,
	["Daughter"] = 20,
	["Dick Growth"] = 21,
	["Ebony"] = 3533,
	["Elf"] = 2744,
	["Exhibitionism"] = 2745,
	["Femdom"] = 23,
	["Foot Fetish"] = 3253,
	["Furry"] = 24,
	["Futanari X Female"] = 3416,
	["Futanari X Futanari"] = 3415,
	["Futanari X Male"] = 26,
	["Futanari | Shemale | Dickgirl"] = 25,
	["Gangbang"] = 27,
	["Gay | Yaoi"] = 28,
	["Gender Bending"] = 29,
	["Giantess"] = 30,
	["Gloryhole"] = 31,
	["Group"] = 49,
	["Hairy Female"] = 3418,
	["Hardcore"] = 36,
	["Harem"] = 37,
	["Incest"] = 38,
	["Inflation | Stomach Bulge"] = 57,
	["Inseki"] = 3417,
	["Kemonomimi"] = 3368,
	["Lactation"] = 39,
	["Lesbian | Yuri | Girls Only"] = 40,
	["Milf"] = 41,
	["Mind Break"] = 3419,
	["Mind Control | Hypnosis"] = 42,
	["Mom | Mother"] = 43,
	["Most Popular"] = 2,
	["Muscle Girl"] = 45,
	["Muscle Growth"] = 46,
	["Nephew"] = 47,
	["Niece"] = 48,
	["Pegging"] = 50,
	["Possession"] = 51,
	["Pregnant | Impregnation"] = 52,
	["Rape"] = 53,
	["Sister"] = 54,
	["Solo"] = 2746,
	["Son"] = 55,
	["Spanking"] = 56,
	["Strap-On"] = 58,
	["Superheroes"] = 59,
	["Tentacles"] = 60,
	["Threesome"] = 61,
	["Tickling"] = 4193,
	["Transformation"] = 62,
	["Uncle"] = 63,
	["Urination"] = 64,
	["Vore | Unbirth"] = 65,
	["Weight Gain"] = 66
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

function MyHentaiGallery:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('gallery/thumbnails/([^"]-)".-src="([^"]-)".-comic%-name">(.-)</h2>') do
		dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink:gsub("%%", "%%%%"):gsub(" ", "%%%%20"), self.ID, self.Link .. "/gallery/thumbnails/" .. Link)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function MyHentaiGallery:getLatestManga(page, dt)
	self:getManga(self.Link .. "/gallery/" .. page, dt)
end

function MyHentaiGallery:getPopularManga(page, dt)
	self:getManga(self.Link .. "/gallery/category/2/" .. page, dt)
end

function MyHentaiGallery:getTagManga(page, dt, tag)
	self:getManga(self.Link .. "/gallery/category/"..(self.TagValues[tag] or "").."/" .. page, dt)
end


function MyHentaiGallery:searchManga(search, page, dt)
	self:getManga(self.Link .. "/search/" .. page .. "?query=" .. search, dt)
end

function MyHentaiGallery:getChapters(manga, dt)
	dt[#dt + 1] = {
		Name = stringify(manga.Name),
		Link = manga.Link,
		Pages = {},
		Manga = manga
	}
end

function MyHentaiGallery:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. "/gallery/thumbnails/" .. chapter.Link)
	for Link in content:gmatch('comic%-thumb.-src="([^"]-)"') do
		dt[#dt + 1] = Link:gsub("%%", "%%%%"):gsub(" ", "%%%%20"):gsub("/thumbnail/","/original/")
	end
end

function MyHentaiGallery:loadChapterPage(link, dt)
	dt.Link = link
end
