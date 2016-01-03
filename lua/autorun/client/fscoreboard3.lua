surface.CreateFont("fs3_hostname",{
    font      = "Segoe UI",
    size      = 48,
    weight    = 500,
})

surface.CreateFont("fs3_title",{
    font   = "Segoe UI",
    size   = 32,
    weight = 500,
})

surface.CreateFont("fs3_text",{
    font   = "Segoe UI",
    size   = 13,
    weight = 500,
})

local PlayerColors = {
    ["0"]  = Color(0, 0, 0),
    ["1"]  = Color(128, 128, 128),
    ["2"]  = Color(192, 192, 192),
    ["3"]  = Color(255, 255, 255),
    ["4"]  = Color(0, 0, 128),
    ["5"]  = Color(0, 0, 255),
    ["6"]  = Color(0, 128, 128),
    ["7"]  = Color(0, 255, 255),
    ["8"]  = Color(0, 128, 0),
    ["9"]  = Color(0, 255, 0),
    ["10"] = Color(128, 128, 0),
    ["11"] = Color(255, 255, 0),
    ["12"] = Color(128, 0, 0),
    ["13"] = Color(255, 0, 0),
    ["14"] = Color(128, 0, 128),
    ["15"] = Color(255, 0, 255),
}

--cvars--
local HostnameColorR    = CreateClientConVar("fs3_hostname_r",   0)
local HostnameColorG    = CreateClientConVar("fs3_hostname_g",   150)
local HostnameColorB    = CreateClientConVar("fs3_hostname_b",   130)
local SidebarColorR     = CreateClientConVar("fs3_sidebar_r",    33)
local SidebarColorG     = CreateClientConVar("fs3_sidebar_g",    91)
local SidebarColorB     = CreateClientConVar("fs3_sidebar_b",    51)
local BackgroundColorR  = CreateClientConVar("fs3_background_r", 50)
local BackgroundColorG  = CreateClientConVar("fs3_background_g", 50)
local BackgroundColorB  = CreateClientConVar("fs3_background_b", 50)

function CreateFScoreboard()
    if IsValid(FScoreboard) then FScoreboard:Remove() end
    FScoreboard = vgui.Create("EditablePanel")
    FScoreboard:SetSize(ScrW()-300,ScrH()-150)
    FScoreboard:Center()

    function FScoreboard:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(BackgroundColorR:GetInt(),BackgroundColorG:GetInt(),BackgroundColorB:GetInt()))
    end

    local header = vgui.Create("EditablePanel",FScoreboard)
    header:Dock(TOP)
    header:SetTall(100)

    local rainbow,rainbow2
    local fade = 0
    function header:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(HostnameColorR:GetInt(),HostnameColorG:GetInt(),HostnameColorB:GetInt()))
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
        draw.RoundedBox(0,0,0,w,h,Color(SidebarColorR:GetInt(),SidebarColorG:GetInt(),SidebarColorB:GetInt()))
        for i = 1,h/50+50 do
            draw.RoundedBox(0,0,50*i-50,50,50,Color(0,0,0,200-(i*5)))
            draw.RoundedBox(0,50,50*i-50,50,50,Color(0,0,0,190-(i*5)))
            draw.RoundedBox(0,100,50*i-50,50,50,Color(0,0,0,180-(i*5)))
            draw.RoundedBox(0,150,50*i-50,50,50,Color(0,0,0,170-(i*5)))
        end
    end

    local players = vgui.Create("EditablePanel",FScoreboard)

    local settings = vgui.Create("EditablePanel",FScoreboard)
    settings:SetVisible(false)

    local scroll = vgui.Create("DScrollPanel",FScoreboard)
    scroll:SetPos(200,100)
    scroll:SetSize(ScrW()-500,ScrH()-250)
    scroll:AddItem(players)
    players:Dock(FILL)
    players:SetTall(ScrH()-250)
    settings:Dock(FILL)
    settings:SetTall(ScrH()-250)

    local players_button = vgui.Create("DButton",sidebar)
    players_button:Dock(TOP)
    players_button:SetTall(40)
    players_button:SetText("Players")
    players_button:SetFont("fs3_text")
    players_button:SetTextColor(Color(255,255,255))
    players_button:SetIcon("icon16/user.png")
    players_button.btncol = Color(0,0,0,100)

    function players_button:Paint(w,h)
        if self.Hovered then self.btncol = Color(0,0,0,200) else self.btncol = Color(0,0,0,100) end
        draw.RoundedBox(0,0,0,w,h,self.btncol)
        draw.RoundedBox(0,0,h-1,w,1,Color(SidebarColorR:GetInt(),SidebarColorG:GetInt(),SidebarColorB:GetInt()))
    end

    function players_button:DoClick()
        scroll:SetVisible(true)
        settings:SetVisible(false)
    end

    local settings_button = vgui.Create("DButton",sidebar)
    settings_button:Dock(TOP)
    settings_button:SetTall(40)
    settings_button:SetText("Settings")
    settings_button:SetFont("fs3_text")
    settings_button:SetTextColor(Color(255,255,255))
    settings_button:SetIcon("icon16/cog.png")
    settings_button.btncol = Color(0,0,0,100)

    function settings_button:Paint(w,h)
        if self.Hovered then self.btncol = Color(0,0,0,200) else self.btncol = Color(0,0,0,100) end
        draw.RoundedBox(0,0,0,w,h,self.btncol)
        draw.RoundedBox(0,0,h-1,w,1,Color(SidebarColorR:GetInt(),SidebarColorG:GetInt(),SidebarColorB:GetInt()))
    end

    function settings_button:DoClick()
        settings:SetVisible(true)
        scroll:SetVisible(false)
    end

    for _,t in pairs(team.GetAllTeams()) do
        if t == team.GetAllTeams()[0] or t == team.GetAllTeams()[1001] or t == team.GetAllTeams()[1002] then continue end
        local tname = t["Name"]:gsub("^.",function(c) return c:upper() end)
        local teamtbl = {}

        local team_pnl = vgui.Create("EditablePanel",players)
        team_pnl:Dock(TOP)
        team_pnl:DockMargin(4,4,4,0)

        function team_pnl:Paint(w,h)
            surface.SetFont("fs3_text")
            draw.RoundedBoxEx(6,0,0,8 + surface.GetTextSize(tname),20,t["Color"],true,true,false,false)
            draw.DrawText(tname,"fs3_text",4,4,Color(255,255,255))
            draw.RoundedBoxEx(6,0,20,w,h-20,t["Color"],false,true,true,true)
        end

        for __,ply in pairs(player.GetAll()) do
            if ply:Team() == _ then
                teamtbl[ply] = true
                team_pnl:SetTall(26+(34*table.Count(teamtbl)))
                team_pnl:DockPadding(0,20,0,4)

                local name_c
                for col in string.gmatch(ply:Nick(),"%^(%d)") do
                name_c = PlayerColors[col]
                end
                for col1,col2,col3 in string.gmatch(ply:Nick(),"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
                name_c = HSVToColor(col1,col2,col3)
                end
                for col1,col2,col3 in string.gmatch(ply:Nick(),"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
                name_c = Color(col1,col2,col3,255)
                end
                local namec = name_c and name_c or Color(255,255,255)

                local name_noc = ply:Nick()
                name_noc = string.gsub(name_noc,"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
                name_noc = string.gsub(name_noc,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
                name_noc = string.gsub(name_noc,"%^(%d+%.?%d*)","")

                local ply_pnl = vgui.Create("EditablePanel",team_pnl)
                ply_pnl:Dock(TOP)
                ply_pnl:DockMargin(4,4,4,0)
                ply_pnl:SetTall(32)

                function ply_pnl:Paint(w,h)
                    draw.RoundedBox(4,0,0,w,h,Color(0,0,0,200))
                end

                local SetFriendStatusOverride = friendsh and friendsh.SetFriendStatusOverride
                if not SetFriendStatusOverride then return end
                local GetFriendStatusOverride = friendsh and friendsh.GetFriendStatusOverride
                if not GetFriendStatusOverride then return end

                function ply_pnl:OnMouseReleased(btn)
                    if btn == MOUSE_RIGHT then
                            local menu = DermaMenu()

                            if ply != LocalPlayer() then
                                menu:AddOption("Goto",function() LocalPlayer():ConCommand("aowl goto _"..ply:EntIndex()) end):SetIcon("icon16/arrow_right.png")
                                menu:AddOption("Bring",function() LocalPlayer():ConCommand("aowl bring _"..ply:EntIndex()) end):SetIcon("icon16/arrow_inout.png")
                                menu:AddSpacer()
                                if LocalPlayer():IsAdmin() then
                                    menu:AddOption("Cleanup",function() LocalPlayer():ConCommand("aowl cleanup _"..ply:EntIndex()) end):SetIcon("icon16/bin_empty.png")
                                end

                                local pp,ppicn = menu:AddSubMenu("Prop Protection") ppicn:SetIcon("icon16/brick_link.png")
                                pp:AddOption("Default",function() SetFriendStatusOverride(ply:SteamID(),nil) end):SetIcon("icon16/user.png")
                                pp:AddOption("Allow",function() SetFriendStatusOverride(ply:SteamID(),true) end):SetIcon("icon16/user_green.png")
                                pp:AddOption("Block",function() SetFriendStatusOverride(ply:SteamID(),false) end):SetIcon("icon16/user_red.png")

                                local b,bicn = menu:AddSubMenu("Block Menu") bicn:SetIcon("icon16/user_delete.png")
                                local muted = ply:IsMuted()
                                b:AddOption(muted and "Unmute" or "Mute",function() ply:SetMuted(not muted) end):SetImage(muted and "icon16/sound_add.png" or "icon16/sound_delete.png")
                                if SprayList then
                                    local spr = ply:IsSprayBlocked()
                                    b:AddOption( spr and "Unblock Spray" or "Block Spray",function() LocalPlayer():ConCommand("blockspray "..ply:EntIndex()) end):SetImage(spr and "icon16/picture.png" or "icon16/picture_empty.png")
                                end
                                if pac then
                                    local bpac = plypac_ignored and pac.UnIgnoreEntity or pac.IgnoreEntity
                                    b:AddOption(plypac_ignored and "Unignore PAC" or "Ignore PAC",function() bpac(ply) end):SetImage(plypac_ignored and "icon16/user_add.png" or "icon16/user_delete.png")
                                end
                                menu:AddSpacer()
                                menu:AddOption("PM",function() ply:ConCommand("chat_open_pm "..ply:SteamID()) end):SetIcon("icon16/group.png")
                            end

                            if ply == LocalPlayer() then
                                menu:AddOption("Blink",function() LocalPlayer():ConCommand("aowl goto _"..ply:EntIndex()) end):SetIcon("icon16/arrow_right.png")
                                menu:AddOption("Rename",function() Derma_StringRequest(
                                    "Name",
                                    "Enter a new name for yourself.",
                                    ply:Nick(),
                                    function(txt) RunConsoleCommand("aowl","name",txt) end,
                                    function(txt) return false end)
                                end):SetIcon("icon16/textfield_rename.png")

                                local c,cicn = menu:AddSubMenu("CTP",function() ctp:Toggle() end )
                                cicn:SetIcon("icon16/camera.png")
                                c:AddOption("Enable",function() ctp:Enable() end):SetIcon("icon16/camera_add.png")
                                c:AddOption("Disable",function() ctp:Disable() end):SetIcon("icon16/camera_delete.png")
                                c:AddOption("Menu",function() LocalPlayer():ConCommand("ctp_toggle_menu") end):SetIcon("icon16/camera_edit.png")
                                c:AddSpacer()
                                c2,c2icn = c:AddSubMenu("Camera Style",function() return end)
                                c2icn:SetIcon("icon16/camera_edit.png")
                                c3,c3icn = c2:AddSubMenu("Custom",function() return end)
                                c3icn:SetIcon("icon16/folder.png")
                                for _,f in pairs(file.Find("ctp/cvar_presets/*","DATA")) do
                                    local nf = f:gsub("%.txt","")
                                    c3:AddOption(nf,function() ctp:Enable() ctp:LoadCVarPreset(nf) end)
                                end
                                c2:AddOption("Thirdperson",function() ctp:Enable() ctp:LoadCVarPreset("Valve Thirdperson") end)
                                c2:AddOption("Cinematic",function() ctp:Enable() ctp:LoadCVarPreset("Cinematic") end)
                                c2:AddOption("Cinematic 2",function() ctp:Enable() ctp:LoadCVarPreset("Cinematic 2") end)
                                c2:AddOption("Helicopter View",function() ctp:Enable() ctp:LoadCVarPreset("Helicopter View") end)
                                c2:AddOption("Isometric",function() ctp:Enable() ctp:LoadCVarPreset("Isometric") end)
                                c2:AddOption("Slow",function() ctp:Enable() ctp:LoadCVarPreset("Slow") end)

                                menu:AddOption("Cleanup Self",function() LocalPlayer():ConCommand("aowl cleanup #me") end):SetIcon("icon16/bin_empty.png")
                            end

                            menu:AddSpacer()
                            menu:AddOption(ply:SteamID(),function() SetClipboardText(ply:SteamID()) end):SetIcon("icon16/vcard.png")
                            menu:AddOption("Entity Index: "..ply:EntIndex(),function() SetClipboardText(ply:SteamID()) end):SetIcon("icon16/status_online.png")
                            menu:Open()

                            return true
                    end
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
                name:SetText(name_noc)
                name:SetFont("fs3_text")
                name:SetColor(namec)
                name:SizeToContents()

                if GetFriendStatusOverride(ply) == true or ply:IsFriend(LocalPlayer(),ply) then
                    local pnl_friend = vgui.Create("EditablePanel",ply_pnl)
                    pnl_friend:Dock(LEFT)

                    local friend_img = vgui.Create("DImage",pnl_friend)
                    friend_img:SetImage("icon16/user_green.png")
                    friend_img:SetSize(16,16)
                    friend_img:Dock(LEFT)
                    friend_img:DockMargin(4,8,0,8)
                elseif GetFriendStatusOverride(ply) == false then
                    local pnl_friend = vgui.Create("EditablePanel",ply_pnl)
                    pnl_friend:Dock(LEFT)

                    local friend_img = vgui.Create("DImage",pnl_friend)
                    friend_img:SetImage("icon16/user_red.png")
                    friend_img:SetSize(16,16)
                    friend_img:Dock(LEFT)
                    friend_img:DockMargin(4,8,0,8)
                end

                if ply.IsAFK and ply:IsAFK() then
                    local pnl_away = vgui.Create("EditablePanel",ply_pnl)
                    pnl_away:Dock(LEFT)

                    local away_img = vgui.Create("DImage",pnl_away)
                    away_img:SetImage("icon16/clock.png")
                    away_img:SetSize(16,16)
                    away_img:Dock(LEFT)
                    away_img:DockMargin(4,8,0,8)
                end

                if !ply:Alive() then
                    local pnl_ded = vgui.Create("EditablePanel",ply_pnl)
                    pnl_ded:Dock(LEFT)

                    local ded_img = vgui.Create("DImage",pnl_ded)
                    ded_img:SetImage("icon16/heart_delete.png")
                    ded_img:SetSize(16,16)
                    ded_img:Dock(LEFT)
                    ded_img:DockMargin(4,8,0,8)
                end

                local pnl_ping = vgui.Create("EditablePanel",ply_pnl)
                pnl_ping:Dock(RIGHT)

                local ping_img = vgui.Create("DImage",pnl_ping)
                ping_img:SetImage(ply:Ping() > 100 and "icon16/transmit.png" or "icon16/transmit_blue.png")
                ping_img:SetSize(16,16)
                ping_img:Dock(LEFT)
                ping_img:DockMargin(4,8,0,8)

                local ping_lbl = vgui.Create("DLabel",pnl_ping)
                ping_lbl:Dock(LEFT)
                ping_lbl:DockMargin(4,0,4,0)
                ping_lbl:SetText(ply:Ping())
                ping_lbl:SetFont("fs3_text")
                ping_lbl:SetColor(Color(255,255,255))
                ping_lbl:SizeToContents()
                ----
                if ply.GetUTime and ply.GetUTimeStart then
                    local pnl_time = vgui.Create("EditablePanel",ply_pnl)
                    pnl_time:Dock(RIGHT)

                    local time_img = vgui.Create("DImage",pnl_time)
                    time_img:SetImage("icon16/time.png")
                    time_img:SetSize(16,16)
                    time_img:Dock(LEFT)
                    time_img:DockMargin(4,8,0,8)

                    local time_lbl = vgui.Create("DLabel",pnl_time)
                    time_lbl:Dock(LEFT)
                    time_lbl:DockMargin(4,0,4,0)
                    time_lbl:SetText(math.floor((ply:GetUTime() + CurTime() - ply:GetUTimeStart())/60/60).." hr")
                    time_lbl:SetFont("fs3_text")
                    time_lbl:SetColor(Color(255,255,255))
                    time_lbl:SizeToContents()

                    pnl_time:InvalidateLayout(true)
                    pnl_time:SizeToChildren(true,false)
                end

                if ply.GetMoney then
                    local pnl_money = vgui.Create("EditablePanel",ply_pnl)
                    pnl_money:Dock(RIGHT)

                    local money_img = vgui.Create("DImage",pnl_money)
                    money_img:SetImage("icon16/money.png")
                    money_img:SetSize(16,16)
                    money_img:Dock(LEFT)
                    money_img:DockMargin(4,8,0,8)

                    local money_lbl = vgui.Create("DLabel",pnl_money)
                    money_lbl:Dock(LEFT)
                    money_lbl:DockMargin(4,0,4,0)
                    money_lbl:SetText(ply:GetMoney())
                    money_lbl:SetFont("fs3_text")
                    money_lbl:SetColor(Color(255,255,255))
                    money_lbl:SizeToContents()

                    pnl_money:InvalidateLayout(true)
                    pnl_money:SizeToChildren(true,false)
                elseif ply.GetCoins then
                    local pnl_money = vgui.Create("EditablePanel",ply_pnl)
                    pnl_money:Dock(RIGHT)

                    local money_img = vgui.Create("DImage",pnl_money)
                    money_img:SetImage("icon16/coins.png")
                    money_img:SetSize(16,16)
                    money_img:Dock(LEFT)
                    money_img:DockMargin(4,8,0,8)

                    local money_lbl = vgui.Create("DLabel",pnl_money)
                    money_lbl:Dock(LEFT)
                    money_lbl:DockMargin(4,0,4,0)
                    money_lbl:SetText(ply:GetCoins())
                    money_lbl:SetFont("fs3_text")
                    money_lbl:SetColor(Color(255,255,255))
                    money_lbl:SizeToContents()

                    pnl_money:InvalidateLayout(true)
                    pnl_money:SizeToChildren(true,false)
                end

                local pnl_deaths = vgui.Create("EditablePanel",ply_pnl)
                pnl_deaths:Dock(RIGHT)

                local deaths_lbl = vgui.Create("DLabel",pnl_deaths)
                deaths_lbl:Dock(LEFT)
                deaths_lbl:DockMargin(4,0,4,0)
                deaths_lbl:SetText("Deaths: "..ply:Deaths())
                deaths_lbl:SetFont("fs3_text")
                deaths_lbl:SetColor(Color(255,255,255))
                deaths_lbl:SizeToContents()

                local pnl_frags = vgui.Create("EditablePanel",ply_pnl)
                pnl_frags:Dock(RIGHT)

                local frags_lbl = vgui.Create("DLabel",pnl_frags)
                frags_lbl:Dock(LEFT)
                frags_lbl:DockMargin(4,0,4,0)
                frags_lbl:SetText("Frags: "..ply:Frags())
                frags_lbl:SetFont("fs3_text")
                frags_lbl:SetColor(Color(255,255,255))
                frags_lbl:SizeToContents()
            end
        end
        team_pnl:InvalidateLayout(true)
        team_pnl:SizeToChildren(false,true)
        if table.Count(teamtbl) < 1 then team_pnl:SetVisible(false) end
    end

    players:InvalidateLayout(true)
    players:SizeToChildren(false,true)

    --settings--

    local settings_header = vgui.Create("EditablePanel",settings)
    settings_header:Dock(TOP)
    settings_header:SetTall(50)

    function settings_header:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,100,100))
        for i = 1,w/50+50 do
            draw.RoundedBox(0,50*i-50,0,50,50,Color(0,0,0,200-(i*10)))
        end
        draw.RoundedBox(0,0,h-1,w,1,Color(0,150,150))
    end

    local settings_title = vgui.Create("DLabel",settings_header)
    settings_title:SetFont("fs3_title")
    settings_title:SetColor(Color(255,255,255))
    settings_title:Dock(LEFT)
    settings_title:DockMargin(20,0,0,0)
    settings_title:SetText("Settings")
    settings_title:SizeToContents()

    local color_sidebar_lbl = vgui.Create("DLabel",settings)
    color_sidebar_lbl:Dock(TOP)
    color_sidebar_lbl:DockMargin(4,4,0,0)
    color_sidebar_lbl:SetText("Sidebar Color")
    color_sidebar_lbl:SetFont("fs3_text")
    color_sidebar_lbl:SetColor(Color(255,255,255))
    color_sidebar_lbl:SizeToContents()

    local color_sidebar = vgui.Create("DColorMixer",settings)
    color_sidebar:Dock(TOP)
    color_sidebar:DockMargin(4,4,0,0)
    color_sidebar:SetPalette(true)
    color_sidebar:SetAlphaBar(false)
    color_sidebar:SetWangs(true)
    color_sidebar:SetColor(Color(SidebarColorR:GetInt(),SidebarColorG:GetInt(),SidebarColorB:GetInt()))
    color_sidebar:SetConVarR("fs3_sidebar_r")
    color_sidebar:SetConVarG("fs3_sidebar_g")
    color_sidebar:SetConVarB("fs3_sidebar_b")

    local color_hostname_lbl = vgui.Create("DLabel",settings)
    color_hostname_lbl:Dock(TOP)
    color_hostname_lbl:DockMargin(4,4,0,0)
    color_hostname_lbl:SetText("Hostname Bar Color")
    color_hostname_lbl:SetFont("fs3_text")
    color_hostname_lbl:SetColor(Color(255,255,255))
    color_hostname_lbl:SizeToContents()

    local color_hostname = vgui.Create("DColorMixer",settings)
    color_hostname:Dock(TOP)
    color_hostname:DockMargin(4,4,0,0)
    color_hostname:SetPalette(true)
    color_hostname:SetAlphaBar(false)
    color_hostname:SetWangs(true)
    color_hostname:SetColor(Color(HostnameColorR:GetInt(),HostnameColorG:GetInt(),HostnameColorB:GetInt()))
    color_hostname:SetConVarR("fs3_hostname_r")
    color_hostname:SetConVarG("fs3_hostname_g")
    color_hostname:SetConVarB("fs3_hostname_b")

    local color_background_lbl = vgui.Create("DLabel",settings)
    color_background_lbl:Dock(TOP)
    color_background_lbl:DockMargin(4,4,0,0)
    color_background_lbl:SetText("Background Color")
    color_background_lbl:SetFont("fs3_text")
    color_background_lbl:SetColor(Color(255,255,255))
    color_background_lbl:SizeToContents()

    local color_background = vgui.Create("DColorMixer",settings)
    color_background:Dock(TOP)
    color_background:DockMargin(4,4,0,0)
    color_background:SetPalette(true)
    color_background:SetAlphaBar(false)
    color_background:SetWangs(true)
    color_background:SetColor(Color(HostnameColorR:GetInt(),HostnameColorG:GetInt(),HostnameColorB:GetInt()))
    color_background:SetConVarR("fs3_background_r")
    color_background:SetConVarG("fs3_background_g")
    color_background:SetConVarB("fs3_background_b")

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
