
local Tag="customfootstep"

concommand.Add("footstep_sound",function(pl,cmd,args)
	if SERVER then
		local n = tonumber(args[1] or "0") or 0
		n = math.Round(n)
		n=n<=0 and 0 or n>=5 and 5 or n
		
		print("footsteps",pl,n)
		
		pl:SetNWInt( "fs_sound", n )
	else
		RunConsoleCommand("cmd",cmd,unpack(args))
	end
end)



local NPC_Citizen_RunFootstepLeft = {

	"npc/footsteps/hardboot_generic1.wav",
	"npc/footsteps/hardboot_generic3.wav",
	"npc/footsteps/hardboot_generic5.wav"

}

local NPC_Citizen_RunFootstepRight = {

	"npc/footsteps/hardboot_generic2.wav",
	"npc/footsteps/hardboot_generic4.wav",
	"npc/footsteps/hardboot_generic6.wav"

}

local NPC_CombineS_RunFootstepLeft = {

	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear5.wav"

}

local NPC_CombineS_RunFootstepRight = {

	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear6.wav"

}

local NPC_MetroPolice_RunFootstepLeft = {

	"npc/metropolice/gear1.wav",
	"npc/metropolice/gear3.wav",
	"npc/metropolice/gear5.wav"

}

local NPC_MetroPolice_RunFootstepRight = {

	"npc/metropolice/gear2.wav",
	"npc/metropolice/gear4.wav",
	"npc/metropolice/gear6.wav"

}

local NPC_MVMBot_RunFootstepLeft = {
	"mvm/player/footsteps/robostep_01.wav",
	"mvm/player/footsteps/robostep_03.wav",
	"mvm/player/footsteps/robostep_05.wav",
	"mvm/player/footsteps/robostep_07.wav",
	"mvm/player/footsteps/robostep_09.wav",
	"mvm/player/footsteps/robostep_11.wav",
	"mvm/player/footsteps/robostep_13.wav",
	"mvm/player/footsteps/robostep_15.wav",
	"mvm/player/footsteps/robostep_17.wav"
}

local NPC_MVMBot_RunFootstepRight = {
	"mvm/player/footsteps/robostep_02.wav",
	"mvm/player/footsteps/robostep_04.wav",
	"mvm/player/footsteps/robostep_06.wav",
	"mvm/player/footsteps/robostep_08.wav",
	"mvm/player/footsteps/robostep_10.wav",
	"mvm/player/footsteps/robostep_12.wav",
	"mvm/player/footsteps/robostep_14.wav",
	"mvm/player/footsteps/robostep_16.wav",
	"mvm/player/footsteps/robostep_18.wav"
}

local NPC_Dog_RunFootstepLeft = {
	"npc/dog/dog_footstep1.wav",
	"npc/dog/dog_footstep3.wav"
}

local NPC_Dog_RunFootstepRight = {
	"npc/dog/dog_footstep2.wav",
	"npc/dog/dog_footstep4.wav"
}





local function PlayerFootstep( pl, pos, foot, sound, volume, filter )

	local ftype=pl:GetNWInt("fs_sound")
	if SERVER then return end
	local combi = false
	if pl:IsBot() then return end
	
	
	if ftype==0 then
	
		-- It's the default footsteps!
		return
	
	elseif ftype== 1 then
	
		-- Ladder and water footstep override
		if combi && ( ( pl:WaterLevel() > 0 && pl:WaterLevel() < 3 ) || pl:GetMoveType() == MOVETYPE_LADDER ) then return false end
	
		if ( foot == 0 ) then
		
			EmitSound( table.Random( NPC_Citizen_RunFootstepLeft ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		elseif ( foot == 1 ) then
		
			EmitSound( table.Random( NPC_Citizen_RunFootstepRight ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		end
		return true
	
	elseif ftype== 2 then
	
		if combi then
		
			volume = volume * 0.4
		
		end
				
		if ( foot == 0 ) then
		
			EmitSound( table.Random( NPC_CombineS_RunFootstepLeft ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		elseif ( foot == 1 ) then
		
			EmitSound( table.Random( NPC_CombineS_RunFootstepRight ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		end
	
		if not combi then
		
			return true
		
		end
	
	elseif ftype== 3 then
	
		if combi then
		
			volume = volume * 0.4
		
		end
	
		if ( foot == 0 ) then
		
			EmitSound( table.Random( NPC_MetroPolice_RunFootstepLeft ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		elseif ( foot == 1 ) then
		
			EmitSound( table.Random( NPC_MetroPolice_RunFootstepRight ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		end
	
		if not combi then
		
			return true
		
		end

	elseif ftype== 4 then
	
		if combi then
		
			volume = volume * 0.4
		
		end
	
		if ( foot == 0 ) then
		
			EmitSound( table.Random( NPC_MVMBot_RunFootstepLeft ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		elseif ( foot == 1 ) then
		
			EmitSound( table.Random( NPC_MVMBot_RunFootstepRight ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		end
	
		if not combi then
		
			return true
		
		end

	elseif ftype== 5 then
	
		if combi then
		
			volume = volume * 0.4
		
		end
	
		if ( foot == 0 ) then
		
			EmitSound( table.Random( NPC_Dog_RunFootstepLeft ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		elseif ( foot == 1 ) then
		
			EmitSound( table.Random( NPC_Dog_RunFootstepRight ), pos, pl:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		end
	
		if not combi then
		
			return true
		
		end
	
	else
	
	
	end

end
hook.Add( "PlayerFootstep", Tag, PlayerFootstep )
