-- Settings ------------
local MAXGHOSTS_LIM		= (game.SinglePlayer() or CLIENT) and 10   or 1
local MAXGHOSTS_UNLIM	= (game.SinglePlayer() or CLIENT) and 1000 or 10
------------------------

local STACKER	= "stacker_adv" -- must match file & folder name
local STACKER_	= STACKER.."_"

local FREEZE		= "freeze"
local UNFREEZE		= "unfreeze"
local WELD			= "weld"
local NOCOLLIDE		= "nocollide"
local CYCLIC		= "cyclic"
local WORLDSPACE	= "ws"
local DIRECTION		= "dir"
local COUNT			= "count"
local ONLYINWORLD	= "onlyinworld"
local USEPHYSICS	= "phy"
local OFFSET		= "offset"
local OFFTIMESDIM	= "offset_td"
local ROTATION		= "rot"
local ROTORIGIN		= "roto"
local GHOSTTRANSP	= "ghost_transp"
local GHOSTLIM		= "ghost_lim"
local TRIADS		= "triads"

local STACKER_PARAMCHANGED	= STACKER_.."paramchanged"
local STACKER_ROTORIGIN		= STACKER_..ROTORIGIN	-- needless?



TOOL.Category		= "Construction"
TOOL.Name			= "#Stacker - Adv"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar =
{
	[FREEZE]		= 1,
	[UNFREEZE]		= 0,
	[WELD]			= 0,
	[NOCOLLIDE]		= 0,
	[CYCLIC]		= 0,
	[WORLDSPACE]	= 0,
	[DIRECTION]		= 1,
	[ONLYINWORLD]	= 1,
	[COUNT]			= 1,
	[USEPHYSICS]	= 0,
	[OFFSET.."x"]	= 0,
	[OFFSET.."y"]	= 0,
	[OFFSET.."z"]	= 0,
	[OFFTIMESDIM]	= 0,
	[ROTATION.."p"]	= 0,
	[ROTATION.."y"]	= 0,
	[ROTATION.."r"]	= 0,
	[ROTORIGIN.."x"]= 0,
	[ROTORIGIN.."y"]= 0,
	[ROTORIGIN.."z"]= 0,
	[GHOSTTRANSP]	= 1,
	[GHOSTLIM]		= 1,
	[TRIADS]		= 0,
}

cleanup.Register( "stacks" )

--           ..                .
local mt = FindMetaTable( "Vector" )
if mt and !mt.__unm then function mt.__unm(v) return -1*v end end

local function PhysObjects( ent )
	local i = -1
	local n = ent:GetPhysicsObjectCount()
	local function itr()
		i = i + 1
		if i == n then return end
		local obj = ent:GetPhysicsObjectNum( i )
		if obj:IsValid() then return i, obj else return itr() end
	end
	return itr
end

function TOOL:GetClientBool( cvar ) return self:GetClientNumber(cvar) ~= 0 end
function TOOL:GetClientVector( cvar ) return Vector( self:GetClientNumber(cvar.."x"), self:GetClientNumber(cvar.."y"), self:GetClientNumber(cvar.."z") ) end
function TOOL:GetClientAngle( cvar ) return Angle( self:GetClientNumber(cvar.."p"), self:GetClientNumber(cvar.."y"), self:GetClientNumber(cvar.."r") ) end

do

local function VecMin(a,b) return Vector( math.min(a.x,b.x), math.min(a.y,b.y), math.min(a.z,b.z) ) end
local function VecMax(a,b) return Vector( math.max(a.x,b.x), math.max(a.y,b.y), math.max(a.z,b.z) ) end
local function VecRotate(vec,ang)
	local ret = vec*1
	ret:Rotate(ang)
	return ret
end
local dirs = { "Up", "Up", "Forward", "Forward", "Right", "Right" }
local dims = { "z", "z", "x", "x", "y", "y" }
local mem
if CLIENT then mem = setmetatable( {}, {__mode = "k"} ) end

function TOOL:CalcOffset( ent )

	-- makes ghosts' DoRagdollBone() 5-7 times faster
	if CLIENT and mem[ent] and mem[ent].frame == FrameNumber() then return mem[ent].transl, mem[ent].rot end

	local usephysics = self:GetClientBool( USEPHYSICS )
	local worldspace = self:GetClientBool( WORLDSPACE )
	local dir = self:GetClientNumber( DIRECTION )
	local offset = self:GetClientVector( OFFSET )
	local offset_td = self:GetClientBool( OFFTIMESDIM )
	local rot = self:GetClientAngle( ROTATION )
	local roto = self:GetClientVector( ROTORIGIN )

	local ang, mins, maxs, rotoffset

	if worldspace then
		ang = Angle(0,0,0)
		mins, maxs = ent:WorldSpaceAABB()
		rotoffset = vector_origin
		--[[
		roto = ent:LocalToWorld( roto ) - ent:GetPos()
		rotoffset = roto - VecRotate( roto, rot )
		rot = ent:LocalToWorldAngles( ang - rot )
		--]]
	else
		ang = ent:GetAngles()

		assert( !(usephysics and CLIENT) )
		if usephysics and IsValid( ent:GetPhysicsObject() ) then
			for _, obj in PhysObjects(ent) do
				local omins, omaxs = obj:GetAABB()
				if !mins then
					mins = obj:LocalToWorldVector(omins)
					maxs = obj:LocalToWorldVector(omaxs)
				else
					mins = VecMin( mins, obj:LocalToWorldVector(omins) )
					maxs = VecMax( maxs, obj:LocalToWorldVector(omaxs) )
				end
			end
		else
			mins, maxs = ent:OBBMins(), ent:OBBMaxs()
		end

		--offset = ent:LocalToWorld( offset ) - ent:GetPos()
		rotoffset = roto - VecRotate( roto, rot )
		rotoffset = ent:LocalToWorld( rotoffset ) - ent:GetPos()
		rot = ent:LocalToWorldAngles( rot ) - ent:GetAngles()
	end

	local dimensions = maxs - mins
	if offset_td then
		offset.x = offset.x * dimensions.x
		offset.y = offset.y * dimensions.y
		offset.z = offset.z * dimensions.z
	end

	local transl = dir == 0 and vector_origin or (-1)^(dir-1) * ang[ dirs[dir] ](ang) * dimensions[ dims[dir] ] --                ,         .
	offset = ang:Forward()*offset.x - ang:Right()*offset.y + ang:Up()*offset.z
	transl = transl + offset + rotoffset

	if CLIENT then mem[ent] = { frame = FrameNumber(), transl = transl, rot = rot } end
	return transl, rot
end
end

local function CalcBonePos( entpos, bpos, bang, translation, rotation )

	local offset = bpos - entpos
	bpos = bpos - offset
	offset:Rotate( rotation )
	bpos = bpos + offset + translation

	bang = bang*1
	bang:RotateAroundAxis(Vector(1,0,0), rotation.r)
	bang:RotateAroundAxis(Vector(0,1,0), rotation.p)
	bang:RotateAroundAxis(Vector(0,0,1), rotation.y)

	return bpos, bang
end


function TOOL:LeftClick( tr )
	
	if !IsValid( tr.Entity ) or tr.Entity:IsPlayer() then return end
	if CLIENT then return true end

	local count		= self:GetClientNumber( COUNT )
	local freeze	= self:GetClientBool( FREEZE )
	local unfreeze	= self:GetClientBool( UNFREEZE )
	local weld		= self:GetClientBool( WELD )
	local cyclic	= self:GetClientBool( CYCLIC )
	local nocollide	= self:GetClientBool( NOCOLLIDE )
	local onlyinworld = self:GetClientBool( ONLYINWORLD )

	local pl = self:GetOwner()
	local src = tr.Entity
	local cls = src:GetClass()
	local isEffect = cls == "prop_effect"
	local created = {}
	local limit = 400


	for i = 1, count do

		if !game.SinglePlayer() then
			local n = 1
			if weld then
				n = n + src:GetPhysicsObjectCount()
			elseif nocollide then
				n = n + 1
			end
			limit = limit - n
			if limit < 0 then MsgN("WARNING: Ents per frame limit hit while stacking!") break end
		end


		local data = duplicator.CopyEntTable( src ) --TODO: make this once

		local transl, rot = self:CalcOffset( isEffect and src.AttachedEntity or src )
		local pos = data.Pos + transl
		local ang = data.Angle + rot
		
		if not util.IsInWorld( pos ) and onlyinworld then
			self:GetOwner():ChatPrint("Aborted: Position was outside world")
			break
		end

		for _, phy in pairs( data.PhysicsObjects ) do
			phy.Pos, phy.Angle = CalcBonePos( data.Pos, phy.Pos, phy.Angle, transl, rot )
			if freeze then phy.Frozen = true end
			if unfreeze then phy.Frozen = false end
		end

		local cpy = duplicator.CreateEntityFromTable( pl, data )
		if !IsValid( cpy ) then break end

		cpy:SetPos( pos )
		cpy:SetAngles( ang )

		cpy.PhysicsObjects = table.Copy( data.PhysicsObjects )
		cpy.BoneMods = table.Copy( data.BoneMods )
		cpy.EntityMods = table.Copy( data.EntityMods )
		duplicator.ApplyEntityModifiers( pl, cpy )
		duplicator.ApplyBoneModifiers( pl, cpy )

		table.insert( created, cpy )


		if weld and src:GetMoveType() == MOVETYPE_VPHYSICS then
			for i, _ in PhysObjects( src ) do
				constraint.Weld( src, cpy, i, i, 0, nocollide )
			end
		elseif nocollide then
			constraint.NoCollide( src, cpy, 0, 0 )
		end

		src = cpy
	end

	if #created	> 0 then

		if cyclic and #created > 1 then
			local tail = created[#created]
			if weld and tr.Entity:GetMoveType() == MOVETYPE_VPHYSICS then
				for i, _ in PhysObjects( tr.Entity ) do
					constraint.Weld( tr.Entity, tail, i, i, 0, nocollide )
				end
			elseif nocollide then
				constraint.NoCollide( tr.Entity, tail, 0, 0 )
			end
		end

		undo.Create( "Stack" )
		undo.SetPlayer( pl )

		for _, ent in ipairs( created ) do
			if ent.PostEntityPaste then ent:PostEntityPaste( pl, ent, created ) end -- final duplicator-related stuff

			undo.AddEntity( ent )
			pl:AddCleanup( "stacks", ent )
			if PropDefender and PropDefender.Player and PropDefender.Player.Give then PropDefender.Player.Give( pl, ent, false ) end -- is that necessary?
		end

		undo.SetCustomUndoText( "Undone Stack (".. cls ..")" )
		undo.Finish( "Stack (".. cls ..")" )

		return true
	end

	return false
end

function TOOL:RightClick( tr )
	if !tr.Hit or !IsValid( self.SrcEntity ) then return end
	if CLIENT then return true end

	local pos = self.SrcEntity:WorldToLocal( tr.HitPos )
	local pl = self:GetOwner()
	pl:ConCommand( STACKER_ROTORIGIN.."x "..tostring(pos.x) )
	pl:ConCommand( STACKER_ROTORIGIN.."y "..tostring(pos.y) )
	pl:ConCommand( STACKER_ROTORIGIN.."z "..tostring(pos.z) )

	return true
end


function TOOL:Reload( tr )
	if CLIENT then return end
	local pl = self:GetOwner()
	pl:ConCommand( STACKER_PARAMCHANGED )
	--[[
	pl:ConCommand( STACKER_ROTORIGIN.."x 0" )
	pl:ConCommand( STACKER_ROTORIGIN.."y 0" )
	pl:ConCommand( STACKER_ROTORIGIN.."z 0" )
	--]]
end

function TOOL:GotGhosts() return self.GhostEntities and #self.GhostEntities > 0 end

-- TODO:                                         ,             !!1
function TOOL:StartGhosts()

	self:ReleaseGhostEntity()
	self.GhostEntities = {}

	local isRagdoll, cls
	local src = self.SrcEntity
	if src:GetClass() == "prop_effect" then
		if CLIENT then return end
		src = src.AttachedEntity
		cls = "prop_dynamic"
	end

	local mdl = src:GetModel()
	if util.IsValidProp(mdl) then
		if SERVER then return end
		isRagdoll = false
		cls = "prop_physics"
	else
		if CLIENT then return end
		isRagdoll = util.IsValidRagdoll( mdl )
		cls = cls or
			isRagdoll and "gmod_ghost" or
				mdl:sub(1,1)=="*" and "func_physbox" or "prop_dynamic"
	end

	-- Client cannot(???) get ents physobjects so it cannot calculate ghosts offsets using it.
	-- That's why we don't create client ghosts and ragdolls (their bones are positioned by client) if USEPHYSICS is on.
	if (CLIENT or SERVER and isRagdoll) and self:GetClientBool( USEPHYSICS ) then return end

	local col = src:GetColor()
	local r, g, b, a_ = col.r,col.g,col.b,col.a
	
	local mat = src:GetMaterial()
	local skin = src:GetSkin()

	local flexes = {}
	local flexNum = src:GetFlexNum()
	local flexScale = src:GetFlexScale()
	for i = 0, flexNum do flexes[i] = src:GetFlexWeight(i) end

	local count		= self:GetClientNumber( COUNT )
	local isLimited	= self:GetClientBool( GHOSTLIM )
	count = isRagdoll and 1 or math.min( count, isLimited and MAXGHOSTS_LIM or MAXGHOSTS_UNLIM )

	local isOpaque = !self:GetClientBool( GHOSTTRANSP )
	local function a(i) return isOpaque and 255 or a_ * 150/256 * math.cos((i-1)/count * math.pi/2) end

	for i = 1, count do

		local gst = CLIENT and ents.CreateClientProp() or ents.Create( cls )
		if !IsValid( gst ) then
			MsgN( "ERROR: AdvStacker StartGhosts() failed: invalid ghost #".. i .."!" )
			break
		end

		gst:SetModel( mdl )
		gst:Spawn()
		gst:DrawShadow( false )
		gst:SetSolid( SOLID_NONE )
		gst:SetMoveType( MOVETYPE_NONE )
		gst:SetRenderMode( RENDERMODE_TRANSALPHA )
		if isRagdoll then
			gst:SetNWEntity( "SrcEntity", src )
			gst:SetNWVector( "Vector0", Vector() ) -- force gmod_ghost to draw. FIXME: draw only for tool's owner (bones updates only for him)
			self.Weapon:SetNWEntity( "AdvStacker_RagdollGhost", gst )
		end

		gst:SetColor( r, g, b, a(i) )
		gst:SetMaterial( mat )
		gst:SetSkin( skin )

		for i = 0, 31 do gst:SetBodygroup( i, src:GetBodygroup(i) ) end -- is that enough? =\

		gst:SetFlexScale( flexScale )
		for i = 0, flexNum do gst:SetFlexWeight( i, flexes[i] ) end

		self.GhostEntities[i] = gst
	end
end

function TOOL:UpdateGhosts()

	local src = self.SrcEntity
	if !self:GotGhosts() or !IsValid( src ) then return end
	if src:GetClass() == "prop_effect" then assert(SERVER) src = src.AttachedEntity end

	for _, gst in ipairs( self.GhostEntities ) do

		if IsValid( gst ) then
			local transl, rot = self:CalcOffset( src )
			gst:SetPos( src:GetPos() + transl )
			gst:SetAngles( src:GetAngles() + rot )
		end
		src = gst
	end
end

function TOOL:Think()

	if self.SrcEntity and !self.SrcEntity:IsValid() then
		self:ReleaseGhostEntity()
		self.SrcEntity = nil
	end

	local pl = self:GetOwner()
	local t = util.GetPlayerTrace( pl--[[:GetViewEntity()]], pl:GetAimVector() )
	t.mask = bit.bor(CONTENTS_SOLID,CONTENTS_MOVEABLE,CONTENTS_MONSTER,CONTENTS_WINDOW,CONTENTS_DEBRIS,CONTENTS_GRATE,CONTENTS_AUX)
	local tr = util.TraceLine( t )

	local realtime = true -- TODO: on-demand update

	local src = tr.Entity
	if IsValid( src ) and !src:IsPlayer() and (!self.GhostEntities or src ~= self.SrcEntity) and gamemode.Call("CanTool", pl, tr, STACKER) then
		self.SrcEntity = src
		self:StartGhosts()
		if !realtime then self:UpdateGhosts() end
	end

	if realtime then self:UpdateGhosts() end
	if CLIENT then self:ClientThink() end
end
TOOL.Deploy = TOOL.Think

function TOOL:Holster()
	self:ReleaseGhostEntity()
	self.SrcEntity = nil
end

function TOOL:ParamChanged( cvar, old, new )
	if !IsValid( self.SrcEntity ) then return end

	if SERVER then
		local mdl = self.SrcEntity:GetModel()
		if (!game.SinglePlayer() or util.IsValidRagdoll( mdl )) and cvar ~= GHOSTTRANSP and cvar ~= USEPHYSICS then return end
	end

	self:StartGhosts()
	self:UpdateGhosts()
end

if SERVER then
	concommand.Add( STACKER_PARAMCHANGED, function( pl, cmd, args )
		-- args[1] - changed convar
		-- args[2] - old value
		-- args[3] - new value
		if !IsValid(pl) or #args ~= 3 then return end

		local wpn = pl:GetActiveWeapon()
		if !IsValid(wpn) or wpn:GetClass() ~= "gmod_tool" or wpn:GetMode() ~= STACKER then return end
		wpn:GetToolObject( STACKER ):ParamChanged( args[1], args[2], args[3] )
	end )
else

	local totaltime = 0
	local totalcalls = 0
	concommand.Add( STACKER_.."prof_spew", function()
		MsgN( "RagdollGhost:DoRagdollBone()" )
		MsgN( string.format("\ttotal calls = %d", totalcalls) )
		MsgN( string.format("\ttotal time  = %.10f", totaltime) )
		MsgN( string.format("\tavg time    = %.10f", totaltime/totalcalls) )
	end )
	concommand.Add( STACKER_.."prof_reset", function()
		totaltime, totalcalls = 0, 0
	end )

	function TOOL:ClientThink()

		local gst = self.Weapon:GetNWEntity( "AdvStacker_RagdollGhost" )
		if self.RagdollGhost ~= gst then

			self.RagdollGhost = gst

		elseif IsValid( self.RagdollGhost ) and !self.RagdollGhost.Hax then

			self.RagdollGhost.Hax = true
			local tool = self

			function self.RagdollGhost:DoRagdollBone( PhysBoneNum, BoneNum )
				local src = self:GetNWEntity( "SrcEntity" )
				if !IsValid( src ) or tool:GetClientBool( USEPHYSICS ) then return end

				local time = os.clock()
					local bpos, bang = src:GetBonePosition( BoneNum )
					local transl, rot = tool:CalcOffset( src )
					bpos, bang = CalcBonePos( src:GetPos(), bpos, bang, transl, rot )
					self:SetBonePosition( BoneNum, bpos, bang )

					local p0 = bpos
					local p1, p2, p3 = p0+bang:Forward()*2, p0-bang:Right()*2, p0+bang:Up()*2
					debugoverlay.Line( p0, p1, 0.01, Color(255,0,0) )
					debugoverlay.Line( p0, p2, 0.01, Color(0,255,0) )
					debugoverlay.Line( p0, p3, 0.01, Color(0,0,255) )
				totaltime = totaltime + (os.clock() - time)
				totalcalls = totalcalls + 1
			end
		end
	end


	local W, H
	local function DrawLine( A, B, r, g, b, a )
		--if (A.x >= 0 and A.x < W and A.y >= 0 and A.y < H) or
		--   (B.x >= 0 and B.x < W and B.y >= 0 and B.y < H) then
			-- at least one point is on screen
			surface.SetDrawColor( r, g, b, a )
			surface.DrawLine( A.x, A.y, B.x, B.y )
		--end
	end
	local function DrawTriad( p0, ang )
		ang = ang or Angle(0,0,0)

		local p1, p2, p3 = p0+ang:Forward()*16, p0-ang:Right()*16, p0+ang:Up()*16
		p0, p1, p2, p3 = p0:ToScreen(), p1:ToScreen(), p2:ToScreen(), p3:ToScreen()

		DrawLine( p0, p1, 255, 0, 0, 255 )
		DrawLine( p0, p2, 0, 255, 0, 255 )
		DrawLine( p0, p3, 0, 0, 255, 255 )
	end
	function TOOL:DrawHUD()

		local src = self.SrcEntity
		if !IsValid( src ) then return end

		if !self:GetClientBool( TRIADS ) then return end
		local worldspace = self:GetClientBool( WORLDSPACE )
		local roto = self:GetClientVector( ROTORIGIN )

		local o = src:LocalToWorld( roto )
		local ang = !worldspace and src:GetAngles() or nil
		W, H = surface.ScreenWidth(), surface.ScreenHeight()
		DrawTriad( o, ang )
		o = o:ToScreen()

		local a, n = o, 0
		for i, gst in ipairs( self:GotGhosts() and self.GhostEntities or {self.RagdollGhost} ) do
			if !IsValid( gst ) then break end
			n = n + 1

			local b = gst:LocalToWorld( roto )
			local ang = !worldspace and gst:GetAngles() or nil
			DrawTriad( b, ang )

			b = b:ToScreen()
			DrawLine( a, b, 255, 255, 255, 150 )
			a = b
		end

		if n > 1 and self:GetClientBool( CYCLIC ) then
			DrawLine( o, a, 255, 255, 255, 150 )
		end
	end


	language.Add( "Tool."..STACKER..".name", "Advanced Stacker" )
	language.Add( "Tool."..STACKER..".desc", "Stacks nearly everything" )
	language.Add( "Tool."..STACKER..".0",    "Left click on entity to stack it. Right click to set rotation origin." )

	language.Add( "Cleanup_stacks", "Stacks" )
	language.Add( "Cleaned_stacks", "Cleaned up all Stacks" )

	function TOOL.BuildCPanel( CPanel )
		
		local STACKER	= "stacker_adv"
		local STACKER_	= STACKER.."_"

		local FREEZE		= "freeze"
		local UNFREEZE		= "unfreeze"
		local WELD			= "weld"
		local NOCOLLIDE		= "nocollide"
		local CYCLIC		= "cyclic"
		local USEPHYSICS	= "phy"
		local WORLDSPACE	= "ws"
		local DIRECTION		= "dir"
		local COUNT			= "count"
		local OFFSET		= "offset"
		local OFFTIMESDIM	= "offset_td"
		local ROTATION		= "rot"
		local ROTORIGIN		= "roto"
		local GHOSTTRANSP	= "ghost_transp"
		local GHOSTLIM		= "ghost_lim"
		local TRIADS		= "triads"

		local STACKER_PARAMCHANGED = STACKER_.."paramchanged"


		local function GetNum( cvar, min, max )
			local val = GetConVarNumber( STACKER_..cvar )
			if min and max then return math.Clamp( val, min, max ) end
			return val
		end
		local function SetNum( cvar, num ) RunConsoleCommand( STACKER_..cvar, num ) end
		local function GetBool( cvar ) return GetNum( cvar, 0, 1 ) ~= 0 end
		local function SetBool( cvar, state ) SetNum( cvar, state and 1 or 0 ) end

		local function SetChangeCallback( cvar, f )
			--local clbcks = cvars.GetConVarCallbacks( STACKER_..cvar )
			-- removing dangling callbacks..
			--for i, f in ipairs( clbcks or {} ) do clbcks[i] = nil end
			cvars.AddChangeCallback( STACKER_..cvar, f,"stacker_adv" )
		end

		local function UpdateGhost( cvar, old, new )
			cvar = cvar:gsub("^"..STACKER_, "")
			
			local wpn = LocalPlayer():GetActiveWeapon()
			if !IsValid(wpn) or wpn:GetClass() ~= "gmod_tool" or wpn:GetMode() ~= STACKER then return end
			wpn:GetToolObject( STACKER ):ParamChanged( cvar, old, new )

			-- Send message to server with a delay (so updated client convar will be recieved before the event).
			timer.Simple( 0.1, function()
				RunConsoleCommand( STACKER_PARAMCHANGED, cvar, old, new )
			end)
		end

		local function Space()
			CPanel:AddControl( "Label", { Text = "" } )
		end

		local function CheckBox( label, cvar, tip )
			cvar = cvar and (STACKER_..cvar) or nil
			local checkbox = CPanel:AddControl( "Checkbox", { Label = label, Command = cvar } )
			if tip then checkbox:SetToolTip( tip ) end
			return checkbox
		end

		local function VectorSliders( label, cvar, abs )

			cvar = STACKER_..cvar
			local lbl = CPanel:AddControl( "Label", { Text = label } )
			
			local btn = vgui.Create('DButton',lbl)
			btn:SetText("Reset")
			btn:Dock(RIGHT)
			
			function btn:DoClick()
				RunConsoleCommand( cvar.."x", 0 )
				RunConsoleCommand( cvar.."y", 0 )
				RunConsoleCommand( cvar.."z", 0 )
			end
			
			CPanel:AddControl( "Slider", { Label = "X",	Type = "float", Min = -abs, Max = abs, Command = cvar.."x" } )
			CPanel:AddControl( "Slider", { Label = "Y",	Type = "float", Min = -abs, Max = abs, Command = cvar.."y" } )
			CPanel:AddControl( "Slider", { Label = "Z",	Type = "float", Min = -abs, Max = abs, Command = cvar.."z" } )

			 
			return lbl, btn
		end

		local function AngleSliders( label, cvar, abs )

			cvar = STACKER_..cvar
			local lbl = CPanel:AddControl( "Label", { Text = label } )
			
			local btn = vgui.Create('DButton',lbl)
			btn:SetText("Reset")
			btn:Dock(RIGHT)
			
			function btn:DoClick()
				RunConsoleCommand( cvar.."p", 0 )
				RunConsoleCommand( cvar.."y", 0 )
				RunConsoleCommand( cvar.."r", 0 )
			end
			
			CPanel:AddControl( "Slider", { Label = "Pitch",	Type = "float", Min = -abs, Max = abs, Command = cvar.."p" } )
			CPanel:AddControl( "Slider", { Label = "Yaw",	Type = "float", Min = -abs, Max = abs, Command = cvar.."y" } )
			CPanel:AddControl( "Slider", { Label = "Roll",	Type = "float", Min = -abs, Max = abs, Command = cvar.."r" } )

			return lbl, btn
		end


		-- Presets -------------
		do
			local presets = vgui.Create( "ControlPresets", CPanel )
			presets:SetPreset( STACKER )
			local cvars =
			{
				[FREEZE]		= 0,
				[UNFREEZE]		= 0,
				[WELD]			= 0,
				[NOCOLLIDE]		= 0,
				[CYCLIC]		= 0,
				[WORLDSPACE]	= 0,
				[DIRECTION]		= 1,
				[COUNT]			= 1,
				[USEPHYSICS]	= 0,
				[OFFSET.."x"]	= 0,
				[OFFSET.."y"]	= 0,
				[OFFSET.."z"]	= 0,
				[OFFTIMESDIM]	= 1,
				[ROTATION.."p"]	= 0,
				[ROTATION.."y"]	= 0,
				[ROTATION.."r"]	= 0,
				[ROTORIGIN.."x"]= 0,
				[ROTORIGIN.."y"]= 0,
				[ROTORIGIN.."z"]= 0,
			--	[GHOSTTRANSP]	= 1,
			--	[GHOSTLIM]		= 1,
			--	[TRIADS]		= 0,
			}
			local defaults = {}
			for k, v in pairs(cvars) do
				presets:AddConVar( STACKER_..k )
				defaults[STACKER_..k] = v
			end
			--presets:AddOption( "Default", defaults ) -- bugz o_O
			CPanel:AddItem( presets )
		end
		------------------------

		-- Freeze/Unfreeze -----
		local checkbox_frz		= CheckBox( "Freeze" )
		local checkbox_unfrz	= CheckBox( "Unfreeze" )

		function checkbox_frz.Button:Toggle()
			local checked = !self:GetChecked()
			self:SetValue( checked )
			SetBool( FREEZE, checked )
			if checked then
				checkbox_unfrz:SetValue( false )
				SetBool( UNFREEZE, false )
			end
		end
		function checkbox_unfrz.Button:Toggle()
			local checked = !self:GetChecked()
			self:SetValue( checked )
			SetBool( UNFREEZE, checked )
			if checked then
				checkbox_frz:SetValue( false )
				SetBool( FREEZE, false )
			end
		end

		local function UpdateFreeze()
			local freeze	= GetBool( FREEZE )
			local unfreeze	= GetBool( UNFREEZE )
			checkbox_frz:SetValue( freeze and !unfreeze )
			checkbox_unfrz:SetValue( unfreeze )
		end

		UpdateFreeze()
		SetChangeCallback( FREEZE,   function(cvar, old, new) UpdateFreeze() end )
		SetChangeCallback( UNFREEZE, function(cvar, old, new) UpdateFreeze() end )
		------------------------

		CheckBox( "Weld", WELD )
		CheckBox( "No-collide", NOCOLLIDE )
		CheckBox( "Cyclic constraining", CYCLIC, "Weld/no-collide tail with head" )

		-- Mode ----------------

		Space()
		local checkbox_ent		= CheckBox( "Relative to entity" )
		local checkbox_world	= CheckBox( "Relative to world" )

		checkbox_ent.Button:SetTextInset(0,1)
		checkbox_world.Button:SetTextInset(0,1)

		function checkbox_ent.Button:Toggle()
			local checked = !self:GetChecked()
			if !checked then return end
			self:SetValue( checked )
			checkbox_world:SetValue( !checked )
			SetBool( WORLDSPACE, !checked )

			
		end
		function checkbox_world.Button:Toggle()
			local checked = !self:GetChecked()
			if !checked then return end
			self:SetValue( checked )
			checkbox_ent:SetValue( !checked )
			SetBool( WORLDSPACE, checked )

		end

		local function UpdateMode()
			local val = GetBool( WORLDSPACE )
			checkbox_world:SetValue( val )
			checkbox_ent:SetValue( !val )
		end

		UpdateMode()
		SetChangeCallback( WORLDSPACE, function(cvar, old, new) UpdateMode() end )
		------------------------

		-- Direction -----------
		local Buttons = {}
		local Tips = {
			{ "Up", "icon16/arrow_up.png",       },
			{ "Down", "icon16/arrow_down.png",   },
			{ "Front", "icon16/arrow_out.png",    },
			{ "Behind", "icon16/arrow_in.png",  },
			{ "Left", "icon16/arrow_left.png",   },
			{ "Right", "icon16/arrow_right.png", },
		}
		local SelectedButton
		
		local function UpdateDir( num )
			
			num = num or GetNum( DIRECTION, 0, 6 )
			
			if SelectedButton then SelectedButton:SetSelected( false ) end
			if num == 0 then SelectedButton = nil return end
			SelectedButton = Buttons[num]
			SelectedButton:SetSelected( true )
		end
		
		local pn = vgui.Create 'EditablePanel'
		pn:SetTall(18)
		CPanel:AddItem(pn)
		
		for i = 1, 6 do
			local btn = vgui.Create('DButton',pn)
			btn:SetImage(Tips[i][2])
			btn:SetTall(18)
			btn:SetText("")
			btn:SetWide(16+4*2)
			btn:SetTooltip(Tips[i][1])
			btn:Dock(LEFT)
			
			function btn:DoClick()
				
				SetNum( DIRECTION, i )
				UpdateDir( i )
			end

			Buttons[i] = btn
		end

		UpdateDir()
		SetChangeCallback( DIRECTION, function(cvar, old, new)  UpdateDir() end )
		------------------------
		
		CPanel:NumSlider( "Num",STACKER_..COUNT,1,20,0 )
		SetChangeCallback( COUNT, UpdateGhost )
		CheckBox( "Actual boundaries", USEPHYSICS, "Use physics bounding box instead of entity bounding box\n" ..
			"For technical reasons prop and ragdoll previews will be disabled" )
		SetChangeCallback( USEPHYSICS, UpdateGhost )

		-- Sliders -------------
		
		CheckBox( "Times entity dimensions", OFFTIMESDIM, "Use entity dimensions as units for offset" )
		CheckBox( "In world check", ONLYINWORLD, "Abort if props go out of world" )
		local lbl_offset, btn_offset = VectorSliders( "Offset", OFFSET, 256 )
		Space()
		local lbl_rot, btn_rot		= AngleSliders( "Rotation", ROTATION, 180 )
		Space()
		local lbl_roto, btn_roto	= VectorSliders( "Rotation Origin", ROTORIGIN, 256 )
		------------------------

		-- Preview -------------
		Space()
		CPanel:AddControl( "Label", { Text = "Preview Options" } )
		CheckBox( "Transparent", GHOSTTRANSP )
		CheckBox( "Limited", GHOSTLIM )
		CheckBox( "Show triads", TRIADS )
		SetChangeCallback( GHOSTTRANSP, UpdateGhost )
		SetChangeCallback( GHOSTLIM, UpdateGhost )
		------------------------




	end

	local BuildCPanel = TOOL.BuildCPanel
	concommand.Add( STACKER_.."reloadui", function()
		local CPanel = GetControlPanel( STACKER )
		CPanel:ClearControls()
		BuildCPanel( CPanel )
	end )
end
