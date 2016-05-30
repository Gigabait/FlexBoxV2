local ENT = FindMetaTable("Entity")

function ENT:Dissolve()
	self:SetName("dissolve_"..tostring(self:EntIndex()))
	self:EmitSound("weapons/physcannon/physcannon_charge.wav")

	local e=ents.Create'env_entity_dissolver'
	e:SetKeyValue("target","dissolve_"..tostring(self:EntIndex()))
	e:SetKeyValue("dissolvetype","3")
	e:Spawn()
	e:Activate()
	e:Fire("Dissolve",self:GetName(),0)
	SafeRemoveEntityDelayed(e,0.1)
end

concommand.Add("dissolvedeath",function(pl)
	pl:Kill()
	local ent = pl.GetRagdollEntity and pl:GetRagdollEntity() or pl
	pl:EmitSound("weapons/physcannon/energy_disintegrate5.wav")
	if not IsValid(ent) then return end
	ent:SetName("dissolve_"..tostring(ent:EntIndex()))

	local e=ents.Create'env_entity_dissolver'
	e:SetKeyValue("target","dissolve_"..tostring(ent:EntIndex()))
	e:SetKeyValue("dissolvetype","3")
	e:Spawn()
	e:Activate()
	e:Fire("Dissolve",ent:GetName(),0)
	SafeRemoveEntityDelayed(e,0.1)
end)