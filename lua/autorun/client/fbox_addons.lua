fb_addons_list = {
	workshop = {
		collection = {
			id = "536311663",
			name = "Server Collection",
			desc = "Everything workshop content is here, maps and all",
			collection = true,
		},
		sprops = {
			id = "173482196",
			name = "SProps",
			desc = "More props to build with.",
		},
		wiremod = {
			id = "160250458",
			name = "Wiremod",
			desc = "Adds wiring, chips, logic and other stuff.",
		},
	},
	svn = {
		chatsounds = {
			url = "https://github.com/Metastruct/garrysmod-chatsounds/trunk",
			name = "Chatsounds",
			desc = "Adds fun to chatting.",
		},
		acf = {
			url = "https://github.com/nrlulz/ACF/trunk",
			name = "ACF",
			desc = "Adds cannons, guns and motors.",
		},
		acfmissiles = {
			url = "https://github.com/Bubbus/ACF-Missiles/trunk",
			name = "ACF missiles",
			desc = "Adds missile based weapons to ACF.",
		},
		wiremod = {
			url = "https://github.com/wiremod/wire/trunk",
			name = "Wiremod",
			desc = "Adds wiring, chips, logic and other stuff. Server uses this version, but you're not required to use it.",
		},
		wireextras = {
			url = "https://github.com/wiremod/wire-extras/trunk",
			name = "Wiremod Extras",
			desc = "Unofficial Wiremod stuff.",
		},
	},
}

spawnmenu.AddCreationTab( "Addons", function()

	local scroll = vgui.Create("DScrollPanel")
	
	local sheet = vgui.Create("DPropertySheet",scroll)
	sheet:Dock(FILL)
	local ws_pan = vgui.Create("EditablePanel",scroll)
	local svn_pan = vgui.Create("EditablePanel",scroll)
	
	sheet:AddSheet("Workshop",ws_pan,"icon16/wrench_orange.png")
	sheet:AddSheet("SVN",svn_pan,"icon16/folder_user.png")

	for k,v in pairs(fb_addons_list.workshop) do
		local addon_panel = vgui.Create("DPanel",ws_pan)
		addon_panel:Dock(TOP)
		addon_panel:DockMargin(0,5,0,0)
		addon_panel:SetTall(100)

		local addon_name = vgui.Create("DLabel",addon_panel)
		addon_name:SetPos(5,5)
		addon_name:SetText(v.name)
		addon_name:SetFont("DermaLarge")
		addon_name:SetColor(color_black)
		addon_name:SizeToContents()

		local addon_desc = vgui.Create("DLabel",addon_panel)
		addon_desc:SetPos(5,42)
		addon_desc:SetText(v.desc)
		addon_desc:SetFont("DermaDefault")
		addon_desc:SetColor(color_black)
		addon_desc:SizeToContents()

		local addon_subscribe = vgui.Create("DButton",addon_panel)
		addon_subscribe:Dock(BOTTOM)
		addon_subscribe:DockMargin(5,5,5,5)
		if steamworks.IsSubscribed(v.id) then
			addon_subscribe:SetText("Subscribed")
			addon_subscribe:SetDisabled(true)
		elseif v.collection then
			addon_subscribe:SetText("Show Collection")
			addon_subscribe:SetDisabled(false)
		else
			addon_subscribe:SetText("Subscribe")
			addon_subscribe:SetDisabled(false)
		end

		function addon_subscribe:DoClick()
			if steamworks.IsSubscribed(v.id) then return end
			gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id="..v.id)
		end
	end

	for k,v in pairs(fb_addons_list.svn) do
		local addon_panel = vgui.Create("DPanel",svn_pan)
		addon_panel:Dock(TOP)
		addon_panel:DockMargin(0,5,0,0)
		addon_panel:SetTall(100)

		local addon_name = vgui.Create("DLabel",addon_panel)
		addon_name:SetPos(5,5)
		addon_name:SetText(v.name)
		addon_name:SetFont("DermaLarge")
		addon_name:SetColor(color_black)
		addon_name:SizeToContents()

		local addon_desc = vgui.Create("DLabel",addon_panel)
		addon_desc:SetPos(5,42)
		addon_desc:SetText(v.desc)
		addon_desc:SetFont("DermaDefault")
		addon_desc:SetColor(color_black)
		addon_desc:SizeToContents()

		local addon_url = vgui.Create("DTextEntry",addon_panel)
		addon_url:Dock(BOTTOM)
		addon_url:DockMargin(5,5,5,5)
		addon_url:AllowInput(false)
		addon_url:SetValue(v.url)
	end

	return scroll

end, "icon16/plugin.png", 250 )
