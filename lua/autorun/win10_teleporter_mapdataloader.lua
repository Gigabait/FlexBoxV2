//Teleporter Mapdata Loader
//Loads teleporters. Loads from lua/mapdata/<current map>/teleporters.lua

wintp = {}
wintpdata = wintpdata or {}

function wintp.RequestMapData(ply)
	wintpdata[game.GetMap()] = {}
	local data = {}
	for k,v in pairs(ents.FindByClass("win10_teleporter")) do
		table.insert(data,{
			["tname"] = v:GetTName(),
			["address"]= v:GetAddress(),
			["private"] = v:GetPrivate(),
			["pos"] = v:GetPos(),
			["ang"] = v:GetAngles()
		})
	end
	table.Add(wintpdata[game.GetMap()],data)
	print(table.ToString(wintpdata[game.GetMap()],'wintpdata["'..game.GetMap()..'"]',true))
end


function wintp.LoadMapData()
	if file.Exists("mapdata/"..game.GetMap().."/teleporters.lua","LUA") then
		 include("mapdata/"..game.GetMap().."/teleporters.lua")
	end
end

function wintp.SpawnMDTeleporters(tbl)
	for k,v in pairs(tbl) do
		local ent = ents.Create("win10_teleporter")
		ent:SetPos(v["pos"])
		ent:SetAngles(v["ang"])
		ent:Spawn()
		ent:SetTName(v["tname"])
		ent:SetAddress(v["address"])
		ent:SetPrivate(v["private"])
	end
end

wintp.LoadMapData()
