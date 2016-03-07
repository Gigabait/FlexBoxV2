if SERVER then
    util.AddNetworkString("imahacker")
    
    net.Recieve("imahacker",function(p,l)
        local ply = net.ReadEntity()
        ply:Kick("baited")
    end)
elseif CLIENT then
    concommand.Add("imahacker",function(ply,args)
        net.Start("imahacker")
            net.WriteEntity(ply)
        net.SendToServer()
    end)
end
