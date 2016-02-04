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
	cam.Start2D()
		local pos = node:ToScreen()
		if LocalPlayer():EyePos():Distance(node) <= 750 then
			draw.DrawText("Vector("..node.x..","..node.y..","..node.z..")","BudgetLabel",pos.x,pos.y,color,TEXT_ALIGN_CENTER)
			if t == NODE_SIT then
				draw.DrawText("Angle("..node.x..","..node.y..","..node.z..")","BudgetLabel",pos.x,pos.y-10,color,TEXT_ALIGN_CENTER)
			end
			draw.DrawText("Type: "..t_str,"BudgetLabel",pos.x,t == NODE_SIT and pos.y-20 or pos.y-10,color,TEXT_ALIGN_CENTER)
			draw.DrawText("NPC: "..(n == 1 and "Citizen" or "Metrocop"),"BudgetLabel",pos.x,t == NODE_SIT and pos.y-30 or pos.y-20,color,TEXT_ALIGN_CENTER)
		end
	cam.End2D()

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
	for _,tbl in pairs(FBoxMapData[game.GetMap()].metrocops.sittable) do
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