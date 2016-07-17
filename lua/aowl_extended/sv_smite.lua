util.AddNetworkString"particlePlayerSmite"

aowl.AddCommand("smite", function(caller, line, target)
	local ply = easylua.FindEntity(target)

	if ply:IsValid() and ply:IsPlayer() then
		net.Start"particlePlayerSmite"
		net.WriteEntity(ply)
		net.Broadcast()

		timer.Simple(.1, function() -- Effect before action
			ply:Kill()
			playerpos = ply:GetPos()
			local traceworld = {}
			traceworld.start = playerpos
			traceworld.endpos = traceworld.start + (Vector(0, 0, -1) * 250)
			local trw = util.TraceLine(traceworld)
			local worldpos1 = trw.HitPos + trw.HitNormal
			local worldpos2 = trw.HitPos - trw.HitNormal
			util.Decal("Scorch", worldpos1, worldpos2)
		end)
	end
end, "developers")