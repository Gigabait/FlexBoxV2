FBoxMapData = FBoxMapData or {}
FBoxMapData[game.GetMap()] = {}

local function mdata_print(txt)
	MsgC(Color(0,150,130),"[Mapdata] ",Color(255,255,255),txt.."\n")
end

function FBoxMapData.LoadMapdata()
	local starttime = CurTime()
	
	for _,file in pairs(file.Find("lua/mapdata/"..game.GetMap().."/*","GAME")) do
		include("mapdata/"..game.GetMap().."/"..file)
		mdata_print("Loaded "..file)
	end
	
	mdata_print("Mapdata loaded, took "..starttime-CurTime().."ms")
end

aowl.AddCommand("reloadmapdata",function(ply,line)
	mdata_print("Reload called by ",tostring(ply))
	FBoxMapData.LoadMapdata()
end)

FBoxMapData.LoadMapdata()
