--==============================================================
-- System code (setup, menus, etc.)
--==============================================================


----------------------------------------------------------------
-- Slash commands
----------------------------------------------------------------

-- slash commands
SLASH_Noteworthy_1, SLASH_Noteworthy_2 = '/noteworthy', '/notes'
SLASH_QuickNotes_1 = '/quicknotes'

--- Creates (assigns) a handler fucntion for the '/noteworthy' command.
-- @param msg a whole message after the slash command (unused)
-- @return nil
-- @see Noteworthy_ToggleView
function SlashCmdList.Noteworthy_(msg)
    Noteworthy_ToggleView()
end

--- Creates (assigns) a handler fucntion for the '/quicknotes' command.
-- @param msg a whole message after the slash command (unused)
-- @return nil
-- @see Noteworthy_QuickContextMenu
function SlashCmdList.QuickNotes_(msg)
    Noteworthy_QuickContextMenu()
end


----------------------------------------------------------------
-- Dropdown menu Code
----------------------------------------------------------------

--- Creates the character notes drop down menu and fills it with all characters.
-- The character that is curenlty being played on will be selected. See
-- Noteworthy_UpdateDropDown for selection change handler fundtion.
-- @return nil
-- @see Noteworthy_UpdateDropDown
function Noteworthy_CreateDropDown()
    UIDropDownMenu_SetWidth(Noteworthy_DropDown, 200)
    UIDropDownMenu_SetText(Noteworthy_DropDown, Noteworthy_character)

    UIDropDownMenu_Initialize(Noteworthy_DropDown, function(self, level, menuList)
        for c = 1, Noteworthy_DB["character_count"], 1 do
            local selected
            local info = UIDropDownMenu_CreateInfo()
            info.func = Noteworthy_UpdateDropDown

            if Noteworthy_DB["character_list"][c] == Noteworthy_character then
                selected = true
            else
                selected = false
            end

            info.text, info.checked = Noteworthy_DB["character_list"][c], selected
            UIDropDownMenu_AddButton(info)
        end
    end)
end

--- Creates a drop down menu for the givent element and populates it with the current available character names.
-- Menu width is set to 100. Creates a basic on-click function for displaying the selected text.
-- @param dropDownElement name of the drop down menu element
-- @param withoutPlayerCharacter boolean indicating should the player controled character be excluded from the list
-- @return nil
-- @see Noteworthy_ClearDropDownSelection
function Noteworthy_CreateCharacterListDropDown(dropDownElement, withoutPlayerCharacter)
    local formattedName = function(id)
        local charName = Noteworthy_DB["character_list"][id]
        if withoutPlayerCharacter and Noteworthy_isCharacterIdFromCurrentPlayer(id) then
            charName = Noteworthy_GrayPhrase(charName)
        end
        return charName
    end

    UIDropDownMenu_SetWidth(dropDownElement, 200)
    UIDropDownMenu_Initialize(dropDownElement, function(self, level, menuList)
        for c = 1, Noteworthy_DB["character_count"], 1 do
            local char = Noteworthy_DB["character_list"][c]
            local info = UIDropDownMenu_CreateInfo()
            info.func = function(self)
                local newCharId = self:GetID()
                UIDropDownMenu_SetSelectedID(dropDownElement, newCharId)
                local charName = formattedName(newCharId)
                UIDropDownMenu_SetText(dropDownElement, charName)
            end
            info.text = formattedName(c)
            UIDropDownMenu_AddButton(info)
        end
        Noteworthy_ClearDropDownSelection(dropDownElement)
    end)
end

--- Called when character notes drop down menu selection is changed.
-- @param self the drop down menu
-- @return nil
-- @see Noteworthy_ChangeCharacter
function Noteworthy_UpdateDropDown(self)
    Noteworthy_ChangeCharacter(self:GetID())
end

--- Clears the selection of the passed drop down menu.
-- @param dropDownMenu drop down menu to clear
-- @return nil
function Noteworthy_ClearDropDownSelection(dropDownMenu)
    UIDropDownMenu_SetSelectedID(dropDownMenu, nil)
    UIDropDownMenu_SetText(dropDownMenu, "")
end


----------------------------------------------------------------
-- Edit context menu
----------------------------------------------------------------

-- edit menu frame
local Noteworthy_EditMenuFrame = CreateFrame("Frame", "EditMenuFrame", UIParent, "UIDropDownMenuTemplate")

--- Creates the edit context menu.
-- Manu that appears when right clicking the edit panel on any notes page. It has 'insert info',
-- 'insert chat', 'change text color' and 'clear formatting' options.
-- @return nil
-- @see Ghost_GetSelectedText
-- @see Noteworthy_InsertText
-- @see Ghost_EditBoxSetTextColour
-- @see Ghost_EditBoxClearEscapes
function Noteworthy_EditContextMenu()
    -- set disabled flags
    local undo, redo, target, chat, colour = true, true, true, true, true

    if UnitName("target") then target = false end
    if Noteworthy_DB["chat_logging"] then chat = false end
    if Ghost_GetSelectedText() then colour = false end

    -- create table
    local Noteworthy_EditMenu = {
        { text = "Edit Menu", isTitle = true, notCheckable = true },
        {
            text = "Insert Info",
            hasArrow = true,
            notCheckable = true,
            menuList = {
                { text = "Current Location", func = function() Noteworthy_InsertText(Noteworthy_GetLocation()) end, notCheckable = true },
                { text = "Character Name", func = function() Noteworthy_InsertText(Noteworthy_CreatePlayerName()) end, notCheckable = true },
                { text = "Target Name", func = function() Noteworthy_InsertText(UnitName("target")) end, notCheckable = true, disabled = target },
                { text = "Date", func = function() Noteworthy_InsertText(date(Noteworthy_DB["date_only_format"])) end, notCheckable = true },
                { text = "Date and Time", func = function() Noteworthy_InsertText(date(Noteworthy_DB["date_time_format"])) end, notCheckable = true }
            }
        },
        {
            text = "Insert Chat Log",
            hasArrow = true,
            notCheckable = true,
            disabled = chat,
            menuList = {
                { text = "Last Entry", notCheckable = true, func = function() Noteworthy_InsertText(Noteworthy_GetChat(1)) end },
                { text = "Last 5 Entries", notCheckable = true, func = function() Noteworthy_InsertText(Noteworthy_GetChat(5)) end },
                { text = "Last 15 Entries", notCheckable = true, func = function() Noteworthy_InsertText(Noteworthy_GetChat(15)) end },
                { text = "Last 30 Entries", notCheckable = true, func = function() Noteworthy_InsertText(Noteworthy_GetChat(30)) end }
            }
        },
        { text = "------------------", nil, notCheckable = true, disabled = true },
        {
            text = "Text Colour",
            hasArrow = true,
            notCheckable = true,
            disabled = colour,
            menuList = {
                { text = "|cFF9C9D98Grey|r", func = function() Ghost_EditBoxSetTextColour("9C9D98") end, notCheckable = true },
                { text = "|cFFFFFFFFWhite|r", func = function() Ghost_EditBoxSetTextColour("FFFFFF") end, notCheckable = true },
                { text = "|cFF18DF00Green|r", func = function() Ghost_EditBoxSetTextColour("18DF00") end, notCheckable = true },
                { text = "|cFF0061C2Blue|r", func = function() Ghost_EditBoxSetTextColour("0061C2") end, notCheckable = true },
                { text = "|cFF992FD7Purple|r", func = function() Ghost_EditBoxSetTextColour("992FD7") end, notCheckable = true },
                { text = "|cFFFF7D0AOrange|r", func = function() Ghost_EditBoxSetTextColour("FF7D0A") end, notCheckable = true },
                { text = "|cFFFFFF06Yellow|r", func = function() Ghost_EditBoxSetTextColour("FFFF06") end, notCheckable = true },
                { text = "|cFFC41F3BRed|r", func = function() Ghost_EditBoxSetTextColour("C41F3B") end, notCheckable = true },
                { text = "|cFF69CCF0Cyan|r", func = function() Ghost_EditBoxSetTextColour("69CCF0") end, notCheckable = true }
            }
        },
        { text = "Clear Formatting", func = function() Ghost_EditBoxClearEscapes() end, notCheckable = true },
        { text = "------------------", nil, notCheckable = true, disabled = true },
        { text = "Close Menu", nil, notCheckable = true },
    }

    -- create the menu
    EasyMenu(Noteworthy_EditMenu, Noteworthy_EditMenuFrame, "cursor", 0, 0, "MENU")
end


----------------------------------------------------------------
-- Quick Notes context menu
----------------------------------------------------------------

-- quick menu frame
local Noteworthy_QuickMenuFrame = CreateFrame("Frame", "QuickNotesMenuFrame", UIParent, "UIDropDownMenuTemplate")

--- Creates a quick notes context menu.
-- It has the 'open quick notes', 'add location', 'add target name', 'add chat', 'edit quick notes', and 'edit my notes'
-- options.
-- @return nil
-- @see Noteworthy_AddQuickNote
-- @see Noteworthy_QuickEdit
-- @see Noteworthy_MyEdit
function Noteworthy_QuickContextMenu()
    -- set disabled flags
    local target, chat = true, true

    if UnitName("target") then target = false end
    if Noteworthy_DB["chat_logging"] then chat = false end

    -- create table
    local Noteworthy_QuickMenu = {
        { text = "Quick Notes", isTitle = true, notCheckable = true },
        { text = "Location", func = function() Noteworthy_AddQuickNote(Noteworthy_GetLocation()) end, notCheckable = true },
        { text = "Target Name", func = function() Noteworthy_AddQuickNote(UnitName("target")) end, notCheckable = true, disabled = target },
        {
            text = "Chat Log",
            hasArrow = true,
            notCheckable = true,
            disabled = chat,
            menuList = {
                { text = "Last Entry", notCheckable = true, func = function() Noteworthy_AddQuickNote(Noteworthy_GetChat(1)) end },
                { text = "Last 5 Entries", notCheckable = true, func = function() Noteworthy_AddQuickNote(Noteworthy_GetChat(5)) end },
                { text = "Last 15 Entries", notCheckable = true, func = function() Noteworthy_AddQuickNote(Noteworthy_GetChat(15)) end },
                { text = "Last 30 Entries", notCheckable = true, func = function() Noteworthy_AddQuickNote(Noteworthy_GetChat(30)) end }
            }
        },
        { text = "------------------", nil, notCheckable = true, disabled = true },
        { text = "Edit Quick Notes", func = function() Noteworthy_QuickEdit() end, notCheckable = true },
        { text = "Edit My Notes", func = function() Noteworthy_MyEdit() end, notCheckable = true },
        { text = "------------------", nil, notCheckable = true, disabled = true },
        { text = "Close Menu", nil, notCheckable = true }
    }

    -- open menu
    EasyMenu(Noteworthy_QuickMenu, Noteworthy_QuickMenuFrame, "cursor", 0, 0, "MENU")
end


----------------------------------------------------------------
-- Misc functions
----------------------------------------------------------------

-- minimap and floating button tooltip text
BUTTON_TOOLTIP = "|cFFFFFFFFNoteworthy II|r\nLeft-click: Toggle window\nRight-click: Quick Notes menu"

-- defines a static popup dialog for confirming/denying character notes migration
StaticPopupDialogs["NOTEWORTHY_MIGRATION_CONFIRM"] = {
    text = "Are you sure you want to migrate notes?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = Noteworthy_MigrateCharacterNotes,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

-- defines a static popup dialog for confirming/denying character notes deletion
StaticPopupDialogs["NOTEWORTHY_DELETION_CONFIRM"] = {
    text = "Are you sure you want to delete character notes?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = Noteworthy_RemoveCharacter,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

-- frame backdrop table
NOTEWORTHY_PANEL_BACKDROP = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileEdge = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 },
}

--- Sets the tooltip text for the Noteworthy floating button.
-- @param button the floating button
-- @return nil
function Noteworthy_ButtonTooltip(button)
    if (button.dragging) then return end

    GameTooltip:SetOwner(button or UIParent, "ANCHOR_LEFT")
    GameTooltip:SetText(BUTTON_TOOLTIP)
end

--- Plays the passed sound file.
-- @param snd a table representing the sound Noteworthy_Snd_Type_Kit for soundkid file id or Noteworthy_Snd_Type_File
-- for the file path
-- @return nil
function Noteworthy_PlaySound(snd)
    if Noteworthy_DB["play_sounds"] then
        if snd.type == Noteworthy_Snd_Type_File then
            PlaySoundFile(snd.snd, "SFX")
        else
            PlaySound(snd.snd, "SFX")
        end
    end
end
