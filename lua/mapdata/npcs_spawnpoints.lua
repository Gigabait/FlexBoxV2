function FBoxMapData.SNPCSpawned(ent,role)
	if role=="dmshop" then
		local data = {}
		ent:SetModel "models/monk.mdl"
		data.ID=198
		timer.Simple(0,function()
			if ent.TaskStart_PlaySequence then
				ent:TaskStart_PlaySequence( data )
			else
				ErrorNoHalt"ent.TaskStart_PlaySequence missing!"
			end
		end)
	end
end

NPCS_REGISTERED={}

function FBoxMapData.RegisterNPC(ent,role)
	FBoxMapData.SNPCSpawned(ent,role)
	NPCS_REGISTERED[role]=NPCS_REGISTERED[role] or {}
	NPCS_REGISTERED[role][ent]=true
end

function FBoxMapData.GetNPCByRole(role)
	for ent,_ in pairs(NPCS_REGISTERED[role] or {}) do
		if IsValid(ent) then return ent end
	end
end

function FBoxMapData.GetNPCsByRole(role)
	return NPCS_REGISTERED[role]
end

FBoxMapData["rp_city17_district47"].npc_spawns = {
	{"bar",Vector(1469, -1299, 192),Angle(0,0,0)},
	{"dmshop",Vector( 1463, -1461, 64 ), Angle( 0, 180, 0 )},
}

hook.Add("InitPostEntity",_NAME..'npcs',function()
	for k,v in pairs(FBoxMapData["rp_city17_district47"].npc_spawns) do
		local npc = ents.Create'lua_npc'
		npc:SetPos(v[2])
		npc.role=v[1]
		npc:SetAngles(v[3])
		npc:Spawn()
		npc:SetPermanent(true)
		npc.PhysgunDisabled = true
	end
	hook.Remove("InitPostEntity",_NAME..'npcs')
end)