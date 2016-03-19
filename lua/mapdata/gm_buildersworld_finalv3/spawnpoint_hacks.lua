local spawnpoints = {
	Vector(520, -1441, -1043),
	Vector(520, -1365, -1043),
	Vector(520, -1297, -1043),
	Vector(460, -1441, -1043),
	Vector(460, -1365, -1043),
	Vector(460, -1297, -1043),
}

function GAMEMODE:PlayerSelectSpawn( pl )
	pl:SetPos(table.Random(spawnpoints))
	pl:DropToFloor()
	if pl.UnStuck then pl:UnStuck() end
	return nil
end

FBoxMapData["gm_buildersworld_finalv3"].spawn = {
	{
		["protected"] = false,
		["pos"] = Vector(505.71621704102, -1506.3341064453, -1127.5640869141),
		["material"] = "",
		["color"] = Color(255, 255, 255, 255),
		["entity"] = "prop_physics",
		["model"] = "models/props_c17/furniturecouch001a.mdl",
		["ang"] = Angle(0, 90, 0),
		["static"] = true,
	},
	{
		["protected"] = false,
		["pos"] = Vector(600.81530761719, -1428.7634277344, -1127.6668701172),
		["material"] = "",
		["color"] = Color(255, 255, 255, 255),
		["entity"] = "prop_physics",
		["model"] = "models/props_c17/furniturecouch001a.mdl",
		["ang"] = Angle(0, -180, 0),
		["static"] = true,
	},
	{
		["protected"] = false,
		["pos"] = Vector(592.86883544922, -1507.1433105469, -1144.7730712891),
		["material"] = "",
		["color"] = Color(255, 255, 255, 255),
		["entity"] = "prop_physics",
		["model"] = "models/props/cs_office/plant01.mdl",
		["ang"] = Angle(0, -90, 0),
		["static"] = true,
	},
	{
		["protected"] = false,
		["pos"] = Vector(607.34197998047, -1227.2290039062, -1143.9936523438),
		["material"] = "",
		["color"] = Color(255, 255, 255, 255),
		["entity"] = "prop_physics",
		["model"] = "models/props/cs_office/table_coffee.mdl",
		["ang"] = Angle(0, 180, 0),
		["static"] = true,
	},
	{
		["protected"] = false,
		["pos"] = Vector(603.57635498047, -1208.3854980469, -1119.4530029297),
		["material"] = "",
		["color"] = Color(255, 255, 255, 255),
		["entity"] = "prop_physics",
		["model"] = "models/props/cs_office/phone.mdl",
		["ang"] = Angle(-0, -180, 0),
		["static"] = true,
	},
	{ ["entity"] = "prop_physics" , ["model"] = "models/hunter/plates/plate5x8.mdl" , ["pos"] = Vector(504.927 , -1358.305 , -1146.189), ["ang"] = Angle(0 , 180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "models/props/cs_militia/roofbeams03" , ["color"] = color_white , ["protected"] = "false"}, 
}

local spawnprops = FBoxMapData["gm_buildersworld_finalv3"].spawn
for k,v in pairs(PropSaver.LoadedProps) do if IsValid(v) and v.spawnprop then v:Remove() end end
PropSaver.LoadPropTable(spawnprops)
for k,v in pairs(PropSaver.LoadedProps) do if IsValid(v) and !v.dm_prop then v.spawnprop = true end end