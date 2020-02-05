if tonumber(Settings.Version) < 0.20 then
    local done_in_launch = false
    if not Threads then
        loadlib("net")
        Settings:load()
        done_in_launch = true
    end
    if Threads.netActionUnSafe(Network.isWifiEnabled) then
        local broken_lang = {
            Russian = {
                update_available = "Доступно обновление: ",
                current_version = "Текущая версия: ",
                press_message = "Нажмите X чтобы скачать\nНажмите O чтобы пропустить и продолжить\n",
                downloading = "Скачивание",
                instruction = "Зайдите в VitaShell в директорию ux0:data/noboru/ и установите NOBORU.vpk"
            },
            English = {
                update_available = "There is new version available: ",
                current_version = "Current version: ",
                press_message = "Press X to Download\nPress O to cancel and continue\n",
                downloading = "Downloading",
                instruction = "Please open VitaShell, go to ux0:data/noboru/ and install NOBORU.vpk"
            }
        }
        local lang = Settings.Language
        local language_now = System.getLanguage()
        if language_now == 8 then
            broken_lang.Default = broken_lang.Russian
        else
            broken_lang.Default = broken_lang.English
        end
        local file = {}
        Threads.addTask("AppUpdateCheck", {
            Type = "StringRequest",
            Link = "https://github.com/Creckeryop/NOBORU/releases/latest",
            Table = file,
            Index = "string",
        })
        while Threads.check("AppUpdateCheck") do
            Threads.update()
        end
        local content = file.string or ""
        local Version, VpkLink = content:match('d%-block mb%-1.-title=\"(.-)\".-"(%S-.vpk)"')
        local changes = content:match('markdown%-body">%s-(.-)</div>'):gsub("<li>"," * "):gsub("<[^>]->",""):gsub("\n\n","\n"):gsub("^\n+%s+",""):gsub("%s+$","")
        if Version and VpkLink and tonumber(Settings.Version) ~= tonumber(Version) then
            local decide = false
            local Tim = Timer.new()
            while true do
                Graphics.initBlend()
                Screen.clear()
                if not decide then
                    Font.print(FONT16, 0, 0, broken_lang[lang].update_available..Version.."\n"..broken_lang[lang].current_version..Settings.Version.."\nDescription:\n"..changes.."\n\n"..broken_lang[lang].press_message,COLOR_WHITE)
                else
                    if Threads.check("AppUpdate") then
                        Font.print(FONT20, 0, 0, broken_lang[lang].downloading..string.rep(".", math.ceil(Timer.getTime(Tim)/800)%3 + 1), COLOR_ROYAL_BLUE)
                    else
                        Font.print(FONT20, 0, 0, broken_lang[lang].instruction, Color.new(255,255,255))
                    end
                end
                Graphics.termBlend()
                Screen.flip()
                Screen.waitVblankStart()
                if not decide then
                    local pad = Controls.read()
                    if Controls.check(pad, SCE_CTRL_CIRCLE) then
                        Timer.destroy(Tim)
                        break
                    elseif Controls.check(pad, SCE_CTRL_CROSS) then
                        Threads.addTask("AppUpdate", {
                            Type = "FileDownload",
                            Link = "https://github.com"..VpkLink,
                            Path = "NOBORU.vpk"
                        })
                        decide = true
                    end
                end
                Threads.update()
            end
        end
    end
    while Threads.getTasksNum()~=0 do
        Threads.update()
    end
    Threads.update()
end