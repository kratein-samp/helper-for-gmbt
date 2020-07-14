script_name('Lua Helper A-RP')
script_author('Cameron_Quinlee')
script_description('Helper for noob')

require "lib.moonloader"
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = "1.1"

local script_path = thisScript().path
local script_url = ""

local update_path = getWorkingDirectory() .. "/update.ini"
local update_url = "https://raw.githubusercontent.com/kratein-samp/helper-for-arp/master/update.ini"

function main()
	if not isSampLoaded() or not isSampfuncsLoaded then return end
	while not isSampAvailable() do wait(100) end

	sampAddChatMessage("[ADVANCE HELPER] Âàø ëè÷íûé ïîìîùíèê, óñïåøíî çàïóùåí.",-1)
	sampAddChatMessage("[ADVANCE HELPER] ×òîáû óçíàòü êîìàíäû, ââåäèòå: /helpc.",-1)
	sampAddChatMessage("[ADVANCE HELPER] Ñâÿçü ñ àäìèíèñòðàòîðîì: https://vk.com/kratein",-1)

	sampRegisterChatCommand("clearchat",cc)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)

	downloadUrlToFile(update_url,update_path,function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
			updateini = inicfg.load(nil, update_path)
			if tonumber(updateini.info.vers) > script_vers then 
				sampAddChatMessage("Åñòü îáíîâëåíèå! Âåðñèÿ: " .. updateini.info.vers_text,-1)
				sampAddChatMessage("Âàøà âåðñèÿ: " .. script_vers_text,-1)
				update_state = true
			end
			os.remove(update_path)
		end
	end)

	while true do
		wait(0)
		if update_state then
			downloadUrlToFile(script_url,script_path,function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
					sampAddChatMessage("îáíîâëåí", -1)
					thisScript():reload()
				end
			end)
			break
		end
	end
end

function cc()
	local memory = require "memory"
	memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
	memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
	memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
	sampAddChatMessage("×àò î÷èùåí",-1)
end
