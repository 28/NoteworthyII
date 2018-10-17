--==============================================================
-- Broker code
--==============================================================

LDB = LibStub("LibDataBroker-1.1");
ldbicon = LibStub("LibDBIcon-1.0", true);

function Noteworthy_InitBroker()
    if LDB then
        -- create LDB object
        Noteworthy_LDB = LDB:NewDataObject("Noteworthy", {
            label = "Noteworthy",
            type = "launcher",
            icon = "Interface\\Icons\\INV_Misc_Book_08",
            OnClick = function(frame, button)
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
