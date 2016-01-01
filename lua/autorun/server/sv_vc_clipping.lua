AddCSLuaFile("autorun/client/clipping.lua")
AddCSLuaFile("autorun/client/preview.lua")
Clipped = {}

duplicator.RegisterEntityModifier( "clips", function( p , Entity , data)
	if !IsValid( Entity ) then return end
	Entity.ClipData = data
	timer.Simple(1, function() SendPropClip( Entity ) end)
	duplicator.StoreEntityModifier( Entity, "clips", Entity.ClipData )
end)


local function RemoveFromTable( ent )
	for i , e in pairs(Clipped) do
		if ent == e then
			table.remove( Clipped , i )
		end
	end
end

function SendPropClip( Entity , ply , ind )
	
	Entity:CallOnRemove( "RemoveFromClippedTable" , RemoveFromTable )
	
	local Data = Entity.ClipData
	if IsValid( ply ) then
		for k , v in pairs(Data) do
			umsg.Start("visual_clip_newclip" , ply)
				umsg.Entity(Entity)
				umsg.Float(v.n.p)
				umsg.Float(v.n.y)
				umsg.Float(v.n.r)
				umsg.Float(v.d)
				umsg.Bool(v.inside)
				umsg.Bool(v.new or false )
			umsg.End()
		end
		return
	end
	if ind then 
		Data = Data[ ind ]
		umsg.Start("visual_clip_newclip")
			umsg.Entity(Entity)
			umsg.Float(Data.n.p)
			umsg.Float(Data.n.y)
			umsg.Float(Data.n.r)
			umsg.Float(Data.d)
			umsg.Bool(Data.inside)
			umsg.Bool(Data.new or false )
		umsg.End()
	else
		for k , Data in pairs(Data) do
			umsg.Start("visual_clip_newclip")
				umsg.Entity(Entity)
				umsg.Float(Data.n.p)
				umsg.Float(Data.n.y)
				umsg.Float(Data.n.r)
				umsg.Float(Data.d)
				umsg.Bool(Data.inside)
				umsg.Bool(Data.new or false )
			umsg.End()
		end
	end
end

local function SlowSendClips( inc  , ply)	
	local ent = Clipped[inc]
	if IsValid(ent) then 
		SendPropClip( ent , ply )
	end
	inc = inc + 1
	if inc > table.Count(Clipped) then
		return
	end
	timer.Simple( 0 , function() SlowSendClips( inc , ply ) end)
end

local function OnRequestClips( ply , command , args )
	if !ply or !IsValid( ply ) then return end
	
	timer.Simple( 0 , function() SlowSendClips( 1 , ply ) end)
end
concommand.Add( "cliptool_request_clips" , OnRequestClips )