msitems.StartItem("food_base")

	ITEM.State = "entity"
	ITEM.WorldModel = "models/props_junk/garbage_plasticbottle001a.mdl"
	ITEM.Points = 10
	ITEM.FoodType = "food"
	ITEM.Inventory = {
		name = "Base Food",
		info = "A base food item",
	}

	if CLIENT then
		function ITEM:Initialize()
			self.DermaMenuOptions = {}
			self:AddBackpackOption()
			self:AddDropOption()
			self:AddSpacer()
			if self.FoodType == "food" then
				self:AddSimpleOption("Eat", "Eat", LocalPlayer())
			elseif self.FoodType == "drink" then
				self:AddSimpleOption("Drink", "Drink", LocalPlayer())
			elseif self.FoodType == "inject" then
				self:AddSimpleOption("Inject", "Inject", LocalPlayer())
			elseif self.FoodType == "use" then
				self:AddSimpleOption("Use", "OnUse", LocalPlayer())
			end
			if self.Init then self:Init() end
		end
	end

	if SERVER then

		function ITEM:Initialize()
			self:AllowOption("Eat", "Eat")
			self:AllowOption("Drink", "Drink")
			self:AllowOption("Inject", "Inject")
			self:AllowOption("Use", "OnUse")
			self:SetModel(	self.WorldModel )
			self:PhysicsInit( SOLID_VPHYSICS )
			self:SetMoveType( MOVETYPE_VPHYSICS )
			self:SetSolid( SOLID_VPHYSICS )
			self:PhysWake()
			if self.Init then self:Init() end
		end

		function ITEM:OnConsume(ply)
			local class = self:GetClass()
			local typ = isstring(class) and string.match(class, "(.-)_.-_.-")
			if MetAchievements and MetaWorks.FireEvent then MetaWorks.FireEvent("ms_consumeitem", ply, typ) end
		end

		function ITEM:Eat(ply)
			ply:SetHealth(math.min(ply:Health() + self.Points, 100))
			self:OnConsume(ply)
			self:Remove()
		end

		function ITEM:PlayDrinkSound(ply)
			timer.Create("drink"..ply:UniqueID(), 0.5, 3, function()
				ply:EmitSound("ambient/levels/canals/toxic_slime_gurgle"..(math.random() > 0.5 and 7 or 4)..".wav", 100, 80)
			end)
		end

		function ITEM:Drink(ply)
			self:PlayDrinkSound(ply)
			self:Eat(ply)
		end

		function ITEM:OnUse(ply)

		end

		function ITEM:PlayInjectSound(ply)
			ply:EmitSound("items/medshot4.wav", 100, 80)
		end

		function ITEM:Inject(ply)
			self:PlayInjectSound(ply)
			self:Eat(ply)
		end
	end

msitems.EndItem()
