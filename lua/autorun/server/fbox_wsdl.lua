local maps = {
	["gm_buildersworld_finalv3"]      = "117667617",
	["rp_city17_district47"]          = "499775246",
	["gm_construct_build_conquer_v2"] = "536915311",
	["gm_genesis_b24"]                = "266666023",
	["gm_mega_flatgrass_v4"]          = "270479735",
	["gm_highway14800"]               = "152413570",
	["gm_carconstruct_b1-8"]          = "138075711",
	["gm_infinite_concrete"]          = "124358552",
	["gm_construct_extended"]         = "509873419",
	["gm_construct_15"]               = "693913132",
	["gm_bigcity_winter"]             = "622351524",
	["rp_c18_winter_holiday2"]        = "603896057",
	["rp_outercanals_winter"]         = "107641602",
}

resource.AddWorkshop(maps[game.GetMap()])
resource.AddWorkshop("218917501") -- Simple Weather Content
resource.AddWorkshop("546392647") -- Media Player
