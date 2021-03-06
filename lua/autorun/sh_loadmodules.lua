module("moduleload", package.seeall)

local TblSuffixEnum = {
	["cl"] = 1,
	["sv"] = 2,
	["sh"] = 3
} -- enumeration is easy and fun

Directory = "modules"
Modules = {}

function Load()
	tblSwitch = {}

	if SERVER then
		tblSwitch = {
			["Client"] = function(strFileNameFull)
				AddCSLuaFile(strFileNameFull)
			end,
			["Server"] = function(strFileNameFull)
				include(strFileNameFull)
			end,
			["Shared"] = function(strFileNameFull)
				include(strFileNameFull)
				AddCSLuaFile(strFileNameFull)
			end
		}
	else
		tblSwitch = {
			["Client"] = function(strFileNameFull)
				include(strFileNameFull)
			end,
			["Server"] = function(strFileNameFull)
				ErrorNoHalt("client has server module '" .. strFileNameFull .. "'")
			end,
			["Shared"] = function(strFileNameFull)
				include(strFileNameFull)
			end
		}
	end

	for strFileName, tblFileInfo in pairs(Modules) do
		tblSwitch[tblFileInfo.Type](tblFileInfo.Location)
	end
end

function AddSingle(strFileName)

	print( "[FlexBox]: Now initializing module " .. strFileName .. "..." )

	iFileIntention = TblSuffixEnum[string.sub(strFileName, 1, 2)] and TblSuffixEnum[string.sub(strFileName, 1, 2)] or 3

	if iFileIntention == 1 then
		Modules[strFileName] = {}
		Modules[strFileName].Type = "Client"
	elseif iFileIntention == 2 then
		Modules[strFileName] = {}
		Modules[strFileName].Type = "Server"
	elseif iFileIntention == 3 then
		Modules[strFileName] = {}
		Modules[strFileName].Type = "Shared"
	end

	Modules[strFileName].Location = Directory .. "/" .. strFileName
	Modules[strFileName].FileSize = file.Size(Directory .. "/" .. strFileName, "LUA" )
end

function RefreshDir( bPostLoading )
	
	TblFiles = file.Find( string.format( "%s/*", Directory ), "LUA")
	Modules = {}

	for _, strFileName in pairs(TblFiles) do
		AddSingle(strFileName)
	end

	if bPostLoading then
		Load()
	end
	
end

function 

hook.Add("PostGamemodeLoaded", "modulePostLoad", function()
	RefreshDir( true )
end)