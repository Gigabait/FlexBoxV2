easylua.StartEntity("item_randomized")

ENT.Author					= "Flex"
ENT.PrintName 				= "Randomized Item Drop"
ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false
ENT.Value 					= 0

local misc = {"adrenaline","armorbattery","armorpack","medkit","minimedkit","battery","gasoline","poison","radioactive"}
local food = {"banana","bananas","orange","chinese_food","melon"}
local drink = {"coke","vodka","coffee","absinthe"}

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_c17/SuitCase001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysWake()
	end

	function ENT:Use( _, ply )
		if not ply:IsPlayer() then return end
		if self:GetModel() == "models/weapons/w_package.mdl" then
			local item1 = table.Random(food)
			local item2 = table.Random(drink)
			ply:ChatPrint("You got a "..msitems.Classes[item1].Inventory.name)
			ply:ChatPrint("You got a "..msitems.Classes[item2].Inventory.name)
			ply:AddToInventory(item1)
			ply:AddToInventory(item2)
		else
			local item = table.Random(misc)
			ply:ChatPrint("You got a "..msitems.Classes[item].Inventory.name)
			ply:AddToInventory(item)
		end
		self:Remove()
	end

end

easylua.EndEntity()