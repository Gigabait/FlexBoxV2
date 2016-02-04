local function gp2Callback( ply, cmd, args ) 
	if args[1] == "up" then
		local tr = util.TraceLine( {
			start = LocalPlayer():GetPos(),
			endpos = LocalPlayer():GetPos() + Vector( 0, 0, 9999999),
			mask = MASK_BLOCKLOS,
		} )
		x = tr.HitPos.X
		y = tr.HitPos.Y
		z = tr.HitPos.Z
	elseif args[1] == "down" then
		local tr = util.TraceLine( {
			start = LocalPlayer():GetPos(),
			endpos = LocalPlayer():GetPos() - Vector( 0, 0, 9999999),
			mask = MASK_BLOCKLOS,
		} )
		x = tr.HitPos.X
		y = tr.HitPos.Y
		z = tr.HitPos.Z
	elseif args[1] == "aim" then
		local tr = util.TraceLine( {
			start = EyePos(),
			endpos = EyePos() + EyeAngles():Forward() * 10000,
			mask = MASK_BLOCKLOS,
		} )
		x = tr.HitPos.X
		y = tr.HitPos.Y
		z = tr.HitPos.Z
	else
		chat.AddText(Color(255,0,0),"ERROR: ",Color(255,255,255),"Unknown placemarker")
		return
	end

	local niceangle = EyeAngles():SnapTo("p", 90):SnapTo("y", 45)
	
	LocalPlayer():SetEyeAngles(niceangle)

	chat.AddText(Color(255,255,255),string.format("Vector( %n, %n, %n ), Angle( %i, %i, %i )", math.floor(x), math.floor(y), math.floor(z), niceangle.p, niceangle.y, niceangle.r))
	return
end


concommand.Add( "getpos2", gp2Callback )

local function node_add(ply,cmd,args)
	local tr = util.TraceLine( {
		start = LocalPlayer():GetPos(),
		endpos = LocalPlayer():GetPos() - Vector( 0, 0, 9999999),
		mask = MASK_BLOCKLOS,
	} )
	x = math.floor(tr.HitPos.X)
	y = math.floor(tr.HitPos.Y)
	z = math.floor(tr.HitPos.Z)
	table.insert(FBoxMapData[game.GetMap()].temp,Vector(x,y,z))
	chat.AddText(Color(255,255,255),"Node added to temp table. Export with node_export_temp.")
end

local function node_export_temp(ply,cmd,args)
	for _,node in pairs(FBoxMapData[game.GetMap()].temp) do
		print(string.format("Vector( %f, %f, %f ),",node.x,node.y,node.z))
	end
	chat.AddText(Color(255,255,255),"Temp nodes printed to console.")
end

local function node_cleartemp(ply,cmd,args)
	FBoxMapData[game.GetMap()].temp = {}
	chat.AddText(Color(255,255,255),"Temp nodes cleared.")
end

concommand.Add("node_add",node_add)
concommand.Add("node_export_temp",node_export_temp)
concommand.Add("node_cleartemp")