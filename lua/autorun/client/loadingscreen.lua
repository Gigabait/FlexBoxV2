local function LSOptions(panel)
	local c_en = vgui.Create("DCheckBoxLabel",panel)
	c_en:DockMargin(5,5,0,0)
	c_en:SetText("Enable music on loading screen")
	c_en:SetValue(1)
	
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
