aowl.cmds.spawn = nil

aowl.AddCommand("home",function(ply,line,cmd,vec1,vec2,vec3)
    if cmd == "set" then
        if !vec1 and !vec2 and !vec3 then
            ply:SetPData("fbox_home_pos",ply:GetPos())
        elseif vec1 and vec2 and vec3 then
            ply:SetPData("fbox_home_pos",Vector(tonumber(vec1),tonumber(vec2),tonumber(vec3)))
        end
aowl.GotoLocations["home"] = isvector(ply:GetPData("fbox_home_pos")) and ply:GetPData("fbox_home_pos") or aowl.GotoLocations["spawn"]
    elseif cmd == "remove" then
        ply:SetPData("fbox_home_pos","")
aowl.GotoLocations["home"] = aowl.GotoLocations["spawn"]
    else
        if isvector(ply:GetPData("fbox_home_pos")) then
            ply:SetPos(ply:GetPData("fbox_home_pos"))
            aowlMsg("home", tostring(ply).." -> home pos")
        end
    end
end)

aowl.AddCommand("spawn", function(ply, line, target)
	local ent = ply:CheckUserGroupLevel("moderators") and target and easylua.FindEntity(target) or ply

	if ent:IsValid() then
		ent.aowl_tpprevious = ent:GetPos()
		if ent:GetPData("fbox_home_pos") != nil and isvector(ply:GetPData("fbox_home_pos")) then
		    ent:SetPos(ent:GetPData("fbox_home_pos"))
		else
		    ent:Spawn()
		end
		aowlMsg("spawn", tostring(ply).." spawned ".. (ent==ply and "self" or tostring(ent)))
	end
end)
