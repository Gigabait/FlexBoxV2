ENT.Width	=	96
ENT.Height	=	48
ENT.Scale	=	0.3
ENT.debug	=	true

if SERVER then return end
function SCREEN:create( ent )end

surface.CreateFont("fbox_clock_small",{
	font = "Roboto Medium",
	size = 32,
})

surface.CreateFont("fbox_clock",{
	font = "Roboto Medium",
	size = 64,
})

function ENT:Draw3D2D(w,h)
	local time = os.date("%H:%m")
	local t_exp = string.Explode("",time)
	draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
	draw.RoundedBox(0,20,30,w-40,h-60,Color(0,80,70))
	draw.OutlinedBox(0,0,w,h,4,Color(0,150,130))
	draw.SimpleTextOutlined("The time is","fbox_clock_small",w/2,2,Color(0,150,130),TEXT_ALIGN_CENTER,nil,1,Color(0,0,0))
	draw.SimpleTextOutlined(t_exp[1],"fbox_clock",w/2-64,40+math.sin(RealTime()*5)*10,Color(0,150,130),TEXT_ALIGN_CENTER,nil,1,Color(0,0,0))
	draw.SimpleTextOutlined(t_exp[2],"fbox_clock",w/2-32,40+math.sin(RealTime()*5)*-10,Color(0,150,130),TEXT_ALIGN_CENTER,nil,1,Color(0,0,0))
	draw.SimpleTextOutlined(t_exp[3],"fbox_clock",w/2,40+math.sin(RealTime()*2)*10,Color(0,150,130),TEXT_ALIGN_CENTER,nil,1,Color(0,0,0))
	draw.SimpleTextOutlined(t_exp[4],"fbox_clock",w/2+32,40+math.sin(RealTime()*5)*-10,Color(0,150,130),TEXT_ALIGN_CENTER,nil,1,Color(0,0,0))
	draw.SimpleTextOutlined(t_exp[5],"fbox_clock",w/2+64,40+math.sin(RealTime()*5)*10,Color(0,150,130),TEXT_ALIGN_CENTER,nil,1,Color(0,0,0))
end