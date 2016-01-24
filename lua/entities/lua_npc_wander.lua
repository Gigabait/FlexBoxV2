ENT.Base 					= "base_ai"
ENT.Type 					= "ai"
ENT.Author					= "Mare"
ENT.PrintName 				= "Wander"
ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false

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

	-- names
		local function namestr(l)
			local t={}
			for n in l:gmatch'[^%s]+' do
				t[#t+1] = n
			end
			return t
		end

		local names = {
			male = namestr[[MIKE STANLEY LEONARD NATHAN DALE MANUEL RODNEY CURTIS NORMAN ALLEN MARVIN VINCENT GLENN JEFFERY TRAVIS JEFF CHAD JACOB LEE MELVIN ALFRED KYLE FRANCIS BRADLEY JESUS HERBERT FREDERICK RAY JOEL EDWIN DON EDDIE RICKY TROY RANDALL BARRY ALEXANDER BERNARD MARIO LEROY FRANCISCO MARCUS MICHEAL THEODORE CLIFFORD MIGUEL OSCAR JAY JIM TOM CALVIN ALEX JON RONNIE BILL LLOYD TOMMY LEON DEREK WARREN DARRELL JEROME FLOYD LEO ALVIN TIM WESLEY GORDON DEAN GREG JORGE DUSTIN PEDRO DERRICK DAN LEWIS ZACHARY COREY HERMAN MAURICE VERNON ROBERTO CLYDE GLEN HECTOR SHANE RICARDO SAM RICK LESTER BRENT RAMON CHARLIE TYLER GILBERT GENE MARC REGINALD]],
			female = namestr[[AMY ANNA REBECCA VIRGINIA PAMELA MARTHA DEBRA AMANDA STEPHANIE CAROLYN CHRISTINE MARIE JANET CATHERINE FRANCES ANN JOYCE DIANE ALICE JULIE HEATHER TERESA DORIS GLORIA EVELYN JEAN CHERYL MILDRED KATHERINE JOAN ASHLEY JUDITH ROSE JANICE KELLY NICOLE JUDY CHRISTINA KATHY THERESA DENISE TAMMY IRENE JANE LORI RACHEL MARILYN ANDREA LOUISE SARA ANNE JACQUELINE WANDA BONNIE JULIA RUBY LOIS TINA PHYLLIS NORMA PAULA DIANA ANNIE LILLIAN EMILY ROBIN PEGGY CRYSTAL GLADYS RITA DAWN CONNIE FLORENCE TRACY EDNA TIFFANY CARMEN ROSA CINDY GRACE WENDY VICTORIA EDITH KIM SHERRY SYLVIA JOSEPHINE SHANNON ETHEL ELLEN ELAINE MARJORIE CARRIE CHARLOTTE MONICA ESTHER PAULINE EMMA JUANITA ANITA RHONDA HAZEL AMBER EVA DEBBIE APRIL LESLIE CLARA LUCILLE JAMIE JOANNE ELEANOR VALERIE DANIELLE MEGAN ALICIA SUZANNE MICHELE GAIL]]
		}

		function ENT:RandomName(gender)
			local n = table.Random(names[gender == true and "male" or gender=="false" and "female" or gender or "male"])
			n = n:sub(1,1)..n:sub(2,-1):lower()
			return n
		end

		function ENT:GetCitizenName()
			return self:RandomName(self:GetGender() or "male") or "Citizen"
		end

	ENT.sounds = {
		female = {
			greet = {
				"vo/npc/female01/hi01.wav",
				"vo/npc/female01/hi02.wav",
				"vo/Streetwar/barricade/female01/c17_05_letusthru.wav",
				"vo/coast/odessa/female01/nlo_cheer01.wav",
				"vo/npc/female01/excuseme01.wav",
				"vo/npc/female01/excuseme02.wav",
				"vo/npc/female01/gordead_ans14.wav",
				"vo/npc/female01/moan01.wav",
				"vo/npc/female01/moan02.wav",
				"vo/npc/female01/moan03.wav",
				"vo/trainyard/female01/cit_hit04.wav",
				"vo/npc/female01/moan04.wav",
				"vo/npc/female01/moan05.wav",
				"vo/npc/female01/pardonme01.wav",
				"vo/npc/female01/pardonme02.wav",
				"vo/npc/female01/answer32.wav",
				"vo/npc/female01/answer30.wav",
				"vo/npc/female01/answer09.wav",
				"vo/npc/female01/answer01.wav",
				"vo/npc/female01/nice01.wav",
				"vo/npc/female01/outofyourway02.wav",
				"vo/trainyard/female01/cit_window_use01.wav",
				"vo/trainyard/female01/cit_pedestrian03.wav",
				"vo/trainyard/female01/cit_pedestrian04.wav",
				"vo/trainyard/female01/cit_pedestrian05.wav",
				"vo/trainyard/female01/cit_pedestrian01.wav",
				"vo/trainyard/female01/cit_pedestrian02.wav",
				"vo/npc/female01/ohno.wav",
				"vo/npc/female01/gordead_ques16.wav",
				"vo/npc/female01/gordead_ques10.wav",
				--random on touch chatter goes here
			},
			bench = {
				"vo/trainyard/female01/cit_bench01.wav",
				"vo/trainyard/female01/cit_bench02.wav",
				"vo/trainyard/female01/cit_bench03.wav",
				"vo/trainyard/female01/cit_bench04.wav",
			},
			hit = {
				"vo/trainyard/female01/cit_hit01.wav",
				"vo/trainyard/female01/cit_hit02.wav",
				"vo/trainyard/female01/cit_hit03.wav",
				"vo/trainyard/female01/cit_hit04.wav",
				"vo/trainyard/female01/cit_hit05.wav",
				"vo/npc/female01/hitingut01.wav",
				"vo/npc/female01/hitingut02.wav",
				"vo/npc/female01/imhurt01.wav",
				"vo/npc/female01/imhurt02.wav",
				"vo/npc/female01/ow01.wav",
				"vo/npc/female01/ow02.wav",
				"vo/npc/alyx/gasp02.wav",
				"vo/npc/alyx/gasp03.wav",
			},
			scared = {
				"vo/canals/female01/stn6_incoming.wav",
				"vo/canals/female01/stn6_shellingus.wav",
				"vo/coast/odessa/female01/nlo_cubdeath01.wav",
				"vo/coast/odessa/female01/nlo_cubdeath02.wav",
				"vo/npc/female01/notthemanithought02.wav",
				"vo/npc/female01/notthemanithought01.wav",
				"vo/npc/female01/no01.wav",
				"vo/npc/female01/no02.wav",
				"vo/npc/female01/imhurt02.wav",
				"vo/npc/female01/help01.wav",
				--scared voice goes here
			}
		},
		male = {
			greet = {
				"vo/npc/male01/hi01.wav",
				"vo/npc/male01/hi02.wav",
				--"vo/canals/male01/gunboat_owneyes.wav",
				"vo/npc/male01/gordead_ans19.wav",
				"vo/npc/male01/gordead_ans01.wav",
				"vo/npc/male01/excuseme01.wav",
				"vo/npc/male01/excuseme02.wav",
				"vo/npc/male01/busy02.wav",
				"vo/npc/male01/answer40.wav",
				"vo/npc/male01/answer39.wav",
				"vo/npc/male01/answer30.wav",
				"vo/trainyard/male01/cit_pedestrian01.wav",
				"vo/trainyard/male01/cit_pedestrian02.wav",
				"vo/trainyard/male01/cit_pedestrian03.wav",
				"vo/trainyard/male01/cit_pedestrian04.wav",
				"vo/trainyard/male01/cit_pedestrian05.wav",
				"vo/npc/male01/answer05.wav",
				--random on touch chatter goes here
			},
			bench = {
				"vo/trainyard/male01/cit_bench01.wav",
				"vo/trainyard/male01/cit_bench02.wav",
				"vo/trainyard/male01/cit_bench03.wav",
				"vo/trainyard/male01/cit_bench04.wav",
			},
			hit = {
				"vo/trainyard/male01/cit_hit01.wav",
				"vo/trainyard/male01/cit_hit02.wav",
				"vo/trainyard/male01/cit_hit03.wav",
				"vo/trainyard/male01/cit_hit04.wav",
				"vo/trainyard/male01/cit_hit05.wav",
				"vo/npc/male01/hitingut01.wav",
				"vo/npc/male01/hitingut02.wav",
				"vo/npc/male01/imhurt01.wav",
				"vo/npc/male01/imhurt02.wav",
				"vo/npc/male01/ow01.wav",
				"vo/npc/male01/ow02.wav",
			},
			scared = {
				"vo/trainyard/male01/cit_hit01.wav",
				"vo/trainyard/male01/cit_hit02.wav",
				"vo/trainyard/male01/cit_hit03.wav",
				"vo/trainyard/male01/cit_hit04.wav",
				"vo/trainyard/male01/cit_hit05.wav",
				"vo/Streetwar/sniper/male01/c17_09_help01.wav",
				"vo/Streetwar/sniper/male01/c17_09_help02.wav",
				"vo/npc/male01/notthemanithought02.wav",
				"vo/npc/male01/heretohelp02.wav",
				--scared voice goes here
			},
		},
	}


	ENT.walktable = {
		Vector(1450, -825, 384),
		Vector(3124, -1412, 384),
		Vector(2989, -875, 384),
		Vector(1344, 845, 384),
		Vector(49, 836, 376),
		Vector(-762, 767, 376),
		Vector(-2098, -104, 384),
		Vector(-2887, -1396, 288),
		Vector(-3675, -1977, 64),
		Vector(-3139, -1150, 384),
		Vector(-1710, -1569, 64),
		Vector(2985, -1617, 64),
		Vector(-3274, -1682, 64),
		Vector(-2511, -1311, 384),
		Vector(-3283, -1332, 384),
		Vector(-2489, -561, 384),
		Vector(-2876, -1753, 64),
		Vector(-3429, -1753, 64),
		Vector(-3419, -1647, 64),
		Vector(-3550, -1735, 64),
		Vector(1772, -782, 640),
		Vector(687, -151, 384),
		Vector(2096, -1097, 640),
		Vector(2761, -1236, 560),
		Vector(2273, -1092, 384),
		Vector(2737, -1231, 384),
	}


	ENT.sittable = true

	ENT.sittable = {
		{
			Vector(-1203, -31, 399),
			Angle(0,-90,0),
			false,
		},
		{
			Vector(-63, -797, 399),
			Angle(0,-90,0),
			false,
		},
		{
			Vector(125, -797, 399),
			Angle(0,-90,0),
			false,
		},
		--Train Station
		{
			Vector(-1536, -1682, 79),
			Angle(0,90,0),
			false,
		},
		{
			Vector(-1787, -1682, 79),
			Angle(0,90,0),
			false,
		},
		{
			Vector(-2061, -1682, 79),
			Angle(0,90,0),
			false,
		},
		--Train Station Tables
		{
			Vector(-2257, -1205, 80),
			Angle(0,-180,0),
			false,
		},
		{
			Vector(-2349, -1205, 80),
			Angle(0,0,0),
			false,
		},
		--Apartments near train
		{
			Vector(1559, -769, 658),
			Angle(0,0,0),
			false,
		},
	}



	local function RandomNPC()
		local spawns = {
			Vector(1467, -1460, 384),
			Vector(1791, -342, 640),
			Vector(-1148, -1198, 64),
		}
		local npcs = ents.FindByClass("lua_npc_wander")
		if #npcs > 50 then return end
		local spawn = table.Random(spawns)
		if not spawn then return end

		local wander = ents.Create("lua_npc_wander")
		wander:SetPos(spawn)
		wander:Spawn()
		wander:Activate()
	end

	timer.Create("ms_spawn_npcs",4,0,RandomNPC)

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
	ENT.PrintName					= "Wander"
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
	ENT.ScareDelay					= 20
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
		--Msg("[Wanderer "..tostring(self:EntIndex())..'] ') print(...)
	end
	function ENT:OnPlayerGreeting(pl,halloween_bag)
		local lg = self.lastgreet or 0
		local now = CurTime()

		self:DBG("ongreet",pl,halloween_bag and "hwn" or "")
		if now-lg<3 then self:DBG("timeout",pl) return end
		if self:GetNPCState() == NPC_STATE_ALERT then self:DBG("alert",pl) return end

		if pl:GetPos():DistToSqr(self:GetPos())> 512*512 then return end

		self:DBG("hello",pl)

		self.lastgreet = now

		local a = pl:GetPos() - self:GetPos()
		a:Normalize()
		self:SetAngles(a:Angle())
		self:PlayAnim(self.ANIM_wave)
		self:EmitSound("vo/npc/"..self:GetGender().."01/hi0"..math.random(1,2)..".wav")
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

ENT.Models = {"Male_01", "male_02", "male_03", "Male_04", "Male_05", "male_06", "male_07", "male_08", "male_09","Female_01", "Female_02", "Female_03", "Female_04", "Female_06", "Female_07"}

function ENT:Initialize()
	self:SetModel("models/Humans/Group02/" .. table.Random(self.Models) .. ".mdl")
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	if SERVER then
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetLagCompensated( true )
		self:SetTrigger(true)
		self:CapabilitiesAdd(bit.bor( CAP_USE , CAP_AUTO_DOORS , CAP_OPEN_DOORS , CAP_ANIMATEDFACE , CAP_TURN_HEAD , CAP_MOVE_GROUND, CAP_USE_WEAPONS, CAP_AIM_GUN, CAP_WEAPON_RANGE_ATTACK1 ))
		self:SetMaxYawSpeed(20)
		self:SetHealth(100)
		self:SetNPCState(NPC_STATE_IDLE)
		self.LastSound = CurTime()
		self.next_alert = CurTime()
	end
end

if SERVER then
	ENT.next_alert = 0

	function ENT:GetGender()
		self.__gender = self.__gender or self:GetModel():lower():find("female",1,true)
			and "female" or "male"
		return self.__gender
	end

	function ENT:PlaySound(type)
		if self.LastSound > CurTime() then return end
		local sound = table.Random(self.sounds[self:GetGender()][type])
		self:EmitSound(sound,math.random(90,100),math.random(90,110))
		self.busy = true
		self.LastSound = CurTime() + self.SoundDelay
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
			if self:GetNPCState() == NPC_STATE_ALERT and self.bScared then
				self:SetNPCState( NPC_STATE_IDLE )
				self.bScared = nil
			elseif self:GetNPCState() == NPC_STATE_NONE then
				self:SetNPCState( NPC_STATE_IDLE )
			end
			self:SelectSchedule()
		end
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
		elseif state == NPC_STATE_ALERT then
			self:SetLastPosition( table.Random(self:GetWalktable()) + Vector( 0, 0, 40 ) )
			self:SetSchedule( SCHED_FORCED_GO_RUN )
			self.iDelay = RealTime() + self.ScareDelay
			self.bScared = true
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

	function ENT:AlertOthers()

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
				v.iDelay = 0
				v.next_alert = CurTime() + 5
				v:SelectSchedule()
			end
		end

	end

	function ENT:OnTakeDamage(dmg)
		if self:Health() <= 0 then return end

		self:SpawnBlood(dmg)

		self:AlertOthers()
		self:SetHealth(self:Health() - dmg:GetDamage())

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
		self:ClearSchedule()

		if self.BecomeRagdollOnClientX then
			self.SelectSchedule=nullf
			self:BecomeRagdollOnClientX(dmg)
		else
			self:SetSchedule( SCHED_FALL_TO_GROUND )
			SafeRemoveEntityDelayed(self,4)
		end
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
		if self:GetNPCState() ~= NPC_STATE_ALERT then
			if math.random()<1/5 then
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
--local t = ents.FindByClass"lua_npc_wander" for k,v in next,t do v:Remove() end