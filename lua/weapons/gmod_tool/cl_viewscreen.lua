local matScreen 	= Material( "models/weapons/v_toolgun/screen" )
local txidScreen	= surface.GetTextureID( "models/weapons/v_toolgun/screen" )
local txRotating	= surface.GetTextureID( "pp/fb" )

local txBackground	= surface.GetTextureID( "vgui/alpha-back" )

local over	= surface.GetTextureID( "vgui/screens/vgui_overlay" )
local gmod_toolmode = GetConVar("gmod_toolmode")

-- GetRenderTarget returns the texture if it exists, or creates it if it doesn't
local RTTexture 	= GetRenderTarget( "GModToolgunScreen", 256, 256 )
local surface=surface
local render=render
local cam=cam


surface.CreateFont( "GModToolScreen",
{
	font		= "Courier New",
	size		= 50,
})

surface.CreateFont( "GModToolConsole",
{
	font		= "Courier New",
	size		= 20,
})

local function DrawScrollingText( text, y, texwide )

		local w, h = surface.GetTextSize( text  )
		w = w + 64

		local x = math.fmod( RealTime() * 255, w ) * -1;

		while ( x < texwide ) do

			surface.SetTextColor( 0,0,0, 255 )
			surface.SetTextPos( x, y )
			surface.DrawText( text )

			x = x + w

		end

end

--[[---------------------------------------------------------
	We use this opportunity to draw to the toolmode
		screen's rendertarget texture.
-----------------------------------------------------------]]

local lastcur=0
local lastreal=0
local diffchange=0
function SWEP:RenderScreen()

	local real=RealTime()
	local cur = CurTime()
	local diffcur=math.abs(cur-lastcur)
	local diffreal=math.abs(real-lastreal)
	local diffcurreal=math.abs(diffcur-diffreal)
	if lastcur~=0 then
		diffchange=diffchange*0.95+diffcurreal*0.05
		diffchange=diffchange>0.1 and 0.1 or diffchange
	end
	lastcur = cur
	lastreal = real

	local TEX_SIZE = 256
	local mode 	= gmod_toolmode:GetString()
	local NewRT = RTTexture
	local oldW = ScrW()
	local oldH = ScrH()

	-- Set the material of the screen to our render target
	matScreen:SetTexture( "$basetexture", NewRT )

	local OldRT = render.GetRenderTarget();

	-- Set up our view for drawing to the texture
	render.SetRenderTarget( NewRT )
	render.SetViewPort( 0, 0, TEX_SIZE, TEX_SIZE )
	cam.Start2D()

		-- Background
		render.Clear(0,0,0,200,false,false)

		-- Give our toolmode the opportunity to override the drawing
		if ( self:GetToolObject() && self:GetToolObject().DrawToolScreen ) then

			self:GetToolObject():DrawToolScreen( TEX_SIZE, TEX_SIZE )

		else


			-- x and y coords


			local ea = LocalPlayer():EyeAngles()
			local yaw=-ea.y/180*math.pi

			local center = TEX_SIZE * 0.5
			local sz = TEX_SIZE*0.2
			local xx,xy=center+math.sin(yaw+math.pi)*sz, center + math.cos(yaw+math.pi)*sz
			local yx,yy=center+math.sin(yaw-math.pi*0.5)*sz,center + math.cos(yaw-math.pi*0.5)*sz

			surface.SetDrawColor( 200,100,0, 255 )
			surface.DrawLine(center,center,xx,xy)
			surface.DrawLine(center,center,yx,yy)


			surface.SetFont( "GModToolConsole" )
			surface.SetTextColor( 200,100,0, 255 )
			surface.SetTextPos(xx,xy)
			surface.DrawText'+x'
			surface.SetTextPos(yx,yy)
			surface.DrawText'+y'

			local tr = util.TraceLine( {
				start = LocalPlayer():EyePos(),
				endpos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 10000,
			} )

			surface.SetTextPos(4,TEX_SIZE-52)
			surface.DrawText("trace: "..math.Round(tr.HitPos.x)..","..math.Round(tr.HitPos.y)..","..math.Round(tr.HitPos.z))

			local blink = {">_",">"}
			surface.SetTextPos(4,TEX_SIZE-28)
			surface.DrawText(">_")

			local rainbow = HSVToColor(RealTime()*10%360,0.5,0.5)
			surface.SetDrawColor(200,100,0)
			surface.DrawRect(0,0,TEX_SIZE,60)

			surface.SetFont( "GModToolScreen" )
			DrawScrollingText( "#tool."..mode..".name", 4, TEX_SIZE )
		end




	cam.End2D()
	render.SetRenderTarget( OldRT )
	render.SetViewPort( 0, 0, oldW, oldH )

end
