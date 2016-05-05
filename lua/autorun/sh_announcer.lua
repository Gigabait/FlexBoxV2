if SERVER then
util.AddNetworkString("fbox_announcer")
	local msgs = {
		{"Chat with us on ",Color(115,139,215),"Discord",Color(255,255,255),": ",Color(200,100,100),"http://discord.gg/0qPf8afP8tPllmm1"},
		{"Seeing errors? Check the help menu by pressing ",Color(100,200,100),"F2",Color(255,255,255)," or typing ",Color(100,200,100),"!help",Color(255,255,255),"."},
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
		local ic = "<texture=icon16/comments.png>"
		local data = {Color(60,60,60),"\xe3\x80\x8a ",Color(255,255,255),ic,Color(220,70,100),"Announcement",Color(60,60,60)," \xe3\x80\x8b ",Color(255,255,255)}
		for _,a in pairs(msg) do
			table.insert(data,a)
		end
		chat.AddTimeStamp(data)

		local data2 = {Color(60,60,60),"\xe3\x80\x8a ",Color(220,70,100),"Announcement",Color(60,60,60)," \xe3\x80\x8b ",Color(255,255,255)}
		for _,a in pairs(msg) do
			table.insert(data2,a)
		end
		table.insert(data2,"\n")
		chat.AddTimeStamp(data2)

		if chathud and chatgui and chatgui.Chat and chatgui.Chat.ChatLog then
			chathud.AddText( unpack(data) )
			chatgui.Chat.ChatLog.AddText(chatgui.Chat.ChatLog,unpack(data2))
		else
			chat.AddText(data)
		end
	end)
end
