easylua.StartEntity("fbox_microwave")

ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.Category 		= "Roleplay Entities"
ENT.PrintName		= "Microwave"
ENT.Author			= "Flex"
ENT.Model 			= "models/props/cs_office/microwave.mdl"
ENT.Spawnable 		= true
ENT.AdminOnly 		= false

function ENT:SetupDataTables()
	self:NetworkVar("Vector",0,"ClockColor")
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local color = self:GetClockColor()

		local pos = self:GetPos()
		local ang = self:GetAngles()

		time = os.date("%H:%M")

		ang:RotateAroundAxis(ang:Right(),90)
		ang:RotateAroundAxis(ang:Forward(),-90)
		ang:RotateAroundAxis(ang:Up(),-90)

		cam.Start3D2D(pos+ang:Up()*10.5,ang,0.15)
			draw.SimpleTextOutlined(time,"default",70,-100,color and Color(color.x,color.y,color.z) or Color(100,200,100),nil,nil,2,color_black)
		cam.End3D2D()
	end

	function ENT:Menu(ply)
		if LocalPlayer() == ply then
			local r,g,b = 100,200,100
			Derma_StringRequest("Clock Color","Enter Red value",r,
			function(val)
				r = val
				Derma_StringRequest("Clock Color","Enter Green value",g,
				function(val)
					g = val
					Derma_StringRequest("Clock Color","Enter Blue value",b,
					function(val)
						b = val
						net.Start("fbox_microwave_"..self:EntIndex())
							net.WriteVector(Vector(r,g,b))
							net.WriteEntity(self)
						net.SendToServer()
					end)
				end)
			end)
		end
	end
end

function ENT:Think()
	if CLIENT then
		net.Receive("fbox_microwave_"..self:EntIndex(),function(len,ply)
			self:Menu(net.ReadEntity())
		end)
	else
		net.Receive("fbox_microwave_"..self:EntIndex(),function()
			self:SetClockColor(net.ReadVector())
		end)
	end
end

function ENT:Initialize()
	if SERVER then
		self:SetModel( self.Model )
		self:SetModelScale(1)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end

		util.AddNetworkString("fbox_microwave_"..self:EntIndex())
	end

	self:SetClockColor(Vector(100,200,100))
end

function ENT:Use(ply)
	self:EmitSound("buttons/blip1.wav",100,math.random(80,200))

	if ply:KeyDown(IN_SPEED) then
		net.Start("fbox_microwave_"..self:EntIndex())
			net.WriteEntity(ply)
		net.Broadcast()
	end
end

easylua.EndEntity(false,true)