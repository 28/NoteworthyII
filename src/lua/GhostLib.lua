--==============================================================
-- GhostLib V1.1
-- Description: useful functions
-- Author: Ghost Dancer
-- Web: https://github.com/28/Noteworthy
--==============================================================


----------------------------------------------------------------
-- Misc functions
----------------------------------------------------------------
local waitTable = {};
local waitFrame;

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

function Ghost_CreateMacro(name, icon, text)
    if GetMacroIndexByName(name) == 0 then
        CreateMacro(name, icon, text, nil, nil)

        if GetMacroIndexByName(name) then
            print(name .. " macro has been created")
        else
            print("Unable to create " .. name .. " macro")
        end
    else
        print(name .. " macro already exists")
    end
end

-- clear character encoding from specified text
function Ghost_ClearEscapeCodes(text)
    -- clear hyperlink encoding (but only if entire sequence is within our selected text)
    text = text:gsub("(|H.-|h)(.-)(|h)", "%2")

    -- ditto for colour
    text = text:gsub("(|c%x%x%x%x%x%x%x%x)(.-)(|r)", "%2")

    return text
end

function Ghost_GetTextPositions(text, startTxt, endTxt, cursorPos)
    -- get positions of text markers within a string, with optional starting position
    cursorPos = cursorPos or 0 -- default value of 0

    local pos = 1
    local startPtr = 0
    local endPtr = 0

    while (pos and pos < strlen(text)) do
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
-- Globals: Ghost_MouseButton
-- Ghost_CursorPos, Ghost_SelectionStart, Ghost_SelectionEnd
-- Shared Globals: Ghost_CurrentEditBox (current focussed EditBox)
----------------------------------------------------------------
-- called by WorldFrame:HookScript
function Ghost_EditBoxMouseDown()
    Ghost_ClearFocus()
    Ghost_MouseButton = button
end

function Ghost_ClearFocus()
    if Ghost_CurrentEditBox then Ghost_CurrentEditBox:ClearFocus() end
    CloseDropDownMenus()
end

function Ghost_EditBoxCursor(self, y, cursorHeight)
    local cursorPos = self:GetCursorPosition()

    if cursorPos ~= Ghost_CursorPos then -- only run code if editbox cursor changes (not mouse position)
        if Ghost_MouseButton == "LeftButton" then CloseDropDownMenus() end

        Ghost_CurrentEditBox = self
        Ghost_UndoEnabled = 0

        -----------------------------------------
        -- scroll to cursor
        -----------------------------------------
        y = -y
        local scroller = self:GetParent()
        local offset = scroller:GetVerticalScroll()

        if y < offset then
            scroller:SetVerticalScroll(y)
        else
            y = y + cursorHeight - scroller:GetHeight()
            if y > offset then scroller:SetVerticalScroll(y) end
        end

        -----------------------------------------
        -- check for link
        -----------------------------------------
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

            -----------------------------------------
            -- store selection & update cursor
            -----------------------------------------
            if Ghost_MouseButton == "LeftButton" then
                local text = self:GetText()
                self:Insert("") -- Delete selected text

                local textNew = self:GetText()
                local cursorNew = self:GetCursorPosition()

                Ghost_SelectionStart = cursorNew
                Ghost_SelectionEnd = #text - (#textNew - cursorNew)

                -- Restore previous text
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

        Ghost_UndoEnabled = 1
    end
end

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

-- returns current selected text (or nil if no selection)
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
-- Shared Globals: Ghost_CurrentEditBox, Ghost_CursorPos, Ghost_SelectionStart, Ghost_SelectionEnd
----------------------------------------------------------------
-- manages items dragged into EditBox
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

-- set selected text to hex colour
function Ghost_EditBoxSetTextColour(colour)
    CloseDropDownMenus()

    if Ghost_CurrentEditBox and Ghost_SelectionStart ~= Ghost_SelectionEnd then
        local text = Ghost_GetSelectedText() -- get text from EditBox
        local newText = "|cff" .. colour .. Ghost_ClearEscapeCodes(text) .. "|r"
        local sizeReduction = #text - #newText -- calc size difference

        Ghost_CurrentEditBox:Insert(newText)

        Ghost_CursorPos = Ghost_CursorPos - sizeReduction -- update cursor pos
        Ghost_SelectionEnd = Ghost_SelectionEnd - sizeReduction -- update selection var
        Ghost_RestoreSelection() -- restore selection
    end
end

-- clear all escape sequences for selected text (or all text if no selection)
function Ghost_EditBoxClearEscapes()
    CloseDropDownMenus()

    local text = Ghost_GetSelectedText() -- get text from EditBox
    if not text then text = Ghost_CurrentEditBox:GetText() end -- or entire text if no selection

    local newText = Ghost_ClearEscapeCodes(text) -- set new var with cleared text
    local sizeReduction = #text - #newText -- calc size difference

    Ghost_CursorPos = Ghost_CursorPos - sizeReduction -- update cursor pos

    -- insert/set new text
    if Ghost_SelectionStart ~= nil and Ghost_SelectionEnd > Ghost_SelectionStart then
        Ghost_CurrentEditBox:Insert(newText)
        Ghost_SelectionEnd = Ghost_SelectionEnd - sizeReduction -- update selection var
        Ghost_RestoreSelection() -- restore selection
    else
        Ghost_CurrentEditBox:SetText(newText)
        Ghost_CurrentEditBox:SetCursorPosition(Ghost_CursorPos) -- rstore cursor
    end
end
