if SERVER then
	return 
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

