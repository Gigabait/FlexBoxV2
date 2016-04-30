local PLAYER = FindMetaTable("Player")

function PLAYER:GetMoney()
	if SERVER then
	if tonumber(self:GetPData("fbox_player_money",100)) < 0 then self:SetPData("fbox_player_money",0) end
	self:SetNWInt("fbox_money", self:GetPData("fbox_player_money")) end
	return tonumber(self:GetNWInt("fbox_money"))
end

function PLAYER:CanAfford(price)
	return price <= self:GetMoney()
end

function PLAYER:TransferMoney(ply,num)
	if ply:IsBot() or not ply:IsPlayer() or ply == self then return false end
	if self:GetMoney() < num then num = self:GetMoney() end

	if SERVER then
		if num <= 0 then return false end
		self:TakeMoney(num)
		ply:GiveMoney(num)
	end
	hook.Run("fbox_transfermoney", self,ply,num)
end

function PLAYER:SetMoney(num)
	if SERVER then
		self:SetPData("fbox_player_money",num)
		self:SetNWInt("fbox_money", self:GetPData("fbox_player_money"))
	end
	hook.Run("fbox_setmoney", self,num)
end

function PLAYER:GiveMoney(num)
	if SERVER then
		self:SetPData("fbox_player_money",self:GetPData("fbox_player_money", 100) + num )
		self:SetNWInt("fbox_money", self:GetPData("fbox_player_money"))
	end
	hook.Run("fbox_givemoney", self,num)
end

function PLAYER:TakeMoney(num)
	if SERVER then
		if self:GetMoney() < 0 then return end
		self:SetPData("fbox_player_money",self:GetPData("fbox_player_money",100) - num )
		self:SetNWInt("fbox_money", self:GetPData("fbox_player_money"))
		self:GetMoney()
	end
	hook.Run("fbox_takemoney", self,num)
end

function PLAYER:SaveMoney()
	self:SetPData("fbox_player_money", self:GetPData("fbox_player_money"))
end

function PLAYER:LoadMoney()
	if SERVER then self:SetNWInt("fbox_money", self:GetPData("fbox_player_money")) end
end

function PLAYER:Katching()
	sound.Play("chatsounds/autoadd/dota2/buy.ogg",self:GetPos())
end

function PLAYER:PayMoney(price)
	self:SetMoney(self:GetMoney()-price)
end

local function sanitycheck(num)
	if num and isnumber(num) and num>2^46 then
		ErrorNoHalt("[Money] Number too big: "..tostring(num)..", precision would have been lost!\n")
		return
	end

	if num and isnumber(num) and not math.isfinite(num) then
		error("[Money] Malicious value passed: "..tostring(num).."!")
	end
	return num
end

function PLAYER:DropMoney(value,reason)
	if CLIENT then return end
	if not isnumber(value) then error"Missing value" end
	assert(value>0,"Negative money value passed")
	value=sanitycheck(value)
	if not value then return end

	value=math.Round(value)

	self:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_DROP)
	timer.Simple(0.8, function()
		local pos = (self:GetPos()+self:GetUp()*32+self:GetRight()*-20)
		local money = ents.Create("lua_money_pickup")
		local phys = money:GetPhysicsObject()
		money:SetPos(pos)
		money.Value = value
		money:Spawn()
		money:Activate()
		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(self:GetAimVector()*200)
		end
		self:PayMoney(value)
	end)
	return true
end

hook.Add("PlayerDisconnected","fbox_money_save",function(ply)
	if CLIENT then return end
	ply:SaveMoney()
	MsgN("Money saved for disconnected player: "..ply:Name())
end)

hook.Add("PlayerInitialSpawn","fbox_money_load",function(ply)
	ply:LoadMoney()
end)

hook.Add("PlayerInitialSpawn","fbox_money_firstjoin",function(ply)

	if !ply:GetPData("fboxhasjoined") then
		ply:SetPData("fboxhasjoined", true)
		ply:GiveMoney(500)
	end
end)

hook.Add("fbox_transfermoney","fbox_transfermoney_notice",function(sender,receiver,num)
	sender:PrintMessage(3,"You gave "..receiver:GetName().." $"..num)
	receiver:PrintMessage(3,sender:GetName().." gave you $"..num)
	receiver:Katching()
	sender:Katching()
end)

hook.Add("fbox_givemoney","fbox_givemoney",function(ply,num)
	ply:Katching()
end)

hook.Add("fbox_takemoney","fbox_takemoney",function(ply,num)
	ply:Katching()
end)

hook.Add("fbox_setmoney","fbox_setmoney",function(ply,num)
	ply:Katching()
end)



if SERVER then
	aowl.AddCommand("transfermoney", function(ply,line,target)
		target = easylua.FindEntity(target)
		local amount = tonumber(string.sub(line,string.find(line,",")+1))
		if not isnumber(amount) or not IsValid(target) then return "Invalid target or amount." end
		ply:TransferMoney(target,amount)
	end, "players")
end
