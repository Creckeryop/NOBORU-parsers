UnionMangas = Parser:new("UnionMangas", "https://unionleitor.top", "PRT", "UNIONMANGASPT")

function UnionMangas:getManga(link, dest_table)
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
    local content = file.string or ""
    local t = dest_table
    local done = true
    for Link, ImageLink, Name in content:gmatch('media lancamento%-linha">[^>]-href="([^"]-)">[^>]-src="([^"]-)".->%s+([^<]-)</a>') do
        t[#t + 1] = CreateManga(Name, Link:match(".+/(.-)$"), ImageLink, self.ID, Link)
        done = false
        coroutine.yield(false)
    end
    if done then
        t.NoPages = true
    end
end

function UnionMangas:getPopularManga(page, dest_table)
    self:getManga(self.Link .. "/lista-mangas/visualizacoes/" .. page, dest_table)
end

function UnionMangas:searchManga(search, page, dest_table)
    local file = {}
    Threads.insertTask(file, {
        Type = "StringRequest",
        Link = self.Link .. "/assets/busca.php?q=" .. search,
        Table = file,
        Index = "string"
    })
    while Threads.check(file) do
        coroutine.yield(false)
    end
    local content = file.string or ""
    local t = dest_table
    local done = true
    for ImageLink, Name, Link in content:gmatch('"imagem":"([^"]-)","titulo":"([^"]-)","url":"([^"]-)"') do
        t[#t + 1] = CreateManga(Name, Link, ImageLink:gsub("\\/", "/"), self.ID, self.Link .. "/perfil-manga/" .. Link)
        done = false
        coroutine.yield(false)
    end
    if done then
        t.NoPages = true
    end
end

function UnionMangas:getChapters(manga, dest_table)
    local file = {}
    Threads.insertTask(file, {
        Type = "StringRequest",
        Link = self.Link .. "/perfil-manga/" .. manga.Link,
        Table = file,
        Index = "string"
    })
    while Threads.check(file) do
        coroutine.yield(false)
    end
    local content = file.string or ""
    local t = {}
    for Link, Name in content:gmatch('row lancamento%-linha">.-href="([^"]-)">([^<]-)</a>') do
        t[#t + 1] = {
            Name = Name,
            Link = Link,
            Pages = {},
            Manga = manga
        }
    end
    for i = #t, 1, -1 do
        dest_table[#dest_table + 1] = t[i]
    end
end

function UnionMangas:prepareChapter(chapter, dest_table)
    local file = {}
    Threads.insertTask(file, {
        Type = "StringRequest",
        Link = chapter.Link,
        Table = file,
        Index = "string"
    })
    while Threads.check(file) do
        coroutine.yield(false)
    end
    local content = file.string or ""
    local count = content:match("total_pages = (.-);") or 0
    local t = dest_table
    for Link, Name in content:gmatch('img src="([^"]-/leitor/[^"]-)"') do
        t[#t + 1] = Link:gsub("%s", "%%%%20")
    end
end

function UnionMangas:loadChapterPage(link, dest_table)
    dest_table.Link = link
end
