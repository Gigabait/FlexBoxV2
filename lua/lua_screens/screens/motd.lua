function draw.OutlinedBox(x,y,w,h,thick,col)
	surface.SetDrawColor(col)
	for i=0, thick - 1 do
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
	draw.OutlinedBox(0,0,w,h,4,Color(0,150,130))
	draw.RoundedBox(0,4,4,w-8,h-8,Color(0,0,0,200))
	draw.DrawText("Welcome to FlexBox","DermaLarge",w/2+math.sin(RealTime()*2)*w/4,20+math.sin(RealTime()*5)*10,HSVToColor(RealTime()*50%360,1,1),TEXT_ALIGN_CENTER)
	draw.DrawText("==Rules==","DermaLarge",w/2,50,Color(100,200,100),TEXT_ALIGN_CENTER)
	draw.DrawText("1. Don't be a dick","DermaLarge",20,80,Color(255,255,255),TEXT_ALIGN_LEFT)
	draw.DrawText("2. No prop spamming","DermaLarge",20,110,Color(255,255,255),TEXT_ALIGN_LEFT)
	draw.DrawText("3. No laggy dupes","DermaLarge",20,140,Color(255,255,255),TEXT_ALIGN_LEFT)
	draw.DrawText("4. No INTENTIONAL server crashing","DermaLarge",20,170,Color(255,255,255),TEXT_ALIGN_LEFT)
	draw.DrawText("Server managed by Flex and KaosHeaven, hosted by Sauermon","DermaLarge",w/2+math.sin(RealTime()*2)*w/12,h-50+math.sin(RealTime()*5)*-10,Color(0,150,130),TEXT_ALIGN_CENTER)
end
