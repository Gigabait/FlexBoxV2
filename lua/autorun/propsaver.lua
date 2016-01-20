-- Prop Saver v3
-- by Flex
-- Original by user4992

PropSaver = PropSaver or {}

PropIndex = 0

function PropSaver.AddPropToTable( entity, model, pos, ang, scale, owner, static, material, color )

--	PropIndex = PropIndex + 1

	local CurrentProp = {
	["entity"] = entity,
	["model"] = model,
	["pos"] = pos,
	["ang"] = ang,
	["scale"] = scale,
	["owner"] = owner,
	["static"] = static,
	["material"] = material,
	["color"] = color,
	}


	return CurrentProp

end

function PropSaver.LoadPropTable( LoadingTable , TableOwner )

	for i=1,#LoadingTable do

		SpawnPropFromTable( i , LoadingTable , TableOwner )

	end

end

function PropSaver.SpawnPropFromTable( index , CurrentPropTable , Owner )


	local Loading = CurrentPropTable[index]

	if Loading["entity"] == "prop_ragdoll" then
		Loading["entity"] = "prop_physics"
	end

	SpawnedProp = ents.Create( Loading["entity"] )

 	if Loading["entity"] ~= "prop_physics" then
 			SpawnedProp:Spawn()
 	end


 	SpawnedProp:SetModel( Loading["model"] )
	SpawnedProp:SetPos( Loading["pos"] )
	SpawnedProp:SetAngles( Loading["ang"] )
	SpawnedProp:SetOwner( Loading["owner"] )
	SpawnedProp:SetMaterial( Loading["material"] )
	SpawnedProp:SetColor( Loading["color"] )

	SpawnedProp.PhysgunDisabled = Loading["static"]

	if isnumber(Loading["scale"]) then
		if Loading["scale"] != 1 then
			SpawnedProp:SetModelScale( Loading["scale"] )
		end
	end



 	if Loading["entity"] != "prop_physics" then SpawnedProp:Spawn() end

	local BGTable = Loading["bodygroup"]

	if istable( BGTable ) then

			for k, v in pairs( BGTable ) do

				if istable( v ) then
					SpawnedProp:SetBodygroup( v[1] , v[2] )
				end
			end
	end



	SpawnedProp:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	SpawnedProp:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	SpawnedProp:SetSolid( SOLID_VPHYSICS )         -- Toolbox

	if Loading["notsolid"] then SpawnedProp:SetSolid( SOLID_NONE )    end

	if Loading["static"] == true  then
		SpawnedProp:SetMoveType(MOVETYPE_NONE)
		local l = SpawnedProp:GetPhysicsObject()
		if IsValid( l ) then
	 		l:EnableMotion(false)
			l:Sleep()
		end
	end

	if Loading["protected"] == "true" then

 		function SpawnedProp:CanTool()
 			return false
 		end
 		function SpawnedProp:CanProperty()
 			return
 		end

	end

	PropIndex = PropIndex + 1

	LoadedProps[PropIndex] = SpawnedProp
	LoadedOwners[PropIndex] = Owner

end

function ClearTableProps( PropTable, CleaningOwner )
	if #PropTable > 0 then
		for k, v in pairs( PropTable ) do
			if IsValid( v ) then
				if isstring(CleaningOwner) and !(CleaningOwner == "") then
					if CleaningOwner == LoadedOwners[ tonumber(k) ] then
						v:Remove()
					end
				else
					v:Remove()
				end
			end
		end
	end
end

function PropSaver.DefineProp( prop,automate )

	local PropClass = tostring( prop:GetClass() )
	local PropModel = tostring( prop:GetModel() )
	local PropPos = tostring( math.Round(prop:GetPos().x ,3) .." , ".. math.Round(prop:GetPos().y ,3) .." , ".. math.Round(prop:GetPos().z ,3))
	local AngDissect = prop:GetAngles()
	local PropAng = tostring( math.Round(AngDissect.x ,0) .." , ".. math.Round(AngDissect.y ,0) .." , ".. math.Round(AngDissect.z ,0) )
	local PropMat = tostring( prop:GetMaterial() )
	local PropColor = table.ToString( prop:GetColor() )

	local PropProtected = false
	if prop.CanTool and (not prop:CanTool()) then PropProtected = true end

	if automate then
		local rand = math.random()
		local PropSaver.TempTables[rand] = {}
	else
		print( '{ ["entity"] = "'.. PropClass ..'" , ["model"] = "' .. PropModel .. '" , ["pos"] = Vector(' .. PropPos .. '), ["ang"] = Angle('.. PropAng ..'), ["owner"] = nil , ["static"] = true , ["material"] = "' .. PropMat .. '" , ["color"] = color_white , ["protected"] = "' .. tostring(PropProtected) .. '"}, ')
	end
end