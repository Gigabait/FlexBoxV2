local slogans = [[
whats an fps
adminhelp
flexbox.us.to
fire up the $5 booter
FucksBollocks
faster than a 30 year old virgin
endorsed b-- allahuackbar
if only they knew
NEVAR SAY NEVAR
fuck off goldblume my animations are damn good
now with more box
WOW! *winks*
it's the shit
s/its the shit/its shit/
Tenrys free or your money back
don't quote me on this
Coming soon to an OGG VIDEO near you
the salt levels could drop a horse
the kekening
Holding the balls
endorsed by who the fuck cares
now with more tentacles
now with FLEX-o-VISION
gotcha faggot
REAAAAAALLY
"it's always flex" --Metastruct Twitter
Ｆ Ｌ Ｅ Ｘ Ｂ Ｏ Ｘ
:ok_hand:
:box:
:B1:
●u● <3
✓
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