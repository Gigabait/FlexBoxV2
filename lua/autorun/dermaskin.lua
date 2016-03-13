if CLIENT then
	include'skins/flexbox.lua'
	include'skins/sleekblack.lua'

	local derma_skin_flexbox = CreateClientConVar("derma_skin_flexbox","1",true)
	local derma_skin_sleekblack = CreateClientConVar("derma_skin_sleekblack","1",true)
	hook.Add("ForceDermaSkin","derma_skin_flexbox",function()
		if derma_skin_flexbox:GetBool() then return "flexbox" end
		if derma_skin_sleekblack:GetBool() then return "sleekblack" end
	end)
	concommand.Add("derma_skin_refresh",function()
		derma.RefreshSkins()
	end)
	return
end
AddCSLuaFile("skins/flexbox.lua")
AddCSLuaFile("skins/sleekblack.lua")
resource.AddFile "materials/gwenskin/flexbox.png"
resource.AddFile "materials/gwenskin/sleekblack.png"