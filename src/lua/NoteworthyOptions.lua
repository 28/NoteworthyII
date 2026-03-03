--==============================================================
-- Add-on settings code
--==============================================================

Noteworthy_Options = {}

local panel = CreateFrame("Frame")
local characterPanel = CreateFrame("Frame")

local scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 3, -4)
scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

local scrollChild = CreateFrame("Frame", nil, panel)
scrollFrame:SetScrollChild(scrollChild)
scrollChild:SetHeight(1)
scrollChild:SetWidth(panel:GetWidth() - 18)
panel.scrollChild = scrollChild

local function CreateText(text, parent, previous)
   local title = parent:CreateFontString(nil, nil, "GameFontNormal")
   title:SetText(text)
   title:SetTextColor(1, 1, 1)

   if previous then
      title:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -15)
   else
      title:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -5)
   end

   title:SetWidth(180)
   title:SetJustifyH("LEFT")

   return title
end

local function CreateDetailsText(text, parent, previous)
   local title = parent:CreateFontString(nil, nil, "GameFontNormal")
   title:SetText(text)
   title:SetTextColor(1, 1, 1)

   if previous then
      title:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -15)
   else
      title:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -5)
   end

   title:SetWidth(600)
   title:SetJustifyH("LEFT")

   return title
end

local function CreateHeading(text, parent, previous)
   local title = parent:CreateFontString(nil, nil, "GameFontNormalLarge")
   title:SetText(text)

   if previous then
      title:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -15)
   else
      title:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -5)
   end

   title:SetWidth(250)
   title:SetJustifyH("LEFT")

   return title
end

local function CreateVersionHeading(parent, previous)
   local title = parent:CreateFontString(nil, nil, "GameFontNormalLarge")
   title:SetText(Noteworthy_GetStructuredVersion())

   if previous then
      title:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -25)
   else
      title:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -5)
   end

   title:SetWidth(600)
   title:SetJustifyH("RIGHT")

   return title
end

local function CreateCheckButton(name, variable, description, parent, previous, updateUi)
   local title = CreateText(name, parent, previous)
   title:SetHeight(20)

   local checkFrame = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
   checkFrame:SetPoint("TOPLEFT", title, "TOPRIGHT", 0, 4)
   checkFrame:SetPoint("BOTTOMLEFT", title, "BOTTOMLEFT", 0, -4)

   checkFrame.tooltipTitle = name
   checkFrame.tooltipText = description

   checkFrame:SetScript("OnEnter", function(self)
                           if self.tooltipText then
                              GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                              GameTooltip:SetText(self.tooltipTitle, nil, nil, nil, nil, true)
                              GameTooltip:AddLine(self.tooltipText, 1, 1, 1, nil, true)
                              GameTooltip:Show()
                           end
   end)

   checkFrame:SetScript("OnLeave", function(self)
                           GameTooltip:Hide()
   end)

   if variable == "show_minimap_button" then
      checkFrame:SetScript("OnClick", function(self)
                              Noteworthy_UpdateMinimapButtonOption(self:GetChecked())
      end)
   else
      checkFrame:SetScript("OnClick", function(self)
                           Noteworthy_SaveFlagOptions(variable, self:GetChecked(), updateUi or false)
      end)
   end
   Noteworthy_Options[variable] = checkFrame

   return title
end

local function CreateButton(name, onClick, parent, previous)
   local title = CreateText("", parent, previous)
   title:SetHeight(20)

   local button = CreateFrame("Button", "Test", parent, "UIPanelButtonTemplate")
   button:SetSize(110 ,22)
   button:SetText(name)
   button:SetPoint("TOPLEFT", title, "TOPRIGHT", 0, 4)
   button:SetPoint("BOTTOMLEFT", title, "BOTTOMLEFT", 0, -4)
   button:SetScript("OnClick", onClick)

   return title
end

local function CreateMainSettings(parent)
   local p = nil

   p = CreateHeading("General", parent, p)

   p = CreateCheckButton("Remember last session", "remember_page", "Remember page and cursor between sessions", parent, p)
   p = CreateCheckButton("Auto focus", "focus_text", "Focus text area when opening note tabs",  parent, p)
   p = CreateCheckButton("Close on combat", "combat_close", "Close window when entering combat", parent, p)
   p = CreateCheckButton("Save on auto close", "save_on_close", "Save changes when closed by toggle, logoff and combat", parent, p)
   p = CreateCheckButton("Save on page change", "save_on_page_change", "Save changes when changing page",  parent, p)
   p = CreateCheckButton("Sound effects", "play_sounds", "Play sound effects when changing pages and saving", parent, p)
   p = CreateCheckButton("Verbose output", "verbose", "Noteworthy II will report some of its activities in the chat", parent, p)
   p = CreateCheckButton("Create notes on open", "notes_on_open", "When enabled, Noteworthy II will create character notes for new characters when Noteworthy II is opened, instead on log-in. Enable this if you have characters you don't use Noteworthy II with.", parent, p)

   p = CreateHeading("Buttons", parent, p)

   p = CreateCheckButton("Minimap button", "show_minimap_button", "Show minimap toggle button", parent, p)
   p = CreateCheckButton("Floating button", "show_floating_button", "Show floating toggle button", parent, p, true)

   p = CreateHeading("Quick Notes", parent, p)

   p = CreateCheckButton("Add prefix", "qnote_prefix", "Add date and character info line before each quick note", parent, p)
   p = CreateCheckButton("Auto edit", "qnote_edit", "Edit quick note after it is saved to notepad", parent, p)
   p = CreateCheckButton("Add at cursor", "qnote_cursor", "Insert quick note at cursor if notepad opened on that page (must save changes manually)", parent, p)

   p = CreateHeading("Performance", parent, p)

   p = CreateDetailsText("Some features can be memory-heavy and disabling them can boost UI performance (especially if you are running a lot of AddOns).", parent, p)

   p = CreateCheckButton("Chat logging", "chat_logging", "Disabling will prevent chat log copying but should improve performance", parent, p, true)
   p = CreateCheckButton("Undo", "undo", "Disabling will prevent undoing note changes but should improve performance", parent, p, true)

   p = CreateHeading("Macros", parent, p)

   p = CreateDetailsText("Pressing the bellow button will create two macros (if they don't exist already) that you can drag to your action bar. These macros will open Noteworthy II character notes and Quick Notes menu respectfully.", parent, p)

   p = CreateButton("Create Macros", Noteworthy_CreateMacros, parent, p)

   p = CreateDetailsText("You can open Noteworthy II by typing the '/noteworthy', '/notes' or '/quicknotes' commands in the chat.", parent, p)

   p = CreateDetailsText("If your minimap is cluttered with AddOns consider enabling the Noteworthy II floating button and placing it anywhere on the screen.", parent, p)

   p = CreateVersionHeading(parent, p)
end

local function NotesMigrationButtonHandler()
   local fromCharId = UIDropDownMenu_GetSelectedID(Noteworthy_Options.fromDropDown)
   local toCharId = UIDropDownMenu_GetSelectedID(Noteworthy_Options.toDropDown)
   if fromCharId ~= nil and toCharId ~= nil and fromCharId ~= toCharId then
      StaticPopup_Show("NOTEWORTHY_MIGRATION_CONFIRM")
   end
end

local function NotesDeleteButtonHandler()
   local charId = UIDropDownMenu_GetSelectedID(Noteworthy_Options.delDropDown)
   if charId ~= nil and not Noteworthy_isCharacterIdFromCurrentPlayer(charId) then
      StaticPopup_Show("NOTEWORTHY_DELETION_CONFIRM")
   end
end

local function CreateMigrationSettings(parent)
   local p = nil

   p = CreateHeading("Character Notes Migration", parent, p)

   p = CreateDetailsText("Migrate notes from one character to another. By default notes will be appended to the end of the target character's notes as a new paragraph. Ticking the 'Override' box will erase the target character's notes before appending. All unsaved work will be lost! Origin notes can be preserved by ticking the 'Preserve origin', otherwise they will be removed!", parent, p)

   p = CreateText("From character:", parent, p)

   FromCharacterDropDown = CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate")
   FromCharacterDropDown:SetPoint("TOPLEFT", p, "TOPRIGHT", 0, 0)
   Noteworthy_Options.fromDropDown = FromCharacterDropDown
   p:SetHeight(FromCharacterDropDown:GetHeight())

   p = CreateText("To character:", parent, p)

   ToCharacterDropDown = CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate")
   ToCharacterDropDown:SetPoint("TOPLEFT", p, "TOPRIGHT", 0, 0)
   Noteworthy_Options.toDropDown = ToCharacterDropDown
   p:SetHeight(ToCharacterDropDown:GetHeight())

   p = CreateCheckButton("Override", "migrate_override", "Save changes when changing page",  parent, p)
   p = CreateCheckButton("Preserve origin", "migrate_preserve", "Play sound effects when changing pages and saving", parent, p)

   p = CreateButton("Migrate", NotesMigrationButtonHandler, parent, p)

   p = CreateHeading("Character Notes Deletion", parent, p)

   p = CreateDetailsText("Select a character from the drop-down menu to delete their notes, remove it from the list, and disable the reminder. This cannot be done for the playing character. Character notes which were deleted will be recreated upon logon but with placeholder text. All unsaved work will be lost!", parent, p)

   p = CreateText("Character:", parent, p)

   DeleteCharacterDropDown = CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate")
   DeleteCharacterDropDown:SetPoint("TOPLEFT", p, "TOPRIGHT", 0, 0)
   Noteworthy_Options.delDropDown = DeleteCharacterDropDown
   p:SetHeight(DeleteCharacterDropDown:GetHeight())

   p = CreateButton("Delete Notes", NotesDeleteButtonHandler, parent, p)
end

CreateMainSettings(scrollChild)
CreateMigrationSettings(characterPanel)

local category = Settings.RegisterCanvasLayoutCategory(panel, "Noteworthy II", "Noteworthy II")
local characterManagementCategory = Settings.RegisterCanvasLayoutSubcategory(category, characterPanel, "Character Management")

Settings.RegisterAddOnCategory(category)
