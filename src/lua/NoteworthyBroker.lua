--==============================================================
-- Broker code
--==============================================================

-- LDB constants
LDB = LibStub("LibDataBroker-1.1");
ldbicon = LibStub("LibDBIcon-1.0", true);

--- Creates a new LDB data object for Noteworthy II minimap button.
-- Only works if LDB and LDB icon libraries are loaded.
-- @return nil
function Noteworthy_InitBroker()
    if LDB then
        Noteworthy_LDB = LDB:NewDataObject("Noteworthy", {
            label = "Noteworthy II",
            type = "launcher",
            icon = "Interface\\Icons\\INV_Misc_Book_08",
            OnClick = function(_, button)
                if button == 'LeftButton' then
                    Noteworthy_ToggleView();
                elseif button == 'RightButton' then
                    Noteworthy_QuickContextMenu();
                end
            end,
            OnTooltipShow = function(tooltip)
                tooltip:AddLine(BUTTON_TOOLTIP);
            end,
        })
    end

    if ldbicon then
        ldbicon:Register("Noteworthy", Noteworthy_LDB, Noteworthy_DB["minimap_button"]);
    end
end
