function draw.OutlinedBox(x,y,w,h,thick,col)
	surface.SetDrawColor(col)
	for i=0, thick - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

function draw.OutlinedBoxFilled( x, y, w, h, thickness, clr, fillclr )
	surface.SetDrawColor( fillclr )
	surface.DrawRect(x,y,w,h)
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end



ENT.Width	=	256
ENT.Height 	=	128
ENT.Scale	=	0.3
ENT.debug	=	true

if SERVER then return end
function SCREEN:create( ent )end

function ENT:Draw3D2D(w,h)
	local x = math.Round(LocalPlayer():GetPlayerColor().x*255)
	local y = math.Round(LocalPlayer():GetPlayerColor().y*255)
	local z = math.Round(LocalPlayer():GetPlayerColor().z*255)
	
	local color_plycolor = Color(x,y,z)
	
	surface.SetDrawColor (0, 0, 0, 200)
	surface.DrawRect (0, 0, w, h)
	draw.OutlinedBox(0,0,w,h,7,color_white)
	
	surface.SetDrawColor(color_white)
	surface.DrawRect(0,(12)-14/2,w,14)
	
	surface.SetDrawColor(Color(x,y,z))
	surface.DrawRect(0,(10)-10/2,w,12)
	
	draw.DrawText("Hello "..UndecorateNick(LocalPlayer():GetName())..", Welcome to FlexBox","DermaLarge",w/2,h/10,color_plycolor,TEXT_ALIGN_CENTER)
	draw.DrawText("There are "..tostring(#player.GetAll()).." players online","DermaLarge",w/2,h/6.5,color_plycolor,TEXT_ALIGN_CENTER)
	
	draw.OutlinedBoxFilled((w/10),(h/4),w/1.25,h/1.6,5,color_plycolor,Color(x,y,z,50))
	surface.SetDrawColor(color_plycolor)
	surface.DrawRect((w/2)-50,(h/4),100,33)
	draw.DrawText("[RULES]","DermaLarge",w/2,h/4,Color(128,128,128),TEXT_ALIGN_CENTER)
	
	draw.DrawText("1. Don't be a dick","DermaLarge",w/9,h/3.5,Color(255,255,255),TEXT_ALIGN_LEFT)
	draw.DrawText("2. No prop spamming","DermaLarge",w/9,h/2.8,Color(255,255,255),TEXT_ALIGN_LEFT)
	draw.DrawText("3. No laggy dupes","DermaLarge",w/9,h/2.3,Color(255,255,255),TEXT_ALIGN_LEFT)
	draw.DrawText("4. No INTENTIONAL server crashing","DermaLarge",w/9,h/1.95,Color(255,255,255),TEXT_ALIGN_LEFT)
	
	
	draw.DrawText("Managed by Flex and KaosHeaven. Hosted by Sauermon","DermaLarge",w/2,h/1.15,color_plycolor,TEXT_ALIGN_CENTER)
	draw.OutlinedBox(0,0,w,h,5,Color(x,y,z))
end
