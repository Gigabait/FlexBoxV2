--[[
PAC3 Spawnlist Generator
by Flex

Based off of Homestuck Playset's spawnlist generator by ¦i?C (http://steamcommunity.com/profiles/76561198018719108/)
--]]

if (SERVER) then AddCSLuaFile() return end

local SpawnTables = {}
local PACSpawnlist = CreateClientConVar("pac_spawnlist", 1)

local function AppendToSpawnlist(kvtype, kvdata, kvtab)
	if kvtype == "header" then
		kvtab.ContentsNum = kvtab.ContentsNum+1
		local kvContainer = {}
		kvContainer[tostring(kvtab.ContentsNum)] = {}
		kvContainer[tostring(kvtab.ContentsNum)]["type"] = "header"
		kvContainer[tostring(kvtab.ContentsNum)]["text"] = kvdata
		table.Add(kvtab.Contents, kvContainer)
	elseif kvtype == "model" then
		kvtab.ContentsNum = kvtab.ContentsNum+1
		local kvContainer = {}
		kvContainer[tostring(kvtab.ContentsNum)] = {}
		kvContainer[tostring(kvtab.ContentsNum)]["type"] = "model"
		kvContainer[tostring(kvtab.ContentsNum)]["model"] = kvdata
		table.Add(kvtab.Contents, kvContainer)
	end
end

local function GenerateSpawnlist(uid, name, id, parent, icon)
	SpawnTables[uid] = {}
	SpawnTables[uid].UID = id.."-"..uid
	SpawnTables[uid].Name = name
	SpawnTables[uid].Contents = {}
	SpawnTables[uid].ContentsNum = 0
	SpawnTables[uid].Icon = icon
	SpawnTables[uid].ID = id
	if parent and SpawnTables[parent] then
		SpawnTables[uid].ParentID = SpawnTables[parent].ID
	else
		SpawnTables[uid].ParentID = 0
	end
end


GenerateSpawnlist("PAC3", "PAC3", 2000, nil, "icon16/user_edit.png")
AppendToSpawnlist("header", "PAC3 Spawnlist made by Flex", SpawnTables["PAC3"])

GenerateSpawnlist("TF2Weapons", "TF2 Weapons", 20000, "PAC3", "games/16/tf.png")
GenerateSpawnlist("TF2Hats", "Hats", 20001, "PAC3", "spawnicons/models/player/items/all_class/all_domination_b_medic.png")
GenerateSpawnlist("AllClass", "All Class", 200011, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("Scout", "Scout", 200012, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("Soldier", "Soldier", 200013, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("Pyro", "Pyro", 200014, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("Demo", "Demoman", 200015, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("Heavy", "Heavy", 200016, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("Engineer", "Engineer", 200017, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("Medic", "Medic", 200018, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("Sniper", "Sniper", 200019, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("Spy", "Spy", 2000110, "TF2Hats", "icon16/folder.png")
GenerateSpawnlist("WS", "Workshop", 20002, "PAC3", "icon16/wrench.png")
GenerateSpawnlist("WSAllClass", "All Class", 200021, "WS", "icon16/folder.png")
GenerateSpawnlist("WSScout", "Scout", 200022, "WS", "icon16/folder.png")
GenerateSpawnlist("WSSoldier", "Soldier", 200023, "WS", "icon16/folder.png")
GenerateSpawnlist("WSPyro", "Pyro", 200024, "WS", "icon16/folder.png")
GenerateSpawnlist("WSDemo", "Demoman", 200025, "WS", "icon16/folder.png")
GenerateSpawnlist("WSHeavy", "Heavy", 200026, "WS", "icon16/folder.png")
GenerateSpawnlist("WSEngineer", "Engineer", 200027, "WS", "icon16/folder.png")
GenerateSpawnlist("WSMedic", "Medic", 200028, "WS", "icon16/folder.png")
GenerateSpawnlist("WSSniper", "Sniper", 200029, "WS", "icon16/folder.png")
GenerateSpawnlist("WSSpy", "Spy", 2000210, "WS", "icon16/folder.png")
GenerateSpawnlist("WSWep", "Weapons", 2000211, "WS", "icon16/gun.png")
GenerateSpawnlist("MvM", "MvM", 20003, "PAC3", "spawnicons/models/player/items/mvm_loot/all_class/mvm_badge.png")
GenerateSpawnlist("PModels", "Playermodels", 20004, "PAC3", "icon16/user.png")
GenerateSpawnlist("PM_HL2", "Half-Life 2", 200041, "PModels", "icon16/user.png")
GenerateSpawnlist("PM_CIT", "Citizens", 2000411, "PM_HL2", "icon16/user_green.png")
GenerateSpawnlist("PM_CSS", "Counter-Strike", 200042, "PModels", "games/16/cstrike.png")
GenerateSpawnlist("PM_GM", "Other", 200043, "PModels", "games/16/garrysmod.png")
GenerateSpawnlist("PACMDL", "PAC Models", 20005, "PAC3", "spawnicons/models/pac/default.png")

-- Not gonna automate because we dunno what players have --

--HL2--
AppendToSpawnlist("header", "Resistance", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/alyx.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/barney.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/eli.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/gman_high.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/kleiner.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/magnusson.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/monk.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/mossman_arctic.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/odessa.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("header", "Combine", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/breen.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/combine_soldier.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/combine_soldier_prisonguard.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/combine_super_soldier.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/police.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/police_fem.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/soldier_stripped.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("header", "Zombies/Misc", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/charple.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/corpse1.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/zombie_classic.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/zombie_fast.mdl", SpawnTables["PM_HL2"])
AppendToSpawnlist("model", "models/player/zombie_soldier.mdl", SpawnTables["PM_HL2"])

--HL2 Citizens--
AppendToSpawnlist("header", "City", SpawnTables["PM_CIT"])
for i = 1,9 do
	AppendToSpawnlist("model", "models/player/group01/male_0"..i..".mdl", SpawnTables["PM_CIT"])
end
for i = 1,6 do
	AppendToSpawnlist("model", "models/player/group01/female_0"..i..".mdl", SpawnTables["PM_CIT"])
end
AppendToSpawnlist("header", "Refugees", SpawnTables["PM_CIT"])
AppendToSpawnlist("model", "models/player/group02/male_02.mdl", SpawnTables["PM_CIT"])
AppendToSpawnlist("model", "models/player/group02/male_04.mdl", SpawnTables["PM_CIT"])
AppendToSpawnlist("model", "models/player/group02/male_06.mdl", SpawnTables["PM_CIT"])
AppendToSpawnlist("model", "models/player/group02/male_08.mdl", SpawnTables["PM_CIT"])
AppendToSpawnlist("header", "Resistance", SpawnTables["PM_CIT"])
for i = 1,9 do
	AppendToSpawnlist("model", "models/player/group03/male_0"..i..".mdl", SpawnTables["PM_CIT"])
end
for i = 1,6 do
	AppendToSpawnlist("model", "models/player/group03/female_0"..i..".mdl", SpawnTables["PM_CIT"])
end
AppendToSpawnlist("header", "Medics", SpawnTables["PM_CIT"])
for i = 1,9 do
	AppendToSpawnlist("model", "models/player/group03m/male_0"..i..".mdl", SpawnTables["PM_CIT"])
end
for i = 1,6 do
	AppendToSpawnlist("model", "models/player/group03m/female_0"..i..".mdl", SpawnTables["PM_CIT"])
end

--CSS--
AppendToSpawnlist("header", "Terrorists", SpawnTables["PM_CSS"])
AppendToSpawnlist("model", "models/player/arctic.mdl", SpawnTables["PM_CSS"])
AppendToSpawnlist("model", "models/player/guerilla.mdl", SpawnTables["PM_CSS"])
AppendToSpawnlist("model", "models/player/leet.mdl", SpawnTables["PM_CSS"])
AppendToSpawnlist("model", "models/player/phoenix.mdl", SpawnTables["PM_CSS"])

AppendToSpawnlist("header", "Counter-Terrorists", SpawnTables["PM_CSS"])
AppendToSpawnlist("model", "models/player/gasmask.mdl", SpawnTables["PM_CSS"])
AppendToSpawnlist("model", "models/player/swat.mdl", SpawnTables["PM_CSS"])
AppendToSpawnlist("model", "models/player/urban.mdl", SpawnTables["PM_CSS"])
AppendToSpawnlist("header", "Hostages", SpawnTables["PM_CSS"])
for i = 1,4 do
	AppendToSpawnlist("model", "models/player/hostage/hostage_0"..i..".mdl", SpawnTables["PM_CSS"])
end

--Other--
AppendToSpawnlist("model", "models/player/dod_american.mdl", SpawnTables["PM_GM"])
AppendToSpawnlist("model", "models/player/dod_german.mdl", SpawnTables["PM_GM"])
AppendToSpawnlist("model", "models/player/p2_chell.mdl", SpawnTables["PM_GM"])
AppendToSpawnlist("model", "models/player/skeleton.mdl", SpawnTables["PM_GM"])

--PAC Models--
AppendToSpawnlist("model", "models/pac/default.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/female/base_female.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/female/base_female_jiggle.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/female/base_female_arm_l.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/female/base_female_arm_r.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/female/base_female_leg_l.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/female/base_female_leg_r.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/female/base_female_torso.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/female/base_female_torso_jiggle.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/male/base_male.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/male/base_male_arm_l.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/male/base_male_arm_r.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/male/base_male_leg_l.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/male/base_male_leg_r.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/male/base_male_torso.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("header", "Jiggles", SpawnTables["PACMDL"])
for i = 0,5 do
	AppendToSpawnlist("model", "models/pac/jiggle/base_cloth_"..i..".mdl", SpawnTables["PACMDL"])
end
for i = 0,5 do
	AppendToSpawnlist("model", "models/pac/jiggle/base_cloth_"..i.."_gravity.mdl", SpawnTables["PACMDL"])
end
for i = 0,5 do
	AppendToSpawnlist("model", "models/pac/jiggle/base_jiggle_"..i..".mdl", SpawnTables["PACMDL"])
end
for i = 0,5 do
	AppendToSpawnlist("model", "models/pac/jiggle/base_jiggle_"..i.."_gravity.mdl", SpawnTables["PACMDL"])
end
AppendToSpawnlist("header", "Capes", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/jiggle/clothing/base_cape_1.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/jiggle/clothing/base_cape_2.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/jiggle/clothing/base_cape_1_gravity.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/jiggle/clothing/base_cape_2_gravity.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/jiggle/clothing/base_trench_1.mdl", SpawnTables["PACMDL"])
AppendToSpawnlist("model", "models/pac/jiggle/clothing/base_trench_1_gravity.mdl", SpawnTables["PACMDL"])

-- AUTOMATION BELOW --
--Weapons
for _,mdl in pairs(file.Find("models/weapons/c_models/*","GAME")) do
	if not mdl:find(".mdl") or not mdl:find("arms") or not mdl:find("animations") then continue end
	AppendToSpawnlist("model", "models/weapons/c_models/"..mdl, SpawnTables["TF2Weapons"])
end
for _,dir in next,select(2,file.Find("models/weapons/c_models/*","GAME")) do
	for _,mdl in pairs(file.Find("models/weapons/c_models/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/weapons/c_models/"..dir.."/"..mdl, SpawnTables["TF2Weapons"])
	end
end

--Hats
for _,mdl in pairs(file.Find("models/player/items/all_class/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/all_class/"..mdl, SpawnTables["AllClass"])
end
for _,mdl in pairs(file.Find("models/player/items/scout/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/scout/"..mdl, SpawnTables["Scout"])
end
for _,mdl in pairs(file.Find("models/player/items/soldier/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/soldier/"..mdl, SpawnTables["Soldier"])
end
for _,mdl in pairs(file.Find("models/player/items/pyro/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/pyro/"..mdl, SpawnTables["Pyro"])
end
for _,mdl in pairs(file.Find("models/player/items/demo/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/demo/"..mdl, SpawnTables["Demo"])
end
for _,mdl in pairs(file.Find("models/player/items/heavy/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/heavy/"..mdl, SpawnTables["Heavy"])
end
for _,mdl in pairs(file.Find("models/player/items/engineer/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/engineer/"..mdl, SpawnTables["Engineer"])
end
for _,mdl in pairs(file.Find("models/player/items/medic/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/medic/"..mdl, SpawnTables["Medic"])
end
for _,mdl in pairs(file.Find("models/player/items/sniper/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/sniper/"..mdl, SpawnTables["Sniper"])
end
for _,mdl in pairs(file.Find("models/player/items/spy/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToSpawnlist("model", "models/player/items/spy/"..mdl, SpawnTables["Spy"])
end

--MvM
for _,dir in next,select(2,file.Find("models/player/items/mvm_loot/*","GAME")) do
	for _,mdl in pairs(file.Find("models/player/items/mvm_loot/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/player/items/mvm_loot/"..dir.."/"..mdl, SpawnTables["MvM"])
	end
end

--Workshop
for _,dir in next,select(2,file.Find("models/workshop/player/items/all_class/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/all_class/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/all_class/"..dir.."/"..mdl, SpawnTables["WSAllClass"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/scout/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/scout/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/scout/"..dir.."/"..mdl, SpawnTables["WSScout"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/soldier/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/soldier/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/soldier/"..dir.."/"..mdl, SpawnTables["WSSoldier"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/pyro/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/pyro/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/pyro/"..dir.."/"..mdl, SpawnTables["WSPyro"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/demo/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/demo/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/demo/"..dir.."/"..mdl, SpawnTables["WSDemo"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/heavy/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/heavy/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/heavy/"..dir.."/"..mdl, SpawnTables["WSHeavy"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/engineer/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/engineer/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/engineer/"..dir.."/"..mdl, SpawnTables["WSEngineer"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/medic/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/medic/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/medic/"..dir.."/"..mdl, SpawnTables["WSMedic"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/sniper/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/sniper/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/sniper/"..dir.."/"..mdl, SpawnTables["WSSniper"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/spy/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/spy/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/player/items/spy/"..dir.."/"..mdl, SpawnTables["WSSpy"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/weapons/c_models/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/weapons/c_models/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToSpawnlist("model", "models/workshop/weapons/c_models/"..dir.."/"..mdl, SpawnTables["WSWep"])
	end
end

hook.Add("PopulatePropMenu", "HSSpawnlistAdd", function()
	if !tobool(LocalPlayer():GetInfo("pac_spawnlist")) then return end
	for k, v in pairs(SpawnTables) do
		spawnmenu.AddPropCategory("settings/spawnlist/" .. v.UID, v.Name, v.Contents, v.Icon, v.ID, v.ParentID)
	end
end)