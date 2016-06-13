local slogans = [[
whats an fps
adminhelp
flexbox.xyz
fire up the $5 booter
if only they knew
now with more box
WOW! *winks*
Tenrys free or your money back
don't quote me on this
Coming soon to an OGG VIDEO near you
the salt levels could drop a horse
Holding the balls
gotcha faggot
"it's always flex" --Metastruct Twitter
:box:
:B1:
wowdistorted!!!!!
this is not a trickkkk
noot noot
THANK'S A LOT FAT DUMB DUMB
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
