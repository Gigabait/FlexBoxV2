if SERVER then
util.AddNetworkString("fbox_announcer")
	local msgs = {
		{"Chat with us on ",Color(115,139,215),"Discord",Color(255,255,255),": ",Color(200,100,100),"http://discord.gg/0qPf8afP8tPllmm1"},
		{"Seeing errors? Check the help menu by pressing ",Color(100,200,100),"F2",Color(255,255,255)," or typing ",Color(100,200,100),"!help",Color(255,255,255),"."},
		{"Want to build privately? Check out the ",Color(200,200,000),"Layers",Color(255,255,255)," tool in the spawnmenu."},
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
net.Receive("fbox_announcer",function()
		local msg = util.JSONToTable(net.ReadString())
		local time = os.date("*t")
		chat.AddText(Color(118,170,217),Format("%.2d:%.2d",time.hour,time.min),Color(255,255,255)," - ",Color(200,150,100),"Announcement",Color(255,255,255),": ",unpack(msg))
	end)
end
