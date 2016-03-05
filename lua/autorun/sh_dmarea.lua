local tag = "fboxdm"

if SERVER then
	local function strip(ply)
		ply:StripWeapon("none")
		ply:StripWeapon("weapon_physgun")
		ply:StripWeapon("weapon_physcannon")
		ply:StripWeapon("weapon_crowbar")
		ply:StripWeapon("gmod_tool")
		ply:StripWeapon("gmod_camera")
	end

	local function default(ply)
		ply:Give("none")
		ply:Give("weapon_physgun")
		ply:Give("weapon_physcannon")
		ply:Give("weapon_crowbar")
		ply:Give("gmod_tool")
		ply:Give("gmod_camera")
	end

	local delay = CurTime()
	hook.Add("Think",tag..".Think",function()
		if delay and delay > CurTime() then return end
		local box1 = ents.FindInBox(Vector(-1279, -1728, 432),Vector(3199, -3071, -32))
		local box2 = ents.FindInBox(Vector(-3298, -3072, 432),Vector(-1280, -2048, -32))
		local safe = ents.FindInBox(Vector(3199, -1536, 432),Vector(-520, -1724, 64))
		for _,ply in pairs(player.GetAll()) do
			if table.HasValue(box1,ply) or table.HasValue(box2,ply) then
				if ply:GetMoveType() == 8 and !ply.Unrestricted then
					ply:SetPos(Vector(1343, -1623, 64))
					ply:SetMoveType(2)
				end
				if ply.__flying then
					ply:SetFlying(false)
				end
				if ply:Health() > 100 then
					ply:SetHealth(100)
				end
				ply.in_dm = true
				ply.in_dmsafe = false
				ply:SetNWBool("in_dm",true)
				ply:SetNWBool("in_dmsafe",false)
				strip(ply)
				ply:ConCommand("cl_dmg_mode 3")
			elseif table.HasValue(safe,ply) then
				strip(ply)
				ply.in_dm = false
				ply.in_dmsafe = true
				ply:SetNWBool("in_dm",false)
				ply:SetNWBool("in_dmsafe",true)
				ply:ConCommand("cl_dmg_mode 1")
			else
				default(ply)
				ply.in_dmsafe = false
				ply.in_dm = false
				ply:SetNWBool("in_dm",false)
				ply:SetNWBool("in_dmsafe",false)
				ply:ConCommand("cl_dmg_mode 1")
			end
		end
		delay = CurTime()+1
	end)

	hook.Add("PlayerShouldTakeDamage",tag,function(vic,att)
		if vic.in_dm and att.in_dm then
			return true
		end
	end)

	hook.Add("PlayerNoClip",tag,function(ply,state)
		if ply.in_dm and !ply.Unrestricted and state == 8 then
			return false
		end
	end)

	local function no(ply,a)
		if ply.in_dm or ply.in_dmsafe then
			return false
		end
	end

	hook.Add("PlayerSpawnEffect",tag,no)
	hook.Add("PlayerSpawnNPC",tag,no)
	hook.Add("PlayerSpawnObject",tag,no)
	hook.Add("PlayerSpawnProp",tag,no)
	hook.Add("PlayerSpawnRagdoll",tag,no)
	hook.Add("PlayerSpawnSENT",tag,no)
	hook.Add("PlayerSpawnSWEP",tag,no)
	hook.Add("PlayerSpawnVehicle",tag,no)

	aowl.GotoLocations["dm@rp_city17_district47"] = Vector(1343, -1623, 64)
	aowl.GotoLocations["deathmatch@rp_city17_district47"] = aowl.GotoLocations["dm@rp_city17_district47"]
	aowl.GotoLocations["pvp@rp_city17_district47"] = aowl.GotoLocations["dm@rp_city17_district47"]
	hook.Add("CanPlyRespawn",tag,function(ply)
		if ply.in_dm then
			ply:SetPos(Vector(1343, -1623, 64))
		end
	end)
	hook.Add("PlayerSpawn",tag,function(ply)
		if ply.in_dm then
			ply:SetPos(Vector(1343, -1623, 64))
		end
	end)
end

if CLIENT then
	surface.CreateFont(tag.."_font",{
		font = "Roboto",
		size = 36,
	})
	hook.Add("HUDPaint",tag..".SafeZone",function()
		if LocalPlayer():GetNWBool("in_dmsafe") == true then
			draw.DrawText("You are in the deathmatch safezone",tag.."_font",ScrW()/2,4,Color(196,196,196,128),TEXT_ALIGN_CENTER)
		end
	end)
end