function IncludeSharedFile(v,func)
	if SERVER and func then
		if not func(v) then return end
	end
	if SERVER then AddCSLuaFile('msitems/'..v..'.lua') end
	if CLIENT and not file.Exists('msitems/'..v..'.lua','LUA') then return end
	include('msitems/'..v..'.lua')
end
IncludeSharedFile("sh_npcs")
