easylua.StartEntity("lua_npc_metrocop")

ENT.Base 					= "base_ai"
ENT.Type 					= "ai"
ENT.Author					= "Mare, Potatofactory, Flex"
ENT.PrintName 				= "Metrocop"
ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false
ENT.IssuedWarnings			= 0

if CLIENT then
	ENT.lobbyok = true
	ENT.PhysgunDisabled = false
	ENT.m_tblToolsAllowed = {}
	function ENT:CanConstruct() return true end
	function ENT:CanTool() return true end
	function ENT:Draw()
		self:DrawModel()
	end
end

if SERVER then
	ENT.AutomaticFrameAdvance	= true

	function ENT:GetCitizenName()
		return "Metrocop P-C17D47-" .. math.floor(self:GetPos().Z) .. "/" .. self:EntIndex()
	end

	ENT.sounds = {
		greet = {
			"npc/metropolice/vo/backup.wav",
			"npc/metropolice/vo/checkformiscount.wav",
			"npc/metropolice/vo/citizen.wav",
			"npc/metropolice/vo/keepmoving.wav",
			"npc/metropolice/vo/keepmoving.wav",
		},
		hit = {
			"npc/metropolice/pain1.wav",
			"npc/metropolice/pain2.wav",
			"npc/metropolice/pain3.wav",
			"npc/metropolice/pain4.wav",
		},
		bench = {
			"",
		},
	}


	ENT.WarningLines = {
		["angry"] = {
			"npc/metropolice/vo/11-99officerneedsassistance.wav",
			"npc/metropolice/vo/contactwith243suspect.wav",
			"npc/metropolice/vo/cpisoverrunwehavenocontainment.wav",
			"npc/metropolice/vo/cpweneedtoestablishaperimeterat.wav",
			"npc/metropolice/vo/Ivegot408hereatlocation.wav",
			"npc/metropolice/vo/malcompliant10107my1020.wav",
		},
		{
			"npc/metropolice/vo/backup.wav",
			"npc/metropolice/vo/firstwarningmove.wav",
			"npc/metropolice/vo/lookingfortrouble.wav",
		},
		{
			"npc/metropolice/vo/secondwarning.wav",
			"npc/metropolice/vo/thisisyoursecondwarning.wav",
			"npc/metropolice/vo/lookingfortrouble.wav",
		},
		{
			"npc/metropolice/vo/finalwarning.wav",
			"npc/metropolice/vo/readytoprosecutefinalwarning.wav",
			"npc/metropolice/vo/code100.wav",
		},
	}

	ENT.walktable = FBoxMapData[game.GetMap()] != nil and FBoxMapData[game.GetMap()].metrocops.walktable or {Vector(0,0,0),}

	ENT.sittable = true

	ENT.sittable = FBoxMapData[game.GetMap()] != nil and FBoxMapData[game.GetMap()].metrocops.sittable or {}



	local function RandomNPC()
		local spawns = FBoxMapData[game.GetMap()] != nil and FBoxMapData[game.GetMap()].metrocops.spawns or {Vector(0,0,0),}
		local npcs = ents.FindByClass("lua_npc_metrocop")
		if #npcs > 10 then return end
		local spawn = table.Random(spawns)
		if not spawn then return end

		local Metrocop = ents.Create("lua_npc_metrocop")
		Metrocop:SetPos(spawn)
		Metrocop:Spawn()
		Metrocop:Activate()
	end

	timer.Create("ms_spawn_cops",4,0,RandomNPC)

	local ENT=ENT
	function ENT:GetSittable()
		local t= ENT._sittable
		if t ==nil then
			t = self.sittable
			if t and t~=true then t=table.Copy(t) end
			ENT._sittable = t
		end
		return t
	end

	function ENT:GetWalktable()
		return self.walktable
	end

	-- ACTUALL NPC CODE STARTS HERE------------------------------------------------------------------------------------------------
	ENT.Base						= "base_ai"
	ENT.Type						= "ai"
	ENT.PrintName					= "Metrocop"
	ENT.Author						= "Mare"

	ENT.PhysgunDisabled				= false
	ENT.Spawnable					= false
	ENT.m_tblToolsAllowed 			= {}
	function ENT:CanConstruct() return true end
	function ENT:CanTool() return true end
	ENT.AutomaticFrameAdvance		= true
	ENT.IsMSNPC						= true
	ENT.lobbyok						= true

	ENT.SoundDelay					= 4
	ENT.iDelay						= 0

	ENT.ANIM_sit = ai_schedule.New("anim_sit")
	ENT.ANIM_sit:AddTask("AlignSit")
	ENT.ANIM_sit:AddTask("PlaySequence", {Name="Idle_to_Sit_Chair",ID = 353, Speed = 0}) -- Sit down
	ENT.ANIM_sit:AddTask("AlignSit", {fwd = - 14} )
	ENT.ANIM_sit:AddTask("PlaySequence", {Name="silo_sit",ID = 132, Dur = 20}) --Sitting
	ENT.ANIM_sit:AddTask("PlaySequence", {Name="Sit_Chair_to_Idle",ID = 355, Speed = 0}) --stand up
	ENT.ANIM_sit:AddTask("EndSit")

	ENT.ANIM_wave = ai_schedule.New("anim_wave")
	ENT.ANIM_wave:AddTask("PlaySequence", {Name="Wave",ID = 77, Speed = 0, Dur = 5})
	ENT.ANIM_wave:AddTask("EndWave")
	function ENT:DBG(...)
		--Msg("[Metrocop "..tostring(self:EntIndex())..'] ') print(...)
	end

	function ENT:TaskStart_AlignSit(data)
		local fwd = 0
		if data then
			fwd = data.fwd
		end
		self:TaskComplete()
		if not self.gotosit then return end
		self:SetAngles(self.gotosit[2])
		self:SetPos(self.gotosit[1] + self:GetForward() * fwd)
		self.bSitting = true
	end

	function ENT:TaskStart_EndSit()
		self:TaskComplete()
		self:SetNPCState(NPC_STATE_IDLE)
		self.bSit = nil
		if not self.gotosit then return end
		self:SetAngles(self.gotosit[2])
		self.gotosit[3] = false
		self.gotosit = nil
		self.bSitting = nil
	end

	function ENT:TaskStart_EndWave(data)
		self:TaskComplete()
		self:SetNPCState(NPC_STATE_IDLE)
	end

	function ENT:Task_AlignSit()
		return
	end

	ENT.Task_EndSit, ENT.Task_EndWave = ENT.Task_AlignSit, ENT.Task_AlignSit
end

function ENT:Initialize()
	self:SetModel("models/police.mdl")
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	if SERVER then
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetLagCompensated( true )
		self:SetTrigger(true)
		self:CapabilitiesAdd(bit.bor( CAP_USE , CAP_AUTO_DOORS , CAP_OPEN_DOORS , CAP_ANIMATEDFACE , CAP_TURN_HEAD , CAP_MOVE_GROUND, CAP_USE_WEAPONS, CAP_AIM_GUN, CAP_WEAPON_RANGE_ATTACK1 ))
		self:SetMaxYawSpeed(20)
		self:SetHealth(750 - math.Clamp(#ents.FindByClass(self:GetClass()) * 50, 50, 500))
		self:SetNPCState(NPC_STATE_IDLE)
		self.LastSound = CurTime()
		self.next_alert = CurTime()
		self:Give(table.Random({
			"weapon_stunstick",
			"weapon_pistol"
		}))
	end
end

if SERVER then
	ENT.next_alert = 0

	function ENT:PlaySound(type) -- Marked for removal
		if self.LastSound > CurTime() then return end
		local sound = table.Random(self.sounds[type])
		self:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav")
		timer.Simple( .5, function()
			self:EmitSound(sound, math.random(90, 100), math.random(90, 110))
		end )
		--self:EmtiSound("npc/metropolice/vo/off" .. math.random(1, 2) .. ".wav")
		-- First we need to way to get the duration of the radio audio
		self.busy = true
		self.LastSound = CurTime() + self.SoundDelay
	end

	function ENT:PlayWarning()
		local function GenerateSctipt( str )
			sound.Add( {
				name = "metrocop_radio",
				channel = CHAN_VOICE,
				volume = 1.0,
				level = 80,
				pitch = { 95, 110 },
				sound = str
			} )
		end
		self.IssuedWarnings = self.IssuedWarnings + 1
		if self.LastSound <= CurTime() then
			GenerateSctipt(self.IssuedWarnings <= #self.WarningLines and 
				table.Random(self.WarningLines[self.IssuedWarnings]) or
				table.Random(self.WarningLines["angry"]))

			self:EmitSound("metrocop_radio", math.random(90, 100), math.random(90, 110))
			self.LastSound = CurTime() + self.SoundDelay
		end
	end

	function ENT:PlayAnim(anim)
		self:SetNPCState(NPC_STATE_SCRIPT)
		self:StopMoving()
		self:StartSchedule(anim)
	end

	function ENT:GotoBench()
		local t = self:GetSittable()
		if not t or t==true then return false end
		for k,v in next,t do
			if not v[3] then
				self.gotosit = t[k]
				self.gotosit[3] = true
				break
			end
		end
		if self.gotosit then
			self:SetLastPosition( self.gotosit[1] )
			self:SetSchedule( SCHED_FORCED_GO )
			self.bSit = true
		end
	end

	local ai_disabled = GetConVar 'ai_disabled'
	function ENT:Think()
		local ang = self:GetAngles() --fix funny walking
		ang.p, ang.r = 0, 0
		self:SetAngles(ang)

		if ai_disabled:GetBool() or self:GetNPCState() == NPC_STATE_DEAD or self:GetNPCState() == NPC_STATE_SCRIPT or self.iDelay > RealTime() then return end

		if self.bSit and self:GetPos():Distance(self.gotosit[1]) < 18 and not self.bSitting then
			self:PlayAnim(self.ANIM_sit)
		elseif not self.bSit then
			if self:GetNPCState() == NPC_STATE_NONE then
				self:SetNPCState( NPC_STATE_IDLE )
			end
			self:SelectSchedule()
		end
	end

	function ENT:ResetEnemy()
		local enttable = ents.FindByClass("npc_*")

		for _, x in pairs(enttable) do
			if (x:GetClass() != self:GetClass()) then
				self:AddEntityRelationship( x, 2, 10 )
			end
		end

		self:AddRelationship("player D_NU 10")
	end

	function ENT:SelectSchedule()
		local state = self:GetNPCState()
		if state == NPC_STATE_SCRIPT or self.bSit or self.iDelay > RealTime() then
			return
		elseif state == NPC_STATE_IDLE then
			self:SetLastPosition( table.Random(self:GetWalktable()) + Vector( 0, 0, 40 ) )
			if math.random(1,10) == 5 then
				self:GotoBench()
			elseif math.random(1,10) == 5 then
				self:SetSched( SCHED_FORCED_GO_RUN )
				self.iDelay = RealTime() + 10
			else
				self:SetSched( SCHED_FORCED_GO )
				self.iDelay = RealTime() + 20
			end
		end
	end

	function ENT:OnNPCKilled( attacker, inflictor )

		-- Convert the inflictor to the weapon that they're holding if we can.
		if ( inflictor and inflictor ~= NULL and attacker == inflictor and (inflictor:IsPlayer() or inflictor:IsNPC()) ) then

			inflictor = inflictor:GetActiveWeapon()
			if ( attacker == NULL ) then inflictor = attacker end

		end

		local InflictorClass = "World"
		local AttackerClass = "World"

		if ( IsValid( inflictor ) ) then InflictorClass = inflictor:GetClass() end
		if ( IsValid( attacker ) ) then

			AttackerClass = attacker:GetClass()

			if ( attacker:IsVehicle() and IsValid( attacker:GetDriver() ) ) then
				attacker = attacker:GetDriver()
			end

			if ( attacker:IsPlayer() ) then

				umsg.Start( "PlayerKilledNPC" )

					umsg.String( self:GetCitizenName() )
					umsg.String( InflictorClass )
					umsg.Entity( attacker )

				umsg.End()

				return
			end

		end

		umsg.Start( "NPCKilledNPC" )
			umsg.String( self:GetCitizenName() )
			umsg.String( InflictorClass )
			umsg.String( AttackerClass )
		umsg.End()

	end

	function ENT:AlertOthers(att)

		local isalert = self:GetNPCState() == NPC_STATE_ALERT

		if isalert and self.next_alert > CurTime() then
			return
		end

		self.next_alert = CurTime() + 4

		local class=self:GetClass()

		for k,v in next,ents.FindInSphere(self:GetPos(),1024) do
			if v:GetClass()==class then
				if v.bSit then
					v:TaskStart_EndSit()
				end

				v:SetNPCState( NPC_STATE_ALERT )
				if IsValid(att) then
					v:SetTarget(att)
				end
				v.iDelay = 0
				v.next_alert = CurTime() + 5
				v:SelectSchedule()
			end
		end

	end

	function ENT:OnTakeDamage(dmg)
		if self:Health() <= 0 then return end

		self:SpawnBlood(dmg)

		self:AlertOthers(dmg:GetAttacker())

 	  	self:ResetEnemy()
 	  	self:SetEnemy( dmg:GetAttacker() )
	   	self:AddEntityRelationship( dmg:GetAttacker(), 1, 20 )

		self:SetSchedule( SCHED_CHASE_ENEMY )

		self:SetTarget(dmg:GetAttacker())
		self:SetHealth(self:Health() - dmg:GetDamage())

		self:PlayWarning() -- Placeholder

		if self.LastSound < CurTime() then
			self:PlaySound("hit")
			self.LastSound = CurTime() + self.SoundDelay
		end

		if self:Health() <= 0 and self:GetNPCState() ~= NPC_STATE_DEAD then
			self:OnDamageDied(dmg)
		end
	end

	local nullf=function() end
	function ENT:OnDamageDied(dmg)

		local ent = dmg:GetAttacker()

		self:OnNPCKilled(ent,dmg:GetInflictor())

		self:SetNPCState( NPC_STATE_DEAD )
		self:SetSchedule( SCHED_FALL_TO_GROUND )
		self:ClearSchedule()

		self:StopSound( "metrocop_radio" )

		self:EmitSound( "npc/metropolice/die" .. math.random(1, 4) ..".wav" )

	end

	function ENT:OnRemove()
		if self.bSit then
			self:TaskStart_EndSit()
		end
	end

	function ENT:SetSched( sched )
		if not self:IsCurrentSchedule( sched ) then
			self:SetSchedule( sched )
		end
	end

	function ENT:SpawnBlood(dmg)
	   	local bloodeffect = ents.Create( "info_particle_system" )
		bloodeffect:SetKeyValue( "effect_name", "blood_impact_red_01")
	    bloodeffect:SetPos( dmg:GetDamagePosition() )
		bloodeffect:Spawn()
		bloodeffect:Activate()
		bloodeffect:Fire( "Start", "", 0 )
		bloodeffect:Fire( "Kill", "", 0 )
	end

	function ENT:StartTouch(ent)
		if ent:GetClass() == "func_door" then
			ent:Fire("unlock")
			ent:Fire("open")
		elseif self:GetNPCState() ~= NPC_STATE_ALERT then
			if math.random() < 1 / 5 then
				self:PlaySound("greet")
			end
		else
			self:PlaySound("scared")
		end
	end

	function ENT:AcceptInput(what,who,who2)
		if what=="Use" then
			self:StartTouch(who)
		end
	end


	function ENT:TaskStart_PlaySequence( data )

		local SequenceID = data.ID

		if ( data.Name ) then
			local seq = self:LookupSequence( data.Name )
			if seq and seq>=0 then
				SequenceID = seq
			end
		end

		if not SequenceID then ErrorNoHalt("Invalid sequence for "..tostring(self)..'\n' ) return end

		self:ResetSequence( SequenceID )
		self:SetNPCState( NPC_STATE_SCRIPT )

		local Duration = self:SequenceDuration()

		if ( data.Speed and data.Speed > 0 ) then

			SequenceID = self:SetPlaybackRate( data.Speed )
			Duration = Duration / data.Speed

		end
	 	Duration = data.Dur or Duration
		self.TaskSequenceEnd = CurTime() + Duration

	end

	function ENT:Task_PlaySequence( data )

		-- Wait until sequence is finished
		if ( CurTime() < self.TaskSequenceEnd ) then return end

		self:TaskComplete()
		self:SetNPCState( NPC_STATE_NONE )

		-- Clean up
		self.TaskSequenceEnd = nil

	end

end
--local t = ents.FindByClass"lua_npc_metrocop" for k,v in next,t do v:Remove() end

easylua.EndEntity(false,false)