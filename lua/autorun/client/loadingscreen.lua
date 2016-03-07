local function LSOptions(panel)

	local check_hud = vgui.Create("DCheckBoxLabel",panel)
	check_hud:DockMargin(5,5,0,0)
	check_hud:SetText("Enabled?")
	check_hud:SetValue(1)
	check_hud:SetConVar("fhud_enabled")
	check_hud:SetTextColor(Color(0,0,0))
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
