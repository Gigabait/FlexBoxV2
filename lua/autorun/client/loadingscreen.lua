local function LSOptions(panel)
	local c_en = vgui.Create("DCheckBoxLabel",panel)
	c_en:Dock(TOP)
	c_en:DockMargin(4,4,0,0)
	c_en:SetText("Enable music on loading screen")
	c_en:SetValue(1)
	
	local  b_wr = vgui.Create("DButton",panel)
	b_wr:Dock(TOP)
	b_wr:DockMargin(4,4,4,0)
	b_wr:SetText("Write Config")
	
end

local function add()
	spawnmenu.AddToolMenuOption( "Options",
	"Loading Screen",
	"Music Loading Screen",
	"Music Loading Screen",
	"",
	"",
	LSOptions)
end

hook.Add( "PopulateToolMenu", "LoadingscreenOptions", add)
