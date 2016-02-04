function precise_gui()
    local PMFrame = vgui.Create("DFrame")
    PMFrame:SetSize(300,500)
    PMFrame:SetPos(ScrW()-20,ScrH()-20)
    PMFrame:SetTitle("Precise Movement")
    PMFrame:SetIcon("icon16/arrow_out.png")
    PMFrame:MakePopup()
    
    local target = vgui.Create("DButton",PMFrame)
    target:Dock(TOP)
    target:SetText("Select Target")
    target.DoClick = target_select
end

local function target_select()
    local select = vgui.Create("DFrame")
end
