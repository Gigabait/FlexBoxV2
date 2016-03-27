if SERVER then
	list.Set( "PA_mirror_exceptions", "models/sprops/trans/wheel_d", Angle( 180, 180, 0 ) )
    list.Set( "PA_mirror_exceptions", "models/sprops/trans/wheel_b", Angle( 180, 180, 0 ) )
    list.Set( "PA_mirror_exceptions", "models/sprops/trans/miscwheels", Angle( 180, 180, 0 ) )
    list.Set( "PA_mirror_exceptions", "models/sprops/trans/train", Angle( 180, 180, 0 ) )
    list.Set( "PA_mirror_exceptions", "models/sprops/trans/lights", Angle( 0, 180, 180 ) )

    list.Set( "PA_mirror_exceptions_specific", "models/sprops/trans/misc/gauge_1.mdl", Angle( 0, 180, 180 ) )
    list.Set( "PA_mirror_exceptions_specific", "models/sprops/trans/misc/gauge_2.mdl", Angle( 0, 180, 180 ) )
    list.Set( "PA_mirror_exceptions_specific", "models/sprops/trans/misc/gauge_3.mdl", Angle( 0, 180, 180 ) )
    list.Set( "PA_mirror_exceptions_specific", "models/sprops/trans/train/track_t90_01.mdl", Angle( 180, 90, 0 ) )
    list.Set( "PA_mirror_exceptions_specific", "models/sprops/trans/train/track_t90_02.mdl", Angle( 180, 90, 0 ) )
end

local function MenuPopulate()
	local t = file.Find("lua/sprops/spawnlist/*.lua", "GAME")
	if #t == 0 then
		return 
	end

	local l = file.Find("settings/spawnlist/*rops.txt", 'MOD')
	for _, v in next, l do
		if v:lower():find("%-sprops%.txt$") then
			Msg '[SProps Hack] ' print("Found ", v, ", not reloading")
			return 
		end

	end

	Msg '[SProps Hack] ' print("Loading ", #t, "spawnlists")
	for k, f in next, t do
		local path = "lua/sprops/spawnlist/" .. f
		local data = file.Read(path, 'GAME')
		local pos = data:find("TableToKeyValues", 1, true)
		if not pos or data:sub(-2, -1) ~= ']]' then
			ErrorNoHalt("Sprops unparseable list " .. f .. '\n')
			continue
		end

		data = data:sub(pos - 1, -3)
		data = util.KeyValuesToTable(data)
		spawnmenu.AddPropCategory("settings/spawnlist/" .. f, data.name, data.contents, data.icon, data.id, data.parentid)
	end

end

hook.Add('Initialize', 'sprops', function()
	hook.Add("PopulatePropMenu", "StopStealingMahDamnedHooks", MenuPopulate)
end)
hook.Add("PopulatePropMenu", "StopStealingMahDamnedHooks", MenuPopulate)

list.Add( "OverrideMaterials", "sprops/sprops_grid_12x12" )
list.Add( "OverrideMaterials", "sprops/sprops_grid_orange_12x12" )
list.Add( "OverrideMaterials", "sprops/sprops_plastic" )
list.Add( "OverrideMaterials", "sprops/trans/lights/light_plastic" )
list.Add( "OverrideMaterials", "sprops/trans/wheels/wheel_d_rim1" )
list.Add( "OverrideMaterials", "sprops/trans/wheels/wheel_d_rim2" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_chrome" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_chrome2" )
list.Add( "OverrideMaterials", "sprops/textures/gear_metal" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_metal1" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_metal2" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_metal3" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_metal4" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_metal5" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_metal6" )
list.Add( "OverrideMaterials", "sprops/trans/misc/ls_m1" )
list.Add( "OverrideMaterials", "sprops/trans/misc/ls_m2" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_wood1" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_wood2" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_wood3" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_wood4" )
list.Add( "OverrideMaterials", "sprops/trans/misc/tracks_wood" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_cfiber1" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_cfiber2" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_rubber" )
list.Add( "OverrideMaterials", "sprops/textures/sprops_rubber2" )
list.Add( "OverrideMaterials", "sprops/trans/misc/beam_side" )