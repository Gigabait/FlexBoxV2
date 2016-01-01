aowl.AddCommand("thirdperson",function(ply)
	ply:SendLua[[ctp:Enable()]]
end)

aowl.AddCommand("firstperson",function(ply)
	ply:SendLua[[ctp:Disable()]]
end)
