surface.CreateFont("fs3_hostname",{
    font      = "Seogei UI",
    size      = 48,
    weight    = 500,
})

surface.CreateFont("fs3_title",{
    font   = "Seogei UI",
    size   = 32,
    weight = 500,
})



function CreateFScoreboard()
    if IsValid(FScoreboard) then FScoreboard:Remove() end
    FScoreboard = vgui.Create("EditablePanel")
    FScoreboard:SetSize(ScrW()-300,ScrH()-150)
    FScoreboard:Center()

    function FScoreboard:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(50,50,50))
    end

    local header = vgui.Create("EditablePanel",FScoreboard)
    header:Dock(TOP)
    header:SetTall(100)

    local rainbow,rainbow2
    local fade = 0
    function header:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,150,130))
        for i = 1,w/50+50 do
            draw.RoundedBox(0,50*i-50,0,50,50,Color(0,0,0,200-(i*5)))
            draw.RoundedBox(0,50*i-50,50,50,50,Color(0,0,0,210-(i*5)))
        end
        --fade = Lerp(FrameTime()*2,fade,200)
        --draw.RoundedBox(0,0,0,w,h,Color(0,0,0,fade))
    end

    local hostname = vgui.Create("DLabel",header)
    hostname:Dock(LEFT)
    hostname:DockMargin(20,20,0,20)
    hostname:SetFont("fs3_hostname")
    hostname:SetText(GetHostName())
    hostname:SizeToContents()
    hostname:SetColor(Color(255,255,255))

    local sidebar = vgui.Create("EditablePanel",FScoreboard)
    sidebar:Dock(LEFT)
    sidebar:SetWide(200)

    function sidebar:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(70,70,70))
    end

    local players = vgui.Create("EditablePanel",FScoreboard)

    local settings = vgui.Create("EditablePanel",FScoreboard)
    settings:SetVisible(false)

    local players_button = vgui.Create("DButton",sidebar)
    players_button:Dock(TOP)
    players_button:SetTall(40)
    players_button:SetText("Players")
    players_button:SetTextColor(Color(160,160,160))
    players_button:SetIcon("icon16/user.png")
    players_button.btncol = Color(70,70,70)

    function players_button:Paint(w,h)
        if self.Hovered then self.btncol = Color(80,80,80) else self.btncol = Color(70,70,70) end
        draw.RoundedBox(0,0,0,w,h,self.btncol)
        draw.RoundedBox(0,0,h-1,w,1,Color(80,80,80))
        draw.RoundedBox(0,0,h-2,w,1,Color(40,40,40))
    end

    function players_button:DoClick()
        players:SetVisible(true)
        settings:SetVisible(false)
    end

    local settings_button = vgui.Create("DButton",sidebar)
    settings_button:Dock(TOP)
    settings_button:SetTall(40)
    settings_button:SetText("Settings")
    settings_button:SetTextColor(Color(160,160,160))
    settings_button:SetIcon("icon16/cog.png")
    settings_button.btncol = Color(70,70,70)

    function settings_button:Paint(w,h)
        if self.Hovered then self.btncol = Color(80,80,80) else self.btncol = Color(70,70,70) end
        draw.RoundedBox(0,0,0,w,h,self.btncol)
        draw.RoundedBox(0,0,h-1,w,1,Color(80,80,80))
        draw.RoundedBox(0,0,h-2,w,1,Color(40,40,40))
    end

    function settings_button:DoClick()
        settings:SetVisible(true)
        players:SetVisible(false)
    end


    local scroll = vgui.Create("DScrollPanel",FScoreboard)
    scroll:SetPos(200,100)
    scroll:SetSize(ScrW()-500,ScrH()-250)
    scroll:AddItem(players)
    scroll:AddItem(settings)
    players:Dock(FILL)
    players:SetTall(scroll:GetTall())
    settings:Dock(FILL)
    settings:SetTall(scroll:GetTall())

    for _,t in pairs(team.GetAllTeams()) do
        if t == team.GetAllTeams()[0] or t == team.GetAllTeams()[1001] or t == team.GetAllTeams()[1002] then continue end
        local tname = t["Name"]:gsub("^.",function(c) return c:upper() end)
        local teamtbl = {}

        local team_pnl = vgui.Create("EditablePanel",players)
        team_pnl:Dock(TOP)
        team_pnl:DockMargin(4,4,4,0)

        function team_pnl:Paint(w,h)
            surface.SetFont("DermaDefault")
            draw.RoundedBoxEx(6,0,0,8 + surface.GetTextSize(tname),20,t["Color"],true,true,false,false)
            draw.DrawText(tname,"DermaDefault",4,4,Color(255,255,255))
            draw.RoundedBoxEx(6,0,20,w,h-20,t["Color"],false,true,true,true)
        end

        for __,ply in pairs(player.GetAll()) do
            if ply:Team() == _ then
                teamtbl[ply] = true
                team_pnl:SetTall(26+(34*table.Count(teamtbl)))
                team_pnl:DockPadding(0,20,0,4)

                local ply_pnl = vgui.Create("EditablePanel",team_pnl)
                ply_pnl:Dock(TOP)
                ply_pnl:DockMargin(4,4,4,0)
                ply_pnl:SetTall(32)

                function ply_pnl:Paint(w,h)
                    draw.RoundedBox(4,0,0,w,h,Color(0,0,0,200))
                end

                local avatar = vgui.Create("AvatarImage",ply_pnl)
                avatar:Dock(LEFT)
                avatar:SetSize(32,32)
                avatar:SetPlayer(ply,32)

                local avatar_link = vgui.Create("DButton",avatar)
                avatar_link:Dock(FILL)
                avatar_link:SetText("")
                avatar_link.Paint = function() end

                function avatar_link:DoClick()
                    gui.OpenURL("http://steamcommunity.com/profiles/"..ply:SteamID64())
                end

                local name = vgui.Create("DLabel",ply_pnl)
                name:Dock(LEFT)
                name:DockMargin(4,0,0,0)
                name:SetText(ply:Name())
                name:SetColor(Color(255,255,255))
                name:SizeToContents()

                ----

                local pnl_ping = vgui.Create("EditablePanel",ply_pnl)
                pnl_ping:Dock(RIGHT)

                local ping_img = vgui.Create("DImage",pnl_ping)
                ping_img:SetImage("icon16/transmit_blue.png")
                ping_img:SetSize(16,16)
                ping_img:Dock(LEFT)
                ping_img:DockMargin(4,8,0,8)

                local ping_lbl = vgui.Create("DLabel",pnl_ping)
                ping_lbl:Dock(LEFT)
                ping_lbl:DockMargin(4,0,0,0)
                ping_lbl:SetText(ply:Ping())
                ping_lbl:SetColor(Color(255,255,255))
                ping_lbl:SizeToContents()

                ----

                local pnl_money = vgui.Create("EditablePanel",ply_pnl)
                pnl_money:Dock(RIGHT)

                local money_img = vgui.Create("DImage",pnl_money)
                money_img:SetImage("icon16/coins.png")
                money_img:SetSize(16,16)
                money_img:Dock(LEFT)
                money_img:DockMargin(4,8,0,8)

                local money_lbl = vgui.Create("DLabel",pnl_money)
                money_lbl:Dock(LEFT)
                money_lbl:DockMargin(4,0,0,0)
                money_lbl:SetText(ply:GetMoney())
                money_lbl:SetColor(Color(255,255,255))
                money_lbl:SizeToContents()

                pnl_money:InvalidateLayout(true)
                pnl_money:SizeToChildren(true,false)
            end
        end
        team_pnl:InvalidateLayout(true)
        team_pnl:SizeToChildren(false,true)
    end

    --settings--

    local settings_header = vgui.Create("EditablePanel",settings)
    settings_header:Dock(TOP)
    settings_header:SetTall(50)

    function settings_header:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,100,100))
        draw.RoundedBox(0,0,h-1,w,1,Color(0,150,150))
        for i = 1,w/50+50 do
            draw.RoundedBox(0,50*i-50,0,50,50,Color(0,0,0,200-(i*10)))
        end
    end

    local settings_title = vgui.Create("DLabel",settings_header)
    settings_title:SetFont("fs3_title")
    settings_title:SetColor(Color(255,255,255))
    settings_title:Dock(LEFT)
    settings_title:DockMargin(20,0,0,0)
    settings_title:SetText("Settings")
    settings_title:SizeToContents()

    return true
end

local function ScoreboardHide()
    if FScoreboard then
        FScoreboard:Remove()
    end
    gui.EnableScreenClicker(false)
    return true
end

local function PlayerBindPress(ply, bind, pressed)
    if pressed and bind == "+attack2" and FScoreboard and FScoreboard:IsVisible() then
        gui.EnableScreenClicker(true)
        return true
    end
end

hook.Add("ScoreboardShow", "FScoreboard3", CreateFScoreboard)
hook.Add("ScoreboardHide", "FScoreboard3", ScoreboardHide)
hook.Add("PlayerBindPress", "FScoreboard3", PlayerBindPress)
