![Noteworthy II banner](https://raw.githubusercontent.com/28/NoteworthyII/master/doc/img/Banner.jpg)

# Noteworthy II

The notes, notepad World of Warcraft addon.

Current version:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.0  
Original author:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ghost Dancer (aka ZathrasEU)  
Contributing author:&nbsp;&nbsp;&nbsp;drow_28 (aka Turuvid, Argent Dawn)  

## Description

Noteworthy II is a feature rich, configurable notepad with full LDB support.

Overview of features:

* Separate notes page for each character plus a Shared and Quick Notes page (see below).
* All notes pages are accessible by all characters.
* Drag & drop items, spells and macros, creating linkable tooltips (if applicable).
* Insert game info, including character location, target name and chat logs via pop-up Edit menu.
* Change colour of selected text via pop-up Edit menu.
* Quick Notes pop-up menu adds location, target name and chat logs, even when notepad is closed.
* Reminder system can show alerts for each character.
* Notepad window toggled via minimap/floating button, slash commands, macro or as LDB plug-in.
* Notepad behavior controlled via comprehensive settings.
* Full LDB support.

This is a continuation of development of the original Noteworthy, which can be found [here](https://www.curseforge.com/wow/addons/noteworthy).
The original author approved it.

Logo and banner made by [Alex](mailto:aleksandar.micic028@gmail.com).

## Instructions & notes

* The notepad window can be toggled opened/closed in a number of ways: left-click minimap/floating button, Broker plugin, '/noteworthy' or via a macro.
* All windows and buttons are draggable.
* Each note page can store up to 5000 letters.
* Spells, inventory items and merchant items can be dragged onto the notes window to insert a link.
* Click links to view their tooltip.
* Right click on editbox -> Insert Current Location: Inserts the current zone and coordinates in Tom Tom format.
* Right click on editbox -> Insert Character Name: Inserts current character name.
* Right click on editbox -> Insert Target Name: Inserts name of current target.
* Right click on editbox -> Insert Date: Inserts current date.
* Right click on editbox -> Insert Date and time: Inserts current date and time.
* Right click on editbox -> Insert Chat Log: Inserts a specified number of entries from the chat log (from all major player initiated channels).
* Right click on editbox -> Text Colour: Set selected text to one of preset colors.
* Right click on editbox -> Clear Formatting: Remove colors and hyperlinks. If no selection will apply to whole page.
* Right click on editbox -> Close Menu: Close the pop-up menu.
* The Save button saves all notes and settings, and then closes the window.
* The Cancel button closes the window, losing all changes since opening it (see also 'Save on auto close' checkbox below)
* Press Esc or click outside notepad window to remove focus from the notepad (e.g. to type in the chat) and close pop-up menus (press Esc again to close Noteworthy II).
* Character notes tab is for storing notes specific to each of your characters (defaults to the current character and can be changed in the drop down menu).
* Each character's notes page is created the first time you log on with that character.
* Setting a reminder for a character will show an alert window when logging on with that character:
* Shared notes tab is for storing general notes.
* Quick Notes tab is a special page where notes are added via the quick notes system.
* Add quick notes by right-clicking minimap/floating button or via QuickNotes macro.
* By default, a character & date prefix will be added to each quick note.
* Quick notes are added to top of page unless notepad opened on this page, in which case the text is inserted at the cursor.
* Quick notes Location: Saves the current zone and coordinates in Tom Tom format.
* Quick notes Target Name: Saves name of current target.
* Quick notes Chat Log: Saves a specified number of entries from the chat log (from all major player initiated channels).
* Quick notes Edit Quick Notes: Opens notepad window on Quick Notes tab.
* Quick notes Edit My Notes: Opens notepad window on Character Notes tab and selects the current character.
* Quick notes Close Menu: Close the pop-up menu.
* Settings tab -> Remember last session checkbox: Remember page and cursor between sessions
* Settings tab -> Auto focus checkbox: Focus text area when opening note tabs
* Settings tab -> Close on combat checkbox: Close window when entering combat
* Settings tab -> Save on auto close checkbox: Save changes when closed by toggle, log off and combat
* Settings tab -> Save on page change checkbox: Save changes when changing page
* Settings tab -> Sound effects checkbox: Play sound effects when changing pages and saving
* Settings tab -> Sound effects checkbox: Play sound effects when changing pages and saving
* Settings tab -> Chat logging: Disabling will prevent chat log copying but MIGHT improve performance
* Settings tab -> Minimap button checkbox: Show minimap toggle button
* Settings tab -> Floating button checkbox: Show floating toggle button
* Settings tab -> Create Macros button: Creates Noteworthy II and QuickNotes macros.
* Settings tab -> Add prefix checkbox: Add date and character info line before each quick note
* Settings tab -> Auto edit checkbox: Edit quick note after it is saved to notepad
* Settings tab -> Add at cursor: Insert quick note at cursor if notepad opened on that page (must save changes manually)

## Installation

* Download the Noteworthy II release zip archive
* Unzip the contents to the location: '<wow_install_directory>\_retail_\Interface\AddOns\'

NOTE: If you are updating to V2.0 (or higher) from an earlier version, please delete your old 'Noteworthy' folder first (your settings and data will be unaffected).
This is just to clear out some old files that are no longer being used.

## Contribution and bug reporting

If you are interested in helping the development go to [Noteworthy II GitHub page](https://github.com/28/NoteworthyII).

For any potential issues please open an issue ticket or submit a pull request on [GitHub](https://github.com/28/NoteworthyII).
