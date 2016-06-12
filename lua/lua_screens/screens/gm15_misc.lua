ENT.Width	=	192
ENT.Height	=	96
ENT.Scale	=	0.3

if SERVER then return end
function SCREEN:create( ent )end

local displayscreen = {
	{x=0,y=0},
	{x=0,y=88*3.35},
	{x=184*3.3,y=0},
	{x=192*3.3,y=14*3.35},
	{x=192*3.3,y=96*3.35},
	{x=12*3.3,y=96*3.35},
	{x=0*3.3,y=84*3.35},
}

local stripes = surface.GetTextureID("vgui/alpha-back")

surface.CreateFont("fbox_screen_14",{
	font = "Roboto",
	size = 14,
})

surface.CreateFont("fbox_screen_32",{
	font = "Roboto",
	size = 32,
})

local icons = {
	["players"]    = Material("icon16/user.png"),
	["respected"]  = Material("icon16/user_add.png"),
	["moderators"] = Material("icon16/group.png"),
	["admins"]     = Material("icon16/group_add.png"),
	["developers"] = Material("icon16/script_code.png"),
	["sysadmins"]  = Material("icon16/server.png"),
	["owners"]     = Material("icon16/server_key.png"),

	--misc
	["ping"]     = Material("icon16/transmit_blue.png"),
	["ping_bad"] = Material("icon16/transmit.png"),
}

function ENT:Draw3D2D(w,h)
	local pr = math.Round(LocalPlayer():GetPlayerColor().x*255)
	local pg = math.Round(LocalPlayer():GetPlayerColor().y*255)
	local pb = math.Round(LocalPlayer():GetPlayerColor().z*255)

	local color_plycolor = Color(pr,pg,pb)

	surface.SetDrawColor(Color(30,30,30))
	draw.NoTexture()
	surface.DrawPoly(displayscreen)

	local pos = w

	local stripebox = {
		{x=0,y=0,u=(pos+(pos%128))/128,v=-1},
		{x=184*3.3,y=0},
		{x=192*3.3,y=32},
		{x=0,y=32,u=(pos+(pos%128))/128,v=0},
	}

	surface.SetTexture(stripes)
	surface.SetDrawColor(pr,pg,pb)
	--surface.DrawTexturedRectUV((pos%128),0,pos+(pos%128),32, 0,0,(pos+(pos%128))/128,1 )
	surface.DrawPoly(stripebox)
	draw.DrawText("Players","fbox_screen_32",192*3.3/2,0,Color(255,255,255),TEXT_ALIGN_CENTER)

	local x,y = 10,40
	for _,pl in next,player.GetAll() do
		local name_noc = pl:GetName()
		name_noc = string.gsub(name_noc,"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
		name_noc = string.gsub(name_noc,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
		name_noc = string.gsub(name_noc,"%^(%d+%.?%d*)","")

		draw.RoundedBox(4,x,y,w-40,24,team.GetColor(pl:Team()))
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(icons[pl:GetUserGroup()])
		surface.DrawTexturedRect(x+4,y+4,16,16)
		draw.DrawText(name_noc,"fbox_screen_14",x+24,y+5,Color(255,255,255))

		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(pl:Ping() > 200 and icons["ping_bad"] or icons["ping"])
		surface.DrawTexturedRect(w-40-52,y+4,16,16)
		draw.DrawText(pl:Ping() == 0 and "BOT" or pl:Ping(),"fbox_screen_14",w-40-32,y+5,Color(255,255,255))
		y = y+28
	end
end