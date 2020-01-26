# NOBORU - Parsers
This repo is created to store parsers for my future MangaApp for PS vita
## Supported Parsers:
Russian:
* ReadManga
* MintManga
* Nude-Moon (NSFW)
* Desu

English:
* MangaHub
* MangaReader
* MangaPanda
* MangaTown
* NineHentai (NSFW)

## Manual Installation
  Throw `*.lua` file to `ux0:data/noboru/parsers/` and launch app

## Tables
  ```Lua
  ---@param Name string
  ---@param Link string
  ---@param ImageLink string
  ---@param ParserID string
  ---@param RawLink string
  ---@return Manga table
  ---This function gives Manga table(see info about Manga table below)
  function CreateManga(Name, Link, ImageLink, ParserID, RawLink)

  Manga = {
	Name,      -- string Manga name
	Link,      -- string Link to the manga format isn't important (variable for parser)
	ImageLink, -- string Link to jpeg/png/bmp cover of manga
	ParserID,  -- string Parser's Unique key (used in saves)
	RawLink,   -- string Link for App (not important)
	Data       -- table to store manga data (for parser or other) 
  }
  
  Chapter = {
	Name,       -- string Chapter name
	Link,       -- var Link to the chapter format isn't important (variable for parser)
	Pages = {}, -- table (don't touch)
	Manga       -- table to Manga
  }
  ```
## Parser structure
  ```Lua
  ---@param name string
  ---@param link string
  ---@param language string
  ---@param uniqueID string
  ---@return Parser
  ---Creates parser
  function Parser:new(name, link, language, uniqueID)
  
  ---@param page integer
  ---@param dest_table table
  ---Adds popular manga(see Manga Table) to `dest_table`
  ---If page was last sets dest_table.NoPages to `true`
  function Parser:getPopularManga(page, dest_table)
  
  ---@param page integer
  ---@param dest_table table
  ---Adds latest manga(see Manga Table) to `dest_table`
  ---If page was last sets dest_table.NoPages to `true`
  function Parser:getLatestManga(page, dest_table)
  
  ---@param search string
  ---@param page integer
  ---@param dest_table table
  ---Adds searched manga(see Manga Table) with `search` string to `dest_table`
  ---If page was last sets dest_table.NoPages to `true`
  function Parser:searchManga(search, page, dest_table)
  
  ---@param manga table
  ---@param dest_table table
  ---Adds chapters(see Chapter Table) to dest_table in relese order (from 1st chapter to nth)
  function Parser:getChapters(manga, dest_table)
  
  ---@param chapter table
  ---@param dest_table table
  ---Adds links to all pages to dest_table
  function Parser:prepareChapter(chapter, dest_table)
  
  ---@param link string
  ---@param dest_table table
  ---Converts `link` in image_link(jpeg/png/bmp) and saves into dest_table.Link
  function Parser:loadChapterPage(link, dest_table)
 
  ```
