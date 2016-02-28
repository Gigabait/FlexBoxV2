if SERVER then	AddCSLuaFile( "autorun/tool_search.lua" ) return end

local PANEL={}

function PANEL:Init()
	self:SetVisible(false)
	
	local wide=256
	self:SetSize(wide,ScrH()*0.9)
	self:SetPos(ScrW()-wide,ScrH()*0.5-self:GetTall()*0.5)
	self:SetTitle( "Tool Search" )
	self:SetDeleteOnClose( false )
	self:ShowCloseButton( true )
	self:SetDraggable( true )
	self:SetSizable( true )
	self.Used={}
	self.Results={}
	
	local entry = vgui.Create( "DTextEntry", self )
		self.entry=entry
		entry:Dock(TOP)
		entry:SetTall(  24 )
		function entry.OnTextChanged(entry)
			local val=entry:GetText() or ""
			if self.lastval~=val then
				local ok=self:SetSearch(val)
				entry.m_ocolText=entry.m_ocolText or entry.m_colText
				if ok then
					entry.m_colText=entry.m_ocolText
				else
					entry.m_colText=Color(200,130,100,255)
				end
			end
		end
		
		function entry.OnEnter(entry,val)
			
			for k,v in pairs(self.Results) do
				local UniqueID,Tool=v[1],v[2]
				self:UseTool(UniqueID,Tool)
				break
			end
			
			self:Close()

		end
		
	local results= vgui.Create( "DPanelList", self )
		self.results=results
		results:Dock(FILL)
end


function PANEL:CreateButton(UniqueID,Tool)
	

	local pnl=vgui.Create("EditablePanel",self)
	pnl:SetTall(20)
	self.results:AddItem(pnl)
	
	
	
	local 	a=vgui.Create("DLabel",pnl)
			a:SetText(Tool.Category or Tool.Tab or "No Category")
			a:SizeToContents()
			a:SetTall(32)
			a:Dock(RIGHT)
			
	local 	b=vgui.Create("DButton",pnl)
			b:SetContentAlignment( 5 )
			b:SetTextInset( 32,0 )
			b:SetText(Tool.Name or '#'..UniqueID)
			b:SizeToContents()
			b:SetTall(32)
			b:Dock(LEFT)
			b.DoClick=function() self:UseTool(UniqueID,Tool) end
			
end

function PANEL:UseTool(UniqueID,Tool)
	local fixme=function(str)
		-- Hopefully this just means the tool doesn't have control panel
		if str then
			print("Tool Search wtf: ",str)
		end
		
		RunConsoleCommand( "gmod_tool", UniqueID )
	end
	
	if not Tab and not Category then
		fixme() -- Hidden?
	end
	
	
	local Tab, Category = Tool.Tab, Tool.Category
	Category=Category or "New Category"
	
	--PrintTable(Tool)
	
	self.Used[UniqueID]=true
	
	self:ClearList()
	self:Close()
	
	
	local Tabs=spawnmenu.GetTools()
	if not Tabs then return fixme"No tools" end
	
	
	if not Tab then
		Tab=Tabs[1].Name
	end
	
	local TabID
	local Items
	
	for k,v in pairs(Tabs) do
		if v.Name==Tab then
			TabID=k
			Items=v.Items
			break
		end
	end
	if not TabID then return fixme"No TabID" end
	
	local tools
	for k,v in pairs(Items) do
		if v.ItemName==Category then
			tools=v
			break
		end
	end
	
	if not tools then
		
		print("No Category ("..tostring(Tab).."/"..tostring(Category).."), bruteforcing!")
		
		-- BRUTE...FORCE...FFS
		for tid,t in pairs(Tabs) do
			local Items=t.Items
			for k,v in pairs(Items) do
				if type(v)=="table" then
					if v.ItemName==Category then
						tools=v
						TabID=tid
						break
					end
				end
			end
		end
		
	end
		
	if not tools then return fixme("No Category ("..tostring(Tab).."/"..tostring(Category)..")") end
	
	local tool
	for k,v in pairs(tools) do
		if type(v)=="table" and v.ItemName==UniqueID then
			tool=v
			break
		end
	end
	if not tool then return /*fixme"No tool"*/ end
	
	local cp = controlpanel.Get and controlpanel.Get( UniqueID )
	if not cp then return fixme"Ah wtf" end
	
	if ( !cp:GetInitialized() ) then
		cp:FillViaTable{
			ControlPanelBuildFunction		= tool.CPanelFunction,
			CPanelFunction					= tool.CPanelFunction,
			Command							= tool.Command,
			Name							= tool.ItemName,
			Controls						= tool.Controls,
			Text							= tool.Text,
		}
	end
	if spawnmenu.ActivateToolPanel then
		spawnmenu.ActivateToolPanel( TabID, cp )
	else
	 --
	end
	
	if ( tool.Command ) then
		LocalPlayer():ConCommand( tool.Command )
	else
		fixme("No Command?")
	end
	
end


function PANEL:ClearList()
	self.Results={}
	self.results:Clear(true) -- delete
end

local MaxItems=64
function PANEL:GenerateList()

	local Text = ""

	self:InvalidateLayout(true)

	local i = 0

	for id, tbl in pairs( self.Results ) do

		local UniqueID,Tool=tbl[1],tbl[2]
		i = i + 1
		
		self:CreateButton(UniqueID,Tool)

		if i >= MaxItems then break end

	end

end

function PANEL:SetSearch(str)
--	fixme("SetSearch",str)
	self:ClearList()
	
	if str=="" then
		return
	end
			
	local tools = weapons.Get"gmod_tool".Tool

	local strarr = string.Explode( " " , str:lower() )
	
	local Results=self.Results
	local foundany
	for Tool, v in pairs( tools ) do
		local Score=0
		local Name = v.Name and language.GetPhrase(v.Name)
		if Name and Name:find("^#") then
			Name = language.GetPhrase(v.Name:gsub("^#",""))
		end
		Name = Name or language.GetPhrase('#'..Tool)
		
		Name=Name:gsub("#","")
		local Category = v.Category
		
		for _, c in pairs( strarr ) do
			if Tool:lower():find(c,1,true) then
				Score=Score+1
			end
			
			if Name:lower():find(c,1,true) then
				Score=Score+1
				if Name:find(c,1,true) then
					Score=Score+1
				end
			end
			
			if Category and Category:lower():find(c,1,true) then
				Score=Score+1
			end
			if Tool:lower()==c then
				Score=Score+2
			end
			if Name:lower()==c then
				Score=Score+2
			end
			if Category and Category:lower()==c then
				Score=Score+2
			end
			
		end
		
		-- todo: sort
		
		if Score>0 then
			local Used
			if self.Used[Tool] then
				Score=Score+1
				Used=true
			end
			foundany=true
			table.insert(Results,{Tool,v,Score,Used})
		end
	end
	if not foundany and str~="" then return false end
	table.sort(Results,function(a,b) return a[3]>b[3] end)
	self:GenerateList()
	return true
end



------ showhide logics below -------


function PANEL:Show()
	if not self:IsVisible() then
		self:SetVisible(true)
		self:MakePopup()
		self:SetKeyboardInputEnabled( true )
		self:SetMouseInputEnabled( true )
	end
	if ValidPanel(self.entry) then
		self.entry:RequestFocus()
		self.entry:SetText("")
	end
	self.movemouse=true
	--hook.Run("OnContextMenuOpen")
end

function PANEL:Think(w,h)
	self.BaseClass.Think(self,w,h)
	if input.IsKeyDown(KEY_ESCAPE) then self:Close() end
	if self.movemouse then
		local x,y=self:LocalToScreen( )
		if x==0 or y==0 then return end -- need to wait one hacky frame
		self.movemouse=false
		local x,y=x+self:GetWide()*0.5,y+32
	
		gui.SetMousePos( x,y )
	end
end

function PANEL:Close()
	self:SetVisible(false)
	--hook.Run("OnContextMenuClose")
end

local Ctool_search_panel = vgui.RegisterTable(PANEL,"DFrame")


local tool_search_panel

function HidePanel()

	tool_search_panel:Close()

end

local function ShowPanel()

	if not ValidPanel(tool_search_panel) then
		tool_search_panel=vgui.CreateFromTable(Ctool_search_panel)
		_G.p=tool_search_panel
	end
	
	tool_search_panel:Show()
	
end

concommand.Add( "tool_search", ShowPanel )

hook.Add("PlayerBindPress","tool_search",function(a,b,c)
	if b=="impulse 101" and GetConVarNumber"sv_cheats"==0 and c and not hook.GetTable().PlayerBindPress.wire_keyboard_blockinput then
		ShowPanel()
	end
end)