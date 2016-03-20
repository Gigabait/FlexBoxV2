local META = FindMetaTable("Player")

function META:GetTags()
	if SERVER then
		return self:GetPData("fbox_tags") != nil and util.JSONToTable(self:GetPData("fbox_tags")) or {}
	else
		return self:GetNWString("fbox_tags") != nil and util.JSONToTable(self:GetNWString("fbox_tags")) or {}
	end
end

function META:SetTag(tag)
	if SERVER then
		if self:GetPData("fbox_tags") == nil then
			self:SetPData("fbox_tags","[]")
		end
		local tags = util.JSONToTable(self:GetPData("fbox_tags")) or {}
		tags[tag] = true
		self:SetPData("fbox_tags",util.TableToJSON(tags))
		self:SetNWString("fbox_tags",util.TableToJSON(tags))
	end
end

if SERVER then
	for _,ply in pairs(player.GetHumans()) do
		ply:SetNWString("fbox_tags",ply:GetPData("fbox_tags"))
	end

	aowl.AddCommand("tag",function(ply,e,t)
		local p = easylua.FindEntity(e)
		p:SetTag(t)
	end)
end