if SERVER then
util.AddNetworkString("fbox_announcer")
	local msgs = {
		{"Chat with us on ",Color(115,139,215),"Discord",Color(255,255,255),": ",Color(200,100,100),"http://discord.gg/0qPf8afP8tPllmm1"},
		{"Seeing errors? Check the help menu by pressing ",Color(100,200,100),"F2",Color(255,255,255)," or typing ",Color(100,200,100),"!help",Color(255,255,255),"."},
		{Color(200,100,100),"Please do not use the ",Color(200,200,100),"Layers ",Color(200,100,100),"tool it is currently broken."},
	}
	local delay = CurTime()
	hook.Add("Think","FlexBoxAnnouncer",function()
		if delay and delay > CurTime() then return end
		local msg = util.TableToJSON(table.Random(msgs))
		net.Start("fbox_announcer")
			net.WriteString(msg)
		net.Broadcast()
		delay = delay + 300
	end)
end

if CLIENT then
	local noicons = CreateClientConVar("chat_rankicons", "1", true)

	net.Receive("fbox_announcer",function()
		local msg = util.JSONToTable(net.ReadString())
		local time = os.date("*t")
		local ic = noicons:GetBool() and "<texture=icon16/comments.png>" or ""
		chat.AddText(Color(200,200,100),Format("%.2d:%.2d ",time.hour,time.min),Color(60,60,60),"\xe3\x80\x8a ",Color(255,255,255),ic,Color(220,70,100),"Announcement",Color(60,60,60)," \xe3\x80\x8b ",Color(255,255,255),unpack(msg))
	end)
end
