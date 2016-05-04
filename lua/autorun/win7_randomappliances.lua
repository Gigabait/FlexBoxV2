easylua.StartEntity("win7_intphone")

//Shit phone, requires chatsounds and CS:S.
ENT.Type = "anim"
ENT.Base = "win7_ibase"
ENT.PrintName = "Interactive Phone"
ENT.Spawnable = true

ENT.Model = "models/props/cs_office/phone.mdl"
ENT.ScreenModel = ""

ENT.UseSounds = {
	"chatsounds/autoadd/sfx_domestic/phone dial 3.ogg",
	"chatsounds/autoadd/sfx_domestic/phone dial 2.ogg"
}

ENT.EnableLight = false
ENT.ScreenOffset = Vector(0,0,-10)

easylua.EndEntity(false,false)

easylua.StartEntity("win7_coffemachine")
//Coffee Machine


ENT.Base = "win7_ibase"
ENT.PrintName = "Coffee Machine"
ENT.Spawnable = true

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
			local query = Derma_Query("This coffee will cost you 10 coins, will you pay?","Payment Confirmation","Yes",function()
				self.SendCoffee(ply) end,"No")
		end)

		net.Receive("coffeedenied",function(len,ply)
			local message = Derma_Message("You cannot afford this","Sorry","Close")
		end)
	end


end

easylua.EndEntity(false,false)