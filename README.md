<!--suppress ALL -->
<p align="center">
    <img src="https://media.forgecdn.net/attachments/780/466/banner.jpg" alt="Noteworthy II banner"/>
</p>

## Development moved to [Sourcehut](https://sr.ht/~tpt/NoteworthyII/)

The main code repository is on Sourcehut, but the GitHub instance will
be an actively updated mirror.

For any bug reports, issues, contributions:
- open an issue or pull request on GitHub
- [e-mail](#contributions) me

# Noteworthy II

[![builds.sr.ht status](https://builds.sr.ht/~tpt.svg)](https://builds.sr.ht/~tpt?)

Fully featured and configurable notes, notepad World of Warcraft addon.

Current version: 2.4.9  
Maintainer: Dejan Josifović / drow_28 / Turuvid, Argent Dawn  
Original author: Ghost Dancer (aka ZathrasEU)

## Description

Noteworthy II is a feature rich, configurable notepad with full LDB
support.

Overview of features:
- Separate notes page for each character with advanced management options, plus a Shared and Quick Notes
page (see below).
- All notes pages are accessible by all characters.
- Drag & drop items, spells and macros, creating linkable tooltips
(if applicable).
- Insert game info, including character location, target name and chat
logs via pop-up Edit menu.
- Change colour of selected text via pop-up Edit menu.
- Quick Notes pop-up menu adds location, target name and chat logs,
even when notepad is closed.
- Reminder system can show alerts for each character.
- Notepad window toggled via minimap/floating button, slash commands,
macro or as LDB plug-in.
- Notepad behavior controlled via comprehensive settings.
- Full LDB support.
- Undo changes support.

This is a continuation of development of the original Noteworthy, which
the original author approved.

Logo and banner made by [Alex](mailto:aleksandar.micic028@gmail.com).

## Screenshots

<img src="https://media.forgecdn.net/attachments/390/968/screen_main_page.jpg" alt="Noteworthy II main page" title="Noteworthy II main page" width="200" align="left"/>
<img src="https://media.forgecdn.net/attachments/390/972/screen_shared.jpg" alt="Noteworthy II shared notes page" title="Noteworthy II shared notes page" width="200" align="left"/>
<img src="https://media.forgecdn.net/attachments/390/971/screen_quick.jpg" alt="Noteworthy II quick notes page" title="Noteworthy II quick notes page" width="200"/>
<img src="https://media.forgecdn.net/attachments/660/401/screen_settings.jpg" alt="Noteworthy II settings page" title="Noteworthy II settings page" width="200" align="left"/>
<img src="https://media.forgecdn.net/attachments/660/402/screen_settings_notes.jpg" alt="Noteworthy II notes settings page" title="Noteworthy II notes settings page" width="200" align="left"/>
<img src="https://media.forgecdn.net/attachments/368/394/screen_reminder.jpg" alt="Noteworthy II reminder" title="Noteworthy II reminder" width="200" align="left"/>
<img src="https://media.forgecdn.net/attachments/306/864/screen_minimap.jpg" alt="Noteworthy II icon on the minimap" title="Noteworthy II icon on the minimap" width="200" align="left"/>
<img src="https://media.forgecdn.net/attachments/660/403/screen_floating_button.jpg" alt="Noteworthy II floating button" title="Noteworthy II floating button" width="200"/>

## Instructions & notes

- The notepad window can be toggled opened/closed in a number of ways:
  left-click minimap/floating button, Broker plugin, '/noteworthy', '/notes', '/quicknotes' or via a macro.
- All windows and buttons are draggable.
- General EditBox features:
  - Each note page can store up to 5000 letters.
  - Spells, inventory items and merchant items can be dragged onto the notes window to insert a link.
  - Click links to view their tooltip.
  - Right click in editbox for the pop-up Edit menu:
	- Insert Info -> Current Location: Inserts the current zone and coordinates in Tom Tom format.
	- Insert Info -> Character Name: Inserts current character name.
	- Insert Info -> Target Name: Inserts name of current target.
	- Insert Info -> Date: Inserts current date.
	- Insert Info -> Date and time: Inserts current date and time.
	- Insert Chat Log: Inserts a specified number of entries from the chat log (from all major player initiated channels).
	- Text Color: Set selected text to one of preset colors.
	- Clear Formatting: Remove colors and hyperlinks. If no selection apply to whole page.
	- Close Menu: Close the pop-up menu.
  - The Save button saves all notes and settings, and then closes the window.
  - The Cancel button closes the window, losing all changes since opening it
	(see also 'Save on auto close' checkbox below)
  - Press Esc or click outside notepad window to remove focus from the notepad (e.g., to type in the chat) and close pop-up menus (press Esc again to close Noteworthy II).
  - The Undo button reverts a number of last changes (typing, text insert, etc.)
- Character Notes tab:
  - This tab is for storing notes specific to each of your characters.
  - It defaults to the current logged on character and can be changed via the drop-down menu.
  - Each character's notes page is created the first time you log on with that character.
  - Setting a reminder for a character will show an alert window when logging on with that character:
	- Open Notes button: Close alert window and open notepad window.
	- Remind Again button: Close alert window and leave reminder enabled for next login.
- Shared Notes tab:
  - This page is for storing general notes.
- Quick Notes tab:
  - This is a special page where notes are added via the quick notes system.
  - Add quick notes by right-clicking minimap/floating button or via QuickNotes macro.
  - By default, a character & date prefix will be added to each quick note.
  - Quick notes are added to top of page unless notepad opened on this page, in which case the text is inserted at the cursor.
  - Quick notes options can be found on the Settings tab.
  - Quick Notes menu
	- Location: Saves the current zone and coordinates in Tom Tom format.
	- Target Name: Saves name of current target.
	- Chat Log: Saves a specified number of entries from the chat log (from all major player initiated channels).
	- Edit Quick Notes: Opens notepad window on Quick Notes tab.
	- Edit My Notes: Opens notepad window on Character Notes tab and selects the current character.
	- Close Menu: Close the pop-up menu.
- Settings page - Interface/AddOns/Noteworthy II (General):
  - Remember last session checkbox: Remember page and cursor between sessions
	- Enabled: Remembers last page and cursor position when you log off.
	- Disabled: First use each session will open on the current character's page.
  - Autofocus checkbox: Focus text area when opening note tabs
	- Enabled: Whenever a notes page is opened, the cursor is focused in the text area.
	- Disabled: To edit text, you must click in the text area.
  - Close on combat checkbox: Close window when entering combat
	- Enabled: If you enter combat, the notepad window will automatically close.
	- Disabled: The notepad window remains open when entering combat.
  - Save on auto close checkbox: Save changes when closed by toggle, log off and combat
	- Enabled: Closing the window by toggling, logging off or entering combat will save all changes.
	- Disabled: Any changes will be lost if the window is closed via the above methods.
  - Save on page change checkbox: Save changes when changing page
	- Enabled: Changes to notes and settings are saved whenever you change tab/page.
	- Disabled: Changes are only saved when the Save button is clicked.
  - Sound effects checkbox: Play sound effects when changing pages and saving
	- Enabled: Sounds effects are played.
	- Disabled: Sounds effects are not played.
  - Sound effects checkbox: Play sound effects when changing pages and saving
	- Enabled: Sounds effects are played.
	- Disabled: Sounds effects are not played.
- Settings page - Interface/AddOns/Noteworthy II (Performance):
  - Chat logging: Disabling will prevent chat log copying but should improve performance
	- Enabled: Enables copying of chat logs using message filters.
	- Disabled: Disables message filters required for copy chat logs feature.
  - Undo: Disabling will prevent undoing note changes but should improve performance
	- Enabled: Enables the Undo button and undo feature - revert any change made on any note type.
	- Disabled: The undo button and undo feature will not work (Nothing will happen when the button is pressed).
- Settings page - Interface/AddOns/Noteworthy II(Buttons):
  - Minimap button checkbox: Show minimap toggle button
	- Enabled: Enables a minimap button to toggle the notepad window.
	- Disabled: Disables the minimap button.
  - Floating button checkbox: Show floating toggle button
	- Enabled: Enables a floating button to toggle the notepad window.
	- Disabled: Disables the floating button.
  - Create Macros button: Creates Noteworthy II and QuickNotes macros.
- Settings page - Interface/AddOns/Noteworthy II (Quick Notes):
  - Add prefix checkbox: Add date and character info line before each quick note
	- Enabled: Adds blank line and info line with date, time & current character name.
	- Disabled: No additional information is added.
  - Auto edit checkbox: Edit quick note after it is saved to notepad
	- Enabled: Opens quick notes tab in window after quick note has been saved.
	- Disabled: Displays notification in chat.
  - Add at cursor: Insert quick note at cursor if notepad opened on that page (must save changes manually)
	- Enabled: If notepad opened on quick notes tab, quick notes will be inserted at cursor position.
	  Note that when added this way, you must manually Save any changes to the text.
	- Disabled: Quick notes will always be added at the top and will be automatically saved.
- Settings page/Character notes - Interface/AddOns/Noteworthy II/Character Notes:
  - Migrate notes: Migrate notes from one character from drop down menu to another character from drop down menu.
    - Override checkbox: Override the target character notes
    - Preserve origin checkbox: Preserve the origin character notes
  - Delete notes: Delete notes for selected character from the drop-down menu (Character which notes were deleted will be recreated upon logon, but with placeholder text).

## Installation

### Manual

1. Download the Noteworthy II release zip archive from [here](https://git.sr.ht/~tpt/NoteworthyII/refs)
2. Unzip the contents to the location: '<wow_install_directory>\_retail_\Interface\AddOns\'
Note that the zip archive already contains the 'NoteworthyII' directory which should be extracted as is.
This means that the final path after the extraction will be: '<wow_install_directory>\_retail_\Interface\AddOns\NoteworthyII'.
The same is applied for other versions of the game, only the destination folder is different - Classic: '\_classic_era_', Wrath of the Lich King: '\_classic_'
3. Start the game, Noteworthy II should be listed in the 'AddOns' game menu

### CurseForge (Overwolf) app

1. Start the [CurseForge (Overwolf) app](https://www.curseforge.com/download/app)
2. Select 'World of Warcraft' game
3. In the top search bar type 'Noteworthy II'
4. Click the 'Install' button on the 'Action' column
5. When installed, start the game, Noteworthy II should be listed in the 'AddOns' game menu

### WoWUp

1. Start the [WowUp app](https://wowup.io)
2. Navigate to 'Get Addons' tab
3. In the upper right search menu type 'Noteworthy II'
4. Select the addon from the list and click the 'Install' button on the right
5. When installed, start the game, Noteworthy II should be listed in the 'AddOns' game menu

### Important

NOTE: If you are updating to V2.0 (or higher) from an earlier version, please
delete your old 'Noteworthy' folder first (your settings and data will be unaffected;
v2.0 folder now has a different name).
This is just to clear out some old files that are no longer being used.

## Development

Noteworthy II is developed in one repository/project for all game versions.

Noteworthy II project file structure:
```text
+- src
	+- lua
		|- GhostLib.lua ---> Code for text editing
		|- NoteworthyBroker.lua ---> Contains LDB code for Noteworthy II
		|- NoteworthyMain.lua ---> Main library code
		|- NoteworthySystem.lua ---> Code for menus, commands and misc
	+- xml
		|- NoteworthyButton.xml ---> Code for the floating button
		|- NoteworthyOptions.xml ---> Noteworthy II settings that appear in Interface settings
		|- NoteworthyTemplates.xml ---> Noteworthy II specific reusable XML templates
		|- NoteworthyVarTemplates.xml ---> Noteworthy II templates that differ between game versions - Retail
		|- NoteworthyVarTemplates-classic.xml ---> Noteworthy II templates that differ between game versions - Classic Era and Classic
		|- NoteworthyWindows.xml ---> Noteworthy II main XML file (main and alert windows)
|- NoteworthyII.toc ---> The Retail TOC file
|- NoteworthyII-Vanilla.toc ---> The Classic Era TOC file
|- NoteworthyII-Wrath.toc ---> The Wrath of the Lich King TOC file
```

Noteworthy II XML structure leverages heavily on inheritance, and
components are located in multiple files. Here is a diagram of
inheritance trying to explain which component is in which file and 
which component inherits which.

![Noteworthy XML inheritance](doc/diagrams/noteworthy-xml-inheritance.png "Noteworthy II XML inheritance")

### Contributions

For any suggestions, bug reports, ideas and patches please send a [plain-text e-mail](https://useplaintext.email)
to ```~tpt/noteworthy-dev@lists.sr.ht```.

### Change log

See the change log file [here](doc/CHANGELOG.md).

### Dependencies

Dependency management and updating is done manually. All libraries are
packaged with Noteworthy II.

1. **CallbackHandler-1.0**  
CallbackHandler is a back-end utility library that makes it easy for
a library to fire its events to interested parties.  
Last updated on 27.12.2023.  
Located [here](https://www.curseforge.com/wow/addons/callbackhandler).

2. **LibDataBroker-1.1**  
LibDataBroker is a small WoW addon library designed to provide an MVC
interface for use in various addons.  
Last updated on 09.10.2018.  
Located [here](https://www.curseforge.com/wow/addons/libdatabroker-1-1).

3. **LibDBIcon-1.0**  
LibDBIcon is a small library you can throw in your LDB addon that will
create a small minimap icon for you and nothing more.  
Last updated on 27.12.2023.  
Located [here](https://www.curseforge.com/wow/addons/libdbicon-1-0).

4. **LibStub**  
LibStub is a minimalist versioning library that allows other
libraries to easily register themselves and upgrade.  
Last updated on 24.07.2019.  
Located [here](https://www.curseforge.com/wow/addons/libstub).

### Noteworthy Wrapper

Noteworthy Wrapper is a custom-made build tool for Noteworthy II.
See the [wrapper repository](https://git.sr.ht/~tpt/Noteworthy-Wrapper) for more info.

### Upcoming

There is no schedule or release date for these features, they are here only for the record.

1. ~~Undo feature~~ (Done in V2.3.0)
2. ~~Move settings to the Interface/Addon game menu~~ (Done in V2.1.0)
3. ~~Restructure the source code to make it more manageable (decide what to do with GhostLib)~~ (New structure implemented
and GhostLib is merged to Noteworthy II source.)
4. ~~Add entries from Combat log to Quick Notes~~ (Decided to omit this as it is too complicated to be a nice-to-have
feature. There are better add-ons that deal with this problem.)
5. Think about UI redesign (not yet confirmed)

#### Requests from the community

These have a slightly higher priority.

1. ~~Character notes should be saved as 'Character-Realm' instead of just 'Character' so that same-named characters
from different realms can have their own notes.~~ (Introduced in V2.2.0)
2. Multiple personal notes per character. It will be easier to divide the notes per topic. (See [wireframes](doc/wireframes/noteworthy-character-notes-wireframes.org).)
3. Create character notes for new characters upon opening Noteworthy II instead of on log-on. This will reduce the number
of unwanted character notes when a player has multiple alts.

### Known issues

- Noteworthy II main window drag can sometimes misbehave like jumping on screen on mouse key. This will be solved
as soon as possible. If it becomes too irritating, reload the UI with `/reload` command.
- ~~If a character who has valid notes (they at least logged in with Noteworthy II on) is deleted, their notes remain
present in the character notes panel without the option to be removed. This will be handled in one of the upcoming
releases.~~ (v2.1.0 introduced migrate and delete character notes feature)
- Sometimes the cursor can misbehave during notes writing (any note type) - randomly change position in the text.
I'm still investigating the issue, and hopefully it will be solved as soon as possible.

Suggestions for solutions are always welcome! Submit a pull request or open an issue. Thanks!

## License

Copyright (C) 2018-2024. Dejan Josifović, The Paranoid Times

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
