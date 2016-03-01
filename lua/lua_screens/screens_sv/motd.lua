function SCREEN:create( ent )	end

function ENT:CallCMD(ply,...)

	if !self:IsScrAccessible( ply ) then return end

end