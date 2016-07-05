
-----------------------------------------------------
function ents.FindInRealSphere( pos, radius )



    local tbl = {}



    for _, ent in pairs( ents.FindInSphere( pos, radius ) ) do

        if ( pos - ent:GetPos() ):Length() <= radius then

            table.insert( tbl, ent )

        end

    end



    return tbl



end



--[[function ents.FindByBase( base )



	local tbl = {}



	for _, ent in pairs( ents.GetAll() ) do



		if ent.Base == base then

			table.insert( tbl, ent )

		end



	end



	return tbl



end]]--



function ents.FindInPVS( vec )



	local tbl = {}

	for k, v in pairs( ents.GetAll() ) do

		if v:VisibleVec(vec) then

			table.insert( tbl, v )

		end

	end



	return tbl



end