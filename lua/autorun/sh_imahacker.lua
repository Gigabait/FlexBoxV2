if SERVER then
    util.AddNetworkString("imahacker")
    
    net.Receive("imahacker",function(len,ply)
        ply:Kick("baited")
    end)
elseif CLIENT then
    concommand.Add("cl_imahacker",function(ply,args)
        net.Start("imahacker")
            net.WriteEntity(ply)
        net.SendToServer()
    end,function(c,a)
    local ac = {}
    for _,ply in pairs(player.GetAll()) do
        table.insert(ac,c..ply:Nick())
    end)
end
