# Changelog

## Unreleased (2.0-alpha)
- General
  - Make interface work with BFA.
  - Fix player location retrieval.
  - Update all dependency libs.

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
