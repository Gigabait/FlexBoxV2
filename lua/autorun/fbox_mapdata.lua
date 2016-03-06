FBoxMapData = FBoxMapData or {}
FBoxMapData["rp_city17_district47"] = {}

local starttime = CurTime()

local function mdata_print(txt)
	MsgC(Color(0,150,130),"[Mapdata] ",Color(255,255,255),txt.."\n")
end


for _,file in pairs(file.Find("lua/mapdata/*","GAME")) do
	include("mapdata/"..file)
	mdata_print("Loaded "..file)
end

mdata_print("Mapdata loaded, took "..starttime-CurTime().."ms")
