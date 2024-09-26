if u8c then
    NewMangaDex = Parser:new("MangaDex", "https://mangadex.org", "DIF", "MANGADEXDIF", 2)

    NewMangaDex.Filters = {
        {
            Name = "Sort By",
            Type = "radio",
            Tags = {
                "Best Match",
                "Latest Upload",
                "Oldest Upload",
                "Title Ascending",
                "Title Descending",
                "Recently Added",
                "Oldest Added",
                "Most Follows",
                "Fewest Follows",
                "Year Ascending",
                "Year Descending"
            }
        },
        {
            Name = "Original Language",
            Type = "radio",
            Tags = {
                "All languages",
                "Japanese",
                "Korean",
                "Chinese (Simplified)",
                "Chinese (Traditional)",
                "English",
                "Arabic",
                "Bengali",
                "Bulgarian",
                "Burmese",
                "Catalan",
                "Czech",
                "Danish",
                "Dutch",
                "Filipino",
                "Finnish",
                "French",
                "German",
                "Greek",
                "Hebrew",
                "Hindi",
                "Hungarian",
                "Indonesian",
                "Italian",
                "Lithuanian",
                "Malay",
                "Mongolian",
                "Nepali",
                "Norwegian",
                "Other",
                "Persian",
                "Polish",
                "Portuguese",
                "Portuguese (Br)",
                "Romanian",
                "Russian",
                "Serbo-Croatian",
                "Spanish",
                "Spanish (LATAM)",
                "Swedish",
                "Thai",
                "Turkish",
                "Ukrainian",
                "Vietnamese"
            }
        },
        {
            Name = "Demographic",
            Type = "check",
            Tags = {
                "Shounen",
                "Shoujo",
                "Seinen",
                "Josei",
                "None"
            }
        },
        {
            Name = "Content Rating",
            Type = "check",
            Tags = {
                "Safe",
                "Suggestive",
                "Erotica",
                "Pornographic"
            },
            Default = {
                "Safe",
                "Suggestive",
                "Erotica"
            }
        },
        {
            Name = "Publication Status",
            Type = "check",
            Tags = {
                "Ongoing",
                "Completed",
                "Hiatus",
                "Cancelled"
            }
        },
        {
            Name = "Content",
            Type = "checkcross",
            Tags = {
                "Gore",
                "Sexual Violence"
            }
        },
        {
            Name = "Format",
            Type = "checkcross",
            Tags = {
                "4-Koma",
                "Adaptation",
                "Anthology",
                "Award Winning",
                "Doujinshi",
                "Fan Colored",
                "Full Color",
                "Long Strip",
                "Official Colored",
                "Oneshot",
                "User Created",
                "Web Comic"
            }
        },
        {
            Name = "Genre",
            Type = "checkcross",
            Tags = {
                "Action",
                "Adventure",
                "Boys' Love",
                "Comedy",
                "Crime",
                "Drama",
                "Fantasy",
                "Girls' Love",
                "Historical",
                "Horror",
                "Isekai",
                "Magical Girls",
                "Mecha",
                "Medical",
                "Mystery",
                "Philosophical",
                "Psychological",
                "Romance",
                "Sci-Fi",
                "Slice of Life",
                "Sports",
                "Superhero",
                "Thriller",
                "Tragedy",
                "Wuxia"
            }
        },
        {
            Name = "Theme",
            Type = "checkcross",
            Tags = {
                "Aliens",
                "Animals",
                "Cooking",
                "Crossdressing",
                "Delinquents",
                "Demons",
                "Genderswap",
                "Ghosts",
                "Gyaru",
                "Harem",
                "Incest",
                "Loli",
                "Mafia",
                "Magic",
                "Martial Arts",
                "Military",
                "Monster Girls",
                "Monsters",
                "Music",
                "Ninja",
                "Office Workers",
                "Police",
                "Post-Apocalyptic",
                "Reincarnation",
                "Reverse Harem",
                "Samurai",
                "School Life",
                "Shota",
                "Supernatural",
                "Survival",
                "Time Travel",
                "Traditional Games",
                "Vampires",
                "Video Games",
                "Villainess",
                "Virtual Reality",
                "Zombies"
            }
        }
    }

    NewMangaDex.SortKeys = {
        ["Best Match"] = "[relevance]=desc",
        ["Latest Upload"] = "[latestUploadedChapter]=desc",
        ["Oldest Upload"] = "[latestUploadedChapter]=asc",
        ["Title Ascending"] = "[title]=asc",
        ["Title Descending"] = "[title]=desc",
        ["Recently Added"] = "[createdAt]=desc",
        ["Oldest Added"] = "[createdAt]=asc",
        ["Most Follows"] = "[followedCount]=desc",
        ["Fewest Follows"] = "[followedCount]=asc",
        ["Year Ascending"] = "[year]=asc",
        ["Year Descending"] = "[year]=desc"
    }

    NewMangaDex.LangKeys = {
        ["Japanese"] = "ja",
        ["Korean"] = "ko",
        ["Chinese (Simplified)"] = "zh",
        ["Chinese (Traditional)"] = "zh-hk",
        ["English"] = "en",
        ["Arabic"] = "ar",
        ["Bengali"] = "bn",
        ["Bulgarian"] = "bg",
        ["Burmese"] = "my",
        ["Catalan"] = "cs",
        ["Czech"] = "ca",
        ["Danish"] = "da",
        ["Dutch"] = "nl",
        ["Filipino"] = "tl",
        ["Finnish"] = "fi",
        ["French"] = "fr",
        ["German"] = "de",
        ["Greek"] = "el",
        ["Hebrew"] = "he",
        ["Hindi"] = "hi",
        ["Hungarian"] = "hu",
        ["Indonesian"] = "id",
        ["Italian"] = "it",
        ["Lithuanian"] = "lt",
        ["Malay"] = "ms",
        ["Mongolian"] = "mn",
        ["Nepali"] = "no",
        ["Norwegian"] = "ne",
        ["Other"] = "NULL",
        ["Persian"] = "fa",
        ["Polish"] = "pl",
        ["Portuguese"] = "pt",
        ["Portuguese (Br)"] = "pt-br",
        ["Romanian"] = "ro",
        ["Russian"] = "ru",
        ["Serbo-Croatian"] = "es",
        ["Spanish"] = "sr",
        ["Spanish (LATAM)"] = "es-la",
        ["Swedish"] = "sv",
        ["Thai"] = "th",
        ["Turkish"] = "tr",
        ["Ukrainian"] = "uk",
        ["Vietnamese"] = "vi"
    }

    NewMangaDex.TagKeys = {
        ["Oneshot"] = "0234a31e-a729-4e28-9d6a-3f87c4966b9e",
        ["Thriller"] = "07251805-a27e-4d59-b488-f0bfbec15168",
        ["Award Winning"] = "0a39b5a1-b235-4886-a747-1d05d216532d",
        ["Reincarnation"] = "0bc90acb-ccc1-44ca-a34a-b9f3a73259d0",
        ["Sci-Fi"] = "256c8bd9-4904-4360-bf4f-508a76d67183",
        ["Time Travel"] = "292e862b-2d17-4062-90a2-0356caa4ae27",
        ["Genderswap"] = "2bd2e8d0-f146-434a-9b51-fc9ff2c5fe6a",
        ["Loli"] = "2d1f5d56-a1e5-4d0d-a961-2193588b08ec",
        ["Traditional Games"] = "31932a7e-5b8e-49a6-9f12-2afa39dc544c",
        ["Official Colored"] = "320831a8-4026-470b-94f6-8353740e6f04",
        ["Historical"] = "33771934-028e-4cb3-8744-691e866a923e",
        ["Monsters"] = "36fd93ea-e8b8-445e-b836-358f02b3d33d",
        ["Action"] = "391b0423-d847-456f-aff0-8b0cfc03066b",
        ["Demons"] = "39730448-9a5f-48a2-85b0-a70db87b1233",
        ["Psychological"] = "3b60b75c-a2d7-4860-ab56-05f391bb889c",
        ["Ghosts"] = "3bb26d85-09d5-4d2e-880c-c34b974339e9",
        ["Animals"] = "3de8c75d-8ee3-48ff-98ee-e20a65c86451",
        ["Long Strip"] = "3e2b8dae-350e-4ab8-a8ce-016e844b9f0d",
        ["Romance"] = "423e2eae-a7a2-4a8b-ac03-a8351462d71d",
        ["Ninja"] = "489dd859-9b61-4c37-af75-5b18e88daafc",
        ["Comedy"] = "4d32cc48-9f00-4cca-9b5a-a839f0764984",
        ["Mecha"] = "50880a9d-5440-4732-9afb-8f457127e836",
        ["Anthology"] = "51d83883-4103-437c-b4b1-731cb73d786c",
        ["Boys' Love"] = "5920b825-4181-4a17-beeb-9918b0ff7a30",
        ["Incest"] = "5bd0e105-4481-44ca-b6e7-7544da56b1a3",
        ["Crime"] = "5ca48985-9a9d-4bd8-be29-80dc0303db72",
        ["Survival"] = "5fff9cde-849c-4d78-aab0-0d52b2ee1d25",
        ["Zombies"] = "631ef465-9aba-4afb-b0fc-ea10efe274a8",
        ["Reverse Harem"] = "65761a2a-415e-47f3-bef2-a9dababba7a6",
        ["Sports"] = "69964a64-2f90-4d33-beeb-f3ed2875eb4c",
        ["Superhero"] = "7064a261-a137-4d3a-8848-2d385de3a99c",
        ["Martial Arts"] = "799c202e-7daa-44eb-9cf7-8a3c0441531e",
        ["Fan Colored"] = "7b2ce280-79ef-4c09-9b58-12b7c23a9b78",
        ["Samurai"] = "81183756-1453-4c81-aa9e-f6e1b63be016",
        ["Magical Girls"] = "81c836c9-914a-4eca-981a-560dad663e73",
        ["Mafia"] = "85daba54-a71c-4554-8a28-9901a8b0afad",
        ["Adventure"] = "87cc87cd-a395-47af-b27a-93258283bbc6",
        ["User Created"] = "891cf039-b895-47f0-9229-bef4c96eccd4",
        ["Virtual Reality"] = "8c86611e-fab7-4986-9dec-d1a2f44acdd5",
        ["Office Workers"] = "92d6d951-ca5e-429c-ac78-451071cbf064",
        ["Video Games"] = "9438db5a-7e2a-4ac0-b39e-e0d95a34b8a8",
        ["Post-Apocalyptic"] = "9467335a-1b83-4497-9231-765337a00b96",
        ["Sexual Violence"] = "97893a4c-12af-4dac-b6be-0dffb353568e",
        ["Crossdressing"] = "9ab53f92-3eed-4e9b-903a-917c86035ee3",
        ["Magic"] = "a1f53773-c69a-4ce5-8cab-fffcd90b1565",
        ["Girls' Love"] = "a3c67850-4684-404e-9b7f-c69850ee5da6",
        ["Harem"] = "aafb99c1-7f60-43fa-b75f-fc9502ce29c7",
        ["Military"] = "ac72833b-c4e9-4878-b9db-6c8a4a99444a",
        ["Wuxia"] = "acc803a4-c95a-4c22-86fc-eb6b582d82a2",
        ["Isekai"] = "ace04997-f6bd-436e-b261-779182193d3d",
        ["4-Koma"] = "b11fda93-8f1d-4bef-b2ed-8803d3733170",
        ["Doujinshi"] = "b13b2a48-c720-44a9-9c77-39c9979373fb",
        ["Philosophical"] = "b1e97889-25b4-4258-b28b-cd7f4d28ea9b",
        ["Gore"] = "b29d6a3d-1569-4e7a-8caf-7557bc92cd5d",
        ["Drama"] = "b9af3a63-f058-46de-a9a0-e0c13906197a",
        ["Medical"] = "c8cbe35b-1b2b-4a3f-9c37-db84c4514856",
        ["School Life"] = "caaa44eb-cd40-4177-b930-79d3ef2afe87",
        ["Horror"] = "cdad7e68-1419-41dd-bdce-27753074a640",
        ["Fantasy"] = "cdc58593-87dd-415e-bbc0-2ec27bf404cc",
        ["Villainess"] = "d14322ac-4d6f-4e9b-afd9-629d5f4d8a41",
        ["Vampires"] = "d7d1730f-6eb0-4ba6-9437-602cac38664c",
        ["Delinquents"] = "da2d50ca-3018-4cc0-ac7a-6b7d472a29ea",
        ["Monster Girls"] = "dd1f77c5-dea9-4e2b-97ae-224af09caf99",
        ["Shota"] = "ddefd648-5140-4e5f-ba18-4eca4071d19b",
        ["Police"] = "df33b754-73a3-4c54-80e6-1a74a8058539",
        ["Web Comic"] = "e197df38-d0e7-43b5-9b09-2842d0c326dd",
        ["Slice of Life"] = "e5301a23-ebd9-49dd-a0cb-2add944c7fe9",
        ["Aliens"] = "e64f6742-c834-471d-8d72-dd51fc02b835",
        ["Cooking"] = "ea2bc92d-1c26-4930-9b7c-d5c0dc1b6869",
        ["Supernatural"] = "eabc5b4c-6aff-42f3-b657-3e90cbd00b75",
        ["Mystery"] = "ee968100-4191-4968-93d3-f82d72be7e46",
        ["Adaptation"] = "f4122d1c-3b44-44d0-9936-ff7502c39ad3",
        ["Music"] = "f42fbf9e-188a-447b-9fdc-f19dc1e4d685",
        ["Full Color"] = "f5ba408b-0e7a-484d-8d49-4e9125ac96de",
        ["Tragedy"] = "f8f62932-27da-4fe4-8ee1-6779a8c5edba",
        ["Gyaru"] = "fad12b5e-68ba-460e-b933-9ae8318f5b65"
    }

    local cdnUrl = "https://uploads.mangadex.org"
    local apiUrl = "https://api.mangadex.org"
    local apiMangaUrl = apiUrl .. "/manga"
    local apiChapterUrl = apiUrl .. "/chapter"
    local apiChapterPagesUrl = apiUrl .. "/at-home/server"

    local mangaLimit = 10

    local function stringify(string)
        return string:gsub(
            "\\u(....)",
            function(a)
                return u8c(tonumber("0x" .. a))
            end
        )
    end

    local function downloadContent(link)
        local file = {}
        Threads.insertTask(
            file,
            {
                Type = "StringRequest",
                Link = link,
                Table = file,
                Index = "string"
            }
        )
        while Threads.check(file) do
            coroutine.yield(false)
        end
        return file.string or ""
    end

    local orderTypes = {
        Popular = "followedCount",
        Latest = "latestUploadedChapter",
        BestMatch = "relevance"
    }

    local contentRatings = {
        "safe",
        "suggestive",
        "erotica",
        "pornographic"
    }

    function NewMangaDex:getManga(page, dt, orderType, title, tags)
        if title then
            title = "title=" .. title:gsub(" ", "%%%%20") .. "&"
        else
            title = ""
        end
        local futureUpdates = ""
        --"includeFutureUpdates=0&"
        local contentRating = ""

        if not Settings.NSFW then
            contentRating = "contentRating[]=safe&"
        else
            for i = 1, #contentRatings do
                if contentRatings[i] ~= "pornographic" then
                    contentRating = contentRating .. "contentRating[]=" .. contentRatings[i] .. "&"
                end
            end
        end
        local limit = "limit=" .. mangaLimit .. "&"
        local offset = "offset=" .. mangaLimit * page .. "&"
        local order = "order[" .. orderType .. "]=desc&"
        local coverArt = "includes[]=cover_art"
        local searchFilter = ""
        if tags then
            local originalLanguageTag = tags["Original Language"]

            if originalLanguageTag ~= "All Languages" and self.LangKeys[originalLanguageTag] then
                searchFilter = searchFilter .. "originalLanguage[]=" .. self.LangKeys[originalLanguageTag] .. "&"
            end

            local sortByTag = tags["Sort By"]

            if self.SortKeys[sortByTag] then
                order = "order" .. self.SortKeys[sortByTag] .. "&"
            end

            local demographicTags = tags["Demographic"]

            for i = 1, #demographicTags do
                searchFilter = searchFilter .. "publicationDemographic[]=" .. demographicTags[i]:lower() .. "&"
            end

            local contentRatingTags = tags["Content Rating"]

            if #contentRatingTags > 0 then
                contentRating = ""
                for i = 1, #contentRatingTags do
                    contentRating = contentRating .. "contentRating[]=" .. contentRatingTags[i]:lower() .. "&"
                end
            end

            local pubStatusTags = tags["Publication Status"]

            for i = 1, #pubStatusTags do
                searchFilter = searchFilter .. "status[]=" .. pubStatusTags[i]:lower() .. "&"
            end
            local tagTags = {"Format", "Genre", "Theme"}
            for i = 1, #tagTags do
                local t = tags[tagTags[i]]
                for j = 1, #t.include do
                    local tag = self.TagKeys[t.include[j]]
                    if tag then
                        searchFilter = searchFilter .. "includedTags[]=" .. tag .. "&"
                    end
                end
                for j = 1, #t.exclude do
                    local tag = self.TagKeys[t.exclude[j]]
                    if tag then
                        searchFilter = searchFilter .. "excludedTags[]=" .. tag .. "&"
                    end
                end
            end
        end
        local url = apiMangaUrl .. "?" .. searchFilter .. futureUpdates .. title .. limit .. offset .. contentRating .. order .. coverArt
        if #url > 512 then
            Notifications.push("Very large request, try to change filters and try again")
            dt.NoPages = true
        else
            local managaContent = downloadContent(url)
            dt.NoPages = true
            for Id, Name, ImageLink in managaContent:gmatch('{"id":"([^"]-)","type":"manga",[^{]-{"title":{[^}]-:"([^"]-)".-"type":"cover_art","attributes":{[^}]-"fileName":"([^"]-)"') do
                dt[#dt + 1] = CreateManga(stringify(Name), Id, cdnUrl .. "/covers/" .. Id .. "/" .. ImageLink .. ".256.jpg", self.ID, self.Link .. "/title/" .. Id)
                dt.NoPages = false
                coroutine.yield(false)
            end
        end
    end

    function NewMangaDex:getPopularManga(page, dt)
        self:getManga(page - 1, dt, orderTypes.Popular)
    end

    function NewMangaDex:getLatestManga(page, dt)
        self:getManga(page - 1, dt, orderTypes.Latest)
    end

    function NewMangaDex:searchManga(search, page, dt, tags)
        self:getManga(page - 1, dt, orderTypes.BestMatch, search, tags)
    end

    local function sortOnValues(t, ...)
        local a = {...}
        table.sort(
            t,
            function(u, v)
                for i = 1, #a do
                    if u[a[i]] > v[a[i]] then
                        return false
                    end
                    if u[a[i]] < v[a[i]] then
                        return true
                    end
                end
            end
        )
    end

    local function checkAttributes(t, a)
        local check = t
        for i = 1, #a do
            if not check[a[i]] then
                --Console.write(a[i].." not found")
                return false
            else
                check = check[a[i]]
            end
        end
        return true
    end

    local function addUniqueAttributes(t, a)
        local check = t
        for i = 1, #a do
            if not check[a[i]] then
                check[a[i]] = {}
            end
            check = check[a[i]]
        end
        --Console.write("Unique value added")
    end

    local function uniqueOnValues(t, ...)
        local a = {...}
        local newT = {}
        local unique = {}
        for i = 1, #t do
            local values = {}
            for j = 1, #a do
                values[j] = t[i][a[j]]
            end
            if not checkAttributes(unique, values) then
                addUniqueAttributes(unique, values)
                newT[#newT + 1] = t[i]
            end
        end
        --Console.write("new count:" .. #newT .. " old count:" .. #t)
        return newT
    end

    local countryCodes = {
        ["af"] = {EnglishName = "Afrikaans", NativeName = "Afrikaans"},
        ["af-za"] = {EnglishName = "Afrikaans (South Africa)", NativeName = "Afrikaans (Suid Afrika)"},
        ["am-et"] = {EnglishName = "Amharic (Ethiopia)", NativeName = "አማርኛ (ኢትዮጵያ)"},
        ["ar"] = {EnglishName = "Arabic", NativeName = "العربية"},
        ["ar-ae"] = {EnglishName = "Arabic (U.A.E.)", NativeName = "العربية (الإمارات العربية المتحدة)"},
        ["ar-bh"] = {EnglishName = "Arabic (Bahrain)", NativeName = "العربية (البحرين)"},
        ["ar-dz"] = {EnglishName = "Arabic (Algeria)", NativeName = "العربية (الجزائر)"},
        ["ar-eg"] = {EnglishName = "Arabic (Egypt)", NativeName = "العربية (مصر)"},
        ["ar-iq"] = {EnglishName = "Arabic (Iraq)", NativeName = "العربية (العراق)"},
        ["ar-jo"] = {EnglishName = "Arabic (Jordan)", NativeName = "العربية (الأردن)"},
        ["ar-kw"] = {EnglishName = "Arabic (Kuwait)", NativeName = "العربية (الكويت)"},
        ["ar-lb"] = {EnglishName = "Arabic (Lebanon)", NativeName = "العربية (لبنان)"},
        ["ar-ly"] = {EnglishName = "Arabic (Libya)", NativeName = "العربية (ليبيا)"},
        ["ar-ma"] = {EnglishName = "Arabic (Morocco)", NativeName = "العربية (المملكة المغربية)"},
        ["ar-om"] = {EnglishName = "Arabic (Oman)", NativeName = "العربية (عمان)"},
        ["ar-qa"] = {EnglishName = "Arabic (Qatar)", NativeName = "العربية (قطر)"},
        ["ar-sa"] = {EnglishName = "Arabic (Saudi Arabia)", NativeName = "العربية (المملكة العربية السعودية)"},
        ["ar-sy"] = {EnglishName = "Arabic (Syria)", NativeName = "العربية (سوريا)"},
        ["ar-tn"] = {EnglishName = "Arabic (Tunisia)", NativeName = "العربية (تونس)"},
        ["ar-ye"] = {EnglishName = "Arabic (Yemen)", NativeName = "العربية (اليمن)"},
        ["arn-cl"] = {EnglishName = "Mapudungun (Chile)", NativeName = "Mapudungun (Chile)"},
        ["as-in"] = {EnglishName = "Assamese (India)", NativeName = "অসমীয়া (ভাৰত)"},
        ["az"] = {EnglishName = "Azeri", NativeName = "Azərbaycan­ılı"},
        ["az-cyrl-az"] = {EnglishName = "Azeri (Cyrillic) (Azerbaijan)", NativeName = "Азәрбајҹан (Азәрбајҹан)"},
        ["az-latn-az"] = {EnglishName = "Azeri (Latin) (Azerbaijan)", NativeName = "Azərbaycan­ılı (Azərbaycanca)"},
        ["ba-ru"] = {EnglishName = "Bashkir (Russia)", NativeName = "Башҡорт (Россия)"},
        ["be"] = {EnglishName = "Belarusian", NativeName = "Беларускі"},
        ["be-by"] = {EnglishName = "Belarusian (Belarus)", NativeName = "Беларускі (Беларусь)"},
        ["bg"] = {EnglishName = "Bulgarian", NativeName = "български"},
        ["bg-bg"] = {EnglishName = "Bulgarian (Bulgaria)", NativeName = "български (България)"},
        ["bn-bd"] = {EnglishName = "Bengali (Bangladesh)", NativeName = "বাংলা (বাংলাদেশ)"},
        ["bn-in"] = {EnglishName = "Bengali (India)", NativeName = "বাংলা (ভারত)"},
        ["bo-cn"] = {EnglishName = "Tibetan (People's Republic of China)", NativeName = "བོད་ཡིག (ཀྲུང་ཧྭ་མི་དམངས་སྤྱི་མཐུན་རྒྱལ་ཁབ།)"},
        ["br-fr"] = {EnglishName = "Breton (France)", NativeName = "brezhoneg (Frañs)"},
        ["bs-cyrl-ba"] = {EnglishName = "Bosnian (Cyrillic) (Bosnia and Herzegovina)", NativeName = "босански (Босна и Херцеговина)"},
        ["bs-latn-ba"] = {EnglishName = "Bosnian (Latin) (Bosnia and Herzegovina)", NativeName = "bosanski (Bosna i Hercegovina)"},
        ["ca"] = {EnglishName = "Catalan", NativeName = "català"},
        ["ca-es"] = {EnglishName = "Catalan (Catalan)", NativeName = "català (català)"},
        ["co-fr"] = {EnglishName = "Corsican (France)", NativeName = "Corsu (France)"},
        ["cs"] = {EnglishName = "Czech", NativeName = "čeština"},
        ["cs-cz"] = {EnglishName = "Czech (Czech Republic)", NativeName = "čeština (Česká republika)"},
        ["cy-gb"] = {EnglishName = "Welsh (United Kingdom)", NativeName = "Cymraeg (y Deyrnas Unedig)"},
        ["da"] = {EnglishName = "Danish", NativeName = "dansk"},
        ["da-dk"] = {EnglishName = "Danish (Denmark)", NativeName = "dansk (Danmark)"},
        ["de"] = {EnglishName = "German", NativeName = "Deutsch"},
        ["de-at"] = {EnglishName = "German (Austria)", NativeName = "Deutsch (Österreich)"},
        ["de-ch"] = {EnglishName = "German (Switzerland)", NativeName = "Deutsch (Schweiz)"},
        ["de-de"] = {EnglishName = "German (Germany)", NativeName = "Deutsch (Deutschland)"},
        ["de-li"] = {EnglishName = "German (Liechtenstein)", NativeName = "Deutsch (Liechtenstein)"},
        ["de-lu"] = {EnglishName = "German (Luxembourg)", NativeName = "Deutsch (Luxemburg)"},
        ["dsb-de"] = {EnglishName = "Lower Sorbian (Germany)", NativeName = "dolnoserbšćina (Nimska)"},
        ["dv"] = {EnglishName = "Divehi", NativeName = "ދިވެހިބަސް"},
        ["dv-mv"] = {EnglishName = "Divehi (Maldives)", NativeName = "ދިވެހިބަސް (ދިވެހި ރާއްޖެ)"},
        ["el"] = {EnglishName = "Greek", NativeName = "ελληνικά"},
        ["el-gr"] = {EnglishName = "Greek (Greece)", NativeName = "ελληνικά (Ελλάδα)"},
        ["en"] = {EnglishName = "English", NativeName = "English"},
        ["en-029"] = {EnglishName = "English (Caribbean)", NativeName = "English (Caribbean)"},
        ["en-au"] = {EnglishName = "English (Australia)", NativeName = "English (Australia)"},
        ["en-bz"] = {EnglishName = "English (Belize)", NativeName = "English (Belize)"},
        ["en-ca"] = {EnglishName = "English (Canada)", NativeName = "English (Canada)"},
        ["en-gb"] = {EnglishName = "English (United Kingdom)", NativeName = "English (United Kingdom)"},
        ["en-ie"] = {EnglishName = "English (Ireland)", NativeName = "English (Eire)"},
        ["en-in"] = {EnglishName = "English (India)", NativeName = "English (India)"},
        ["en-jm"] = {EnglishName = "English (Jamaica)", NativeName = "English (Jamaica)"},
        ["en-my"] = {EnglishName = "English (Malaysia)", NativeName = "English (Malaysia)"},
        ["en-nz"] = {EnglishName = "English (New Zealand)", NativeName = "English (New Zealand)"},
        ["en-ph"] = {EnglishName = "English (Republic of the Philippines)", NativeName = "English (Philippines)"},
        ["en-sg"] = {EnglishName = "English (Singapore)", NativeName = "English (Singapore)"},
        ["en-tt"] = {EnglishName = "English (Trinidad and Tobago)", NativeName = "English (Trinidad y Tobago)"},
        ["en-us"] = {EnglishName = "English (United States)", NativeName = "English (United States)"},
        ["en-za"] = {EnglishName = "English (South Africa)", NativeName = "English (South Africa)"},
        ["en-zw"] = {EnglishName = "English (Zimbabwe)", NativeName = "English (Zimbabwe)"},
        ["es"] = {EnglishName = "Spanish", NativeName = "español"},
        ["es-ar"] = {EnglishName = "Spanish (Argentina)", NativeName = "Español (Argentina)"},
        ["es-bo"] = {EnglishName = "Spanish (Bolivia)", NativeName = "Español (Bolivia)"},
        ["es-cl"] = {EnglishName = "Spanish (Chile)", NativeName = "Español (Chile)"},
        ["es-co"] = {EnglishName = "Spanish (Colombia)", NativeName = "Español (Colombia)"},
        ["es-cr"] = {EnglishName = "Spanish (Costa Rica)", NativeName = "Español (Costa Rica)"},
        ["es-do"] = {EnglishName = "Spanish (Dominican Republic)", NativeName = "Español (República Dominicana)"},
        ["es-ec"] = {EnglishName = "Spanish (Ecuador)", NativeName = "Español (Ecuador)"},
        ["es-es"] = {EnglishName = "Spanish (Spain)", NativeName = "español (España)"},
        ["es-gt"] = {EnglishName = "Spanish (Guatemala)", NativeName = "Español (Guatemala)"},
        ["es-hn"] = {EnglishName = "Spanish (Honduras)", NativeName = "Español (Honduras)"},
        ["es-mx"] = {EnglishName = "Spanish (Mexico)", NativeName = "Español (México)"},
        ["es-ni"] = {EnglishName = "Spanish (Nicaragua)", NativeName = "Español (Nicaragua)"},
        ["es-pa"] = {EnglishName = "Spanish (Panama)", NativeName = "Español (Panamá)"},
        ["es-pe"] = {EnglishName = "Spanish (Peru)", NativeName = "Español (Perú)"},
        ["es-pr"] = {EnglishName = "Spanish (Puerto Rico)", NativeName = "Español (Puerto Rico)"},
        ["es-py"] = {EnglishName = "Spanish (Paraguay)", NativeName = "Español (Paraguay)"},
        ["es-sv"] = {EnglishName = "Spanish (El Salvador)", NativeName = "Español (El Salvador)"},
        ["es-us"] = {EnglishName = "Spanish (United States)", NativeName = "Español (Estados Unidos)"},
        ["es-uy"] = {EnglishName = "Spanish (Uruguay)", NativeName = "Español (Uruguay)"},
        ["es-ve"] = {EnglishName = "Spanish (Venezuela)", NativeName = "Español (Republica Bolivariana de Venezuela)"},
        ["es-la"] = {EnglishName = "Spanish (Latin America, Caribbean)", NativeName = "Español (...)"},
        ["es-419 "] = {EnglishName = "Spanish (Latin America, Caribbean)", NativeName = "Español (...)"},
        ["et"] = {EnglishName = "Estonian", NativeName = "eesti"},
        ["et-ee"] = {EnglishName = "Estonian (Estonia)", NativeName = "eesti (Eesti)"},
        ["eu"] = {EnglishName = "Basque", NativeName = "euskara"},
        ["eu-es"] = {EnglishName = "Basque (Basque)", NativeName = "euskara (euskara)"},
        ["fa"] = {EnglishName = "Persian", NativeName = "فارسى"},
        ["fa-ir"] = {EnglishName = "Persian (Iran)", NativeName = "فارسى (ايران)"},
        ["fi"] = {EnglishName = "Finnish", NativeName = "suomi"},
        ["fi-fi"] = {EnglishName = "Finnish (Finland)", NativeName = "suomi (Suomi)"},
        ["fil-ph"] = {EnglishName = "Filipino (Philippines)", NativeName = "Filipino (Pilipinas)"},
        ["fo"] = {EnglishName = "Faroese", NativeName = "føroyskt"},
        ["fo-fo"] = {EnglishName = "Faroese (Faroe Islands)", NativeName = "føroyskt (Føroyar)"},
        ["fr"] = {EnglishName = "French", NativeName = "français"},
        ["fr-be"] = {EnglishName = "French (Belgium)", NativeName = "français (Belgique)"},
        ["fr-ca"] = {EnglishName = "French (Canada)", NativeName = "français (Canada)"},
        ["fr-ch"] = {EnglishName = "French (Switzerland)", NativeName = "français (Suisse)"},
        ["fr-fr"] = {EnglishName = "French (France)", NativeName = "français (France)"},
        ["fr-lu"] = {EnglishName = "French (Luxembourg)", NativeName = "français (Luxembourg)"},
        ["fr-mc"] = {EnglishName = "French (Principality of Monaco)", NativeName = "français (Principauté de Monaco)"},
        ["fy-nl"] = {EnglishName = "Frisian (Netherlands)", NativeName = "Frysk (Nederlân)"},
        ["ga-ie"] = {EnglishName = "Irish (Ireland)", NativeName = "Gaeilge (Éire)"},
        ["gd-gb"] = {EnglishName = "Scottish Gaelic (United Kingdom)", NativeName = "Gàidhlig (An Rìoghachd Aonaichte)"},
        ["gl"] = {EnglishName = "Galician", NativeName = "galego"},
        ["gl-es"] = {EnglishName = "Galician (Galician)", NativeName = "galego (galego)"},
        ["gsw-fr"] = {EnglishName = "Alsatian (France)", NativeName = "Elsässisch (Frànkrisch)"},
        ["gu"] = {EnglishName = "Gujarati", NativeName = "ગુજરાતી"},
        ["gu-in"] = {EnglishName = "Gujarati (India)", NativeName = "ગુજરાતી (ભારત)"},
        ["ha-latn-ng"] = {EnglishName = "Hausa (Latin) (Nigeria)", NativeName = "Hausa (Nigeria)"},
        ["he"] = {EnglishName = "Hebrew", NativeName = "עברית"},
        ["he-il"] = {EnglishName = "Hebrew (Israel)", NativeName = "עברית (ישראל)"},
        ["hi"] = {EnglishName = "Hindi", NativeName = "हिंदी"},
        ["hi-in"] = {EnglishName = "Hindi (India)", NativeName = "हिंदी (भारत)"},
        ["hr"] = {EnglishName = "Croatian", NativeName = "hrvatski"},
        ["hr-ba"] = {EnglishName = "Croatian (Latin) (Bosnia and Herzegovina)", NativeName = "hrvatski (Bosna i Hercegovina)"},
        ["hr-hr"] = {EnglishName = "Croatian (Croatia)", NativeName = "hrvatski (Hrvatska)"},
        ["hsb-de"] = {EnglishName = "Upper Sorbian (Germany)", NativeName = "hornjoserbšćina (Němska)"},
        ["hu"] = {EnglishName = "Hungarian", NativeName = "magyar"},
        ["hu-hu"] = {EnglishName = "Hungarian (Hungary)", NativeName = "magyar (Magyarország)"},
        ["hy"] = {EnglishName = "Armenian", NativeName = "Հայերեն"},
        ["hy-am"] = {EnglishName = "Armenian (Armenia)", NativeName = "Հայերեն (Հայաստան)"},
        ["id"] = {EnglishName = "Indonesian", NativeName = "Bahasa Indonesia"},
        ["id-id"] = {EnglishName = "Indonesian (Indonesia)", NativeName = "Bahasa Indonesia (Indonesia)"},
        ["ig-ng"] = {EnglishName = "Igbo (Nigeria)", NativeName = "Igbo (Nigeria)"},
        ["ii-cn"] = {EnglishName = "Yi (People's Republic of China)", NativeName = "ꆈꌠꁱꂷ (ꍏꉸꏓꂱꇭꉼꇩ)"},
        ["is"] = {EnglishName = "Icelandic", NativeName = "íslenska"},
        ["is-is"] = {EnglishName = "Icelandic (Iceland)", NativeName = "íslenska (Ísland)"},
        ["it"] = {EnglishName = "Italian", NativeName = "italiano"},
        ["it-ch"] = {EnglishName = "Italian (Switzerland)", NativeName = "italiano (Svizzera)"},
        ["it-it"] = {EnglishName = "Italian (Italy)", NativeName = "italiano (Italia)"},
        ["iu-cans-ca"] = {EnglishName = "Inuktitut (Syllabics) (Canada)", NativeName = "ᐃᓄᒃᑎᑐᑦ (ᑲᓇᑕ)"},
        ["iu-latn-ca"] = {EnglishName = "Inuktitut (Latin) (Canada)", NativeName = "Inuktitut (kanata)"},
        ["ja"] = {EnglishName = "Japanese", NativeName = "日本語"},
        ["ja-jp"] = {EnglishName = "Japanese (Japan)", NativeName = "日本語 (日本)"},
        ["ka"] = {EnglishName = "Georgian", NativeName = "ქართული"},
        ["ka-ge"] = {EnglishName = "Georgian (Georgia)", NativeName = "ქართული (საქართველო)"},
        ["kk"] = {EnglishName = "Kazakh", NativeName = "Қазащb"},
        ["kk-kz"] = {EnglishName = "Kazakh (Kazakhstan)", NativeName = "Қазақ (Қазақстан)"},
        ["kl-gl"] = {EnglishName = "Greenlandic (Greenland)", NativeName = "kalaallisut (Kalaallit Nunaat)"},
        ["km-kh"] = {EnglishName = "Khmer (Cambodia)", NativeName = "ខ្មែរ (កម្ពុជា)"},
        ["kn"] = {EnglishName = "Kannada", NativeName = "ಕನ್ನಡ"},
        ["kn-in"] = {EnglishName = "Kannada (India)", NativeName = "ಕನ್ನಡ (ಭಾರತ)"},
        ["ko"] = {EnglishName = "Korean", NativeName = "한국어"},
        ["ko-kr"] = {EnglishName = "Korean (Korea)", NativeName = "한국어 (대한민국)"},
        ["kok"] = {EnglishName = "Konkani", NativeName = "कोंकणी"},
        ["kok-in"] = {EnglishName = "Konkani (India)", NativeName = "कोंकणी (भारत)"},
        ["ky"] = {EnglishName = "Kyrgyz", NativeName = "Кыргыз"},
        ["ky-kg"] = {EnglishName = "Kyrgyz (Kyrgyzstan)", NativeName = "Кыргыз (Кыргызстан)"},
        ["lb-lu"] = {EnglishName = "Luxembourgish (Luxembourg)", NativeName = "Lëtzebuergesch (Luxembourg)"},
        ["lo-la"] = {EnglishName = "Lao (Lao P.D.R.)", NativeName = "ລາວ (ສ.ປ.ປ. ລາວ)"},
        ["lt"] = {EnglishName = "Lithuanian", NativeName = "lietuvių"},
        ["lt-lt"] = {EnglishName = "Lithuanian (Lithuania)", NativeName = "lietuvių (Lietuva)"},
        ["lv"] = {EnglishName = "Latvian", NativeName = "latviešu"},
        ["lv-lv"] = {EnglishName = "Latvian (Latvia)", NativeName = "latviešu (Latvija)"},
        ["mi-nz"] = {EnglishName = "Maori (New Zealand)", NativeName = "Reo Māori (Aotearoa)"},
        ["mk"] = {EnglishName = "Macedonian", NativeName = "македонски јазик"},
        ["mk-mk"] = {EnglishName = "Macedonian (Former Yugoslav Republic of Macedonia)", NativeName = "македонски јазик (Македонија)"},
        ["ml-in"] = {EnglishName = "Malayalam (India)", NativeName = "മലയാളം (ഭാരതം)"},
        ["mn"] = {EnglishName = "Mongolian", NativeName = "Монгол хэл"},
        ["mn-mn"] = {EnglishName = "Mongolian (Cyrillic) (Mongolia)", NativeName = "Монгол хэл (Монгол улс)"},
        ["mn-mong-cn"] = {EnglishName = "Mongolian (Traditional Mongolian) (People's Republic of China)", NativeName = "ᠮᠤᠨᠭᠭᠤᠯ ᠬᠡᠯᠡ (ᠪᠦᠭᠦᠳᠡ ᠨᠠᠢᠷᠠᠮᠳᠠᠬᠤ ᠳᠤᠮᠳᠠᠳᠤ ᠠᠷᠠᠳ ᠣᠯᠣᠰ)"},
        ["moh-ca"] = {EnglishName = "Mohawk (Canada)", NativeName = "Kanien'kéha (Canada)"},
        ["mr"] = {EnglishName = "Marathi", NativeName = "मराठी"},
        ["mr-in"] = {EnglishName = "Marathi (India)", NativeName = "मराठी (भारत)"},
        ["ms"] = {EnglishName = "Malay", NativeName = "Bahasa Malaysia"},
        ["ms-bn"] = {EnglishName = "Malay (Brunei Darussalam)", NativeName = "Bahasa Malaysia (Brunei Darussalam)"},
        ["ms-my"] = {EnglishName = "Malay (Malaysia)", NativeName = "Bahasa Malaysia (Malaysia)"},
        ["mt-mt"] = {EnglishName = "Maltese (Malta)", NativeName = "Malti (Malta)"},
        ["nb-no"] = {EnglishName = "Norwegian, Bokmål (Norway)", NativeName = "norsk, bokmål (Norge)"},
        ["ne-np"] = {EnglishName = "Nepali (Nepal)", NativeName = "नेपाली (नेपाल)"},
        ["nl"] = {EnglishName = "Dutch", NativeName = "Nederlands"},
        ["nl-be"] = {EnglishName = "Dutch (Belgium)", NativeName = "Nederlands (België)"},
        ["nl-nl"] = {EnglishName = "Dutch (Netherlands)", NativeName = "Nederlands (Nederland)"},
        ["nn-no"] = {EnglishName = "Norwegian, Nynorsk (Norway)", NativeName = "norsk, nynorsk (Noreg)"},
        ["no"] = {EnglishName = "Norwegian", NativeName = "norsk"},
        ["nso-za"] = {EnglishName = "Sesotho sa Leboa (South Africa)", NativeName = "Sesotho sa Leboa (Afrika Borwa)"},
        ["oc-fr"] = {EnglishName = "Occitan (France)", NativeName = "Occitan (França)"},
        ["or-in"] = {EnglishName = "Oriya (India)", NativeName = "ଓଡ଼ିଆ (ଭାରତ)"},
        ["pa"] = {EnglishName = "Punjabi", NativeName = "ਪੰਜਾਬੀ"},
        ["pa-in"] = {EnglishName = "Punjabi (India)", NativeName = "ਪੰਜਾਬੀ (ਭਾਰਤ)"},
        ["pl"] = {EnglishName = "Polish", NativeName = "polski"},
        ["pl-pl"] = {EnglishName = "Polish (Poland)", NativeName = "polski (Polska)"},
        ["prs-af"] = {EnglishName = "Dari (Afghanistan)", NativeName = "درى (افغانستان)"},
        ["ps-af"] = {EnglishName = "Pashto (Afghanistan)", NativeName = "پښتو (افغانستان)"},
        ["pt"] = {EnglishName = "Portuguese", NativeName = "Português"},
        ["pt-br"] = {EnglishName = "Portuguese (Brazil)", NativeName = "Português (Brasil)"},
        ["pt-pt"] = {EnglishName = "Portuguese (Portugal)", NativeName = "português (Portugal)"},
        ["qut-gt"] = {EnglishName = "K'iche (Guatemala)", NativeName = "K'iche (Guatemala)"},
        ["quz-bo"] = {EnglishName = "Quechua (Bolivia)", NativeName = "runasimi (Bolivia Suyu)"},
        ["quz-ec"] = {EnglishName = "Quechua (Ecuador)", NativeName = "runasimi (Ecuador Suyu)"},
        ["quz-pe"] = {EnglishName = "Quechua (Peru)", NativeName = "runasimi (Peru Suyu)"},
        ["rm-ch"] = {EnglishName = "Romansh (Switzerland)", NativeName = "Rumantsch (Svizra)"},
        ["ro"] = {EnglishName = "Romanian", NativeName = "română"},
        ["ro-ro"] = {EnglishName = "Romanian (Romania)", NativeName = "română (România)"},
        ["ru"] = {EnglishName = "Russian", NativeName = "русский"},
        ["ru-ru"] = {EnglishName = "Russian (Russia)", NativeName = "русский (Россия)"},
        ["rw-rw"] = {EnglishName = "Kinyarwanda (Rwanda)", NativeName = "Kinyarwanda (Rwanda)"},
        ["sa"] = {EnglishName = "Sanskrit", NativeName = "संस्कृत"},
        ["sa-in"] = {EnglishName = "Sanskrit (India)", NativeName = "संस्कृत (भारतम्)"},
        ["sah-ru"] = {EnglishName = "Yakut (Russia)", NativeName = "саха (Россия)"},
        ["se-fi"] = {EnglishName = "Sami (Northern) (Finland)", NativeName = "davvisámegiella (Suopma)"},
        ["se-no"] = {EnglishName = "Sami (Northern) (Norway)", NativeName = "davvisámegiella (Norga)"},
        ["se-se"] = {EnglishName = "Sami (Northern) (Sweden)", NativeName = "davvisámegiella (Ruoŧŧa)"},
        ["si-lk"] = {EnglishName = "Sinhala (Sri Lanka)", NativeName = "සිංහ (ශ්‍රී ලංකා)"},
        ["sk"] = {EnglishName = "Slovak", NativeName = "slovenčina"},
        ["sk-sk"] = {EnglishName = "Slovak (Slovakia)", NativeName = "slovenčina (Slovenská republika)"},
        ["sl"] = {EnglishName = "Slovenian", NativeName = "slovenski"},
        ["sl-si"] = {EnglishName = "Slovenian (Slovenia)", NativeName = "slovenski (Slovenija)"},
        ["sma-no"] = {EnglishName = "Sami (Southern) (Norway)", NativeName = "åarjelsaemiengiele (Nöörje)"},
        ["sma-se"] = {EnglishName = "Sami (Southern) (Sweden)", NativeName = "åarjelsaemiengiele (Sveerje)"},
        ["smj-no"] = {EnglishName = "Sami (Lule) (Norway)", NativeName = "julevusámegiella (Vuodna)"},
        ["smj-se"] = {EnglishName = "Sami (Lule) (Sweden)", NativeName = "julevusámegiella (Svierik)"},
        ["smn-fi"] = {EnglishName = "Sami (Inari) (Finland)", NativeName = "sämikielâ (Suomâ)"},
        ["sms-fi"] = {EnglishName = "Sami (Skolt) (Finland)", NativeName = "sääm´ǩiõll (Lää´ddjânnam)"},
        ["sq"] = {EnglishName = "Albanian", NativeName = "shqipe"},
        ["sq-al"] = {EnglishName = "Albanian (Albania)", NativeName = "shqipe (Shqipëria)"},
        ["sr"] = {EnglishName = "Serbian", NativeName = "srpski"},
        ["sr-cyrl-ba"] = {EnglishName = "Serbian (Cyrillic) (Bosnia and Herzegovina)", NativeName = "српски (Босна и Херцеговина)"},
        ["sr-cyrl-cs"] = {EnglishName = "Serbian (Cyrillic) (Serbia and Montenegro (Former))", NativeName = "српски (Србија и Црна Гора (Претходно))"},
        ["sr-cyrl-me"] = {EnglishName = "Serbian (Cyrillic) (Montenegro)", NativeName = "српски (Црна Гора)"},
        ["sr-cyrl-rs"] = {EnglishName = "Serbian (Cyrillic) (Serbia)", NativeName = "српски (Србија)"},
        ["sr-latn-ba"] = {EnglishName = "Serbian (Latin) (Bosnia and Herzegovina)", NativeName = "srpski (Bosna i Hercegovina)"},
        ["sr-latn-cs"] = {EnglishName = "Serbian (Latin) (Serbia and Montenegro (Former))", NativeName = "srpski (Srbija i Crna Gora (Prethodno))"},
        ["sr-latn-me"] = {EnglishName = "Serbian (Latin) (Montenegro)", NativeName = "srpski (Crna Gora)"},
        ["sr-latn-rs"] = {EnglishName = "Serbian (Latin) (Serbia)", NativeName = "srpski (Srbija)"},
        ["sv"] = {EnglishName = "Swedish", NativeName = "svenska"},
        ["sv-fi"] = {EnglishName = "Swedish (Finland)", NativeName = "svenska (Finland)"},
        ["sv-se"] = {EnglishName = "Swedish (Sweden)", NativeName = "svenska (Sverige)"},
        ["sw"] = {EnglishName = "Kiswahili", NativeName = "Kiswahili"},
        ["sw-ke"] = {EnglishName = "Kiswahili (Kenya)", NativeName = "Kiswahili (Kenya)"},
        ["syr"] = {EnglishName = "Syriac", NativeName = "ܣܘܪܝܝܐ"},
        ["syr-sy"] = {EnglishName = "Syriac (Syria)", NativeName = "ܣܘܪܝܝܐ (سوريا)"},
        ["ta"] = {EnglishName = "Tamil", NativeName = "தமிழ்"},
        ["ta-in"] = {EnglishName = "Tamil (India)", NativeName = "தமிழ் (இந்தியா)"},
        ["te"] = {EnglishName = "Telugu", NativeName = "తెలుగు"},
        ["te-in"] = {EnglishName = "Telugu (India)", NativeName = "తెలుగు (భారత దేశం)"},
        ["tg-cyrl-tj"] = {EnglishName = "Tajik (Cyrillic) (Tajikistan)", NativeName = "Тоҷикӣ (Тоҷикистон)"},
        ["th"] = {EnglishName = "Thai", NativeName = "ไทย"},
        ["th-th"] = {EnglishName = "Thai (Thailand)", NativeName = "ไทย (ไทย)"},
        ["tk-tm"] = {EnglishName = "Turkmen (Turkmenistan)", NativeName = "türkmençe (Türkmenistan)"},
        ["tn-za"] = {EnglishName = "Setswana (South Africa)", NativeName = "Setswana (Aforika Borwa)"},
        ["tr"] = {EnglishName = "Turkish", NativeName = "Türkçe"},
        ["tr-tr"] = {EnglishName = "Turkish (Turkey)", NativeName = "Türkçe (Türkiye)"},
        ["tt"] = {EnglishName = "Tatar", NativeName = "Татар"},
        ["tt-ru"] = {EnglishName = "Tatar (Russia)", NativeName = "Татар (Россия)"},
        ["tzm-latn-dz"] = {EnglishName = "Tamazight (Latin) (Algeria)", NativeName = "Tamazight (Djazaïr)"},
        ["ug-cn"] = {EnglishName = "Uyghur (People's Republic of China)", NativeName = "ئۇيغۇرچە (جۇڭخۇا خەلق جۇمھۇرىيىتى)"},
        ["uk"] = {EnglishName = "Ukrainian", NativeName = "україньска"},
        ["uk-ua"] = {EnglishName = "Ukrainian (Ukraine)", NativeName = "україньска (Україна)"},
        ["ur"] = {EnglishName = "Urdu", NativeName = "اُردو"},
        ["ur-pk"] = {EnglishName = "Urdu (Islamic Republic of Pakistan)", NativeName = "اُردو (پاکستان)"},
        ["uz"] = {EnglishName = "Uzbek", NativeName = "U'zbek"},
        ["uz-cyrl-uz"] = {EnglishName = "Uzbek (Cyrillic) (Uzbekistan)", NativeName = "Ўзбек (Ўзбекистон)"},
        ["uz-latn-uz"] = {EnglishName = "Uzbek (Latin) (Uzbekistan)", NativeName = "U'zbek (U'zbekiston Respublikasi)"},
        ["vi"] = {EnglishName = "Vietnamese", NativeName = "Tiếng Việt"},
        ["vi-vn"] = {EnglishName = "Vietnamese (Vietnam)", NativeName = "Tiếng Việt (Việt Nam)"},
        ["wo-sn"] = {EnglishName = "Wolof (Senegal)", NativeName = "Wolof (Sénégal)"},
        ["xh-za"] = {EnglishName = "isiXhosa (South Africa)", NativeName = "isiXhosa (uMzantsi Afrika)"},
        ["yo-ng"] = {EnglishName = "Yoruba (Nigeria)", NativeName = "Yoruba (Nigeria)"},
        ["zh-chs"] = {EnglishName = "Chinese (Simplified)", NativeName = "中文(简体)"},
        ["zh-cht"] = {EnglishName = "Chinese (Traditional)", NativeName = "中文(繁體)"},
        ["zh-cn"] = {EnglishName = "Chinese (People's Republic of China)", NativeName = "中文(中华人民共和国)"},
        ["zh-hk"] = {EnglishName = "Chinese (Hong Kong S.A.R.)", NativeName = "中文(香港特别行政區)"},
        ["zh-mo"] = {EnglishName = "Chinese (Macao S.A.R.)", NativeName = "中文(澳門特别行政區)"},
        ["zh-sg"] = {EnglishName = "Chinese (Singapore)", NativeName = "中文(新加坡)"},
        ["zh-tw"] = {EnglishName = "Chinese (Taiwan)", NativeName = "中文(台灣)"},
        ["zu-za"] = {EnglishName = "isiZulu (South Africa)", NativeName = "isiZulu (iNingizimu Afrika)"},
        [""] = {EnglishName = "Unknown Language", NativeName = "Unknown Language"}
    }
    local includeInAllLang = {
        "en",
        "en-029",
        "en-au",
        "en-bz",
        "en-ca",
        "en-gb",
        "en-ie",
        "en-in",
        "en-jm",
        "en-my",
        "en-nz",
        "en-ph",
        "en-sg",
        "en-tt",
        "en-us",
        "en-za",
        "en-zw"
    }
    local languagePoints = {
        Russian = {
            "ru",
            "ru-ru"
        },
        English = {},
        Turkish = {
            "tr",
            "tr-tr"
        },
        Spanish = {
            "es",
            "es-ar",
            "es-bo",
            "es-cl",
            "es-co",
            "es-cr",
            "es-do",
            "es-ec",
            "es-es",
            "es-gt",
            "es-hn",
            "es-mx",
            "es-ni",
            "es-pa",
            "es-pe",
            "es-pr",
            "es-py",
            "es-sv",
            "es-us",
            "es-uy",
            "es-ve",
            "es-la"
        },
        Vietnamese = {
            "vi",
            "vi-vn"
        },
        French = {
            "fr",
            "fr-be",
            "fr-ca",
            "fr-ch",
            "fr-fr",
            "fr-lu",
            "fr-mc"
        },
        Italian = {
            "it",
            "it-ch",
            "it-it"
        },
        PortugueseBR = {
            "pt",
            "pt-br",
            "pt-pt"
        },
        SimplifiedChinese = {
            "zh-chs",
            "zh-cht",
            "zh-cn",
            "zh-hk",
            "zh-mo",
            "zh-sg",
            "zh-tw",
            "zu-za"
        },
        TraditionalChinese = {
            "zh-cht",
            "zh-chs",
            "zh-cn",
            "zh-hk",
            "zh-mo",
            "zh-sg",
            "zh-tw",
            "zu-za"
        },
        Romanian = {
            "ro",
            "ro-ro"
        },
        Polish = {
            "pl",
            "pl-pl"
        },
        German = {
            "de",
            "de-at",
            "de-ch",
            "de-de",
            "de-li",
            "de-lu"
        },
        Default = {}
    }

    for _, v in pairs(languagePoints) do
        for i = 1, #includeInAllLang do
            v[#v + 1] = includeInAllLang[i]
        end
    end

    for _, v in pairs(languagePoints) do
        for i = 1, #v do
            v[v[i]] = (-(#v) + i) - 1
        end
    end

    for _, langName in ipairs(GetLanguages()) do
        if languagePoints[langName] == nil then
            languagePoints[langName] = languagePoints.English
        end
    end

    for _, langName in ipairs(GetLanguages()) do
        if langName ~= "Default" then
            if Language[langName] == Language.Default then
                languagePoints.Default = languagePoints[langName] or languagePoints.English
            end
        end
    end

    function NewMangaDex:getChapters(manga, dt)
        do -- description parser
            local content = downloadContent(apiMangaUrl .. "/" .. manga.Link)
            local descriptionList = {}
            for descriptions in content:gmatch('"description":{([^}]-)}') do
                for lang, description in descriptions:gmatch('"([^"]-)":"([^"]-)"') do
                    local langPoints = 0
                    if lang and languagePoints[Settings.Language] and languagePoints[Settings.Language][lang:lower()] then
                        langPoints = languagePoints[Settings.Language][lang:lower()]
                    end
                    descriptionList[#descriptionList + 1] = {
                        Language = lang,
                        Description = description,
                        LanguagePoints = langPoints
                    }
                end
            end
            if #descriptionList > 0 then
                sortOnValues(descriptionList, "LanguagePoints", "Language")
                dt.Description = stringify(descriptionList[1].Description:gsub("\\n", "\n"):gsub("\\/", "/"))
            end
        end
        local page = 0
        local t = {}
        local a = 0
        local contentRating = ""
        for i = 1, #contentRatings do
            contentRating = contentRating .. "contentRating[]=" .. contentRatings[i] .. "&"
        end
        while true do
            local content = downloadContent(apiChapterUrl .. "?manga=" .. manga.Link .. "&" .. contentRating .. "limit=100&offset=" .. (page * 100))
            for id, volume, chapter, title, translatedLanguage in content:gmatch('{"id":"([^"]-)","type":"chapter",[^{]-{"volume":([^,]-),"chapter":"([^"]-)","title":([^,]-),"translatedLanguage":"([^"]-)"') do
                volume = volume:match('"([^"]-)"') or volume
                if volume == "null" then
                    volume = -1
                else
                    volume = volume:gsub(",", ".")
                    volume = tonumber(volume) or volume
                end
                if title == "null" then
                    title = ""
                else
                    title = stringify(title) or title
                end
                chapter = chapter:gsub(",", ".")
                local langPoints = 0
                if translatedLanguage and languagePoints[Settings.Language] and languagePoints[Settings.Language][translatedLanguage:lower()] then
                    langPoints = languagePoints[Settings.Language][translatedLanguage:lower()]
                end
                t[#t + 1] = {
                    Id = id,
                    Volume = tonumber(volume) or 0,
                    Chapter = tonumber(chapter) or chapter,
                    CompareChapter = tonumber(chapter) or tonumber(chapter:match("%d*")) or 0,
                    Title = stringify(title),
                    TranslatedLanguage = (translatedLanguage or ""):lower(),
                    LanguagePoints = langPoints
                }
            end
            if a == #t then
                break
            else
                a = #t
            end
            page = page + 1
            coroutine.yield(true)
        end
        t = uniqueOnValues(t, "LanguagePoints", "TranslatedLanguage", "Volume", "CompareChapter")
        sortOnValues(t, "LanguagePoints", "TranslatedLanguage", "Volume", "CompareChapter")
        for i = 1, #t do
            local lang = ""
            if countryCodes[t[i].TranslatedLanguage] then
                lang = countryCodes[t[i].TranslatedLanguage].EnglishName
            else
                lang = t[i].TranslatedLanguage
            end

            dt[i] = {
                Link = t[i].Id,
                Name = (t[i].Volume >= 0 and ("Volume " .. t[i].Volume .. " ") or "") .. "Chapter " .. t[i].Chapter .. (t[i].Title and t[i].Title ~= "" and (" - " .. t[i].Title) or "") .. " '" .. lang .. "'",
                Pages = {},
                Manga = manga
            }
        end
    end

    function NewMangaDex:prepareChapter(chapter, dt)
        local content = downloadContent(apiChapterPagesUrl .. "/" .. chapter.Link)
        local baseUrl = content:match('"baseUrl":"([^"]-)"')
        local hash = content:match('"hash":"([^"]-)"')
        local data = content:match('"data":%[([^%]]-)]')
        if not (baseUrl or data or hash) then
            return
        end
        for image in data:gmatch('"([^"]-)"') do
            dt[#dt + 1] = baseUrl:gsub("\\", "") .. "/data/" .. hash .. "/" .. image
        end
    end

    function NewMangaDex:loadChapterPage(link, dt)
        dt.Link = link
    end
end
