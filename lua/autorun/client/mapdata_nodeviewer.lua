local ShowNodes = CreateClientConVar("fboxmapdata_shownodes",0,false)

local NODE_WALK = 0
local NODE_SIT = 1
local NODE_SPAWN = 2
local NPC_METRO = 0
local NPC_CITIZEN = 1

local NodeColor = {
	[0] = Color(0,255,255),
	[1] = Color(255,0,255),
	[2] = Color(255,255,0),
}

local function MapNode(node,type,npc)
	local t = type or 0
	local t_str
	if t == 0 then t_str = "Walk" elseif t == 1 then t_str = "Sit" elseif t == 2 then t_str = "Spawn" else t_str = "Unknown type!?!?!" end
	local n = npc or 1
	local color = NodeColor[t]
	local lookatme = EyeAngles()
	lookatme:RotateAroundAxis(lookatme:Right(),90)
	lookatme:RotateAroundAxis(lookatme:Up(),-90)
	cam.Start3D2D(node+Vector(0,0,30),lookatme,0.5)
		draw.DrawText("Vector("..node.x..","..node.y..","..node.z..")","BudgetLabel",0,0,color,TEXT_ALIGN_CENTER)
		draw.DrawText("Type: "..t_str,"BudgetLabel",0,-10,color,TEXT_ALIGN_CENTER)
		draw.DrawText("NPC: "..(n == 1 and "Citizen" or "Metrocop"),"BudgetLabel",0,-20,color,TEXT_ALIGN_CENTER)
	cam.End3D2D()

	render.SetColorModulation(color.r/255,color.g/255,color.b/255)
	local node_mdl = ClientsideModel("models/hunter/blocks/cube05x05x05.mdl",RENDERGROUP_OTHER)
	node_mdl:SetPos(node)
	node_mdl:SetMaterial("models/wireframe")
	node_mdl:DrawModel()
	node_mdl:Remove()
end

hook.Add("PostDrawOpaqueRenderables","FBoxMapData.DrawNodes",function()
	if !ShowNodes:GetBool() then return end
	for _,node in pairs(FBoxMapData[game.GetMap()].metrocops.walktable) do
		MapNode(node,NODE_WALK,NPC_METRO)
	end
	for _,tbl in pairs(FBoxMapData[game.GetMap()].wanderer.sittable) do
		MapNode(tbl[1],NODE_SIT,NPC_METRO)
	end
	for _,node in pairs(FBoxMapData[game.GetMap()].metrocops.spawns) do
		MapNode(node,NODE_SPAWN,NPC_METRO)
	end

	for _,node in pairs(FBoxMapData[game.GetMap()].wanderer.walktable) do
		MapNode(node,NODE_WALK,NPC_CITIZEN)
	end
	for _,tbl in pairs(FBoxMapData[game.GetMap()].wanderer.sittable) do
		MapNode(tbl[1],NODE_SIT,NPC_CITIZEN)
	end
	for _,node in pairs(FBoxMapData[game.GetMap()].wanderer.spawns) do
		MapNode(node,NODE_SPAWN,NPC_CITIZEN)
	end
end)