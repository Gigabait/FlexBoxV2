local file_Find = file.Find
local SERVER = SERVER
local CLIENT = not SERVER

module("includes")

function IncludeOnServer(what)
	if SERVER then
		include(what)
	end
end

function IncludeShared(what)
	if SERVER then
		AddCSLuaFile(what)
	end
	include(what)
end

function IncludeShared(what)
	if SERVER then
		AddCSLuaFile(what)
	end
	if CLIENT then
		include(what)
	end
end

--[[

no workie
dont touchie

function IncludeFolderOnServer(folder)
	if not folder:EndsWith("/") and not folder:EndsWith("/*") then
		folder = folder .. "/"
	end
	if not Folder:EndsWith("*") then
		folder = folder .. "*"
	end
	local files = file_Find(folder,"LUA")
	for _,fn in pairs(files) do
		IncludeOnServer(fn)
	end
end

function IncludeFolderShared(folder)
	if not folder:EndsWith("/") and not folder:EndsWith("/*") then
		folder = folder .. "/"
	end
	if not Folder:EndsWith("*") then
		folder = folder .. "*"
	end
	local files = file_Find(folder,"LUA")
	for _,fn in pairs(files) do
		IncludeShared(fn)
	end
end

function IncludeFolderOnClient(folder)
	if not folder:EndsWith("/") and not folder:EndsWith("/*") then
		folder = folder .. "/"
	end
	if not Folder:EndsWith("*") then
		folder = folder .. "*"
	end
	local files = file_Find(folder,"LUA")
	for _,fn in pairs(files) do
		IncludeOnClient(fn)
	end
end


]]--