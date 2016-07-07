local function HostnameManager()
	local hostnames = {}

	net.Start("fbox_hostname")
	net.WriteDouble(1)
	net.SendToServer()

	net.Receive("fbox_hostname",function()
		local tbl,ent = net.ReadTable(),net.ReadEntity()
		if ent == LocalPlayer() then
			hostnames = tbl
		end
	end)

	timer.Simple(0.2,function()

		local hf = vgui.Create("DFrame")
		hf:SetSkin("Default")
		hf:SetSize(800,600)
		hf:Center()
		hf:SetTitle("Hostnames")
		hf:MakePopup()

		local buttons = vgui.Create("EditablePanel",hf)
		buttons:Dock(TOP)
		buttons:SetTall(32)

		local b_add = vgui.Create("DButton",buttons)
		b_add:Dock(LEFT)
		b_add:DockMargin(0,0,4,0)
		b_add:SetWide(96)
		b_add:SetText("Add")

		local b_rem = vgui.Create("DButton",buttons)
		b_rem:Dock(LEFT)
		b_rem:SetWide(96)
		b_rem:SetText("Remove")
		b_rem:SetEnabled(false)
		b_rem:SetTooltip("No hostname selected for removal.")

		local b_apl = vgui.Create("DButton",buttons)
		b_apl:Dock(RIGHT)
		b_apl:SetWide(96)
		b_apl:SetText("Apply")

		if not LocalPlayer():IsAdmin() then
			b_add:SetEnabled(false)
			b_add:SetTooltip("You cannot modify hostnames not being an admin.")
			b_apl:SetEnabled(false)
			b_apl:SetTooltip("You cannot modify hostnames not being an admin.")
		else
			b_add:SetTooltip("Add a hostname.")
			b_apl:SetTooltip("Send hostnames to server.")
		end

		local l_names = vgui.Create("DListView",hf)
		l_names:Dock(FILL)
		l_names:SetMultiSelect(false)
		l_names:AddColumn("Hostname")
		l_names:AddColumn("Author")

		function l_names:OnRowSelected(p,r)
			b_rem.DoClick = function(s)
				if r:GetValue(2) == "default" then
					Derma_Message("Cannot remove default hostnames.","Error removing hostname","OK")
				else
					l_names:RemoveLine(p)
					b_rem:SetEnabled(false)
					b_rem:SetTooltip("No hostname selected for removal.")
				end
			end
			b_rem:SetEnabled(true)
			b_rem:SetTooltip("Remove selected hostname")
		end

		for _,h in pairs(hostnames) do
			l_names:AddLine(h[1],h[2])
		end

		b_add.DoClick = function(s)
			Derma_StringRequest("Add Hostname","Insert text to be added to hostnames","",
			function(s)
				if s:len() == 0 then
					Derma_Message("No string inputted, what was the point of that.","Error adding hostname","OK")
				elseif s:len() > 50 then
					Derma_Message("String too long (must be below 50 chars)","Error adding hostname","OK")
				else
					l_names:AddLine(s,GetConVar("name"):GetString())
				end
			end,
			function() end)
		end

		b_apl.DoClick = function(s)
			local hh = {}
			for _,line in pairs(l_names:GetLines()) do
				table.insert(hh,{line:GetValue(1),line:GetValue(2)})
			end
			net.Start("fbox_hostname")
			net.WriteDouble(2)
			net.WriteTable(hh)
			net.SendToServer()
		end
	end)
end

concommand.Add("hostname_manager",HostnameManager)