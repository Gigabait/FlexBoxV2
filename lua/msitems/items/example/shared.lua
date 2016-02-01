--[[
msitems.AddNPCShopItem("vending","barrysred",10) --add to shop if you want to do it this way

msitems.StartItem("barrysred")
	ITEM.State = "food" --types are food, entity, inject
	ITEM.WorldModel = "models/props_junk/PopCan01a.mdl"
	ITEM.Inventory = {
		name = "Barry's Red Cola",
		info = "A refreshing soda.",
	}

	function ITEM:Initialize()
		self.DermaMenuOptions = {}
		self:AddBackpackOption()
		self:AddDropOption()
		self:AddSpacer()
	end

	if SERVER then
	
		function ITEM:Initialize()
			self:SetModel(	self.WorldModel )
			self:PhysicsInit( SOLID_VPHYSICS )
			self:SetMoveType( MOVETYPE_VPHYSICS )
			self:SetSolid( SOLID_VPHYSICS )
			self:PhysWake()
		end
	end
	
msitems.EndItem()
]]--
