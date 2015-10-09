AddCSLuaFile()

local tag = "tlmoney"
module("money", package.seeall)

local function isPlayer(ply)
	return (IsValid(ply) and ply:IsPlayer())
end

function GetMoney(ply)
	if SERVER then
		local dirName = isPlayer(ply) and ply:UniqueID() or (isstring(ply) and ply or nil)
		local money = tonumber(file.Read(tag .. "/" .. dirName .. "/money.txt", "DATA"))
		return money
	elseif CLIENT then
		return tonumber(ply:GetNWString(tag)) or 0
	end
end

if SERVER then
	function InitMoney(ply)
		local dirName = isPlayer(ply) and ply:UniqueID() or (isstring(ply) and ply or nil)
		if not file.IsDir(tag .. "/" .. dirName, "DATA") then file.CreateDir(tag .. "/" .. dirName) end
		if not file.Exists(tag .. "/" .. dirName .. "/money.txt", "DATA") then file.Write(tag .. "/" .. dirName .. "/money.txt", "0") end
		return dirName
	end

	function SaveMoney(ply, amount)
		local dirName = InitMoney(ply)
		file.Write(tag .. "/" .. dirName .. "/money.txt", amount or GetMoney(ply))
	end
	function LoadMoney(ply)
		local dirName = InitMoney(ply)
		ply:SetNWString(tag, tostring(GetMoney(ply)))
	end

	function SetMoney(ply, amount)
		if not isnumber(amount) or amount < 0 then amount = 0 end
		if amount > 10^12 then amount = 10^12 end
		amount = math.Round(amount)
		SaveMoney(ply, amount)
		ply:SetNWString(tag, tostring(amount))
	end

	function GiveMoney(ply, amount)
		SetMoney(ply, GetMoney(ply) + amount)
	end
	function TakeMoney(ply, amount)
		SetMoney(ply, GetMoney(ply) - amount)
	end

	function TransferMoney(ply1, amount, ply2)
		TakeMoney(ply1, amount)
		GiveMoney(ply2, amount)
	end

	hook.Add("PlayerAuthed", tag, LoadMoney)
	hook.Add("PlayerDisconnected", tag, SaveMoney)
	
	if easylua and aowl then
		local hookNames = {
			[GiveMoney] = "give",
			[TakeMoney] = "take",
			[SetMoney] = "set",
		}

		local function MoneyExcitement(amount)
			local excitementLevel = math.Clamp(#string.match(tostring(math.Round(amount, 0)), "%d+") - 3, 0, 5)
			local str = ""
			if excitementLevel >= 1 then
				str = ("!"):rep(excitementLevel)
			else
				str = "."
			end
			return str
		end

		local stringsCaller = {
			[GiveMoney] = "You gave $%s to %s%s (hax)",
			[TakeMoney] = "You took $%s from %s%s",
			[SetMoney] = "You set $%s as %s money%s",
		}
		local stringsTarget = {
			[GiveMoney] = "%s gave you $%s%s (hax)",
			[TakeMoney] = "%s took $%s from yourself%s",
			[SetMoney] = "%s set your money to $%s%s (hax)",
		}

		local function moneyManagementCommand(caller, amount, ply, func)
			if not amount then return false, "Invalid amount!" end
			if amount:lower():Trim():match("nan") then return false, "Can't break the system mate" end
			amount,ply = amount:Trim(), ply and ply:Trim() or ""
			if ply and  isnumber(tonumber(ply)) then
				local amt,tar = ply,amount
				amount = amt
				ply = tar
			end
			local amount = tonumber(amount) or 0
			if not isnumber(amount) or amount < 0 then return false, "Invalid amount!" end 
			if amount > 10^12 then amount = 10^12 end
			if ply == "" or ply == nil then
				ply = caller
			else
			 	ply = easylua.FindEntity(ply)
			 	ply = isPlayer(ply) == false and caller or ply
			end
			func(ply, amount)
			hook.Run(tag .. hookNames[func], caller, amount, ply)
			local callerStr = caller == ply and (func == SetMoney and "your" or "yourself") or ply:Nick() .. (func == SetMoney and "'s" or "")
			caller:ChatPrint(string.format(stringsCaller[func], tostring(amount), callerStr, MoneyExcitement(amount)))
			if caller ~= ply then
				local plyStr = caller == ply and "you" or caller:Nick()
				ply:ChatPrint(string.format(stringsTarget[func], plyStr, tostring(amount), MoneyExcitement(amount)))
			end
		end
	end
elseif CLIENT then
	--[[
	    FLEX NOTE: Do we really need this code?
	  local function LerpColor(frac, colorFrom, colorTo)
		local color = Color(255, 255, 255, 255)
		color.r = (colorTo.r - colorFrom.r) * frac + colorFrom.r 
		color.g = (colorTo.g - colorFrom.g) * frac + colorFrom.g 
		color.b = (colorTo.b - colorFrom.b) * frac + colorFrom.b 
		color.a = (colorTo.a - colorFrom.a) * frac + colorFrom.a

		return color
	end

	surface.CreateFont(tag .. "_1", {
		font = "Roboto Light",
		size = 72,
		weight = 1,
		italic = true,
	})

	surface.CreateFont(tag .. "_1_blur", {
		font = "Roboto Light",
		size = 72,
		weight = 1,
		italic = true,
		blursize = 4,
	})

	surface.CreateFont(tag .. "_2", {
		font = "Roboto Light",
		size = 48,
		weight = 1,
		italic = true,
	})

	surface.CreateFont(tag .. "_2_blur", {
		font = "Roboto Light",
		size = 48,
		weight = 1,
		italic = true,
		blursize = 4,
	})

	local initialized = false
	local ply
	local moneyAlpha
	local moneyY
	local moneyColor
	local money
	local lastMoneyGet
	local moneyLast2
	local moneyLast2Delay
	local oldMoneyAlpha
	local oldMoneyY
	local oldMoneyColor
	local oldMoney
	local add
	local addPositive

	local function initialize()
		ply = LocalPlayer()
		moneyAlpha = 0
		moneyY = ScrH()
		moneyColor = Color(255, 255, 255)
		money = string.format("%.0f", GetMoney(ply))
		lastMoneyGet = CurTime()
		moneyGetWait = CurTime()
		shouldWaitMoneyGet = false
		oldMoneyAlpha = 0
		oldMoneyY = ScrH()
		oldMoneyColor = Color(255, 255, 255)
		oldMoney = 0
		add = 0
		addPositive = true
		initialized = true
	end

	hook.Add("HUDPaint", tag, function()
		if not initialized or ply == NULL then 
			initialize()
		end

		surface.SetFont(tag .. "_1")
		local txt = "$" .. string.Comma(money)
		local txtW, txtH = surface.GetTextSize(txt)

		local frameMoney = GetMoney(ply)
		if frameMoney ~= money and not moneyChanged then
			if lastMoneyGet <= CurTime() then shouldWaitMoneyGet = false end
			lastMoneyGet = CurTime() + 4
			if not shouldWaitMoneyGet then
				moneyGetWait = CurTime() + .33
				shouldWaitMoneyGet = true
			end
			if moneyGetWait <= CurTime() then
				oldMoney = money
				money = frameMoney
				add = money - oldMoney
				addPositive = add >= 0
				moneyColor = addPositive and Color(255, 255, 255) or Color(255, 127 * 0.75, 127 * 0.75)
				oldMoneyAlpha = 1
				oldMoneyY = ScrH() - txtH * (addPositive and 2.5 or 1.5)
				oldMoneyColor = addPositive and Color(255, 255, 255) or Color(255, 127 * 0.75, 127 * 0.75)
			end
		end
		
		moneyAlpha = Lerp(FrameTime() * 15, moneyAlpha, lastMoneyGet <= CurTime() and 0 or 1)
		moneyY = Lerp(FrameTime() * 7.5, moneyY, lastMoneyGet <= CurTime() and ScrH() or ScrH() - txtH * 1.5)
		moneyColor = LerpColor(FrameTime() * 5, moneyColor, Color(0, 255, 127 * 0.75))

		oldMoneyAlpha = Lerp(FrameTime() * 5, oldMoneyAlpha, 0)
		oldMoneyY = Lerp(FrameTime() * 5, oldMoneyY, ScrH() - txtH * (addPositive and 1.5 or 2.5))

		surface.SetAlphaMultiplier(moneyAlpha)

		surface.SetFont(tag .. "_1_blur")
		surface.SetTextPos(ScrW() / 2 - txtW / 2, moneyY)
		surface.SetTextColor(Color(0, 0, 0))
		surface.DrawText(txt)
		
		surface.SetFont(tag .. "_1")
		surface.SetTextPos(ScrW() / 2 - txtW / 2, moneyY)
		surface.SetTextColor(moneyColor)
		surface.DrawText(txt)

		surface.SetFont(tag .. "_2")
		local txt = (addPositive and "+" or "-") .. "$" .. string.Comma(math.abs(add))
		local txtW, txtH = surface.GetTextSize(txt)

		surface.SetAlphaMultiplier(oldMoneyAlpha)

		surface.SetFont(tag .. "_2_blur")
		surface.SetTextPos(ScrW() / 2 - txtW / 2, oldMoneyY)
		surface.SetTextColor(Color(0, 0, 0))
		surface.DrawText(txt)
		
		surface.SetFont(tag .. "_2")
		surface.SetTextPos(ScrW() / 2 - txtW / 2, oldMoneyY)
		surface.SetTextColor(oldMoneyColor)
		surface.DrawText(txt)

		surface.SetAlphaMultiplier(1)
	end)]]--
end

local PLAYER = FindMetaTable("Player")
for k, v in pairs(_G.money) do
	if isfunction(v) then
		PLAYER[k] = v or nil
	end
end
