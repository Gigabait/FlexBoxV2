easylua.StartEntity("win7_icomputer")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Interactive Computer"
ENT.Author = "Win7yes"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "On")
end

if SERVER then
	
	function ENT:Initialize()

		//self:SetModel("models/props_combine/combine_interface002.mdl")
		self:SetModel("models/props_c17/computer01_keyboard.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
		self:SetUseType(SIMPLE_USE)
		self:GetPhysicsObject():EnableMotion(false)


		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end

		self.screen = ents.Create("prop_physics")
		self.screen:SetModel("models/props_lab/monitor02.mdl")
		self.screen:SetPos(self:LocalToWorld(Vector(-20,0,0)))
		self.screen:SetAngles(self:GetAngles())
		self.screen:Spawn()
		self.screen:SetSkin(0)
		self:SetSkin(1)
		self.screen:GetPhysicsObject():EnableMotion(false)
		self.screen:SetParent(self)
		self:SetOn(false)
		local loopsounds = {
			"ambient/computer_working.wav",
			"ambient/machines/combine_terminal_loop1.wav",
			"ambient/levels/labs/machine_moving_loop4.wav",
			"ambient/levels/labs/equipment_beep_loop1.wav",
			"hl1/ambience/computalk2.wav",
		}
		self.idlesound = CreateSound(self, loopsounds[math.Round(math.random(1,#loopsounds))])
		self.idlesound:ChangeVolume(0.05)
		self.idlesound:SetSoundLevel(60)

	end

	function ENT:Use(ply)
		local sounds = {
			"ambient/machines/keyboard_fast1_1second.wav",
			"ambient/machines/keyboard_fast2_1second.wav",
			"ambient/machines/keyboard_fast3_1second.wav",
			"ambient/machines/keyboard_slow_1second.wav",
			"ambient/machines/keyboard1_clicks.wav",
			"ambient/machines/keyboard2_clicks.wav",
			"ambient/machines/keyboard3_clicks.wav",
			"ambient/machines/keyboard4_clicks.wav",
			"ambient/machines/keyboard5_clicks.wav",
			"ambient/machines/keyboard6_clicks.wav",
			"ambient/machines/keyboard7_clicks_enter.wav",
		}
				
		local idlesounds = {
			"chatsounds/autoadd/cartoon_sfx/computercalculatefinish/marker 03.ogg",
			"chatsounds/autoadd/cartoon_sfx/computercalculate.ogg",
			"buttons/button6.wav",
			//"buttons/button5.wav",
		}
		
		if ply:KeyDown(IN_WALK) then
			if not self:GetOn() then
				self:EmitSound("buttons/combine_button5.wav")
				self.screen:SetSkin(1)
				self:SetSkin(0)
				self.idlesound:Play()
				if timer.Exists("iccmainoff") then
					timer.Destroy("iccmainoff")
				end
				timer.Create("iccidlesound",5,0,function()
					self:EmitSound(idlesounds[math.Round(math.random(1,#idlesounds))])
				end)
				self:SetOn(true)
			else
				self:EmitSound("buttons/combine_button2.wav")
				self.screen:SetSkin(0)
				timer.Create("iccmainoff",1,1,function()
					self:SetSkin(1)
				end)
				//self.idlesound:Stop()
				self.idlesound:FadeOut(0.5)
				if timer.Exists("iccidlesound") then
					timer.Destroy("iccidlesound")
				end
				self:SetOn(false)
			end
		end

		if self:GetOn() then
			self:EmitSound(sounds[math.Round(math.random(1,#sounds))])
		end

	end

	function ENT:OnRemove()
		self.idlesound:Stop()
		self.idlesound = nil
		self.screen:Remove()
		if timer.Exists("iccidlesound") then
			timer.Destroy("iccidlesound")
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		self.light = DynamicLight(self:EntIndex())
		if ( self.light ) then
			self.light.pos = self:GetPos()+Vector(0,0,50)
			self.light.r = 255
			self.light.g = 255
			self.light.b = 255
			if self:GetOn() then
				self.light.brightness = 5
				self.light.Size = 100
			else
				self.light.brightness = 0
				self.light.Size = 0
			end
			self.light.Decay = 1000
			self.light.DieTime = CurTime() + 1
		end
	end

end

easylua.EndEntity(false,false)