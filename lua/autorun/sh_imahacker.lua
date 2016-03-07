if SERVER then
    util.AddNetworkString("imahacker")
    
    net.Receive("imahacker",function(len,ply)
        ply:Kick("baited")
    end)
elseif CLIENT then
    concommand.Add("imahacker",function(ply,args)
        net.Start("imahacker")
        net.SendToServer()
    end)
end
