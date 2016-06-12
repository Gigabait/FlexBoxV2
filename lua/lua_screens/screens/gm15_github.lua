ENT.Width	=	192
ENT.Height	=	96
ENT.Scale	=	0.3

if SERVER then return end
function SCREEN:create( ent )end

local displayscreen = {
	{x=8*3.3,y=0},
	{x=192*3.3,y=0},
	{x=192*3.3,y=88*3.35},
	{x=184*3.3,y=96*3.35},
	{x=0,y=96*3.35},
	{x=0,y=8*3.35},
}

ENT.commitdata = ENT.commitdata or {
	["B1IS/FlexBoxV2"] = {},
	["B1IS/moddedbox"] = {},
	["LUModder/FWP"] = {},
}

local commitdata = ENT.commitdata

local repos = {
	"B1IS/FlexBoxV2",
	"B1IS/moddedbox",
	"LUModder/FWP",
}

function ENT:FetchCommitData()
	for _,repo in pairs(repos) do
		http.Fetch("https://api.github.com/repos/"..repo.."/commits",
		function(data)
			local c = util.JSONToTable(data)[1]
			commitdata[repo] = c
			self.fetched = true
			timer.Simple(150,function() self.fetched = false end)
		end,
		function(e)
			--do nothing
			self.fetched = false
		end)
	end
end

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
		{x=8*3.3,y=0,u=0,v=0},
		{x=192*3.3,y=0,u=(pos+(pos%128))/128,v=0},
		{x=192*3.3,y=32,u=(pos+(pos%128))/128,v=1},
		{x=0,y=32,u=0,v=0},
		{x=0,y=8*3.35},
	}

	surface.SetTexture( stripes )
	surface.SetDrawColor(pr,pg,pb)
	--surface.DrawTexturedRectUV((pos%128),0,pos+(pos%128),32, 0,0,(pos+(pos%128))/128,1 )
	surface.DrawPoly(stripebox)
	draw.DrawText("Updates","fbox_screen_32",192*3.3/2,0,Color(255,255,255),TEXT_ALIGN_CENTER)

	self:ShouldLoad()

	if self.fetched then
		surface.SetFont("fbox_screen_32")
		draw.DrawText("FlexBox:","fbox_screen_32",20,40,Color(255,255,255))
		draw.DrawText("\tCommit ","fbox_screen_32",20,70,color_plycolor)
		draw.DrawText(string.sub(commitdata["B1IS/FlexBoxV2"].sha,0,6),"fbox_screen_32",surface.GetTextSize("\tCommit ")+20,70,Color(220,70,100))
		draw.DrawText(" by ","fbox_screen_32",surface.GetTextSize("\tCommit "..string.sub(commitdata["B1IS/FlexBoxV2"].sha,0,6))+20,70,color_plycolor)
		draw.DrawText(commitdata["B1IS/FlexBoxV2"].commit.author.name,"fbox_screen_32",surface.GetTextSize("\tCommit "..string.sub(commitdata["B1IS/FlexBoxV2"].sha,0,6).." by ")+20,70,Color(220,70,100))
		draw.DrawText("\t\t"..commitdata["B1IS/FlexBoxV2"].commit.message:gsub("\n"," "),"fbox_screen_14",20,100,Color(255,255,255))

		draw.DrawText("ModdedBox:","fbox_screen_32",20,120,Color(255,255,255))
		draw.DrawText("\tCommit ","fbox_screen_32",20,150,color_plycolor)
		draw.DrawText(string.sub(commitdata["B1IS/moddedbox"].sha,0,6),"fbox_screen_32",surface.GetTextSize("\tCommit ")+20,150,Color(220,70,100))
		draw.DrawText(" by ","fbox_screen_32",surface.GetTextSize("\tCommit "..string.sub(commitdata["B1IS/moddedbox"].sha,0,6))+20,150,color_plycolor)
		draw.DrawText(commitdata["B1IS/moddedbox"].commit.author.name,"fbox_screen_32",surface.GetTextSize("\tCommit "..string.sub(commitdata["B1IS/moddedbox"].sha,0,6).." by ")+20,150,Color(220,70,100))
		draw.DrawText("\t\t"..commitdata["B1IS/moddedbox"].commit.message:gsub("\n"," "),"fbox_screen_14",20,180,Color(255,255,255))

		draw.DrawText("FWP:","fbox_screen_32",20,200,Color(255,255,255))
		draw.DrawText("\tCommit ","fbox_screen_32",20,230,color_plycolor)
		draw.DrawText(string.sub(commitdata["LUModder/FWP"].sha,0,6),"fbox_screen_32",surface.GetTextSize("\tCommit ")+20,230,Color(220,70,100))
		draw.DrawText(" by ","fbox_screen_32",surface.GetTextSize("\tCommit "..string.sub(commitdata["LUModder/FWP"].sha,0,6))+20,230,color_plycolor)
		draw.DrawText(commitdata["LUModder/FWP"].commit.author.name,"fbox_screen_32",surface.GetTextSize("\tCommit "..string.sub(commitdata["LUModder/FWP"].sha,0,6).." by ")+20,230,Color(220,70,100))
		draw.DrawText("\t\t"..commitdata["LUModder/FWP"].commit.message:gsub("\n"," "),"fbox_screen_14",20,260,Color(255,255,255))
	end
end

function ENT:ShouldLoad()
	if not self.targeted then self.lookedaway=true return false end

	if self.lookedaway then
		self.lookedaway=false

		if self.fetched then return end
		self:FetchCommitData()
	end
end