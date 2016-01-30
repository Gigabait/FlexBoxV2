local enable = CreateClientConVar("fbox_pp", "0")
local DrawColorModify = DrawColorModify

local C = {
	["sun_angles"] = Angle(-90, 45, 0),
	["moon_angles"] = -Angle(-90, 45, 0),
	["world_light_multiplier"] = 0.001,
	
	["color_brightness"] = 0,
	["color_contrast"] = 1,
	["color_saturation"] = 0.75,
	["color_multiply"] = Vector(-0.017, -0.005, 0.02),
	["color_add"] = Vector(0, 0, 0),
	
	["fog_start"] = 0,
	["fog_end"] = 14000,
	["fog_max_density"] = 0.25,
	["fog_color"] = Vector(0.25, 0.20, 0.30),
	
	["shadow_angles"] = Angle(-90, 45, 0),
	["shadow_color"] = Vector(0, 0, 0),
	
	["star_intensity"] = 1,
	
	["bloom_passes"] = 1,
	["bloom_color"] = Vector(1, 1, 1),
	["bloom_width"] = 1,
	["bloom_saturation"] = 1,
	["bloom_height"] = 1,
	["bloom_darken"] = 0,
	["bloom_multiply"] = 0,
	
	["sharpen_contrast"] = 0,
	["sharpen_distance"] = 0,
	
	["sky_topcolor"] = Vector(5, 12, 15) / 255 * 100,
	["sky_bottomcolor"] = Vector(12, 14, 13) / 255 * 100,
	
	["sky_fadebias"] = 1,
	["sky_sunsize"] = 0,
	["sky_sunnormal"] = Vector(0.4, 0, 0.01),
	["sky_suncolor"] = Vector(0.2, 0.1, 0),
	["sky_duskscale"] = 1,
	["sky_duskintensity"] = 1,
	["sky_duskcolor"] = Vector(0, 0, 0),
	["sky_starscale"] = 2,
	["sky_starfade"] = 1,
	["sky_starspeed"] = 0.005,
	["sky_hdrscale"] = 0.66,
}

hook.Add("RenderScreenspaceEffects", "fbox_pp", function()

	if not enable:GetBool() then return end

	-- hack
	-- DrawColorModify may exist after this script is ran
	DrawColorModify = DrawColorModify or _G.DrawColorModify

	if
		C.sharpen_contrast ~= 0 or
		C.sharpen_distance ~= 0
	then
		DrawSharpen(
			C.sharpen_contrast,
			C.sharpen_distance
		)
	end

	if
		C.color_add ~= vector_origin or
		C.color_multiply ~= vector_origin or
		C.color_brightness ~= 0 or
		C.color_contrast ~= 1 or
		C.color_saturation ~= 1
	then
		local params = {}
			params["$pp_colour_addr"] = C.color_multiply.r
			params["$pp_colour_addg"] = C.color_multiply.g
			params["$pp_colour_addb"] = C.color_multiply.b
			params["$pp_colour_brightness"] = C.color_brightness
			params["$pp_colour_contrast"] = C.color_contrast
			params["$pp_colour_colour"] = C.color_saturation
			params["$pp_colour_mulr"] = C.color_add.r
			params["$pp_colour_mulg"] = C.color_add.g
			params["$pp_colour_mulb"] = C.color_add.b
		DrawColorModify(params)
	end

	if
		C.bloom_darken ~= 1 or
		C.bloom_multiply ~= 0
	then
		DrawBloom(
			C.bloom_darken,
			C.bloom_multiply,
			C.bloom_width,
			C.bloom_height,
			C.bloom_passes,
			C.bloom_saturation,
			C.bloom_color.r,
			C.bloom_color.g,
			C.bloom_color.b
		)
	end
end)