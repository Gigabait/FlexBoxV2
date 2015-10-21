fbox_housing = fbox_housing or {
    rooms = {
        {
            door1 = Entity(222),
            door2 = Entity(2215),
            owner = "",
        },
        {
            door1 = Entity(223),
            door2 = Entity(2217),
            owner = "",
        },
        {
            door1 = Entity(226),
            door2 = Entity(381),
            owner = "",
        },
        {
            door1 = Entity(225),
            door2 = Entity(2222),
            owner = "STEAM_0:0:58178275",
        },
        {
            door1 = Entity(2491),
            door2 = Entity(2488),
            owner = "",
        },
        {
            door1 = Entity(2507),
            door2 = Entity(2508),
            owner = "",
        },
        {
            door1 = Entity(2490),
            door2 = Entity(2492),
            owner = "",
        },
    },
}

for _,room in pairs(fbox_housing.rooms) do
    if CLIENT then
        hook.Add("PostDrawOpaqueRenderables","housing_door_"..room.door1:EntIndex(),function()
            cam.Start3D2D(room.door1:GetPos()+Vector(5,0,25),room.door1:GetAngles()+Angle(0,90,90),0.25)
            draw.SimpleTextOutlined("Room #".._,"DermaLarge",100,10,Color(100,100,100),TEXT_ALIGN_CENTER,nil,2,Color(0,0,0))
            draw.SimpleTextOutlined("Owned by:","DermaLarge",100,40,Color(100,100,100),TEXT_ALIGN_CENTER,nil,2,Color(0,0,0))
            draw.SimpleTextOutlined(room.owner != "" and room.owner or "No one","DermaLarge",100,80,room.owner != "" and Color(100,200,100) or Color(200,200,200),TEXT_ALIGN_CENTER,nil,2,Color(0,0,0))
            cam.End3D2D()
        end)
    end

    if SERVER then
        if room.owner != "" then
            room.door1:Fire("lock")
        end
    end
end

local keys = {Primary = {},Secondary = {}}

keys.PrintName = "Keys"

keys.Spawnable = false
keys.AdminOnly = true
