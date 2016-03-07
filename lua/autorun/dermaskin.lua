if CLIENT then

	include'skins/flexbox.lua'

	local derma_skin_flexbox = CreateClientConVar("derma_skin_flexbox","1",true)
	hook.Add("ForceDermaSkin","derma_skin_flexbox",function()
		if derma_skin_flexbox:GetBool() then return "flexbox" end
	end)
	concommand.Add("derma_skin_refresh",function()
		derma.RefreshSkins()
	end)
	return
end
AddCSLuaFile("skins/flexbox.lua")
resource.AddFile "materials/gwenskin/flexbox.png"