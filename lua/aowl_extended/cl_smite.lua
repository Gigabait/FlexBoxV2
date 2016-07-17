AddCSLuaFile()

if CLIENT then
	net.Receive("particlePlayerSmite", function()
		local ply = net.ReadEntity()

		if ply:IsPlayer() and ply:IsValid() then
			if not IsValid(ply) then return end

			-- WHY U NO HAVE LIGHTING SOUND VALVE?!
			for i = 1, 10 do
				sound.Play("npc/scanner/scanner_electric1.wav", ply:GetPos(), math.random(75, 100), math.random(80, 200))
			end

			-- "variation" of the meta upgrade effect
			sound.Play("ambient/explosions/explode_" .. math.random(1, 9) .. ".wav", ply:GetPos())
			local p1 = ClientsideModel("models/props_junk/popcan01a.mdl", RENDERGROUP_OPAQUE)
			p1:SetNoDraw(true)
			local p2 = ClientsideModel("models/props_junk/popcan01a.mdl", RENDERGROUP_OPAQUE)
			p2:SetNoDraw(true)

			local cp0 = {
				["entity"] = p1,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW
			}

			local cp1 = {
				["entity"] = p2,
				["attachtype"] = PATTACH_ABSORIGIN_FOLLOW
			}

			for i = 1, 10 do
				local a = ((i * 36) * math.pi) / 180
				local t = Vector(math.sin(a), math.cos(a), 0) * 2
				p1:SetPos(ply:GetPos() + Vector(0, 0, 1000) + t)
				p2:SetPos(ply:GetPos() + t)
				ply:CreateParticleEffect("Weapon_Combine_Ion_Cannon", {cp0, cp1})
			end

			ParticleEffectAttach("Weapon_Combine_Ion_Cannon_Explosion", 1, ply, 0)
		end
	end)
end