easylua.StartEntity("lua_npc")

ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.AutomaticFrameAdvance = true

ENT.IsMSNPC = true
ENT.RenderGroup = RENDERGROUP_BOTH

local Models = {"Female_01", "Female_02", "Female_03", "Female_04", "Female_06", "Female_07", "Male_01", "male_02", "male_03", "Male_04", "Male_05", "male_06", "male_07", "male_08", "male_09"}

if SERVER then
	local prot = ai_schedule.New( "protect selff" )
	prot:AddTask("PlaySequence", 	{ Name = "photo_react_blind" } )

	function ENT:CanConstruct()

		self:StopThat()
		return false
	end
	function ENT:CanTool()

		self:StopThat()
		return false
	end
	function ENT:CanProperty()

		self:StopThat()
		return false
	end
end
ENT.PhysgunDisabled = true
ENT.m_tblToolsAllowed = {}

local sounds = {
	female = {
		greet = {
			"vo/npc/female01/hi01.wav",
			"vo/npc/female01/hi02.wav",
		},
	},
	male = {
		greet = {
			"vo/npc/male01/hi01.wav",
			"vo/npc/male01/hi02.wav",
		}
	},
}

function ENT:Initialize()

	self:SetModel( "models/Humans/Group01/" .. table.Random(Models) .. ".mdl" )
	self:SetSolid( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_STEP )
	if SERVER then
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal()
		self:CapabilitiesAdd( bit.bor(CAP_OPEN_DOORS , CAP_ANIMATEDFACE , CAP_TURN_HEAD , CAP_USE_SHOT_REGULATOR , CAP_AIM_GUN ) )

		self:SetMaxYawSpeed( 5000 )

		self:AddEFlags(EFL_NO_DISSOLVE)
		self:SetUseType(SIMPLE_USE)
		if self.role then
			FBoxMapData.RegisterNPC(self,self.role)
		else
			print(self,"has no npc role!")
		end
		self.fixshit = CurTime()+3
		self.nexttalk = 0
	end
end

if SERVER then
	function ENT:GetGender()
		self.__gender = self.__gender or (self:GetModel():lower():find("female",1,true)
			or self:GetModel():lower():find("alyx",1,true))
			and "female" or "male"
		return self.__gender
	end

	function ENT:PlaySound(sndtype,a,b,c)
		local now = RealTime()
		if (self.nexttalk or 0)>now then return false end

		local rndsnd = sounds[self:GetGender()][sndtype]
		local sound = rndsnd and table.Random(rndsnd) or sndtype

		self:EmitSound(sound,100,math.random(96,104))

		local dur = SoundDuration(sound)
		dur=dur and dur>0 and dur or 0.3

		self.nexttalk=now+dur+0.3
		return  true
	end



	function ENT:OnCondition( cond )

	end

	function ENT:SelectSchedule()
	end

	function ENT:Think()
		if self.fixshit then
			if self.fixshit<CurTime() then
				self.fixshit = false
				for k,v in next,ents.FindInSphere(self:GetPos(),32) do
					if v~=self and v:GetClass()==self:GetClass() and v.role==self.role then
						self:SetPermanent(false)
						self:Remove()
						break
					end
				end

			end
		end
	end

	function ENT:AcceptInput(what,who,who2)
		if what=="Use" then
			self:OnUse(who,who2)
		end
	end

	function ENT:OnUse(who,who2)
		if (self.nexthi or 0)<RealTime() and self:PlaySound("greet") then
			self.nexthi=RealTime()+4
		end
	end

	function ENT:KeyValue( key, value )
		if key=="role" then
			self.role=value
		end
	end
	hook.Add("PlayerShouldTakeDamage","lua_npc",function(pl,attack)
		if attack and attack:IsValid() and attack.IsMSNPC then
			return true
		end
	end)


	function ENT:StopThat()
		local female = self:GetGender()=="female"
		if( female ) then
			self:PlaySound("vo/trainyard/female01/cit_hit0"..math.random(1, 3)..".wav")
			else
			self:PlaySound("vo/trainyard/male01/cit_hit0"..math.random(1, 3)..".wav")
		end
	end

	function ENT:OnTakeDamage( dmg )

	   	local v = dmg:GetAttacker()
		local mdl = self:GetModel()

		self:StopThat()

		if self:IsOnFire() then
			self:Extinguish()
		end

		if not IsValid(v) then return end
		if not v:IsPlayer() then
			v = v:CPPIGetOwner()
			if not IsValid(v) or not v:IsPlayer() then
				return
			end
		end

		local id = v:UserID()..'pl_lua_npc_kill'
		if timer.Exists(id) then
			return
		end

		self:StartSchedule(prot)

		timer.Create(id,1,1, function()
			timer.Remove(id)
			if IsValid(v) and v:IsPlayer() then
				if v:Alive() then
					if v:IsValid() then
						v:EmitSound("ambient/explosions/explode_2.wav")
					end

					local weapon = v:GetActiveWeapon()
					weapon = IsValid(weapon) and weapon:GetClass() or nil
					local info = DamageInfo()
					info:SetInflictor(game.GetWorld())
					info:SetAttacker(self:IsValid() and self or game.GetWorld())
					info:SetDamage(v:Health())
					v:TakeDamageInfo(info)

					local ent = v:GetRagdollEntity()
					if not IsValid(ent) then return end
					ent:SetName("dissolvemenao"..tostring(ent:EntIndex()))

					local e=ents.Create'env_entity_dissolver'
					e:SetKeyValue("target","dissolvemenao"..tostring(ent:EntIndex()))
					e:SetKeyValue("dissolvetype","1")
					e:Spawn()
					e:Activate()
					e:Fire("Dissolve",ent:GetName(),0)
					SafeRemoveEntityDelayed(e,0.1)
				end
			end
		end)

	end


	function ENT:SetPermanent(yes)
		if yes then
			self.__permaent={Pos=self:GetPos(),Ang=self:GetAngles()}
		else
			self.__permaent = nil
		end
	end

	function ENT:Clone()
		local role = self.role
		local pos = self.__permaent.Pos
		local ang = self.__permaent.Ang

		timer.Simple(3,function()
			if self:IsValid() then return end
			local ent = ents.Create'lua_npc'
			ent.role=role
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent:Spawn()
			ent:Activate()
			ent:SetPermanent(true)
		end)

		-- todo: full clone
	end

	function ENT:OnRemove()
		if self.__permaent then
			self:Clone()
		end
	end
end

if CLIENT then
	ENT.lobbyok = true
	ENT.PhysgunDisabled = false
	ENT.m_tblToolsAllowed = {}
	function ENT:CanConstruct() return true end
	function ENT:CanTool() return true end


	ENT.Base 					= "base_ai"
	ENT.Type 					= "ai"
	ENT.PrintName 				= "NPC"
	ENT.Spawnable 				= false
	ENT.AdminSpawnable 			= false

	ENT.AutomaticFrameAdvance	= true

	language.Add("lua_npc","NPC")
end

duplicator.RegisterEntityClass("lua_npc", function() end, "Model", "Pos", "Ang", "Data")

easylua.EndEntity()
