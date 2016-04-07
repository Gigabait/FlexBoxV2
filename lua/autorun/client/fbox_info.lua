local PANEL = {}

surface.CreateFont("fbox_info_title",{
	font = "Roboto",
	size = 36,
})

local tabs = {
	{
		icon = "icon16/information.png",
		text = "Info",
	},
	{
		icon = "icon16/plugin.png",
		text = "Addons",
	},
	{
		icon = "icon16/gun.png",
		text = "Deathmatch",
	},
	{
		icon = "icon16/cart.png",
		text = "Shop",
	},
}

local addons = {
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

function PANEL:Init()
	self:SetSkin("Default")
	self:SetSize(ScrW()-200,ScrH()-200)
	self:Center()
	self:SetTitle("FlexBox Info")
	self:SetIcon("icon16/page_white.png")
	self:MakePopup()

	self.sidebar = vgui.Create("EditablePanel",self)
	self.sidebar:Dock(LEFT)
	self.sidebar:DockMargin(-4,-4,0,-4)
	self.sidebar:SetWide(200)

	function self.sidebar:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(60,60,60))
	end

	self.sidebar_tabs = {}

	for _,btn in ipairs(tabs) do
		self.sidebar_tabs[btn.text] = vgui.Create("DButton",self.sidebar)
		self.sidebar_tabs[btn.text]:Dock(TOP)
		self.sidebar_tabs[btn.text]:SetTall(40)
		self.sidebar_tabs[btn.text]:SetText(btn.text)
		self.sidebar_tabs[btn.text]:SetTextColor(Color(255,255,255))
		self.sidebar_tabs[btn.text]:SetIcon(btn.icon)
		self.sidebar_tabs[btn.text].btncol = Color(60,60,60)

		self.sidebar_tabs[btn.text].Paint = function(s,w,h)
			if s.Hovered then s.btncol = Color(90,90,90) else s.btncol = Color(60,60,60) end
			draw.RoundedBox(0,0,0,w,h,s.btncol)
			draw.RoundedBox(0,0,h-1,w,1,Color(90,90,90))
		end

		self.sidebar_tabs[btn.text].DoClick = function(s)
			if not IsValid(self.title_lbl) or not IsValid(self.content[btn.text]) then return end
			self.title_lbl:SetText(btn.text)
			if self.ActivePanel then
				self.ActivePanel:SetVisible(false)
			end
			self.content[btn.text]:SetVisible(true)
			self.ActivePanel = self.content[btn.text]
		end
	end

	----

	self.title = vgui.Create("EditablePanel",self)
	self.title:Dock(TOP)
	self.title:DockMargin(0,-4,-4,0)
	self.title:SetTall(64)

	function self.title:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,150,130))
	end

	self.title_lbl = vgui.Create("DLabel",self.title)
	self.title_lbl:Dock(LEFT)
	self.title_lbl:DockMargin(10,10,0,10)
	self.title_lbl:SetText("Choose a category")
	self.title_lbl:SetTextColor(Color(255,255,255))
	self.title_lbl:SetFont("fbox_info_title")
	self.title_lbl:SizeToContents()

	self.cscrl = vgui.Create("DScrollPanel",self)
	self.cscrl:SetPos(200,89)
	self.cscrl:SetSize(ScrW()-200-200,ScrH()-200-89)

	self.content = {}
	for _,pnl in ipairs(tabs) do
		self.content[pnl.text] = vgui.Create("EditablePanel",self)
		self.content[pnl.text]:SetSize(self.cscrl:GetSize())
		self.content[pnl.text]:SetVisible(false)
		self.cscrl:AddItem(self.content[pnl.text])
	end
	--info
	--addons
	local tabs = vgui.Create("DPropertySheet",self.content["Addons"])
	local ws_pan = vgui.Create("EditablePanel",tabs)
	local svn_pan = vgui.Create("EditablePanel",tabs)

	tabs:AddSheet("Workshop",ws_pan,"games/16/all.png")
	tabs:AddSheet("SVN",svn_pan,"icon16/folder_user.png")
	tabs:Dock(FILL)

	for k,v in pairs(addons.workshop) do
		local addon_panel = vgui.Create("DPanel",ws_pan)
		addon_panel:Dock(TOP)
		addon_panel:DockMargin(4,0,4,4)
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
			addon_subscribe:SetText("Download")
			addon_subscribe:SetDisabled(false)
		end

		function addon_subscribe:DoClick()
			if steamworks.IsSubscribed(v.id) then return end
			if not v.collection then
				steamworks.FileInfo(v.id,function(result)
					LocalPlayer():PrintMessage(3,"Downloading "..result.title.." ("..result.id..")")
					steamworks.Download(result.previewid,true,function(name)
						game.MountGMA(name)
						LocalPlayer():PrintMessage(3,"Mounted")
					end)
				end)
			else
			end
		end
	end

	for k,v in pairs(addons.svn) do
		local addon_panel = vgui.Create("DPanel",svn_pan)
		addon_panel:Dock(TOP)
		addon_panel:DockMargin(4,0,4,4)
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

	ws_pan:Dock(FILL)
	svn_pan:Dock(FILL)

	--dm
	local a = vgui.Create("DLabel",self.content["Deathmatch"])
	a:Dock(TOP)
	a:DockMargin(4,4,0,0)
	a:SetText("Coming soon!")
	a:SetTextColor(Color(0,0,0))
	a:SetFont("fbox_info_title")
	a:SizeToContents()

	--shop
	local a = vgui.Create("DLabel",self.content["Shop"])
	a:Dock(TOP)
	a:DockMargin(4,4,0,0)
	a:SetText("Coming soon!")
	a:SetTextColor(Color(0,0,0))
	a:SetFont("fbox_info_title")
	a:SizeToContents()
end

vgui.Register("fbox_info",PANEL,"DFrame")

local key = "gm_showteam"
local function translatekey(onlykey) --thanks scap
	local a = input.LookupBinding(key)
	if a and onlykey then return key end
end

local function bindhook(ply,bind,pressed)
	if not pressed or bind~=translatekey(true) then return end
	return vgui.Create("fbox_info")
end

hook.Add("PlayerBindPress","fbox_info",bindhook)
hook.Add("PlayerSay","fbox_info",function(ply,txt)
	if txt:match("^!help") then
		vgui.Create("fbox_info")
		return ""
	end
end)
