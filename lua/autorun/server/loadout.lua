function GAMEMODE:PlayerLoadout(ply)
    ply:RemoveAllAmmo()
    ply:Give("none")
    ply:Give("weapon_physgun")
    ply:Give("weapon_physcannon")
    ply:Give("weapon_crowbar")
    ply:Give("gmod_tool")
    ply:Give("gmod_camera")
end
