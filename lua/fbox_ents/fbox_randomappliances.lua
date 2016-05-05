easylua.StartEntity("fbox_intphone")

//Shit phone, requires chatsounds and CS:S.
ENT.Type = "anim"
ENT.Base = "fbox_ibase"
ENT.Category = "Roleplay Entities"
ENT.PrintName = "Interactive Phone"
ENT.Spawnable = true

function ENT:Init()
	//print("Init")
	self.InCall = false
	self.CallRand = 0
	self.TimerCreated = false
	self.TimerIndex = tostring(self:EntIndex())
	timer.Create("intphone_phonecall"..self.TimerIndex,10,0,function()
		if not self then return end
		if self.InCall ~= false then return end
		if not self:GetOn() then return end
		
		//print("trying to check phone "..self.CallRand)
		if self.CallRand == 10 then
			//print("PHONE GOT CALL")
			self:CPPIGetOwner():ChatPrint("You're receiving a call on your phone!")
			self.InCall = true
			self.CallRand = math.random(0,10)
			timer.Create("intphone_incall"..self.TimerIndex,3,0,function()
				if not self then return end
				self:EmitSound("chatsounds/autoadd/cartoon_sfx/computercalculate.ogg")
				if self.TimerCreated then return end
				//print("Creating Timer")
				timer.Simple(math.random(20,60),function()
					if not self then return end
					timer.Destroy("intphone_incall"..self.TimerIndex)
					self.InCall = false
					self:CPPIGetOwner():ChatPrint("The caller hung up.")
					self.TimerCreated = false
				end)
				self.TimerCreated = true
			end)
		else
			self.CallRand = math.random(0,10)
		end
	end)
end

function ENT:SpecialFunc(ply)
	if self.InCall then
		self.InCall = false
		self:EmitSound("chatsounds/autoadd/sfx_domestic/phone pick up 1.ogg")
		ply:ChatPrint("You pick up, they hang up.")
		timer.Destroy("intphone_incall"..self.TimerIndex)
	else

	end

end

ENT.Model = "models/props/cs_office/phone.mdl"
ENT.ScreenModel = ""

ENT.UseSounds = {
	"chatsounds/autoadd/sfx_domestic/phone dial 3.ogg",
	"chatsounds/autoadd/sfx_domestic/phone dial 2.ogg"
}

ENT.EnableLight = false
ENT.ScreenOffset = Vector(0,0,-10)

easylua.EndEntity(false,false)

//End Phone

easylua.StartEntity("fbox_coffemachine")
//Coffee Machine


ENT.Base = "fbox_ibase"
ENT.PrintName = "Coffee Machine"
ENT.Spawnable = true
ENT.Category = "Roleplay Entities"

ENT.EnableLight = false
ENT.Model = "models/props_2fort/coffeemachine.mdl"
ENT.ScreenModel = "models/props_2fort/coffeepot.mdl"
ENT.ScreenOffset = Vector(-5,3.55,2)

function ENT:Init()
	util.AddNetworkString("coffeequery")
	util.AddNetworkString("coffeeback")
	util.AddNetworkString("coffeedenied")
	function self.MakeCoffee(ply)
		local cursound = 1
		local sounds = {
			"common/null.wav",
			"buttons/button17.wav",
			"common/null.wav",
			"buttons/button17.wav",
			"buttons/button1.wav",
			"ambient/levels/canals/toxic_slime_sizzle3.wav",
			"common/null.wav",
			"common/null.wav",
			"common/null.wav",
			"common/null.wav",
			"common/null.wav",
			"common/null.wav",
			"buttons/button6.wav"
		}
		if ply:CanAfford(10) then
			ply:TakeMoney(10)
			timer.Create("icm-createcoffee"..self.TimerIndex,0.2,#sounds-1,function()
				cursound = cursound + 1
				self:EmitSound(sounds[cursound])
				if cursound == #sounds then
					local coffee = ents.Create("coffee_item_sent")
					coffee:SetPos(self:LocalToWorld(Vector(5,5,3)))
					//coffee:SetModel("models/props_junk/garbage_coffeemug001a.mdl")
					coffee:Spawn()
				end
			end)
		else
			net.Start("coffeedenied")
			net.Send(ply)
		end
	end
end

ENT.UseSounds ={
	"buttons/blip1.wav",
	//"buttons/button1.wav",
	"buttons/button24.wav",
	"buttons/button6.wav"
}

function ENT:SpecialFunc(ply)
	net.Start("coffeequery")
	net.WriteEntity(ply)
	net.Send(ply)
end

function ENT:Think()
	net.Receive("coffeeback",function()
		local ply = net.ReadEntity()
		self.MakeCoffee(ply)
	end)
end

if CLIENT then
	
	function ENT:Initialize()
		function self.SendCoffee(ply)
			//print("we send coffee back")
			net.Start("coffeeback")
			net.WriteEntity(ply)
			net.SendToServer()
		end
	end
	function ENT:Think()
		net.Receive("coffeequery",function(len,ply)
			local ply = net.ReadEntity()
			local query = Derma_Query("This coffee will cost you $10, Are you sure?","Payment Confirmation","Yes",function()
				self.SendCoffee(ply) end,"No")
		end)

		net.Receive("coffeedenied",function(len,ply)
			local message = Derma_Message("You cannot afford this","Payment Problem","Close")
		end)
	end

	function ENT:Draw()
		self:DrawModel()
		if self:GetOn() then
			local ang = self:GetAngles()
			ang:RotateAroundAxis(ang:Right(),90)
			ang:RotateAroundAxis(ang:Forward(),180)
			ang:RotateAroundAxis(ang:Up(),-90)

			cam.Start3D2D(self:GetPos()+ang:Up(),ang,0.2)
				//surface.DrawRect(-151,-110,8,81)
				draw.RoundedBox(0,23.5,-165,60,15,Color(0,0,0))
				draw.SimpleText("Coffee: $10","DermaDefault",25,-165,Color(255,255,255))
			cam.End3D2D()
		end

	end



end

easylua.EndEntity(false,false)