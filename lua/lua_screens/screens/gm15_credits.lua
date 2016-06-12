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
	draw.DrawText("Credits","fbox_screen_32",192*3.3/2,0,Color(255,255,255),TEXT_ALIGN_CENTER)

	draw.DrawText("Meta Construct:","fbox_screen_32",10,40,Color(255,255,255))
	draw.DrawText("\t90% of the content used on this server.","fbox_screen_14",10,70,Color(255,255,255))
	draw.DrawText("Sauermon:","fbox_screen_32",10,80,Color(255,255,255))
	draw.DrawText("\tHosting this server for free.","fbox_screen_14",10,110,Color(255,255,255))
	draw.DrawText("Flex:","fbox_screen_32",10,120,Color(255,255,255))
	draw.DrawText("\tHaving this server live as long as it has.","fbox_screen_14",10,150,Color(255,255,255))
	draw.DrawText("VanderAGSN:","fbox_screen_32",10,160,Color(255,255,255))
	draw.DrawText("\tThis great huge map.","fbox_screen_14",10,190,Color(255,255,255))
end