--==============================================================
-- Main code (functionality, events, etc.)
--==============================================================

-- constants
local NOTEWORTHY_VERSION = 203000
local NOTEWORTHY_VTEXT = "2.3.0"
local MAX_CHAT_LINES = 30
local TAB_CHAR = 1
local TAB_SHARED = 2
local TAB_QUICK = 3
local MAX_UNDO_STACK_SIZE = 50
Noteworthy_Snd_Type_File = -10
Noteworthy_Snd_Type_Kit = -20

-- set saved variable to table to store all settings
if not Noteworthy_DB then Noteworthy_DB = {} end

-- session vars
Noteworthy_character = "" -- selected character
local Noteworthy_plrID = 0 -- player character ID
local Noteworthy_current_tab = 1 -- ID of current tab
local Noteworthy_textbox -- current visible textbox (diff to Ghost_CurrentEditBox which is focussed box)
local Noteworthy_text = {} -- character notes text
local Noteworthy_reminder = {} -- character reminder flags
local Noteworthy_bufferTxt = {} -- text buffer for quick notes
local Noteworthy_bufferID = 1 -- current buffer entry
local Noteworthy_Undo_Stack = { -- a table of undo stacks per tab
    [TAB_CHAR] = {},
    [TAB_SHARED] = {},
    [TAB_QUICK] = {}
}


----------------------------------------------------------------
-- Initialise code
----------------------------------------------------------------

--- Returns the character ID for the character stored in Noteworthy_character var.
-- @return the character ID or 0 if the character is not in the table
-- @see Noteworthy_character
function Noteworthy_GetPlrID()
    for c = 1, Noteworthy_DB["character_count"], 1 do
        if Noteworthy_DB["character_list"][c] == Noteworthy_character then return c end
    end
    return 0
end

--- Initializes Noteworthy II on startup.
-- 1. Sets the Noteworthy_character var
-- 2. Initializes default setting values is needed.
-- 3. Sets default shared notes if needed.
-- 4. Sets default quick notes if needed.
-- 5. Sets default character notes for current character if needed.
-- 6. Applies last session options if available.
-- 7. Initializes LDB broker.
-- 8. Updates Noteworthy UI.
-- 9. Populates drop down menus.
-- 10. Sets initial character tab and populates it.
-- 11. Fires the reminder for current char if set.
-- @return nil
-- @see Noteworthy_character
-- @see Noteworthy_SetDefaults
-- @see Noteworthy_InitBroker
-- @see Noteworthy_GetPlrID
-- @see Noteworthy_ResetOptions
-- @see Noteworthy_ResetGadgetInfo
-- @see Noteworthy_SetInterface
-- @see Noteworthy_CreateDropDownMenus
-- @see Noteworthy_ValidTab
-- @see Noteworthy_SetTab
-- @see Noteworthy_ChangeCharacter
-- @see Ghost_CursorPos
-- @see Noteworthy_SetTextFocus
function Noteworthy_Initialise()
    local startupMsg = "|cFFFF7D0ANoteworthy II V" .. NOTEWORTHY_VTEXT .. " loaded.|r"

    Noteworthy_character = Noteworthy_CreatePlayerName()

    -- TODO: For dev only - check if commented before release/upload
    -- Noteworthy_DB["version"] = 1100		-- temporarily uncomment this line & change number to reset to previous version
    -- Noteworthy_DB["initialised"] = nil	-- temporarily uncomment this line to reset default settings (but not notes)
    -- Noteworthy_DB = {}                   -- temporarily uncomment this line to reset ALL saved data
    ----------------------------------------------------------------

    -- version check
    if Noteworthy_DB["initialised"] == nil then
        startupMsg = "|cFF00FF00Noteworthy II V" .. NOTEWORTHY_VTEXT .. " installed.|r"
        Noteworthy_SetDefaults()
    end
    if Noteworthy_DB["version"] ~= NOTEWORTHY_VERSION then
        startupMsg = "|cFF00FF00Noteworthy II updated to V" .. NOTEWORTHY_VTEXT .. ".|r"
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

    -- set gadgets from saved vars
    Noteworthy_VersionLabelText:SetText("V" .. NOTEWORTHY_VTEXT)
    Noteworthy_ResetOptions()
    Noteworthy_ResetGadgetInfo()
    Noteworthy_SetInterface()

    -- configure dropdown menus
    Noteworthy_CreateDropDownMenus()

    -- set initial tab etc.
    if Noteworthy_DB["remember_page"] and Noteworthy_ValidTab(Noteworthy_DB["last_tab"]) then
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

    -- TODO: only for beta version
    -- print("This is a beta version of Noteworthy II. Please keep an eye for bugs and issues. If you can, report anything suspicious you find on https://www.curseforge.com/wow/addons/noteworthy-ii or https://github.com/28/NoteworthyII/issues. Also, if possible you can send me an IGM at Turuvid on ArgentDawn. Thank you!")
end

--- Creates all Noteworthy II drop down menus
-- @return nil
-- @see Noteworthy_CreateDropDown
-- @see Noteworthy_CreateCharacterListDropDown
function Noteworthy_CreateDropDownMenus()
    Noteworthy_CreateDropDown()
    Noteworthy_CreateCharacterListDropDown(Noteworthy_FromCharDropDown, false)
    Noteworthy_CreateCharacterListDropDown(Noteworthy_ToCharDropDown, false)
    Noteworthy_CreateCharacterListDropDown(Noteworthy_DelCharDropDown, true)
end

--- Asserts if passed tab ID is valid/existing.
-- Introduced for version compatibility in case that last session remembered a tab that is no longer available
-- (like settings tab that was removed in 2.1).
-- @param tabId ID to check
-- @return true if tab ID is valid, otherwise false
function Noteworthy_ValidTab(tabId)
    return tabId ~= nil and (tabId == TAB_CHAR or tabId == TAB_SHARED or tabId == TAB_QUICK)
end

--- Sets the default setting values with regards to the version being upgraded to.
-- @return nil
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
    if Noteworthy_DB["version"] < 1100 then
        Noteworthy_DB["version"] = 1100
        Noteworthy_DB["chat_logging"] = true
        Noteworthy_DB["qnote_cursor"] = true

        Noteworthy_DB["date_only_format"] = "%d %b %Y"
        Noteworthy_DB["date_time_format"] = "%d %b %Y %H:%M"
        Noteworthy_DB["coord_format"] = "%.2f %.2f"
        Noteworthy_DB["snd_scribble"] = { type = Noteworthy_Snd_Type_Kit, snd = 3093 }
        Noteworthy_DB["snd_pageturn"] = { type = Noteworthy_Snd_Type_Kit, snd = SOUNDKIT.IG_QUEST_LIST_OPEN }
        Noteworthy_DB["snd_pageclose"] = { type = Noteworthy_Snd_Type_Kit, snd = SOUNDKIT.IG_QUEST_LIST_CLOSE }
    end

    -- V2.2.0 settings
    if Noteworthy_DB["version"] < 202000 then
        Noteworthy_DB["version"] = 202000
        -- print this message only when updating to this version (newly installed Noteworthy does not have old format character names)
        if Noteworthy_DB["initialised"] == true then
            print("|c00FFFF00Noteworthy II changed the way it stores character notes. All notes are stored as 'Character-Realm' instead of only 'Character'. If you have notes stored in the old format, use the character migration/deletion options from addon settings menu to move your notes.|r")
        end
    end

    -- V2.3.0 settings
    if Noteworthy_DB["version"] < 203000 then
        Noteworthy_DB["version"] = 203000
        Noteworthy_DB["undo"] = true
    end

    Noteworthy_DB["initialised"] = true
    Noteworthy_DB["version"] = NOTEWORTHY_VERSION
end


----------------------------------------------------------------
-- Core event functions
----------------------------------------------------------------

--- Core Noteworthy II handler function.
-- Handles log in, entering combat and log off.
-- @param event
-- @return nil
-- @see Noteworthy_Initialise
-- @see Noteworthy_AutoCloseSave
function Noteworthy_EventHandler(event)
    if (event == "VARIABLES_LOADED") then
        -- log in
        Noteworthy_Initialise()

    elseif event == "PLAYER_REGEN_DISABLED" then
        -- entering combat
        if Noteworthy_DB["combat_close"] then Noteworthy_AutoCloseSave(true) end

    elseif event == "PLAYER_LEAVING_WORLD" then
        -- log off
        Noteworthy_DB["last_tab"] = Noteworthy_current_tab
        Noteworthy_DB["last_char"] = UIDropDownMenu_GetSelectedID(Noteworthy_DropDown)
        Noteworthy_DB["last_curs"] = Ghost_CursorPos

        Noteworthy_AutoCloseSave(false)
    end
end

--- Sets the tab with the passed tab ID.
-- @param tab ID od the tab to set
-- @return nil
-- @see Noteworthy_SaveGadgetInfo
-- @see Noteworthy_SetTextFocus
-- @see Noteworthy_PlaySound
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
    end

    if Noteworthy_MainWindow:IsVisible() then
        Noteworthy_SetTextFocus()
        Noteworthy_PlaySound(Noteworthy_DB["snd_pageturn"])
    end
end

--- Changes the character in the character notes when a new value is selected in the drop down menu.
-- @param newCharacterID ID of the character to set
-- @return nil
-- @see Noteworthy_SaveGadgetInfo
-- @see Noteworthy_UpdateCharacterGadgets
-- @see Noteworthy_SetTextFocus
-- @see Noteworthy_PlaySound
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

    -- reset undo stack for character
    if Noteworthy_UndoEnabled() then
        Noteworthy_EmptyUndoStack()
        Noteworthy_UndoPush()
    end

    if (Noteworthy_MainWindow:IsVisible()) then
        Noteworthy_SetTextFocus()
        Noteworthy_PlaySound(Noteworthy_DB["snd_pageturn"])
    end
end

--- Noteworthy chat filter.
-- Allow all text through, storing it in buffer (up to MAX_CHAT_LINES).
-- @param self the frame that registered the event (unused)
-- @param event event type
-- @param msg chat message
-- @param author message author
-- @return false always return false
function Noteworthy_ChatFilter(self, event, msg, author)
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

--- Left click on Noteworthy button handler.
-- @param button the button being pressed
-- @return nil
-- @see Noteworthy_ToggleView
-- @see Noteworthy_QuickContextMenu
function Noteworthy_ButtonClick(button)
    if button == "LeftButton" then
        Noteworthy_ToggleView()
    else
        Noteworthy_QuickContextMenu()
    end
end

--- Toggles the Noteworthy frame visibility.
-- If visible close the frame with auto save (if available). If hidden displays it.
-- @return nil
-- @see Noteworthy_AutoCloseSave
-- @see Noteworthy_ShowNotepad
function Noteworthy_ToggleView()
    if Noteworthy_MainWindow:IsVisible() then
        Noteworthy_AutoCloseSave(true)
    elseif not Noteworthy_MainWindow:IsVisible() then
        Noteworthy_ShowNotepad()
    end
end

--- Shows the Noteworthy frame.
-- @param pos the cursor position to set on the displayed frame
-- @return nil
-- @see Noteworthy_SetTextFocus
function Noteworthy_ShowNotepad(pos)
    CloseDropDownMenus()
    Noteworthy_AlertWindow:Hide()
    Noteworthy_MainWindow:Show()
    Noteworthy_SetTextFocus(pos)
end

--- Saves current changes and hides the frame.
-- Also empties the undo stacks.
-- @param playSoundFx boolean indicating should the close/save sound be played.
-- @return nil
-- @see Noteworthy_SaveGadgetInfo
-- @see Noteworthy_EmptyUndoStack()
function Noteworthy_SaveChanges(playSoundFx)
    CloseDropDownMenus()
    Noteworthy_EmptyUndoStack()

    if Noteworthy_MainWindow:IsVisible() then
        playSoundFx = playSoundFx or true

        Noteworthy_SaveGadgetInfo(playSoundFx)
        Noteworthy_MainWindow:Hide()
    end
end

--- Reverts to previous data and hides the frame.
-- Also empties the undo stacks.
-- @return nil
-- @see Noteworthy_ResetGadgetInfo
-- @see Noteworthy_EmptyUndoStack()
function Noteworthy_CancelChanges()
    CloseDropDownMenus()
    Noteworthy_EmptyUndoStack()

    if Noteworthy_MainWindow:IsVisible() then
        Noteworthy_ResetGadgetInfo()
        Noteworthy_MainWindow:Hide()
    end
end

--- Saves the current state if save on close if available otherwise discards the changes.
-- @param playSoundFx a boolean indicating should the close/save sound be played
-- @return nil
-- @see Noteworthy_SaveChanges
-- @see Noteworthy_CancelChanges
function Noteworthy_AutoCloseSave(playSoundFx)
    if Noteworthy_DB["save_on_close"] then
        Noteworthy_SaveChanges(playSoundFx)
    else
        Noteworthy_CancelChanges()
    end
end

--- Retrieves the current player location in a formatted coordinates string.
-- @return a formatted coordinates string
function Noteworthy_GetLocation()
    local x, y = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()

    return GetRealZoneText() .. " " .. format(Noteworthy_DB["coord_format"], x * 100, y * 100)
end

--- Retrieves the passed number of chat entries from the chat buffer.
-- @param entries the number of entries to retrieve
-- @return the string of appended chat lines from the buffer
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

--- Inserts the passed text to the current visible text box.
-- Also triggers the undo push of the text box which was modified.
-- @param text to insert
-- @return nil
-- @see Noteworthy_UndoEnabled()
-- @see Noteworthy_UndoPush()
function Noteworthy_InsertText(text)
    CloseDropDownMenus()
    if Noteworthy_textbox then Noteworthy_textbox:Insert(text) end
    if Noteworthy_UndoEnabled() then Noteworthy_UndoPush() end
end

--- Adds a quick note to the quick notes DB and panel.
-- Will add a player and timestamp prefix if the that setting is available.
-- Will open for edit if that setting is available.
-- Also triggers the undo push of the text box which was modified.
-- @param quicknote text to add
-- @return nil
-- @see Noteworthy_UndoEnabled()
-- @see Noteworthy_UndoPush()
function Noteworthy_AddQuickNote(quicknote)
    CloseDropDownMenus()

    if quicknote == nil or quicknote == "" then
        print("Noteworthy II quick note NOT saved (no text).")
    else
        -- check for prefix
        if Noteworthy_DB["qnote_prefix"] then
            quicknote = date(Noteworthy_DB["date_time_format"]) .. " (" .. Noteworthy_CreatePlayerName() .. "): " .. "\n" .. quicknote .. "\n"
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

        -- add inserted text to undo stack
        if Noteworthy_UndoEnabled() then
            Noteworthy_UndoPush()
        end

        -- check for edit
        if Noteworthy_DB["qnote_edit"] then
            Noteworthy_QuickEdit()
        else
            print("Noteworthy II quick note saved.")
        end
    end
end

--- Open the Noteworthy frame on quick notes tab.
-- @return nil
-- @see Noteworthy_ShowNotepad
function Noteworthy_QuickEdit()
    Noteworthy_SetTab(TAB_QUICK)
    Noteworthy_ShowNotepad(0)
end

--- Open the Noteworthy frame on character notes tab on current selected character.
-- @return nil
-- @see Noteworthy_ChangeCharacter
-- @see Noteworthy_ShowNotepad
function Noteworthy_MyEdit()
    Noteworthy_SetTab(TAB_CHAR)
    Noteworthy_ChangeCharacter(Noteworthy_plrID)
    Noteworthy_ShowNotepad(0)
end


----------------------------------------------------------------
-- Close/save/options functions
----------------------------------------------------------------

--- Updates all visible elements with stored DB values.
-- Stores the working copy of character notes.
-- @return nil
-- @see Noteworthy_UpdateCharacterGadgets
function Noteworthy_ResetGadgetInfo()
    Noteworthy_text = {}

    for c = 1, Noteworthy_DB["character_count"], 1 do
        thisCharacter = Noteworthy_DB["character_list"][c]
        Noteworthy_text[thisCharacter] = Noteworthy_DB[thisCharacter]
        Noteworthy_reminder[thisCharacter] = Noteworthy_DB["Remind_" .. thisCharacter]
    end

    -- set gadgets
    Noteworthy_TextAreaSEditBox:SetText(Noteworthy_DB["shared_text"])
    Noteworthy_TextAreaQEditBox:SetText(Noteworthy_DB["quick_text"])
    Noteworthy_UpdateCharacterGadgets()
end

--- Resets all the settings with the values from DB.
-- @return nil
function Noteworthy_ResetOptions()
    Noteworthy_RememberPageCheckbox:SetChecked(Noteworthy_DB["remember_page"])
    Noteworthy_FocusCheckbox:SetChecked(Noteworthy_DB["focus_text"])
    Noteworthy_CombatCloseCheckbox:SetChecked(Noteworthy_DB["combat_close"])
    Noteworthy_CloseSaveCheckbox:SetChecked(Noteworthy_DB["save_on_close"])
    Noteworthy_PageSaveCheckbox:SetChecked(Noteworthy_DB["save_on_page_change"])
    Noteworthy_SoundCheckbox:SetChecked(Noteworthy_DB["play_sounds"])
    Noteworthy_ChatLoggingCheckbox:SetChecked(Noteworthy_DB["chat_logging"])
    Noteworthy_UndoCheckbox:SetChecked(Noteworthy_DB["undo"])
    Noteworthy_MiniButtonCheckbox:SetChecked(not Noteworthy_DB["minimap_button"].hide)
    Noteworthy_ShowIconCheckbox:SetChecked(Noteworthy_DB["show_floating_button"])
    Noteworthy_QNotePrefixCheckbox:SetChecked(Noteworthy_DB["qnote_prefix"])
    Noteworthy_QNoteEditCheckbox:SetChecked(Noteworthy_DB["qnote_edit"])
    Noteworthy_QNoteCursorCheckbox:SetChecked(Noteworthy_DB["qnote_cursor"])
end

--- Updates all visible UI elements on the character notes page.
-- @return nil
function Noteworthy_UpdateCharacterGadgets()
    _G[Noteworthy_ReminderCheckbox:GetName() .. "Text"]:SetText("Remind " .. Noteworthy_character .. " at logon")
    Noteworthy_ReminderCheckbox:SetChecked(Noteworthy_reminder[Noteworthy_character])
    Noteworthy_TextAreaCEditBox:SetText(Noteworthy_text[Noteworthy_character])
end

--- Saves all notes current state.
-- Saves the current state of shared and quick notes. Saves the notes for all characters available.
-- @param playSoundFx a boolean indicating should the close/save sound be played
-- @return nil
-- @see Noteworthy_PlaySound
function Noteworthy_SaveGadgetInfo(playSoundFx)
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

--- Updates the Noteworthy II minimap button visibility status.
-- @param shouldUpdateButton flag indicating if button should be visible or not
-- @return nil
-- @see Noteworthy_SetInterface
function Noteworthy_UpdateMinimapButtonOption(shouldUpdateButton)
    local updateMinimap = false
    local currentMinimap = not shouldUpdateButton

    if currentMinimap ~= Noteworthy_DB["minimap_button"].hide then
        Noteworthy_DB["minimap_button"].hide = currentMinimap
        updateMinimap = true
    end

    Noteworthy_SetInterface(updateMinimap)
end

--- Updates the given flag with the given value.
-- @param flagName the name of the flag to set/update
-- @param flagValue value of the flag to set
-- @param updateInterface flag indicating should the interface be updated after the new value is set
-- @return nil
-- @see Noteworthy_SetInterface
function Noteworthy_SaveFlagOptions(flagName, flagValue, updateInterface)
    Noteworthy_DB[flagName] = flagValue
    if updateInterface then Noteworthy_SetInterface(false) end
end

--- Creates noteworthy and quick notes macros.
-- @return nil
-- @see Ghost_CreateMacro
function Noteworthy_CreateMacros()
    Ghost_CreateMacro("Noteworthy II", "INV_Misc_Book_08", "/noteworthy")
    Ghost_CreateMacro("QuickNotes", "INV_Misc_Book_11", "/quicknotes")
end

--- Migrates the character notes from one character to another and updates gadgets.
-- Migrating notes are concatenated as a new paragraph to the target unless
-- the 'override' check box is ticked. Origin notes will be removed if 'preserve origin'
-- checkbox is ticked, otherwise not.
-- @return nil
-- @see Noteworthy_ResetGadgetInfo
-- @see Noteworthy_ClearDropDownSelection
function Noteworthy_MigrateCharacterNotes()
    local fromCharId = UIDropDownMenu_GetSelectedID(Noteworthy_FromCharDropDown)
    local toCharId = UIDropDownMenu_GetSelectedID(Noteworthy_ToCharDropDown)
    local override = Noteworthy_OverrideOnMigrateCheckbox:GetChecked() or false
    local preserveOrigin = Noteworthy_LeaveOriginCheckbox:GetChecked() or false
    local fromChar = Noteworthy_DB["character_list"][fromCharId]
    local toChar = Noteworthy_DB["character_list"][toCharId]
    local notes
    if override then
        notes = Noteworthy_DB[fromChar]
    else
        notes = Noteworthy_DB[toChar] .. "\n\n" .. Noteworthy_DB[fromChar]
    end
    Noteworthy_DB[toChar] = notes
    if not preserveOrigin then Noteworthy_DB[fromChar] = "" end
    Noteworthy_ResetGadgetInfo()
    Noteworthy_ClearDropDownSelection(Noteworthy_FromCharDropDown)
    Noteworthy_ClearDropDownSelection(Noteworthy_ToCharDropDown)
end

--- Removes a character from Noteworthy II character lists, notes and reminders.
-- @return nil
-- @see Noteworthy_CreateDropDownMenus
-- @see Noteworthy_ResetGadgetInfo
function Noteworthy_RemoveCharacter()
    local charId = UIDropDownMenu_GetSelectedID(Noteworthy_DelCharDropDown)
    local charName = Noteworthy_DB["character_list"][charId]
    local currentPlayerName = Noteworthy_CreatePlayerName()
    if charName ~= currentPlayerName then
        Noteworthy_DB[charName] = nil
        table.remove(Noteworthy_DB["character_list"], charId)
        Noteworthy_DB["character_count"] = Noteworthy_DB["character_count"] - 1

        Noteworthy_reminder[charName] = nil
        Noteworthy_text[charName] = nil
        Noteworthy_character = currentPlayerName
        Noteworthy_plrID = Noteworthy_GetPlrID()
        Noteworthy_DB["Remind_" .. charName] = nil
        if Noteworthy_DB["last_char"] == charId then Noteworthy_DB["last_char"] = nil end

        Noteworthy_CreateDropDownMenus()
        Noteworthy_ResetGadgetInfo()
    end
end


----------------------------------------------------------------
-- Undo functions
----------------------------------------------------------------

--- Performs the undo action.
-- Takes the last entry from the undo stack of the current tab and
-- sets it to its edit box.
-- @return nil
function Noteworthy_PerformUndo()
    local undoText = Noteworthy_UndoPop(Noteworthy_current_tab)
    if undoText then
        Noteworthy_SetTextForTab(Noteworthy_current_tab, undoText)
    end
end

--- Pushes the text from the edit box from the current tab into the undo stack.
-- Does nothing if edit box is empty or if the text is the same as the last entry in the undo stack.
-- If stack exceeds the MAX_UNDO_STACK_SIZE removes the first/oldest entry before inserting the new one.
-- @return nil
function Noteworthy_UndoPush()
    local stack = Noteworthy_Undo_Stack[Noteworthy_current_tab]
    local lastText = Noteworthy_UndoPeek(Noteworthy_current_tab)
    local text = Noteworthy_GetTextFromTab(Noteworthy_current_tab)
    if text and (not lastText or text ~= lastText) then
        local i = #stack + 1
        if i > MAX_UNDO_STACK_SIZE then
            table.remove(stack, 1)
            i = #stack + 1
        end
        stack[i] = text
    end
end

--- Retrieves the last entry from the undo stack for the given tab.
-- If the last entry is equal to the current text in the tab's edit box dumps it and retrieves the next value
-- (continues to do so until the texts are different).
-- @param stackId the ID of the undo stack (tab ID)
-- @return the first stack entry that is different than the current text in the tab's edit box
function Noteworthy_UndoPop(stackId)
    local stack = Noteworthy_Undo_Stack[stackId]
    if #stack > 0 then
        local currentText = Noteworthy_GetTextFromTab(stackId)
        local lastEntry = Noteworthy_UndoPeek(stackId)
        local result
        if #stack == 1 then
            if (currentText ~= lastEntry) then
                result = Noteworthy_UndoPeek(stackId) -- preserve initial state
            end
        else
            repeat
                result = table.remove(stack, #stack) -- should not remove initial state because of equality
            until (result ~= currentText)
        end
        return result
    end
end

--- Retrieves the last entry from the undo stack
-- @param stackId the ID of the undo stack
-- @return the last entry from the undo stack
function Noteworthy_UndoPeek(stackId)
    local stack = Noteworthy_Undo_Stack[stackId]
    return stack[#stack]
end

--- Retrieves the text from the given tab's edit box.
-- @param tabId the tab to retrieve text from
-- @return the text from the tab
function Noteworthy_GetTextFromTab(tabId)
    if tabId == TAB_CHAR then
        return Noteworthy_TextAreaCEditBox:GetText()
    elseif tabId == TAB_QUICK then
        return Noteworthy_TextAreaQEditBox:GetText()
    else
        return Noteworthy_TextAreaSEditBox:GetText()
    end
end

--- Sets the given text to the given tab's edit box.
-- @param tabId the ID of the tab to add text to
-- @param text the text to add
-- @return nil
function Noteworthy_SetTextForTab(tabId, text)
    if tabId == TAB_CHAR then
        return Noteworthy_TextAreaCEditBox:SetText(text)
    elseif tabId == TAB_QUICK then
        return Noteworthy_TextAreaQEditBox:SetText(text)
    else
        return Noteworthy_TextAreaSEditBox:SetText(text)
    end
end

--- Reinitializes/empties the undo stack.
-- @return nil
function Noteworthy_EmptyUndoStack()
    Noteworthy_Undo_Stack = {
        [TAB_CHAR] = {},
        [TAB_SHARED] = {},
        [TAB_QUICK] = {}
    }
end

--- Asserts if Noteworthy undo feature is on.
-- @return true if undo is on, otherwise false
function Noteworthy_UndoEnabled()
    return Noteworthy_DB["undo"] == true
end

----------------------------------------------------------------
-- Other event functions
----------------------------------------------------------------

--- Sets the minimap button, floating button and adds/removes the chat filter.
-- @param updateMinimap a boolean indicating should the minimap button state be updated
-- @return nil
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
end

--- Set the focus to current text box if auto focus enabled.
-- @param pos the position to set the cursor to
-- @return nil
-- @see Noteworthy_SetFocus
function Noteworthy_SetTextFocus(pos)
    if Noteworthy_DB["focus_text"] then
        Noteworthy_SetFocus(pos)
    end
end

--- Sets the focus and cursor position on the current visible textbox.
-- @param pos the position to set the cursor to
-- @return nil
function Noteworthy_SetFocus(pos)
    if Noteworthy_textbox then
        Noteworthy_textbox:SetFocus()
        if pos ~= nil then Noteworthy_textbox:SetCursorPosition(pos) end
    end
end

--- Asserts if the passed ID corresponds to the player character.
-- @param charId id to assert
-- @return true if ID corresponds to the player character otherwise false
function Noteworthy_isCharacterIdFromCurrentPlayer(charId)
    local charName = Noteworthy_DB["character_list"][charId]
    return charName == Noteworthy_CreatePlayerName()
end

--- Creates a Character-Realm name for the current playing character.
-- @return current playing character name with realm suffix
function Noteworthy_CreatePlayerName()
    return GetUnitName("player") .. "-" .. GetRealmName()
end

--- Takes a phrase and returns it formatted to be displayed in gray color.
-- @param phrase to be formatted
-- @return formatted string
function Noteworthy_GrayPhrase(phrase)
    return "|c80808001" .. phrase .. "|r"
end
