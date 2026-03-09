--==============================================================
-- Ghost utility functions
--==============================================================


----------------------------------------------------------------
-- Misc functions
----------------------------------------------------------------
local waitTable = {};
local waitFrame;

--- Waits for the given 'delay' an executes the function with the passes arguments
-- @param delay the delay duration
-- @param func function to execute
-- @param function_params variable parameters to pass to the function
function Ghost_Wait(delay, func, ...)
    if (type(delay) ~= "number" or type(func) ~= "function") then
        return false;
    end
    if (waitFrame == nil) then
        waitFrame = CreateFrame("Frame", "WaitFrame", UIParent);
        waitFrame:SetScript("onUpdate", function(self, elapse)
            local count = #waitTable;
            local i = 1;
            while (i <= count) do
                local waitRecord = tremove(waitTable, i);
                local d = tremove(waitRecord, 1);
                local f = tremove(waitRecord, 1);
                local p = tremove(waitRecord, 1);
                if (d > elapse) then
                    tinsert(waitTable, i, { d - elapse, f, p });
                    i = i + 1;
                else
                    count = count - 1;
                    f(unpack(p));
                end
            end
        end);
    end
    tinsert(waitTable, { delay, func, { ... } });
    return true;
end

--- Creates a macro if a macro with the same name does not exist.
-- @param name the macro name
-- @param icon the macro icon
-- @param text the macro code
function Ghost_CreateMacro(name, icon, text)
    if GetMacroIndexByName(name) == 0 then
        CreateMacro(name, icon, text, nil, nil)

        if (Noteworthy_DB["verbose"]) then
           if GetMacroIndexByName(name) then
              print("|cFF18DF00Noteworthy II|r: " .. name .. " macro has been created.")
           else
              print("|cFF18DF00Noteworthy II|r: Unable to create " .. name .. " macro.")
           end
        end
    else
       if (Noteworthy_DB["verbose"]) then
          print("|cFF18DF00Noteworthy II|r: " .. name .. " macro already exists")
       end
    end
end

--- Clear character encoding from specified text.
-- @param text text to clear
-- @return cleared text
function Ghost_ClearEscapeCodes(text)
    -- clear hyperlink encoding (but only if entire sequence is within our selected text)
    text = text:gsub("(|H.-|h)(.-)(|h)", "%2")

    -- ditto for color
    text = text:gsub("(|c%x%x%x%x%x%x%x%x)(.-)(|r)", "%2")

    return text
end

--- Get positions of text markers within a string, with optional starting position.
-- @param text text to get the positions from
-- @param startTxt starting text
-- @param endTxt ending text
-- @param cursorPos starting cursor position
-- @return the start and end positions of the subtext
function Ghost_GetTextPositions(text, startTxt, endTxt, cursorPos)
   if text == nil then
      return nil,nil
   end

    cursorPos = cursorPos or 0 -- default value of 0

    local pos = 1
    local startPtr = 0
    local endPtr = 0

    while (pos and pos < string.len(text)) do
        startPtr = string.find(text, startTxt, pos, true)

        if (not startPtr) then
            return nil, nil
        else
            endPtr = string.find(text, endTxt, startPtr, true)

            if (startPtr and startPtr < cursorPos and endPtr and endPtr > cursorPos) then
                return startPtr, endPtr + endTxt:len() - 1
            end

            pos = endPtr
        end
    end

    return nil, nil
end


----------------------------------------------------------------
-- Ghost_EditBox cursor & selection code
----------------------------------------------------------------

-- Globals: Ghost_MouseButton
-- Ghost_CursorPos, Ghost_SelectionStart, Ghost_SelectionEnd
-- Shared Globals: Ghost_CurrentEditBox (current focussed edit box)

--- Called by WorldFrame:HookScript to clear focus and assign the pressed mouse button.
-- @return nil
-- @see Ghost_ClearFocus
function Ghost_EditBoxMouseDown()
    Ghost_ClearFocus()
    Ghost_MouseButton = button
end

--- Clears the Ghost_CurrentEditBox focus and closes the drop down menus.
-- @return nil
function Ghost_ClearFocus()
    if Ghost_CurrentEditBox then Ghost_CurrentEditBox:ClearFocus() end
    CloseDropDownMenus()
end

--- Handles the edit box cursor move events.
-- @param self the edit box
-- @param y cursor vertical position
-- @param cursorHeight the cursor height
function Ghost_EditBoxCursor(self, y, cursorHeight)
    local cursorPos = self:GetCursorPosition()

    if cursorPos ~= Ghost_CursorPos then -- only run code if edit box cursor changes (not mouse position)
        if Ghost_MouseButton == "LeftButton" then CloseDropDownMenus() end

        Ghost_CurrentEditBox = self

        -- scroll to cursor
        y = -y
        local scroller = self:GetParent()
        local offset = scroller:GetVerticalScroll()

        if y < offset then
            scroller:SetVerticalScroll(y)
        else
            y = y + cursorHeight - scroller:GetHeight()
            if y > offset then scroller:SetVerticalScroll(y) end
        end

        -- check for link
        local text = self:GetText()
        local startPtr, endPtr = Ghost_GetTextPositions(text, "|H", "|r", cursorPos)
        local x, y = GetCursorPosition()

        if (startPtr and endPtr) then
            -- we have a link, so show its tooltip
            GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
            GameTooltip:SetHyperlink(strsub(text, startPtr, endPtr))
        else
            -- no link, hide any existing tooltip and store selection
            GameTooltip:Hide()

            -- store selection & update cursor
            if Ghost_MouseButton == "LeftButton" then
                local text = self:GetText()
                self:Insert("") -- Delete selected text

                local textNew = self:GetText()
                local cursorNew = self:GetCursorPosition()

                Ghost_SelectionStart = cursorNew
                Ghost_SelectionEnd = #text - (#textNew - cursorNew)

                -- restore previous text
                self:SetText(text)

                -- always update cursor on left-click
                Ghost_CursorPos = cursorPos
            else
                -- only update cursor if no selection
                if Ghost_SelectionStart == Ghost_SelectionEnd and cursorPos ~= Ghost_SelectionStart then
                    Ghost_CursorPos = cursorPos
                end
            end

            -- restore cursor & selection
            Ghost_RestoreSelection()
        end
    end
end

--- Restores the current selected text in the current edit box.
-- @return nil
function Ghost_RestoreSelection()
    -- call with small delay if using pop-up menu as it can interfere with the selection being shown
    if Ghost_CurrentEditBox then
        Ghost_CurrentEditBox:SetCursorPosition(Ghost_CursorPos)

        if not Ghost_SelectionStart and not Ghost_SelectionEnd then
            -- force 'selection' to cursor pos if vars are nil
            Ghost_SelectionStart = Ghost_CursorPos
            Ghost_SelectionEnd = Ghost_CursorPos
        end

        Ghost_CurrentEditBox:HighlightText(Ghost_SelectionStart, Ghost_SelectionEnd)
    end
end

--- Returns current selected text (or nil if no selection).
-- @return current selected text or nil
function Ghost_GetSelectedText()
    local text

    if Ghost_SelectionStart ~= nil and Ghost_SelectionEnd > Ghost_SelectionStart then
        text = Ghost_CurrentEditBox:GetText()
        text = text:sub(Ghost_SelectionStart + 1, Ghost_SelectionEnd)
    end

    return text
end


----------------------------------------------------------------
-- Ghost_EditBox text formatting & insert code
----------------------------------------------------------------

-- Shared Globals: Ghost_CurrentEditBox, Ghost_CursorPos, Ghost_SelectionStart, Ghost_SelectionEnd

--- Manages items dragged into edit box.
-- @return nil
function Ghost_EditBoxDrag()
    local infoType, info1, info2 = GetCursorInfo()
    local text = ""

    if (infoType == "item") then
        text = info2
    elseif (infoType == "spell") then
        local skillType, spellId = GetSpellBookItemInfo(info1, "player")
        text = GetSpellLink(spellId)
    elseif (infoType == "merchant") then
        text = GetMerchantItemLink(info1)
    elseif (infoType == "macro") then
        text = GetMacroInfo(info1) .. " macro:\n" .. GetMacroBody(info1)
    end

    if text ~= "" and Ghost_CurrentEditBox then
        Ghost_CurrentEditBox:Insert(text)
    end

    ClearCursor()
end

--- Set selected text to hex color.
-- @param color hex code of the color.
-- @return nil
function Ghost_EditBoxSetTextColour(color)
    CloseDropDownMenus()

    if Ghost_CurrentEditBox and Ghost_SelectionStart ~= Ghost_SelectionEnd then
        local text = Ghost_GetSelectedText() -- get text from EditBox
        local newText = "|cff" .. color .. Ghost_ClearEscapeCodes(text) .. "|r"
        local sizeReduction = #text - #newText -- calc size difference

        Ghost_CurrentEditBox:Insert(newText)

        Ghost_CursorPos = Ghost_CursorPos - sizeReduction -- update cursor pos
        Ghost_SelectionEnd = Ghost_SelectionEnd - sizeReduction -- update selection var
        Ghost_RestoreSelection() -- restore selection
    end
end

--- Clear all escape sequences for selected text (or all text if no selection).
-- @return nil
-- @see Ghost_GetSelectedText
-- @see Ghost_RestoreSelection
function Ghost_EditBoxClearEscapes()
    CloseDropDownMenus()

    local text = Ghost_GetSelectedText() -- get text from edit box
    if not text then text = Ghost_CurrentEditBox:GetText() end -- or entire text if no selection

    local newText = Ghost_ClearEscapeCodes(text) -- set new var with cleared text
    local sizeReduction = #text - #newText -- calculate size difference

    Ghost_CursorPos = Ghost_CursorPos - sizeReduction -- update cursor pos

    -- insert/set new text
    if Ghost_SelectionStart ~= nil and Ghost_SelectionEnd > Ghost_SelectionStart then
        Ghost_CurrentEditBox:Insert(newText)
        Ghost_SelectionEnd = Ghost_SelectionEnd - sizeReduction -- update selection var
        Ghost_RestoreSelection() -- restore selection
    else
        Ghost_CurrentEditBox:SetText(newText)
        Ghost_CurrentEditBox:SetCursorPosition(Ghost_CursorPos) -- restore cursor
    end
end
