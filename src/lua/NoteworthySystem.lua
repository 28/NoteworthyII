--==============================================================
-- System code (setup, menus, etc.)
--==============================================================


----------------------------------------------------------------
-- Slash commands
----------------------------------------------------------------

-- slash commands
SLASH_Noteworthy_1, SLASH_Noteworthy_2 = '/noteworthy', '/notes'
SLASH_QuickNotes_1 = '/quicknotes'

--- Creates (assigns) a handler function for the '/noteworthy' command.
-- @param msg a whole message after the slash command (unused)
-- @return nil
-- @see Noteworthy_ToggleView
function SlashCmdList.Noteworthy_(msg)
   Noteworthy_ToggleView()
end

--- Creates (assigns) a handler function for the '/quicknotes' command.
-- @param msg a whole message after the slash command (unused)
-- @return nil
-- @see Noteworthy_QuickContextMenu
function SlashCmdList.QuickNotes_(msg)
   Noteworthy_QuickContextMenu()
end


----------------------------------------------------------------
-- Drop down menu code
----------------------------------------------------------------

--- Creates the character notes drop down menu and fills it with all characters.
-- The character that is currently being played on will be selected. See
-- Noteworthy_UpdateDropDown for selection change handler function.
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
-- @param withoutPlayerCharacter boolean indicating should the player controlled character be excluded from the list
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
   UIDropDownMenu_Initialize(dropDownElement, function(self1, level, menuList)
                                for c = 1, Noteworthy_DB["character_count"], 1 do
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

--- Creates the edit context menu.
-- Menu that appears when right clicking the edit panel on any notes page. It has 'insert info',
-- 'insert chat', 'change text color' and 'clear formatting' options.
-- @return nil
-- @see Ghost_GetSelectedText
-- @see Noteworthy_InsertText
-- @see Ghost_EditBoxSetTextColour
-- @see Ghost_EditBoxClearEscapes
function Noteworthy_EditContextMenu()
   local targetEnabled = false
   if UnitName("target") then
      targetEnabled = true
   end
   local chatLogEnabled = Noteworthy_DB["chat_logging"] or false
   local colorEnabled = false
   if Ghost_GetSelectedText() then
      colorEnabled = true
   end

   MenuUtil.CreateContextMenu(UIParent, function(_, rootDescription)
                                 rootDescription:CreateTitle("Edit Menu")

                                 local insertSubMenu = rootDescription:CreateButton("Insert Info")
                                 insertSubMenu:CreateButton("Current Location", function()
                                                               Noteworthy_InsertText(Noteworthy_GetLocation())
                                                               Noteworthy_SetFocus()
                                 end)
                                 insertSubMenu:CreateButton("Character Name", function()
                                                               Noteworthy_InsertText(Noteworthy_CreatePlayerName())
                                                               Noteworthy_SetFocus()
                                 end)
                                 local targetButton = insertSubMenu:CreateButton("Target Name", function()
                                                                                    Noteworthy_InsertText(UnitName("target"))
                                                                                    Noteworthy_SetFocus()
                                 end)
                                 targetButton:SetEnabled(targetEnabled)
                                 insertSubMenu:CreateButton("Date", function()
                                                               Noteworthy_InsertText(date(Noteworthy_DB["date_only_format"]))
                                                               Noteworthy_SetFocus()
                                 end)
                                 insertSubMenu:CreateButton("Date and Time", function()
                                                               Noteworthy_InsertText(date(Noteworthy_DB["date_time_format"]))
                                                               Noteworthy_SetFocus()
                                 end)

                                 local undoButton = rootDescription:CreateButton("Undo", function()
                                                                                    Noteworthy_PerformUndo()
                                                                                    Noteworthy_SetFocus()
                                 end)
                                 undoButton:SetEnabled(Noteworthy_UndoEnabled())

                                 local chatSubMenu = rootDescription:CreateButton("Chat Log")
                                 chatSubMenu:CreateButton("Last Entry", function()
                                                             Noteworthy_AddQuickNote(Noteworthy_GetChat(1))
                                                             Noteworthy_SetFocus()
                                 end)
                                 chatSubMenu:CreateButton("Last 5 Entries", function()
                                                             Noteworthy_AddQuickNote(Noteworthy_GetChat(5))
                                                             Noteworthy_SetFocus()
                                 end)
                                 chatSubMenu:CreateButton("Last 15 Entries", function()
                                                             Noteworthy_AddQuickNote(Noteworthy_GetChat(15))
                                                             Noteworthy_SetFocus()
                                 end)
                                 chatSubMenu:CreateButton("Last 30 Entries", function()
                                                             Noteworthy_AddQuickNote(Noteworthy_GetChat(30))
                                                             Noteworthy_SetFocus()
                                 end)
                                 chatSubMenu:SetEnabled(chatLogEnabled)

                                 rootDescription:CreateDivider()
                                 local colorSubMenu = rootDescription:CreateButton("Text Color")
                                 colorSubMenu:CreateButton("|cFF9C9D98Grey|r", function()
                                                              Ghost_EditBoxSetTextColour("9C9D98")
                                                              Noteworthy_SetFocus()
                                 end)
                                 colorSubMenu:CreateButton("|cFFFFFFFFWhite|r", function()
                                                              Ghost_EditBoxSetTextColour("FFFFFF")
                                                              Noteworthy_SetFocus()
                                 end)
                                 colorSubMenu:CreateButton("|cFF18DF00Green|r", function()
                                                              Ghost_EditBoxSetTextColour("18DF00")
                                                              Noteworthy_SetFocus()
                                 end)
                                 colorSubMenu:CreateButton("|cFF0061C2Blue|r", function()
                                                              Ghost_EditBoxSetTextColour("0061C2")
                                                              Noteworthy_SetFocus()
                                 end)
                                 colorSubMenu:CreateButton("|cFF992FD7Purple|r", function()
                                                              Ghost_EditBoxSetTextColour("992FD7")
                                                              Noteworthy_SetFocus()
                                 end)
                                 colorSubMenu:CreateButton("|cFFFF7D0AOrange|r", function()
                                                              Ghost_EditBoxSetTextColour("FF7D0A")
                                                              Noteworthy_SetFocus()
                                 end)
                                 colorSubMenu:CreateButton("|cFFFFFF06Yellow|r", function()
                                                              Ghost_EditBoxSetTextColour("FFFF06")
                                                              Noteworthy_SetFocus()
                                 end)
                                 colorSubMenu:CreateButton("|cFFC41F3BRed|r", function()
                                                              Ghost_EditBoxSetTextColour("C41F3B")
                                                              Noteworthy_SetFocus()
                                 end)
                                 colorSubMenu:CreateButton("|cFF69CCF0Cyan|r", function()
                                                              Ghost_EditBoxSetTextColour("69CCF0")
                                                              Noteworthy_SetFocus()
                                 end)
                                 colorSubMenu:SetEnabled(colorEnabled)

                                 rootDescription:CreateButton("Clear Formatting", function()
                                                                 Ghost_EditBoxClearEscapes()
                                                                 Noteworthy_SetFocus()
                                 end)
                                 rootDescription:CreateDivider()
                                 rootDescription:CreateButton("Close Menu", function() end)

   end)
end


----------------------------------------------------------------
-- Quick Notes context menu
----------------------------------------------------------------

--- Creates a quick notes context menu.
-- It has the 'open quick notes', 'add location', 'add target name', 'add chat', 'edit quick notes', and 'edit my notes'
-- options.
-- @return nil
-- @see Noteworthy_AddQuickNote
-- @see Noteworthy_QuickEdit
-- @see Noteworthy_MyEdit
function Noteworthy_QuickContextMenu()
   local targetEnabled = false
   if UnitName("target") then
      targetEnabled = true
   end
   local chatLogEnabled = Noteworthy_DB["chat_logging"] or false

   MenuUtil.CreateContextMenu(UIParent, function(_, rootDescription)
                                 rootDescription:CreateTitle("Quick Notes")
                                 rootDescription:CreateButton("Location", function() Noteworthy_AddQuickNote(Noteworthy_GetLocation()) end)
                                 local targetButton = rootDescription:CreateButton("Target Name", function() Noteworthy_AddQuickNote(UnitName("target")) end)
                                 targetButton:SetEnabled(targetEnabled)

                                 local chatSubMenu = rootDescription:CreateButton("Chat Log")
                                 chatSubMenu:CreateButton("Last Entry", function() Noteworthy_AddQuickNote(Noteworthy_GetChat(1))  end)
                                 chatSubMenu:CreateButton("Last 5 Entries", function() Noteworthy_AddQuickNote(Noteworthy_GetChat(5))  end)
                                 chatSubMenu:CreateButton("Last 15 Entries", function() Noteworthy_AddQuickNote(Noteworthy_GetChat(15)) end)
                                 chatSubMenu:CreateButton("Last 30 Entries", function() Noteworthy_AddQuickNote(Noteworthy_GetChat(30)) end)
                                 chatSubMenu:SetEnabled(chatLogEnabled)

                                 rootDescription:CreateDivider()
                                 rootDescription:CreateButton("Edit Quick Notes", function() Noteworthy_QuickEdit() end)
                                 rootDescription:CreateButton("Edit My Notes", function() Noteworthy_MyEdit()  end)
                                 rootDescription:CreateDivider()
                                 rootDescription:CreateButton("Close Menu", function () end)
   end)
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
