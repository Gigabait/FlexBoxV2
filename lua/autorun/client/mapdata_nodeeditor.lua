local icons = {
	frame = "icon16/tag_blue_edit.png",
	node_walk = "icon16/tag_blue.png",
	node_sit = "icon16/tag_pink.png",
	node_spawn = "icon16/tag_yellow.png",
	citizen = "spawnicons/models/Humans/Group02/male_02.png",
	metrocop = "spawnicons/models/Police.png",
}

local NODE_WALK = 0
local NODE_SIT = 1
local NODE_SPAWN = 2
local NPC_METRO = 0
local NPC_CITIZEN = 1

local function NodeEditor(ply,cmd,args)
	local totalnodes = #FBoxMapData[game.GetMap()].metrocops.walktable + #FBoxMapData[game.GetMap()].metrocops.sittable + #FBoxMapData[game.GetMap()].metrocops.spawns + #FBoxMapData[game.GetMap()].wanderer.walktable + #FBoxMapData[game.GetMap()].wanderer.sittable + #FBoxMapData[game.GetMap()].wanderer.spawns
	local totalwalk = #FBoxMapData[game.GetMap()].metrocops.walktable + #FBoxMapData[game.GetMap()].wanderer.walktable
	local totalsit = #FBoxMapData[game.GetMap()].metrocops.sittable + #FBoxMapData[game.GetMap()].wanderer.sittable
	local totalspawns = #FBoxMapData[game.GetMap()].metrocops.spawns + #FBoxMapData[game.GetMap()].wanderer.spawns

	NE_frame = vgui.Create("DFrame")
	NE_frame:SetPos(10,10)
	NE_frame:SetSize(600,500)
	NE_frame:MakePopup()
	NE_frame:SetTitle("FlexBox Node Editor - Alt + E sets visibility")
	NE_frame:SetIcon(icons.frame)

	local tree = vgui.Create("DTree",NE_frame)
	tree:Dock(LEFT)
	tree:SetWide(200)
	local root = tree:AddNode("Nodes")

	local c_nodes = root:AddNode("Citizens")
	c_nodes:SetIcon(icons.citizen)
	local c_walk = c_nodes:AddNode("Walk Nodes")
	c_walk:SetIcon(icons.node_walk)
	local c_sit = c_nodes:AddNode("Sit Nodes")
	c_sit:SetIcon(icons.node_sit)
	local c_spawn = c_nodes:AddNode("Spawn Nodes")
	c_spawn:SetIcon(icons.node_spawn)

	local m_nodes = root:AddNode("Metrocops")
	m_nodes:SetIcon(icons.metrocop)
	local m_walk = m_nodes:AddNode("Walk Nodes")
	m_walk:SetIcon(icons.node_walk)
	local m_sit = m_nodes:AddNode("Sit Nodes")
	m_sit:SetIcon(icons.node_sit)
	local m_spawn = m_nodes:AddNode("Spawn Nodes")
	m_spawn:SetIcon(icons.node_spawn)

	local function AddNode(pos,type,npc)
		if type == NODE_WALK and npc == NPC_CITIZEN then
			local node = c_walk:AddNode("Vector("..pos.x..","..pos.y..","..pos.z..")")
			node:SetIcon(icons.node_walk)
		elseif type == NODE_SIT and npc == NPC_CITIZEN then
			local node = c_sit:AddNode("Vector("..pos.x..","..pos.y..","..pos.z..")")
			node:SetIcon(icons.node_sit)
		elseif type == NODE_SPAWN and npc == NPC_CITIZEN then
			local node = c_spawn:AddNode("Vector("..pos.x..","..pos.y..","..pos.z..")")
			node:SetIcon(icons.node_spawn)
		elseif type == NODE_WALK and npc == NPC_METRO then
			local node = m_walk:AddNode("Vector("..pos.x..","..pos.y..","..pos.z..")")
			node:SetIcon(icons.node_walk)
		elseif type == NODE_SIT and npc == NPC_METRO then
			local node = m_sit:AddNode("Vector("..pos.x..","..pos.y..","..pos.z..")")
			node:SetIcon(icons.node_sit)
		elseif type == NODE_SPAWN and npc == NPC_METRO then
			local node = m_spawn:AddNode("Vector("..pos.x..","..pos.y..","..pos.z..")")
			node:SetIcon(icons.node_spawn)
		end
	end

	for _,node in pairs(FBoxMapData[game.GetMap()].metrocops.walktable) do
		AddNode(node,NODE_WALK,NPC_METRO)
	end
	for _,tbl in pairs(FBoxMapData[game.GetMap()].wanderer.sittable) do
		AddNode(tbl[1],NODE_SIT,NPC_METRO)
	end
	for _,node in pairs(FBoxMapData[game.GetMap()].metrocops.spawns) do
		AddNode(node,NODE_SPAWN,NPC_METRO)
	end

	for _,node in pairs(FBoxMapData[game.GetMap()].wanderer.walktable) do
		AddNode(node,NODE_WALK,NPC_CITIZEN)
	end
	for _,tbl in pairs(FBoxMapData[game.GetMap()].wanderer.sittable) do
		AddNode(tbl[1],NODE_SIT,NPC_CITIZEN)
	end
	for _,node in pairs(FBoxMapData[game.GetMap()].wanderer.spawns) do
		AddNode(node,NODE_SPAWN,NPC_CITIZEN)
	end

	----

	local editpane = vgui.Create("DPanel",NE_frame)
	editpane:Dock(FILL)
	local node_txt = vgui.Create("DLabel",editpane)
	node_txt:SetColor(Color(0,0,0))
	node_txt:Dock(TOP)
	node_txt:DockMargin(4,4,4,0)
	node_txt:SetText(game.GetMap().." has a total of "..totalnodes.." nodes ("..totalwalk.." walk nodes, "..totalsit.." sit nodes, "..totalspawns.." spawn nodes)"
	local node_prop = vgui.Create("DProperties",editpane)
	node_prop:Dock(FILL)
	node_prop:DockMargin(4,4,4,4)
	local node_pos = node_prop:CreateRow("Node Properties","Node Position")
	node_pos:Setup("Generic")
	node_pos:SetValue("0,0,0")
	local node_type = node_prop:CreateRow("Node Properties","Node Type")
	node_type:Setup("Combo",{text = "Node Type"})
	node_type:AddChoice("NODE_WALK",NODE_WALK):SetIcon(icons.node_walk)
	node_type:AddChoice("NODE_SIT",NODE_SIT):SetIcon(icons.node_sit)
	node_type:AddChoice("NODE_SPAWN",NODE_SPAWN):SetIcon(icons.node_spawn)

end

concommand.Add("fbox_nodeeditor",NodeEditor)
