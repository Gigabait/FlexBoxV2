local Announcer = {}
net.new("Announcer",Announcer,"net")
:cl"msg"

if SERVER then
	local msgs = {
		{"Chat with us on ",Color(115,139,215),"Discord",Color(255,255,255),": ",Color(200,100,100),"http://discord.gg/0qPf8afP8tPllmm1"},
		{"Seeing errors? Check the ",Color(100,200,100),"Addons",Color(255,255,255)," tab in the spawnmenu."},
	}
	local delay = CurTime()
	hook.Add("Think","FlexBoxAnnouncer",function()
		if delay and delay > CurTime() then return end
		local msg = util.TableToJSON(table.Random(msgs))
		Announcer.net.msg(4,msg).Broadcast()
		delay = delay + 300
	end)
end

if CLIENT then
	function Announcer:msg(n,t)
		local msg = util.JSONToTable(t)
		local time = os.date("*t")
		chat.AddText(Color(118,170,217),Format("%.2d:%.2d",time.hour,time.min),Color(255,255,255)," - ",Color(200,150,100),"Announcement",Color(255,255,255),": ",unpack(msg))
	end
end