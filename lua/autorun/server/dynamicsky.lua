-- Dynamic sky
-- by user4992
--
-- to be run on server


function StartSky()

	local SkyTable =  ents.FindByClass("env_skypaint")
	SkyEnt =  SkyTable[1]

--	local FogTable =  ents.FindByClass("env_fog_controller")
--	FogEnt =  FogTable[1]

	local SunTable =  ents.FindByClass("env_sun")
	SunEnt =  SunTable[1]
	
	RunConsoleCommand("sv_skyname", "painted")

	timer.Create("SkyTime", 0.2, 0, function() SetupSky() end)
	timer.Start( "SkyTime" )
	
	
end

function SetupSky( )


	if SW.Time > 12 then
		SkyBrightness = tonumber( 12 - (SW.Time - 12) )
	else	
		SkyBrightness = (SW.Time)
	end
	
--	SkyBrightness = ( SkyBrightness / 20 ) 
	-- should be divided by 12
	-- but increased for a bit more nighttime
	
	SunMod = SkyBrightness
	
	TimeMod = ( SkyBrightness / 20 ) 
	NightMod = 1 - TimeMod
	
	if IsValid( SkyEnt ) then

		local CTop = Vector( 0.2 * TimeMod , 0.5 * TimeMod , 1 * TimeMod )
		local CBottom = Vector( 0.8 * TimeMod , 1 * TimeMod , 1 * TimeMod )
		local CSun = Vector( 0.2 * TimeMod , 0.1 * TimeMod , 0.1 * NightMod )

		SkyEnt:SetTopColor( CTop )	
		SkyEnt:SetBottomColor( CBottom )	
		SkyEnt:SetSunColor( CSun )
		
	end	

--	if IsValid( FogEnt ) then
--		render.FogStart( 1000 )
--		render.FogEnd( 10000 )
--		render.FogColor( Vector(0.7 , 0.75 , 0.8) )
--		render.FogMaxDensity( NightMod )
--	end

	if IsValid( SunEnt ) then
		local SunVal = 30 + (SunMod * 20)
		local SunAng = Angle( 0 , 0 , SunVal )
		SunEnt:SetKeyValue( "sun_dir", tostring( SunAng:Right() ) )
	end
end

function StopSky()

	SkyEnt:SetTopColor( Vector( 0.2  , 0.5  , 1 ) )	
	SkyEnt:SetBottomColor(  Vector( 0.8 , 1 , 1 ) )	
	SkyEnt:SetSunColor(  Vector( 0.2 , 0.1 , 0 ) )

	SunEnt:SetKeyValue( "sun_dir", tostring( Angle( 0 , 0 , 220 ):Right() ) )

--	render.FogMaxDensity( 0.1 )	
		
	timer.Stop( "SkyTime" )
end

timer.Simple( 5 , function() StartSky() end)
