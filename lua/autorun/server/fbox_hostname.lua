local Tag = "fbox_hostname"

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
this joke is overused
you wot m8 ill have you know i gra-- shadup
Lounging like its 2015
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

if not file.Exists("hostnames.txt","DATA") then
	local h = {}

	for _,s in pairs(slogans) do
		table.insert(h,{s,"default"})
	end

	file.Write("hostnames.txt",util.TableToJSON(h))
end

if not _G.fbox_is_dev_server then
	timer.Create(Tag,10,0,function()
		local hostnames = util.JSONToTable(file.Read("hostnames.txt","DATA"))
		local hh = {}
		for k,slogan in pairs(hostnames) do
			hh[k] = "FlexBox - " .. slogan[1]
		end
		RunConsoleCommand("hostname",tostring(table.Random(hh)))
	end)

	hook.Add("GetGameDescription", "moddedboxhack", function()
		return "Sandbox: ModdedBox"
	end)
else
	local gm = {
		["darkrp"] = "wow darkrp, a new low",
		["moddedbox"] = "just dev things"
	}

	RunConsoleCommand("hostname","FlexBox Dev Server - "..(gm[GAMEMODE.FolderName] and gm[GAMEMODE.FolderName] or "just dev things"))
end

util.AddNetworkString(Tag)

net.Receive(Tag,function(l,pl)
	local t = net.ReadDouble()

	if t == 1 then --read
		Msg("[Hostnames] ") print("READ: ",tostring(pl))
		net.Start(Tag)
		net.WriteTable(util.JSONToTable(file.Read("hostnames.txt","DATA")))
		net.WriteEntity(pl) --we need to verify
		net.Broadcast()
	elseif t == 2 then --write
		if not pl:IsAdmin() then return end
		Msg("[Hostnames] ") print("WRITE: ",tostring(pl))
		local tbl = net.ReadTable()
		file.Write("hostnames.txt",util.TableToJSON(tbl))
	end
end)