# NOBORU - Parsers
This repo is created to store parsers for NOBORU app on PS vita
## Supported Parsers: 
|    Different    |    Russian    |      English      |     Japan     |      Spanish       |    Portuguese    |      French       |     Turkish     |    Italian    | Vietnamese |    Polish     |   German   |  Brazil   | Indonesian |   Korean   |
| :-------------: | :-----------: | :---------------: | :-----------: | :----------------: | :--------------: | :---------------: | :-------------: | :-----------: | :--------: | :-----------: | :--------: | :-------: | :--------: | :--------: |
|    MangaDex     | ~~ReadManga~~ |   ~~MangaHub~~    |   SenManga    |      LeoManga      |    Animaregia    |   ~~LelScanVF~~   | ~~Mabushimajo~~ | ~~MangaEden~~ |  TruyenQQ  | Phoenix-Scans | NineManga  | NineManga |  Komikid   | manatoki95 |
|  ~~Bato.to*~~   |  МангаПоиск   |  ~~MangaReader~~  | ~~Manga1000~~ |      InManga       |   UnionMangas    |      ScanFR       |     Puzzmos     |   NineManga   |            |               | Wie Manga! |           |            |            |
|  LoveHug (RAW)  | ~~MintManga~~ |  ~~MangaPanda~~   |               |    ~~Submanga~~    | ~~GoldenMangas~~ |     NineManga     |   ~~MangaTR~~   |               |            |               |            |           |            |            |
| RawDevArt (RAW) | ~~SelfManga~~ |     MangaTown     |               |     NineManga      |     BRMangas     |                   |    SeriManga    |               |            |               |            |           |            |            |
|                 |     Desu      |   ~~MangaOwl~~    |               |    HeavenManga     |                  |                   |   MangaDenizi   |               |            |               |            |           |            |            |
|                 |   NineManga   | ReadComicsOnline  |               | ~~TumangaOnline~~  |                  |                   |                 |               |            |               |            |           |            |            |
|                 | MangaOneLove  |   MangaKakalot    |               |   ~~MangaDoor~~    |                  |                   |                 |               |            |               |            |           |            |            |
|                 |  Манга-Тян!   |     MangaNelo     |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|                 |  MangaHubRu   |    ~~VLComic~~    |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|                 |               |   ~~MangaEden~~   |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|                 |               |     NineManga     |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|                 |               |   ~~MangaSee~~    |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|                 |               |    XoXoComics     |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|                 |               | ReadComicOnlineTo |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|                 |               |     Mangafast     |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|                 |               |   Reaper Scans    |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|    **NSFW**     |   **NSFW**    |     **NSFW**      |   **NSFW**    |      **NSFW**      |     **NSFW**     |     **NSFW**      |    **NSFW**     |   **NSFW**    |  **NSFW**  |   **NSFW**    |  **NSFW**  | **NSFW**  |  **NSFW**  |  **NSFW**  |
|     nhentai     |   Nude-Moon   |     PervEden      |               |    DoujinHentai    |                  | Histoire d'Hentai |                 |   PervEden    |            |               |            |           |            |            |
|   HentaiRead    | ~~AllHentai~~ |  ~~HentaiCafe~~   |               | VerComicsPorno.xxx |                  |                   |                 |               |            |               |            |           |            |            |
|     9hentai     |   Яой-Тян!    |  MyHentaiGallery  |               |                    |                  |                   |                 |               |            |               |            |           |            |            |
|  Hentai Shark   |  Хентай-Тян!  |     Hentai20      |               |                    |                  |                   |                 |               |            |               |            |           |            |            |

**Catalog works with option Preferred Language and deletes extra manga from it*<br>
*strikethrough parsers don't work*

## Cloudflare-sites
  Parsers in this folder will work if there is the way to bypass cloudflare with cURL or with sites that avoid cloudflare thing (that will never happen).

## Manual Installation
  Throw `*.lua` file to `ux0:data/noboru/parsers/` and launch app

## Creating parsers
  For understanding how to create parser you can check `parsers/[JP]RawDevArt.lua`, there all functions described and you can see how it all works.

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
  ---@param version number
  ---@return Parser
  ---Creates parser
  function Parser:new(name, link, language, uniqueID, version)
  
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
