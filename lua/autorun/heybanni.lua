--[[
Hey Banni, Metastruct banni remake
]]--

heybanni = {}

local META = FindMetaTable("Player")

function META:IsBanned()
	return self:GetPData("hb_isbanned")
end

function heybanni.Ban(banni,banner,length,reason)
	if CLIENT then
		
    elseif SERVER then
		
	end
end
