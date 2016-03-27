local slogans = [[
whats an fps
adminhelp
flexbox.us.to
]]
----------------------------------------------------
-- ^ how long our quotes can be                 ^ --

slogans = string.Explode ("\n", slogans)

do
	local _slogans = {}
	for _, text in next, slogans do
		local slogan = text:Trim()

		if slogan:len() > 1 then
			table.insert (_slogans, slogan)
		end
	end
	slogans = _slogans
end

local hostname = {}
for k,slogan in pairs(slogans) do
	hostname[k] = "FlexBox - " .. slogan
end

timer.Create("fbox_hostname",10,0,function()
	RunConsoleCommand("hostname",tostring(table.Random(hostname)))
end)

hook.Add("GetGameDescription", "moddedboxhack", function()
	return "Sandbox: ModdedBox"
end)