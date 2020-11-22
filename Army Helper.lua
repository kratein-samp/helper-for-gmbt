script_name('army helper') -- название скрипта
script_author('Cameron Quinlee') -- автор скрипта
script_description('Helper for Army.') -- описание скрипта

local imgui = require 'imgui'
local notify = import 'lib_imgui_notf.lua'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local key = require 'vkeys'
local tag = "{D2691E}[Army Helper]{FFFFFF} "

encoding.default = 'CP1251'
u8 = encoding.UTF8

local main_window_state = imgui.ImBool(false)
update_state = false

local script_vers = 1
local script_vers_text = "1.01"

local update_url = "https://raw.githubusercontent.com/kratein-samp/helper-for-arp/master/update.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "/update.ini" -- и тут свою ссылку

local script_url = "https://github.com/kratein-samp/helper-for-arp/blob/master/Army%20Helper.lua" -- тут свою ссылку
local script_path = thisScript().path

function imgui.OnDrawFrame()
  if main_window_state.v then -- чтение и запись значения такой переменной осуществляется через поле v (или Value)
    imgui.SetNextWindowSize(imgui.ImVec2(150, 200), imgui.Cond.FirstUseEver) -- меняем размер
    -- но для передачи значения по указателю - обязательно напрямую
    -- тут main_window_state передаётся функции imgui.Begin, чтобы можно было отследить закрытие окна нажатием на крестик
    imgui.Begin('My window', main_window_state)
    imgui.Text('Hello world')
    if imgui.Button('Press me') then -- а вот и кнопка с действием
      -- условие будет выполнено при нажатии на неё
      printStringNow('Button pressed!', 1000)
    end
    imgui.End()
  end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
	
	sampAddChatMessage(tag .. "Помощник активирован! Создан специально для Advance RolePlay.", 0xD2691E)
	sampAddChatMessage(tag .. "Чтобы открыть меню помощника введите команду: /ah", 0xD2691E)
	sampRegisterChatCommand("ah", ah)
	  downloadUrlToFile(update_url, update_path, function(id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				updateIni = inicfg.load(nil, update_path)
				if tonumber(updateIni.info.vers) > script_vers then
					sampAddChatMessage("Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
					update_state = true
				end
				os.remove(update_path)
			end
		end)
		
		while true do
			wait(0)

			if update_state then
				downloadUrlToFile(script_url, script_path, function(id, status)
					if status == dlstatus.STATUS_ENDDOWNLOADDATA then
						sampAddChatMessage("Скрипт успешно обновлен!", -1)
						thisScript():reload()
					end
				end)
				break
			end

		end
end
function ah()
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
	notify.addNotify("тест", "ТЕСТ", 1, 2, 5)
end