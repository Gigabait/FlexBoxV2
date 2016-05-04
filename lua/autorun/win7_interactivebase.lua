//Interactive Consoles base entity
easylua.StartEntity("win7_ibase")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Interactive Stuff Base"
ENT.Author = "Win7yes"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Model = "models/props_c17/computer01_keyboard.mdl"
ENT.ScreenModel = "models/props_lab/monitor02.mdl"
ENT.ScreenOffset = Vector(-20,0,0)
ENT.LoopSounds = {
	"common/null.wav"
}
ENT.UseSounds = {
	"buttons/lightswitch2.wav"
}
ENT.IdleSounds = {
	"common/null.wav"
}
ENT.EnableLight = true
function ENT:SpecialFunc(ply)
	ply:ChatPrint("Special function goes here")
end

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "On")
end

function ENT:Init()
	return
end

if SERVER then
	
	function ENT:Initialize()

		//self:SetModel("models/props_combine/combine_interface002.mdl")
		self:SetModel(self.Model)
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
		if self.ScreenModel ~= "" then
			self.screen:SetModel(self.ScreenModel)
		else
			self.screen:SetModel("models/props_junk/PopCan01a.mdl")
			self.screen:SetColor(Color(255,255,255,0))
			self.screen:SetRenderMode(RENDERMODE_TRANSALPHA)
		end
		self.screen:SetPos(self:LocalToWorld(self.ScreenOffset))
		self.screen:SetAngles(self:GetAngles())
		self.screen:Spawn()
		self.screen:SetSkin(0)
		self:SetSkin(1)
		self.screen:GetPhysicsObject():EnableMotion(false)
		self.screen:SetParent(self)
		self:SetOn(false)
		local loopsounds = self.LoopSounds
		self.idlesound = CreateSound(self, loopsounds[math.Round(math.random(1,#loopsounds))])
		self.idlesound:ChangeVolume(0.05)
		self.idlesound:SetSoundLevel(60)
		self.TimerIndex = tostring(self:EntIndex())

		self:Init()

	end

	function ENT:Use(ply)
		local sounds = self.UseSounds
				
		local idlesounds = self.IdleSounds
		
		if ply:KeyDown(IN_WALK) then
			if not self:GetOn() then
				self:EmitSound("buttons/combine_button5.wav")
				self.screen:SetSkin(1)
				self:SetSkin(0)
				self.idlesound:Play()
				if timer.Exists("iccmainoff-"..self.TimerIndex) then
					timer.Destroy("iccmainoff-"..self.TimerIndex)
				end
				timer.Create("iccidlesound-"..self.TimerIndex,5,0,function()
					self:EmitSound(idlesounds[math.Round(math.random(1,#idlesounds))])
				end)
				self:SetOn(true)
			else
				self:EmitSound("buttons/combine_button2.wav")
				self.screen:SetSkin(0)
				timer.Create("iccmainoff-"..self.TimerIndex,1,1,function()
					self:SetSkin(1)
				end)
				//self.idlesound:Stop()
				self.idlesound:FadeOut(0.5)
				if timer.Exists("iccidlesound-"..self.TimerIndex) then
					timer.Destroy("iccidlesound-"..self.TimerIndex)
				end
				self:SetOn(false)
			end
		end

		if self:GetOn() then
			if ply:KeyDown(IN_SPEED) then
				self:SpecialFunc(ply)
			else
				self:EmitSound(sounds[math.Round(math.random(1,#sounds))])
			end
		end

	end

	function ENT:OnRemove()
		self.idlesound:Stop()
		self.idlesound = nil
		self.screen:Remove()
		if timer.Exists("iccidlesound-"..self.TimerIndex) then
			timer.Destroy("iccidlesound-"..self.TimerIndex)
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		if self.EnableLight == true then
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

end

easylua.EndEntity(false,false)