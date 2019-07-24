--==============================================================
-- Main code (functionality, events, etc.)
--==============================================================

-- constants
local NOTEWORTHY_VERSION = 2000
local NOTEWORTHY_VTEXT = "2.0-alpha"
local MAX_CHAT_LINES = 30
local TAB_CHAR = 1
local TAB_SHARED = 2
local TAB_QUICK = 3
local TAB_OPT = 4
BUTTON_TOOLTIP = "|cFFFFFFFFNoteworthy|r\nLeft-click: Toggle window\nRight-click: Quick Notes menu"

-- set saved variable to table to store all settings
if not Noteworthy_DB then Noteworthy_DB = {} end

-- session vars
Noteworthy_character = "" -- selected character
Noteworthy_Snd_Type_File = -10
Noteworthy_Snd_Type_Kit = -20
local Noteworthy_plrID = 0 -- player character ID
local Noteworthy_current_tab = 1 -- ID of current tab
local Noteworthy_textbox -- current visible textbox (diff to Ghost_CurrentEditBox which is focussed box)
local Noteworthy_text = {} -- character notes text
local Noteworthy_reminder = {} -- character reminder flags
local Noteworthy_bufferTxt = {} -- text buffer for quick notes
local Noteworthy_bufferID = 1 -- current buffer entry


----------------------------------------------------------------
-- Initialise code
----------------------------------------------------------------

-- get Noteworthy charactger id
function Noteworthy_GetPlrID()
    for c = 1, Noteworthy_DB["character_count"], 1 do
	if Noteworthy_DB["character_list"][c] == Noteworthy_character then return c end
    end

    return 0 -- return 0 if character not in table
end

-- variable initialisation
function Noteworthy_Initialise()
    local startupMsg = "|cFFFF7D0ANoteworthy V" .. NOTEWORTHY_VTEXT .. " loaded.|r"

    Noteworthy_character = UnitName("player")

    --Noteworthy_DB["version"] = 1010		-- temporarily uncomment this line & change number to reset to previous version
    --Noteworthy_DB["initialised"] = nil	-- temporarily uncomment this line to reset default settings (but not notes)
    --Noteworthy_DB = {}                        -- temporarily uncomment this line to reset ALL saved data

    -- version check
    if Noteworthy_DB["initialised"] == nil then
	startupMsg = "|cFF00FF00Noteworthy V" .. NOTEWORTHY_VTEXT .. " installed.|r"
	Noteworthy_SetDefaults()
    end
    if Noteworthy_DB["version"] ~= NOTEWORTHY_VERSION then
	startupMsg = "|cFF00FF00Noteworthy updated to V" .. NOTEWORTHY_VTEXT .. "|r"
	Noteworthy_SetDefaults()
    end

    -- set notes text if nil
    if Noteworthy_DB["shared_text"] == nil then
	Noteworthy_DB["shared_text"] = "These notes are shared between all of your characters."
    end

    if Noteworthy_DB["quick_text"] == nil then
	Noteworthy_DB["quick_text"] = "This page is used to store quick notes created via the context menu (right-click minimap and floating buttons, or use /quicknotes or QuickNotes macro)."
    end

    -- character check
    if Noteworthy_DB["character_count"] == nil or Noteworthy_DB["character_list"] == nil then
	Noteworthy_DB["character_count"] = 0
	Noteworthy_DB["character_list"] = {}
    end

    -- check if character has been added to table
    Noteworthy_plrID = Noteworthy_GetPlrID()

    if Noteworthy_plrID == 0 then
	Noteworthy_DB["character_count"] = Noteworthy_DB["character_count"] + 1
	Noteworthy_DB["character_list"][Noteworthy_DB["character_count"]] = Noteworthy_character
	Noteworthy_DB[Noteworthy_character] = Noteworthy_character .. "'s notes."

	-- sort character list
	table.sort(Noteworthy_DB["character_list"])

	-- update plr ID
	Noteworthy_plrID = Noteworthy_GetPlrID()
    end

    if Noteworthy_DB["last_char"] == nil then Noteworthy_DB["last_char"] = Noteworthy_plrID end

    -- broker setup
    Noteworthy_InitBroker()

    -- set gadgdets from saved vars
    Noteworthy_VersionLabelText:SetText("V" .. NOTEWORTHY_VTEXT)
    Noteworthy_ResetGadgetInfo()
    Noteworthy_SetInterface()

    -- configure dropdown menu
    Noteworthy_CreateDropDown()

    -- set initial tab etc.
    if Noteworthy_DB["remember_page"] then
	Noteworthy_SetTab(Noteworthy_DB["last_tab"])

	if Noteworthy_current_tab == TAB_CHAR then Noteworthy_ChangeCharacter(Noteworthy_DB["last_char"]) end

	Ghost_CursorPos = Noteworthy_DB["last_curs"]
	Noteworthy_SetTextFocus(Ghost_CursorPos)
    else
	Noteworthy_SetTab(1)
    end

    -- check for reminder
    if Noteworthy_DB["Remind_" .. Noteworthy_character] then
	Noteworthy_ReminderLabelText:SetText("You have a reminder set for " .. Noteworthy_character)
	Noteworthy_AlertWindow:Show()
    end

    print(startupMsg .. " Use buttons or /noteworthy to open.")
end

function Noteworthy_SetDefaults()
    -- V1.0 settings
    if Noteworthy_DB["initialised"] == nil then
	Noteworthy_DB["version"] = 1000
	Noteworthy_DB["last_tab"] = 1
	Noteworthy_DB["last_curs"] = 1

	Noteworthy_DB["remember_page"] = false
	Noteworthy_DB["focus_text"] = true
	Noteworthy_DB["combat_close"] = true
	Noteworthy_DB["save_on_close"] = true
	Noteworthy_DB["save_on_page_change"] = false
	Noteworthy_DB["play_sounds"] = true

	Noteworthy_DB["minimap_button"] = {}
	Noteworthy_DB["show_floating_button"] = false
	Noteworthy_DB["qnote_prefix"] = true
	Noteworthy_DB["qnote_edit"] = false
    end

    -- V1.1 settings
    if Noteworthy_DB["version"] < 2000 then
	Noteworthy_DB["chat_logging"] = true
	Noteworthy_DB["qnote_cursor"] = true

	Noteworthy_DB["date_only_format"] = "%d %b %Y"
	Noteworthy_DB["date_time_format"] = "%d %b %Y %H:%M"
	Noteworthy_DB["coord_format"] = "%.2f %.2f"
	Noteworthy_DB["snd_scribble"] = { type = Noteworthy_Snd_Type_File, snd = 567396 }
	Noteworthy_DB["snd_pageturn"] = { type = Noteworthy_Snd_Type_Kit, snd = SOUNDKIT.IG_QUEST_LIST_OPEN }
	Noteworthy_DB["snd_pageclose"] = { type = Noteworthy_Snd_Type_Kit, snd = SOUNDKIT.IG_QUEST_LIST_CLOSE }
    end

    if Noteworthy_DB["version"] == nil then Noteworthy_DB["version"] = 2000 end

    Noteworthy_DB["initialised"] = true
    Noteworthy_DB["version"] = NOTEWORTHY_VERSION
end


----------------------------------------------------------------
-- Core event functions
----------------------------------------------------------------
function Noteworthy_EventHandler(event)
    if (event == "VARIABLES_LOADED") then
	Noteworthy_Initialise()

    elseif event == "PLAYER_REGEN_DISABLED" then
	-- entering combat
	if Noteworthy_DB["combat_close"] then Noteworthy_AutoCloseSave(true) end

    elseif event == "PLAYER_LEAVING_WORLD" then
	-- logoff
	Noteworthy_DB["last_tab"] = Noteworthy_current_tab
	Noteworthy_DB["last_char"] = UIDropDownMenu_GetSelectedID(Noteworthy_DropDown)
	Noteworthy_DB["last_curs"] = Ghost_CursorPos

	Noteworthy_AutoCloseSave(false)
    end
end

function Noteworthy_SetTab(tab)
    CloseDropDownMenus()
    Noteworthy_current_tab = tab

    if Noteworthy_DB["save_on_page_change"] and Noteworthy_MainWindow:IsVisible() then
	Noteworthy_SaveGadgetInfo(false)
    end

    PanelTemplates_SetTab(Noteworthy_MainWindow, Noteworthy_current_tab)

    -- hide all components
    Noteworthy_PanelChar:Hide()
    Noteworthy_PanelShared:Hide()
    Noteworthy_PanelQuick:Hide()
    Noteworthy_PanelOpt:Hide()

    -- show components for this tab
    if Noteworthy_current_tab == TAB_CHAR then
	Noteworthy_textbox = Noteworthy_TextAreaCEditBox
	Noteworthy_PageLabelText:SetText("Page:")
	Noteworthy_PanelChar:Show()
    elseif Noteworthy_current_tab == TAB_SHARED then
	Noteworthy_textbox = Noteworthy_TextAreaSEditBox
	Noteworthy_PageLabelText:SetText("Page: Shared notes")
	Noteworthy_PanelShared:Show()
    elseif Noteworthy_current_tab == TAB_QUICK then
	Noteworthy_textbox = Noteworthy_TextAreaQEditBox
	Noteworthy_PageLabelText:SetText("Page: Quick notes")
	Noteworthy_PanelQuick:Show()
    elseif Noteworthy_current_tab == TAB_OPT then
	Noteworthy_textbox = nil
	Noteworthy_PageLabelText:SetText("Page: Settings")
	Noteworthy_PanelOpt:Show()
    end

    if Noteworthy_MainWindow:IsVisible() then
	Noteworthy_SetTextFocus()
	Noteworthy_PlaySound(Noteworthy_DB["snd_pageturn"])
    end
end

function Noteworthy_ChangeCharacter(newCharacterID)
    -- save current info
    Noteworthy_reminder[Noteworthy_character] = Noteworthy_ReminderCheckbox:GetChecked()
    Noteworthy_text[Noteworthy_character] = Noteworthy_TextAreaCEditBox:GetText()
    if Noteworthy_DB["save_on_page_change"] then Noteworthy_SaveGadgetInfo(false) end

    -- update menu and set new character
    UIDropDownMenu_SetSelectedID(Noteworthy_DropDown, newCharacterID)
    Noteworthy_character = Noteworthy_DB["character_list"][newCharacterID]
    UIDropDownMenu_SetText(Noteworthy_DropDown, Noteworthy_character) -- needed when not changed via menu

    -- set gadget info for new character
    Noteworthy_UpdateCharacterGadgets()

    if (Noteworthy_MainWindow:IsVisible()) then
	Noteworthy_SetTextFocus()
	Noteworthy_PlaySound(Noteworthy_DB["snd_pageturn"])
    end
end

function Noteworthy_ChatFilter(_, event, msg, author)
    -- allow all text through, storing it in buffer (up to MAX_CHAT_LINES)
    Noteworthy_bufferTxt[Noteworthy_bufferID] = "[" .. author .. "] " .. msg
    if event == "CHAT_MSG_BN_WHISPER_INFORM" or event == "CHAT_MSG_WHISPER_INFORM" then
	Noteworthy_bufferTxt[Noteworthy_bufferID] = "To " .. Noteworthy_bufferTxt[Noteworthy_bufferID]
    end

    Noteworthy_bufferID = Noteworthy_bufferID + 1
    if Noteworthy_bufferID > MAX_CHAT_LINES then Noteworthy_bufferID = 1 end

    return false
end


----------------------------------------------------------------
-- Button/menu triggered actions
----------------------------------------------------------------
function Noteworthy_ButtonClick(button)
    if button == "LeftButton" then
	Noteworthy_ToggleView()
    else
	Noteworthy_QuickContextMenu()
    end
end

function Noteworthy_ToggleView()
    if Noteworthy_MainWindow:IsVisible() then
	Noteworthy_AutoCloseSave(true)
    elseif not Noteworthy_MainWindow:IsVisible() then
	Noteworthy_ShowNotepad()
    end
end

function Noteworthy_ShowNotepad(pos)
    CloseDropDownMenus()
    Noteworthy_AlertWindow:Hide()
    Noteworthy_MainWindow:Show()
    Noteworthy_SetTextFocus(pos)
end

-- save current changes and hide window
function Noteworthy_SaveChanges(playSoundFx)
    CloseDropDownMenus()

    if Noteworthy_MainWindow:IsVisible() then
	playSoundFx = playSoundFx or true -- default value of 1

	Noteworthy_SaveGadgetInfo(playSoundFx)
	Noteworthy_MainWindow:Hide()
    end
end

-- revert to previous data and hide window
function Noteworthy_CancelChanges()
    CloseDropDownMenus()

    if Noteworthy_MainWindow:IsVisible() then
	Noteworthy_ResetGadgetInfo()
	Noteworthy_MainWindow:Hide()
    end
end

function Noteworthy_AutoCloseSave(playSoundFx)
    if Noteworthy_DB["save_on_close"] then
	Noteworthy_SaveChanges(playSoundFx)
    else
	Noteworthy_CancelChanges()
    end
end

function Noteworthy_ApplyOptions()
    CloseDropDownMenus()
    Noteworthy_SaveOptionsInfo()
end

function Noteworthy_GetLocation()
    local x, y = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()

    return GetRealZoneText() .. " " .. format(Noteworthy_DB["coord_format"], x * 100, y * 100)
end

function Noteworthy_GetChat(entries)
    local entryID = Noteworthy_bufferID
    local text = ""

    for n = 1, entries, 1 do
	entryID = entryID - 1
	if entryID < 1 then entryID = MAX_CHAT_LINES end
	if Noteworthy_bufferTxt[entryID] == nil then break end

	if text ~= "" then text = "\n" .. text end
	text = Noteworthy_bufferTxt[entryID] .. text
    end

    return text
end

function Noteworthy_InsertText(text)
    CloseDropDownMenus()
    if Noteworthy_textbox then Noteworthy_textbox:Insert(text) end
end

function Noteworthy_AddQuickNote(quicknote)
    CloseDropDownMenus()

    if quicknote == nil or quicknote == "" then
	print("Noteworthy quick note NOT saved (no text)")
    else
	Ghost_UndoEnabled = 0

	-- check for prefix
	if Noteworthy_DB["qnote_prefix"] then
	    quicknote = date(Noteworthy_DB["date_time_format"]) .. " (" .. UnitName("player") .. "): " .. "\n" .. quicknote .. "\n"
	end

	-- save existing text first (in case window already open and page edited)
	Noteworthy_DB["quick_text"] = Noteworthy_TextAreaQEditBox:GetText()

	-- add note to DB and textbox
	if Noteworthy_DB["qnote_cursor"] and Noteworthy_MainWindow:IsVisible() and Noteworthy_current_tab == TAB_QUICK then
	    Noteworthy_TextAreaQEditBox:Insert(quicknote)
	else
	    Noteworthy_DB["quick_text"] = quicknote .. "\n" .. Noteworthy_DB["quick_text"]
	    Noteworthy_TextAreaQEditBox:SetText(Noteworthy_DB["quick_text"])
	end

	-- check for edit
	if Noteworthy_DB["qnote_edit"] then
	    Noteworthy_QuickEdit()
	else
	    print("Noteworthy quick note saved")
	end

	Ghost_UndoEnabled = 1
    end
end

function Noteworthy_QuickEdit()
    Noteworthy_SetTab(TAB_QUICK)
    Noteworthy_ShowNotepad(0)
end

function Noteworthy_MyEdit()
    Noteworthy_SetTab(TAB_CHAR)
    Noteworthy_ChangeCharacter(Noteworthy_plrID)
    Noteworthy_ShowNotepad(0)
end


----------------------------------------------------------------
-- Close/save/options functions
----------------------------------------------------------------
function Noteworthy_ResetGadgetInfo()
    -- store working copy of character notes
    Noteworthy_text = {}

    for c = 1, Noteworthy_DB["character_count"], 1 do
	thisCharacter = Noteworthy_DB["character_list"][c]
	Noteworthy_text[thisCharacter] = Noteworthy_DB[thisCharacter]
	Noteworthy_reminder[thisCharacter] = Noteworthy_DB["Remind_" .. thisCharacter]
    end

    -- set gadgets
    Ghost_UndoEnabled = 0
    Noteworthy_TextAreaSEditBox:SetText(Noteworthy_DB["shared_text"])
    Noteworthy_TextAreaQEditBox:SetText(Noteworthy_DB["quick_text"])
    Noteworthy_UpdateCharacterGadgets()
    Ghost_UndoEnabled = 1

    -- options
    Noteworthy_RememberPageCheckbox:SetChecked(Noteworthy_DB["remember_page"])
    Noteworthy_FocusCheckbox:SetChecked(Noteworthy_DB["focus_text"])
    Noteworthy_CombatCloseCheckbox:SetChecked(Noteworthy_DB["combat_close"])
    Noteworthy_CloseSaveCheckbox:SetChecked(Noteworthy_DB["save_on_close"])
    Noteworthy_PageSaveCheckbox:SetChecked(Noteworthy_DB["save_on_page_change"])
    Noteworthy_SoundCheckbox:SetChecked(Noteworthy_DB["play_sounds"])
    Noteworthy_ChatLoggingCheckbox:SetChecked(Noteworthy_DB["chat_logging"])
    --Noteworthy_LargeUndoCheckbox:SetChecked(Noteworthy_DB["large_undo"])

    Noteworthy_MiniButtonCheckbox:SetChecked(not Noteworthy_DB["minimap_button"].hide)
    Noteworthy_ShowIconCheckbox:SetChecked(Noteworthy_DB["show_floating_button"])
    Noteworthy_QNotePrefixCheckbox:SetChecked(Noteworthy_DB["qnote_prefix"])
    Noteworthy_QNoteEditCheckbox:SetChecked(Noteworthy_DB["qnote_edit"])
    Noteworthy_QNoteCursorCheckbox:SetChecked(Noteworthy_DB["qnote_cursor"])
end

function Noteworthy_UpdateCharacterGadgets()
    _G[Noteworthy_ReminderCheckbox:GetName() .. "Text"]:SetText("Remind " .. Noteworthy_character .. " at logon")
    Noteworthy_ReminderCheckbox:SetChecked(Noteworthy_reminder[Noteworthy_character])

    Ghost_UndoEnabled = 0
    Noteworthy_TextAreaCEditBox:SetText(Noteworthy_text[Noteworthy_character])
    Ghost_UndoEnabled = 1
end

function Noteworthy_SaveGadgetInfo(playSoundFx)
    -- save settings first
    Noteworthy_SaveOptionsInfo()

    -- save text area text
    Noteworthy_DB["shared_text"] = Noteworthy_TextAreaSEditBox:GetText()
    Noteworthy_DB["quick_text"] = Noteworthy_TextAreaQEditBox:GetText()
    Noteworthy_text[Noteworthy_character] = Noteworthy_TextAreaCEditBox:GetText()

    Noteworthy_reminder[Noteworthy_character] = Noteworthy_ReminderCheckbox:GetChecked()

    -- store working text for all characters
    for c = 1, Noteworthy_DB["character_count"], 1 do
	thisCharacter = Noteworthy_DB["character_list"][c]
	Noteworthy_DB[thisCharacter] = Noteworthy_text[thisCharacter]
	Noteworthy_DB["Remind_" .. thisCharacter] = Noteworthy_reminder[thisCharacter]
    end

    -- play sound
     if playSoundFx then Noteworthy_PlaySound(Noteworthy_DB["snd_scribble"]) end
end

function Noteworthy_SaveOptionsInfo()
    Noteworthy_DB["remember_page"] = Noteworthy_RememberPageCheckbox:GetChecked()
    Noteworthy_DB["focus_text"] = Noteworthy_FocusCheckbox:GetChecked()
    Noteworthy_DB["combat_close"] = Noteworthy_CombatCloseCheckbox:GetChecked()
    Noteworthy_DB["save_on_close"] = Noteworthy_CloseSaveCheckbox:GetChecked()
    Noteworthy_DB["save_on_page_change"] = Noteworthy_PageSaveCheckbox:GetChecked()
    Noteworthy_DB["play_sounds"] = Noteworthy_SoundCheckbox:GetChecked()
    Noteworthy_DB["chat_logging"] = Noteworthy_ChatLoggingCheckbox:GetChecked()
    --Noteworthy_DB["large_undo"] = Noteworthy_LargeUndoCheckbox:GetChecked()

    local updateMinimap = false
    local currentMinimap = not Noteworthy_MiniButtonCheckbox:GetChecked()

    if currentMinimap ~= Noteworthy_DB["minimap_button"].hide then
	Noteworthy_DB["minimap_button"].hide = currentMinimap
	updateMinimap = true
    end

    Noteworthy_DB["show_floating_button"] = Noteworthy_ShowIconCheckbox:GetChecked()
    Noteworthy_DB["qnote_prefix"] = Noteworthy_QNotePrefixCheckbox:GetChecked()
    Noteworthy_DB["qnote_edit"] = Noteworthy_QNoteEditCheckbox:GetChecked()
    Noteworthy_DB["qnote_cursor"] = Noteworthy_QNoteCursorCheckbox:GetChecked()

    Noteworthy_SetInterface(updateMinimap)
end

function Noteworthy_CreateMacros()
    Ghost_CreateMacro("Noteworthy", "INV_Misc_Book_08", "/noteworthy")
    Ghost_CreateMacro("QuickNotes", "INV_Misc_Book_11", "/quicknotes")
end


----------------------------------------------------------------
-- Other event functions
----------------------------------------------------------------

-- set interface from options
function Noteworthy_SetInterface(updateMinimap)
    -- minimap button (only show/hide if changed)
    if updateMinimap then
	if Noteworthy_DB["minimap_button"].hide then
	    ldbicon:Hide("Noteworthy")
	else
	    ldbicon:Show("Noteworthy")
	end
    end

    -- floating button
    if Noteworthy_DB["show_floating_button"] then
	Noteworthy_FloatingButton:Show()
    else
	Noteworthy_FloatingButton:Hide()
    end

    -- chat logging
    if Noteworthy_DB["chat_logging"] then
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", Noteworthy_ChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", Noteworthy_ChatFilter)
    else
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_BN_CONVERSATION", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_BN_WHISPER", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_EMOTE", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_GUILD", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY_LEADER", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_OFFICER", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", Noteworthy_ChatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", Noteworthy_ChatFilter)
    end

    -- undo buffer
    if Noteworthy_DB["large_undo"] == 1 then
	Ghost_MaxUndoSize = 50
    else
	Ghost_MaxUndoSize = 25
    end
end

-- set focus to current text box if auto focus enabled
function Noteworthy_SetTextFocus(pos)
    if Noteworthy_DB["focus_text"] then
	Noteworthy_SetFocus(pos)
    end
end

-- set focus and cursor position
function Noteworthy_SetFocus(pos)
    if Noteworthy_textbox then
	Noteworthy_textbox:SetFocus()
	if pos ~= nil then Noteworthy_textbox:SetCursorPosition(pos) end
    end
end
