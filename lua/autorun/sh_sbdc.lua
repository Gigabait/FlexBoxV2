--[[
SBDC - Sandbox Damage Control
Based off of QBox gamemode's damage control

Credits:
QBox - Metastruct Dev Team
Modifications - Flex
]]--

if SERVER then
	AddCSLuaFile("sh_sbdc.lua")
end

local GM = istable(GM) and GM or GAMEMODE

function GM:MortalRequested(ply,att)
	local req = hook.Call("PlayerShouldTakeDamage",self,ply,att or ply)
	return req == true
end

local enf
function GM:MortalEnforced(ply,att)
	enf = true
	local req = hook.Call("PlayerShouldTakeDamage",nil,ply,att or ply)
	enf = false
	return req == true
end

local sbgm = GetConVar("sbox_godmode")
function GM:PlayerShouldTakeDamage(ply,att)
	if enf then enf = false return end

	--EXPLANATION: sbox_godmode == -1 forces off
	if !IsValid(ply) or sbgm:GetInt() == -1 then return true end

	if IsValid(ply) and ply:IsBot() then
		if ply.nokill == true then return false end
		return true
	end

	--EXPLANATION: sbox_playershurtplayers == -1 forces off
	if att:IsValid() and GetConVar("sbox_playershurtplayers"):GetInt() == -1 then
		return true
	end

	local dmgmode = ply:GetInfoNum("cl_dmg_mode",0)

	if dmgmode == 0 then
		return false
	elseif dmgmode == 1 then
		return false
	elseif dmgmode == 2 and att:IsPlayer() then
		return false
	end

	return true
end

--Better Fall Damage--

local velDeath = 600
function GM:GetFallDamage(ply,speed)
	if speed < velDeath then return 0 end
	return math.pow(0.05 * (speed - velDeath), 1.75)
end

local hurt1 = 'player/pl_pain5.wav'
local hurt2 = "physics/body/body_medium_break3.wav"
function GM:OnPlayerHitGround(ply,water,var,speed)
	if water or var or !IsFirstTimePredicted() then return true end

	local vel = ply:GetVelocity()*800
	vel.z = vel.z*0.5
	local dmg = hook.Call("GetFallDamage",self,ply,speed)
	dmg = isnumber(dmg) and dmg or 0
	if dmg <= 0 then return true end

	local nofall
	if SERVER then
		nofall = tobool(ply:GetInfoNum("cl_dmg_nofall",0))
	else
		nofall = GetConVar("cl_dmg_nofall"):GetBool()
	end

	local enforced = self:MortalEnforced(ply,ply)

	if !enforced and sbgm:GetInt() != -1 and nofall then
		return true
	end

	local snd = dmg > 50 and hurt2 or hurt1
	if snd then
		local wep = ply:GetActiveWeapon()
		if wep and wep:IsValid() then
			wep:EmitSound(snd,100,math.random(93,108))
		end
	end

	if not SERVER then return true end

	local info = DamageInfo()
	info:SetDamage(dmg)
	info:SetDamageType(DMG_FALL)
	info:SetDamageForce(vel)
	info:SetDamagePosition(ply:LocalToWorld(ply:OBBCenter()))
	info:SetAttacker(ply) --santity check i guess

	local hp = ply:Health()

	ply:TakeDamageInfo(info)

	local hpdiff = hp-ply:Health()
	if hpdiff > 0 then end

	return true
end

if CLIENT then
	language.Add("msg_fall","Gravity")
	local function killbyfall(umsg)
		local vic = umsg:ReadEntity()
		if !IsValid(vic) then return end

		GAMEMODE:AddDeathNotice("#msg_fall",-1,"fell",vic:Name(),vic:Team())
	end

	usermessage.Hook("KilledByFalling",killbyfall)

	--cvars--
	CreateClientConVar("cl_dmg_mode",1,true,true)
	CreateClientConVar("cl_dmg_nofall",0,true,true)

	language.Add("sbdc_title","Sandbox Damage Control")
	language.Add("damage_mode","Damage Controls")
	language.Add("disable_fall_damage","Disable fall damage")
	language.Add("dmg_god","God")
	language.Add("dmg_pvp","Players cant hurt you")
	language.Add("dmg_all","Mortal")
	language.Add("dmg_buddha","Buddha mode")

	list.Set("DamageMode","#dmg_god",{cl_dmg_mode = "1"})
	list.Set("DamageMode","#dmg_pvp",{cl_dmg_mode = "2"})
	list.Set("DamageMode","#dmg_all",{cl_dmg_mode = "3"})
	list.Set("DamageMode","#dmg_buddha",{cl_dmg_mode = "4"})

	local function SBDCSpawnmenu(pnl)
		pnl:AddControl("Label",{Text = "Damage Mode:"})
		pnl:AddControl("ComboBox",{ Label = "#damage_mode",
									Description = "damage_mode",
									MenuButton = "0",
									Options = list.Get("DamageMode")
								  })
		pnl:AddControl("CheckBox",{Label = "#disable_fall_damage",Command = "cl_dmg_nofall"})
	end

	hook.Add("PopulateToolMenu","SBDCSpawnmenu",function()
		spawnmenu.AddToolMenuOption("Options","Player","#sbdc_title","#sbdc_title","","",SBDCSpawnmenu)
	end)
end
