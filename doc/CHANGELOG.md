# Change log

## V2.4.9
- General
  - Update dependency libraries
  - Update interface version for Vanilla

## V2.4.8
- General
  - Update interface version for Retail
  - Update interface version for Wrath
  - Update interface version for Vanilla

## V2.4.7
- General
  - Update interface version for Retail
  - Update interface version for Vanilla

## V2.4.6
- General
  - Update interface version for Retail
  - Update interface version for Wrath

## V2.4.5
- General
  - Remove 'Noteworthy II loaded' chat message on log-on
  - Update interface version for Retail
- UI
  - Enrich Options screen with more description and hint text
  - Added chat commands info to Options screen
  - Increase the frame strata to DIALOG
  - Redesign floating button

## V2.4.4
- General
  - Update interface version for Retail

## V2.4.3
- General
  - Update interface version for Retail
  - Update interface version for Classic

## V2.4.2
- General
  - Merge GhostLib.xml to NoteworthyTemplates.xml
  - Update interface version for Retail

## V2.4.1
- General
  - Update interface version for Retail
  - Adapt to new Retail UI changes (fix backward compatibility with Classic/Vanilla)

## V2.4.0
- General
  - Switch to multi TOC packaging (separate TOC for each game version)

## V2.3.4
- General
  - Update interface version

## V2.3.3
- General
  - Update interface version

## V2.3.2
- General
  - Update interface version

## V2.3.1
- General
  - Update interface version

## V2.3.0
- General
  - Introduce the undo feature for each tab
- UI
  - Introduce 'Undo' button in the top right corner of the Noteworthy window

## V2.2.1
- General
  - Update interface version

## V2.2.0
- General
  - Character notes are now saved as 'Character-Realm'
- UI
  - Noteworthy window size changed to 400x450
  - Reminder window size changed to 350x100    
  - Reminder checkbox moved under the text area in character notes screen

## V2.1.1
- General
  - Update interface version
  - Introduce Noteworthy wrapper build tool

## V2.1.0
- General
  - Migrate settings page to Interface/AddOns game menu
  - Introduce character notes migration feature
  - Introduce character notes deletion feature
  - Switch to 3 part version format

## V2.0.1
- General
  - Update game client version to Shadowlands
  - Implement new Backdrop API changes

## V2.0
- General
  - Noteworthy is now draggable only on title part.
  - Always set focus in edit box on click on text area.
  - Add exit button (X button) on top right.
  - Make interface work with BFA.
  - Fix player location retrieval.
  - Update all dependency libs.
  - Add dev helper tools.
  - Make Noteworthy close on ESC.
  - Officially rebrand to Noteworthy II.

## V1.1
- Cursor & selection behavior:
  - EditBox now automatically scrolls to cursor position.
  - Clicking outside notepad window now removes focus from window.
  - Right clicking in EditBox when text selected retains current selection and cursor position.
  - Right clicking in EditBox with no text selected now shows link tooltip.
- Pop-up menus (general):
  - New 'Close Menu' option has been added.
  - Separators added to group similar options.
  - Menu options are disabled if they can't currently be used (e.g. no target, no selection, etc.).
  - Automatically closes when window closed, tab changed, world frame clicked, cursor changes or escape pressed.
- Edit menu
  - Insert options grouped into one 'Insert Info' sub-menu.
  - New option: Insert Info -> Character Name.
  - New option: Insert Info -> Date.
  - New sub-menu: Text Colour (Set selected text to one of nine preset colours).
  - New option: Clear Formatting (Remove colours and hyperlinks. If no selection will apply to whole page).
- Quick Notes
  - Now inserted at the cursor position if notepad opened on quick notes page. Note that text added this way must be saved manually.
  - New option on Settings tab to disable this new behavior.
- New 'Chat logging' setting to disable chat filtering in case it causes performance issues for some users.
- Changed position of link tooltip to keep it within window as much as possible.
- Various other improvements to performance and memory usage.
- Bug fixes:
  - Quick Notes prefix now adds current character name, not the name selected on the character dropdown menu.
  - Link tooltips now detected correctly using actual hyperlink, not text colour.

## V1.01
- Scribble sound now only plays when window is actually saved & closed (and appropriate settings are enabled).

## V1.0
- Release version.
