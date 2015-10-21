hook.Add("PlayerNoClip","fbox_lobby", function(ply,state)
    for _,ent in pairs(ents.FindInBox(Vector(-1252, -1506,-1827),Vector(-8107, 2303, 3029))) do
        if ent == ply and !ply.Unrestricted then
            return false,ply:PrintMessage(4,"You are not allowed to noclip in the lobby")
        end
    end
end)

hook.Add("Think","fbox_lobby_setnoclip", function()
    for _,ent in pairs(ents.FindInBox(Vector(-1252, -1506,-1827),Vector(-8107, 2303, 3029))) do
        for __,ply in pairs(player.GetAll()) do
            if ent == ply and !ply.Unrestricted and ply:GetMoveType() == 8 then
                ply:SetMoveType(2)
            end
        end
    end
end)

hook.Add("PlayerNoClip","fbox_housing", function(ply,state)
    for _,ent in pairs(ents.FindInBox(Vector(413, 2899, 720),Vector(924, 1908, 144))) do
        if ent == ply then
            return false
        end
    end
end)

hook.Add("Think","fbox_lobby_setnoclip", function()
    for _,ent in pairs(ents.FindInBox(Vector(413, 2899, 720),Vector(924, 1908, 144))) do
        for __,ply in pairs(player.GetAll()) do
            if ent == ply and ply:GetMoveType() == 8 then
                ply:SetMoveType(2)
            end
        end
    end
end)

hook.Add("PlayerSpawnObject","fbox_lobby",function(ply)
    for _,ent in pairs(ents.FindInBox(Vector(-1252, -1506,-1827),Vector(-8107, 2303, 3029))) do
        if ent == ply and !ply.Unrestricted then
            return false
        end
    end
end)
