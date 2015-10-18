local PlayerColors = {
    ["0"]  = Color(0,0,0),
    ["1"]  = Color(128,128,128),
    ["2"]  = Color(192,192,192),
    ["3"]  = Color(255,255,255),
    ["4"]  = Color(0,0,128),
    ["5"]  = Color(0,0,255),
    ["6"]  = Color(0,128,128),
    ["7"]  = Color(0,255,255),
    ["8"]  = Color(0,128,0),
    ["9"]  = Color(0,255,0),
    ["10"] = Color(128,128,0),
    ["11"] = Color(255,255,0),
    ["12"] = Color(128,0,0),
    ["13"] = Color(255,0,0),
    ["14"] = Color(128,0,128),
    ["15"] = Color(255,0,255),
}


hook.Add("OnPlayerChat","FlexBoxChat",function(ply,txt,bTeam,bDead)

    local name_c
    for col in string.gmatch(ply:Name(),"%^(%d)") do
    name_c = PlayerColors[col]
    end
    for col1,col2,col3 in string.gmatch(ply:Name(),"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
    name_c = HSVToColor(col1,col2,col3)
    end
    for col1,col2,col3 in string.gmatch(ply:Name(),"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
    name_c = Color(col1,col2,col3,255)
    end
    local c = name_c and name_c or team.GetColor(ply:Team())

    local name_noc = ply:GetName()
    name_noc = string.gsub(name_noc,"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
    name_noc = string.gsub(name_noc,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
    name_noc = string.gsub(name_noc,"%^(%d+%.?%d*)","")

    local tab = {}

    table.insert(tab,Color(150,200,150))
    table.insert(tab,os.date("[%H:%M] "))

    if bDead then
    table.insert(tab,Color(150,50,50))
    table.insert(tab,"*DEAD* ")
    end

    if bTeam then
    table.insert(tab,Color(50,150,50))
    table.insert(tab,"(TEAM) ")
    end

    if IsValid(ply) then
        table.insert(tab,c)
        table.insert(tab,name_noc)
    else
    table.insert(tab,Color(100,200,100))
    table.insert(tab,"Server")
    end

    table.insert(tab, Color( 255, 255, 255 ) )
    table.insert(tab,": "..txt)

    chat.AddText(unpack(tab))

    return true
end)
