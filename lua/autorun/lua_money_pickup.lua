easylua.StartEntity("lua_money_pickup")

ENT.Author					= "Potatofactory, Flex"
ENT.PrintName 				= "Money"
ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false
ENT.Value 					= 0

ENT.Configuration 			= {
	["defines"] = {
		["warn_negative"] = true,
		["low"]	= 100,
		["max_value"] = 1000,
		["sfxValueChanged"] = "ambient/levels/canals/windchime".. math.random(4,5) ..".wav",
		["sfxPickupMoney"] = "ambient/levels/labs/coinslot1.wav",
	},


	["models"] = {
		["low"] = "models/props/cs_assault/Dollar.mdl",
		["high"] = "models/props/cs_assault/Money.mdl",
	},

	["lighting"] = {
		["enabled"] = true,
		["colour"] = Color( 255, 255, 255 ),
		["sprite_max"] = 30,
		["sprite_decay"] = 15,
	},

}


if SERVER then
	function ENT:Initialize()
		self:SetModel( self.Configuration["models"]["low"] ) -- Temportary
		self:PhysicsInit( SOLID_BBOX )
		self:PhysWake()
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	end

	function ENT:SetValue( num )

		if num > 1e4 then
			self:EmitSound( self.Configuration["defines"]["sfxValueChanged"] )
			self:SetModel( "models/props/cs_assault/moneypallet.mdl" )

			--self:PhysicsDestroy()
			--self:PhysicsInit( SOLID_BBOX )

			-- HOW THE FUCK DO YOU CHANGE COLLISION??

			self.Value = num
			return
		end
		if num < 0 and self.Configuration["defines"]["warn_negative"] then
			self:SetColor( 255, 225, 225 )
			self.Configuration["lighting"]["colour"] = Color( 255, 220, 220 )
		end
		if num <= self.Configuration["defines"]["low"] then
			self:SetModel( self.Configuration["models"]["low"] )
		else
			if num > self.Configuration["defines"]["max_value"] then
				local entsneeded, extras = math.modf( num / self.Configuration["defines"]["max_value"] )
				if extras == 0 then
					for i=1, entsneeded - 1 do 
						local newmoney = ents.Create( self:GetClass() )
						newmoney:SetPos( self:GetPos() + Vector( 0, 0, i*10 ) )
						newmoney:Spawn()
						newmoney:SetValue( self.Configuration["defines"]["max_value"] )
					end
				else
					for i=1, entsneeded - 1 do 
						local newmoney = ents.Create( self:GetClass() )
						newmoney:SetPos( self:GetPos() + Vector( 0, 0, i*10 )  )
						newmoney:Spawn()
						newmoney:SetValue( self.Configuration["defines"]["max_value"] )
					end
					local floatmoney = ents.Create( self:GetClass() )
					floatmoney:SetPos( self:GetPos() + Vector( 0, 0, i*10 ) )
					floatmoney:Spawn()
					floatmoney:SetValue( math.floor( self.Configuration["defines"]["max_value"] * extras ) )
				end

				self:Remove() -- No longer needed
			else
				self:SetModel( self.Configuration["models"]["high"] )
			end
		end
		self.Value = num
		self:EmitSound( self.Configuration["defines"]["sfxValueChanged"] )
	end

	function ENT:Use( _, ply )
		if not ply:IsPlayer() then return end
		self:EmitSound( self.Configuration["defines"]["sfxPickupMoney"] )
		ply:GiveMoney( self.Value )
		self:Remove()
	end

end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		-- Things that help make the money 'distinguished'
		local mat = Matrix()
		mat:Scale( Vector( 1.5, 1.5, 1.5 ) )
		self:EnableMatrix( "RenderMultiply", mat )

		if self.Configuration["lighting"]["enabled"] then
			local dlight = DynamicLight( self:EntIndex() )
			if dlight then
				dlight.pos = self:GetPos() + Vector( 0, 0, 20 )
				dlight.r = self.Configuration["lighting"]["colour"].r
				dlight.g = self.Configuration["lighting"]["colour"].g
				dlight.b = self.Configuration["lighting"]["colour"].b
				dlight.brightness = 5
				dlight.Decay = self.Configuration["lighting"]["sprite_decay"]
				dlight.Size = self.Configuration["lighting"]["sprite_max"]
				dlight.DieTime = CurTime() + 1
			end
		end
	end
end

easylua.EndEntity(false, false)