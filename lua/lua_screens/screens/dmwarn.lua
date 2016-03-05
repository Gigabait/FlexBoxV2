ENT.Width	=	128
ENT.Height	=	48
ENT.Scale	=	0.3
ENT.debug	=	true

if SERVER then return end
function SCREEN:create( ent )end

surface.CreateFont("fboxdm_screen_2x",{
	font = "Roboto Medium",
	size = 96,
})
surface.CreateFont("fboxdm_screen_big",{
	font = "Roboto Medium",
	size = 48,
})
surface.CreateFont("fboxdm_screen_small",{
	font = "Roboto",
	size = 36,
})

function ENT:Draw3D2D(w,h)
	draw.RoundedBox(0,0,0,w,h,Color(50,25,25))
	draw.OutlinedBox(0,0,w,h,4,Color(100,50,50))
	draw.DrawText("WARNING!","fboxdm_screen_big",w/2,10,Color(200,100,100),TEXT_ALIGN_CENTER)
	draw.DrawText("Deathmatch area next right","fboxdm_screen_small",w/2,50,Color(200,100,100),TEXT_ALIGN_CENTER)
	draw.DrawText("\xe2\x87\xa8","fboxdm_screen_2x",w/2,60,Color(200,100,100),TEXT_ALIGN_CENTER)
end
