for _,file in pairs(file.Find("fbox_ents/*","LUA")) do
	if SERVER then
		AddCSLuaFile("fbox_ents/"..file)
	end
	include("fbox_ents/"..file)
end