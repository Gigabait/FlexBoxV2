//Computers and Combine Terminal

easylua.StartEntity("fbox_computer")

ENT.PrintName = "Computer"
ENT.Category = "Roleplay Entities"
ENT.Base = "fbox_ibase"
ENT.Type = "anim"
ENT.Spawnable = true

ENT.Model = "models/props_c17/computer01_keyboard.mdl"
ENT.ScreenModel = "models/props_lab/monitor02.mdl"

ENT.UseSounds = {
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
				
ENT.IdleSounds = {
	"chatsounds/autoadd/cartoon_sfx/computercalculatefinish/marker 03.ogg",
	"chatsounds/autoadd/cartoon_sfx/computercalculate.ogg",
	"buttons/button6.wav",
}

ENT.LoopSounds = {
	"ambient/computer_working.wav",
	"ambient/machines/combine_terminal_loop1.wav",
	"ambient/levels/labs/machine_moving_loop4.wav",
	"ambient/levels/labs/equipment_beep_loop1.wav",
	"hl1/ambience/computalk2.wav",
}

function ENT:SpecialFunc(ply)
	return
end


easylua.EndEntity(false,false)

//Combine Terminal

easylua.StartEntity("fbox_combineterm")

ENT.PrintName = "Combine Terminal"
ENT.Category = "Roleplay Entities"
ENT.Base = "fbox_ibase"
ENT.Type = "anim"
ENT.Spawnable = true

ENT.Model = "models/props_combine/combine_interface002.mdl"
ENT.ScreenModel = "models/props_combine/combine_intmonitor001.mdl"
ENT.ScreenOffset = Vector(-5,0,50)

ENT.UseSounds = {
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
				
ENT.IdleSounds = {
	"ambient/machines/combine_terminal_idle1.wav",
	"ambient/machines/combine_terminal_idle2.wav",
	"ambient/machines/combine_terminal_idle3.wav",
	"ambient/machines/combine_terminal_idle4.wav",
}

ENT.LoopSounds = {
	"ambient/machines/combine_terminal_loop1.wav"
}

function ENT:SpecialFunc(ply)
	return
end

if SERVER then
	function ENT:Think()
		if not self:GetOn() then
			self.screen:SetSkin(1)
		elseif self:GetOn() then
			self.screen:SetSkin(0)
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		self.light = DynamicLight(self:EntIndex())
		if ( self.light ) then
			self.light.pos = self:GetPos()+Vector(0,0,50)
			self.light.r = 0
			self.light.g = 255
			self.light.b = 255
			if self:GetOn() then
				self.light.brightness = 5
				self.light.Size = 256
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