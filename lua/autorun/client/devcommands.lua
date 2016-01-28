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
		chat.AddText("ERROR: Unknown placemarker")
		return
	end

	local niceangle = EyeAngles():SnapTo("p", 90):SnapTo("y", 45)
	
	LocalPlayer():SetEyeAngles(niceangle)

	chat.AddText(string.format("Vector( %f, %f, %f ), Angle( %i, %i, %i )", x, y, z, niceangle.p, niceangle.y, niceangle.r))
	return
end


concommand.Add( "getpos2", gp2Callback )