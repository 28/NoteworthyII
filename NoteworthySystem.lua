--==============================================================
-- System code (setup, menus, etc.)
--==============================================================


----------------------------------------------------------------
-- Slash commands
----------------------------------------------------------------
SLASH_Noteworthy_1, SLASH_Noteworthy_2 = '/noteworthy', '/notes'
SLASH_QuickNotes_1 = '/quicknotes'

function SlashCmdList.Noteworthy_(msg, editbox)
    Noteworthy_ToggleView()
end

function SlashCmdList.QuickNotes_(msg, editbox)
    Noteworthy_QuickContextMenu()
end


----------------------------------------------------------------
-- Dropdown menu Code
----------------------------------------------------------------
function Noteworthy_CreateDropDown()
    UIDropDownMenu_SetWidth(Noteworthy_DropDown, 100)
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
    UIDropDownMenu_SetWidth(dropDownElement, 100)
    UIDropDownMenu_Initialize(dropDownElement, function(self, level, menuList)
        for c = 1, Noteworthy_DB["character_count"], 1 do
            local char = Noteworthy_DB["character_list"][c]
            if char ~= GetUnitName("player") or not withoutPlayerCharacter then
                local info = UIDropDownMenu_CreateInfo()
                info.func = function(self)
                    local newCharId = self:GetID()
                    UIDropDownMenu_SetSelectedID(dropDownElement, newCharId)
                    local charName = Noteworthy_DB["character_list"][newCharId]
                    UIDropDownMenu_SetText(dropDownElement, charName)
                end
                info.text = Noteworthy_DB["character_list"][c]
                UIDropDownMenu_AddButton(info)
            end
        end
        Noteworthy_ClearDropDownSelection(dropDownElement)
    end)
end

function Noteworthy_UpdateDropDown(self)
    Noteworthy_ChangeCharacter(self:GetID())
end

--- Clears the selection of the passed drop down menu.
-- @param dropDownMenu drop down menu to clear
-- @return nil
function Noteworthy_ClearDropDownSelection(dropDownMenu)
    UIDropDownMenu_SetSelectedID(dropDownMenu, nil)
    UIDropDownMenu_SetText(dropDownMenu, nil)
end


----------------------------------------------------------------
-- Edit context menu
----------------------------------------------------------------
local Noteworthy_EditMenuFrame = CreateFrame("Frame", "EditMenuFrame", UIParent, "UIDropDownMenuTemplate")

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
                { text = "Character Name", func = function() Noteworthy_InsertText(UnitName("player")) end, notCheckable = true },
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
local Noteworthy_QuickMenuFrame = CreateFrame("Frame", "QuickNotesMenuFrame", UIParent, "UIDropDownMenuTemplate")

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

-- Defines a static popup dialog for confirming/denying character notes migration.
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

-- Defines a static popup dialog for confirming/denying character notes deletion.
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

function Noteworthy_ButtonTooltip(button)
    if (button.dragging) then return end

    GameTooltip:SetOwner(button or UIParent, "ANCHOR_LEFT")
    GameTooltip:SetText(BUTTON_TOOLTIP)
end

function Noteworthy_PlaySound(snd)
    if Noteworthy_DB["play_sounds"] then
        if snd.type == Noteworthy_Snd_Type_File then
            PlaySoundFile(snd.snd, "SFX")
        else
            PlaySound(snd.snd, "SFX")
        end
    end
end
