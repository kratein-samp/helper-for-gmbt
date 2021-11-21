script_name('Autoupdate script') -- íàçâàíèå ñêðèïòà
script_author('FORMYS') -- àâòîð ñêðèïòà
script_description('Autoupdate') -- îïèñàíèå ñêðèïòà

require "lib.moonloader" -- ïîäêëþ÷åíèå áèáëèîòåêè
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = "1.02"

local update_url = "https://raw.githubusercontent.com/kratein-samp/helper-for-gmbt/master/update.ini" -- òóò òîæå ñâîþ ññûëêó
local update_path = getWorkingDirectory() .. "/update.ini" -- è òóò ñâîþ ññûëêó

local script_url = "https://github.com/kratein-samp/helper-for-gmbt/blob/master/blackcatscript.lua?raw=true" -- òóò ñâîþ ññûëêó
local script_path = thisScript().path


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    sampRegisterChatCommand("update", cmd_update)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("Åñòü îáíîâëåíèå! Âåðñèÿ: " .. updateIni.info.vers_text, -1)
                update_state = true
			else
				sampAddChatMessage("Îáíîâëåíèé íåò!", -1)
			end
            os.remove(update_path)
        end
    end)
    
	while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Ñêðèïò óñïåøíî îáíîâëåí!", -1)
                    thisScript():reload()
                end
            end)
            break
        end

	end
end

function cmd_update(arg)
    sampShowDialog(1000, "Àâòîîáíîâëåíèå v2.0", "{FFFFFF}Ýòî óðîê ïî îáíîâëåíèþ\n{FFF000}Íîâàÿ âåðñèÿ", "Çàêðûòü", "", 0)
end
