AddCSLuaFile()

local tag = "nametags"

local PLAYER = FindMetaTable("Player")

if SERVER then
	util.AddNetworkString(tag .. "TitleChange")

	function PLAYER:SetCustomTitle(txt)
		self:SetPData(tag .. "Title", txt)
		self:SetNWString(tag .. "Title", txt)

		net.Start(tag .. "TitleChange")
			net.WriteInt(self:EntIndex(), 16)
			net.WriteString(txt)
		net.Broadcast()
	end

	net.Receive(tag .. "TitleChange", function(len, ply)
		local txt = net.ReadString()
		ply:SetCustomTitle(txt)
	end)

	if aowl and easylua then
		aowl.AddCommand("title", function(caller, line, txt, ply)
			if not txt or txt:Trim() == "" then txt = "" end
			if not ply or ply:Trim() == "" then
				ply = caller
			end
			if ply ~= caller then
				ply = easylua.FindEntity(ply)
			end
			if not IsValid(ply) then return false, "Invalid player" end

			ply:SetCustomTitle(txt)
		end)
	end

	hook.Add("PlayerSpawn", tag, function(ply)
		ply:SetCustomTitle(ply:GetPData(tag .. "Title") or "")
	end)
end

function PLAYER:GetCustomTitle()
	return self:GetNWString(tag .. "Title")
end

if CLIENT then
	function PLAYER:SetCustomTitle(txt)
		net.Start(tag .. "TitleChange")
			net.WriteString(txt)
		net.SendToServer()
	end

	net.Receive(tag .. "TitleChange", function()
		local plyID = net.ReadInt(16)
		local txt = net.ReadString()
		Entity(plyID).CustomTitle = txt
	end)

	local name_font = CreateClientConVar("cl_nametags_name_font", "Segoe UI", true, false)
	local name_weight = CreateClientConVar("cl_nametags_name_weight", "880", true, false)
	local name_blursize = CreateClientConVar("cl_nametags_name_blursize", "8", true, false)
	local title_font = CreateClientConVar("cl_nametags_title_font", "Roboto", true, false)
	local title_weight = CreateClientConVar("cl_nametags_title_weight", "1", true, false)
	local title_italic = CreateClientConVar("cl_nametags_title_italic", "0", true, false)
	local title_blursize = CreateClientConVar("cl_nametags_title_blursize", "6", true, false)
	local iFont = 1
	local function CreateFont(font, size, weight, italic, additive, blursize)
		surface.CreateFont(tag .. "_" .. iFont, {
			font = font,
			size = size,
			weight = weight,
			italic = italic,
			additive = additive
		})

		surface.CreateFont(tag .. "_" .. iFont .. "_blur", {
			font = font,
			size = size,
			weight = weight,
			italic = italic,
			blursize = blursize,
			additive = false,
		})

		iFont = iFont + 1
	end
	CreateFont(name_font:GetString(), 128, name_weight:GetInt(), false, false, name_blursize:GetFloat())
	CreateFont(title_font:GetString(), 72, title_weight:GetInt(), title_italic:GetBool(), false, title_blursize:GetFloat())
	concommand.Add("cl_nametags_font_recreate", function()
		iFont = 1
		CreateFont(name_font:GetString(), 128, name_weight:GetInt(), false, false, name_blursize:GetFloat())
		CreateFont(title_font:GetString(), 72, title_weight:GetInt(), title_italic:GetBool(), false, title_blursize:GetFloat())
	end)

	local function DrawTextSplit(txt, separator, font, x, y, colors)
		if separator ~= nil and separator ~= "" then
			local txtSplit = txt:Split(separator)
			local txtWidths = {}
			for i, str in next, txtSplit do
				surface.SetFont(font)
				local txtW = surface.GetTextSize(str)
				txtWidths[i] = txtW + (txtWidths[i - 1] or 0)
				surface.SetTextColor(colors[i] or colors[#colors])
				surface.SetTextPos(x + (i <= 1 and 0 or (txtWidths[i - 1] or 0)), y)
				surface.DrawText(str)
			end
		else
			surface.SetFont(font)
			surface.SetTextColor(colors[1])
			surface.SetTextPos(x, y)
			surface.DrawText(txt)
		end
	end

	local pos, ang, eyeAng = Vector(), Angle(), Angle()
	local fn = 0
	hook.Add("RenderScene", tag, function(pos, ang)
		eyeAng = ang
		fn = FrameNumber()
	end)
	local function DrawNameTagText(txt, font, y, colors, alpha, scale, times)
		if not txt then return end
		if table.Count(colors) == 4 and colors.r and colors.g and colors.b and colors.a then
			colors = { colors }
		end
		cam.Start3D2D(pos + Vector(0, 0, 16), ang, .066 * scale)
			surface.SetFont(font)
			local txtW, txtH = surface.GetTextSize(txt:gsub("¦", ""))
			-- local brightness = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b
			local shadowColor = Color(0, 0, 0, 192 * alpha)
			for i = 1, times do
				surface.SetFont(font .. "_blur")
				surface.SetTextColor(shadowColor)
				surface.SetTextPos(-txtW / 2 - 1, 128 * y)
				surface.DrawText(txt:gsub("¦", ""))
			end
			for k, color in next, colors do
				colors[k] = Color(color.r, color.g, color.b, color.a * alpha)
			end
			DrawTextSplit(txt, "¦", font, -txtW / 2, 128 * y, colors)
		cam.End3D2D()
	end

	local maxRange = 512
	local PlayerColors = {
		["0"]  = Color(0, 0, 0),
		["1"]  = Color(128, 128, 128),
		["2"]  = Color(192, 192, 192),
		["3"]  = Color(255, 255, 255),
		["4"]  = Color(0, 0, 128),
		["5"]  = Color(0, 0, 255),
		["6"]  = Color(0, 128, 128),
		["7"]  = Color(0, 255, 255),
		["8"]  = Color(0, 128, 0),
		["9"]  = Color(0, 255, 0),
		["10"] = Color(128, 128, 0),
		["11"] = Color(255, 255, 0),
		["12"] = Color(128, 0, 0),
		["13"] = Color(255, 0, 0),
		["14"] = Color(128, 0, 128),
		["15"] = Color(255, 0, 255),
	}
	local tags = {
		color = {
			default = { 255, 255, 255, 255 },
			callback = function(params)
				return Color(params[1], params[2], params[3], params[4])
			end,
			params = { "number", "number", "number", "number" }
		},
		hsv = {
			default = { 0, 1, 1 },
			callback = function(params)
				return HSVToColor(params[1] % 360, params[2], params[3])
			end,
			params = { "number", "number", "number" }
		},
	}
	local types = {
		["number"] = tonumber,
		["bool"] = tobool,
		["string"] = tostring,
	}
	local lib =
	{
		PI = math.pi,
		pi = math.pi,
		rand = math.random,
		random = math.random,
		randx = function(a,b)
			a = a or -1
			b = b or 1
			return math.Rand(a, b)
		end,

		abs = math.abs,
		sgn = function (x)
			if x < 0 then return -1 end
			if x > 0 then return  1 end
			return 0
		end,

		pwm = function(offset, w)
			w = w or 0.5
			return offset % 1 > w and 1 or 0
		end,

		square = function(x)
			x = math.sin(x)

			if x < 0 then return -1 end
			if x > 0 then return  1 end

			return 0
		end,

		acos = math.acos,
		asin = math.asin,
		atan = math.atan,
		atan2 = math.atan2,
		ceil = math.ceil,
		cos = math.cos,
		cosh = math.cosh,
		deg = math.deg,
		exp = math.exp,
		floor = math.floor,
		frexp = math.frexp,
		ldexp = math.ldexp,
		log = math.log,
		log10 = math.log10,
		max = math.max,
		min = math.min,
		rad = math.rad,
		sin = math.sin,
		sinc = function (x)
			if x == 0 then return 1 end
			return math.sin(x) / x
		end,
		sinh = math.sinh,
		sqrt = math.sqrt,
		tanh = math.tanh,
		tan = math.tan,

		clamp = math.Clamp,
		pow = math.pow,

		t = RealTime,
		time = RealTime,
	}
	local blacklist = { "repeat", "until", "function", "end" }
	local afkPhrases = {
		"Drinking some tea...",
		"Probably sleeping...",
		"Away...",
		"Ya-a-a-a-wn...",
		"Zzz...",
		"Dreaming of GMod...",
	}
	local info = {
		afk = function(ply, alpha)
			if ply.IsAFK and ply:IsAFK() then
				local len = ply:AFKTime()
				local h = math.floor(len / 60 / 60)
				local m = math.floor(len / 60 - h * 60)
				local s = math.floor(len - m * 60 - h * 60 * 60)

				local AFKTime = string.format("%.2d:%.2d:%.2d", h, m, s)
				local s = afkPhrases[math.floor((CurTime() / 4 + ply:EntIndex()) % #afkPhrases) + 1]

				return AFKTime .. "¦ - ¦" .. s, tag .. "_2", -1.4, { Color(172, 255, 86), color_white, Color(122, 122, 172) }, alpha, .75, 3
			end
		end,
		nick = function(ply, alpha)
			local nick = ply:Nick()
			local nickColor = { team.GetColor(ply:Team()) }

			if nick:match("<(.-)=(.-)>") or nick:match("(^%d+)") then
				local nickTags = {}
				local inCOD = false
				local CODchars = ""

				local nickChars = ply:Nick():Split("")
				local inMarkup = false
				local markupTag = ""
				local markupParams = {}
				local markupParam = ""
				local lookingForParams = false

				for i, char in next, nickChars do

					-- COD colors

					if not inMarkup and nick:match("(^%d+)") then
						if char == "^" then
							inCOD = true
							continue
						end

						if inCOD then
							if type(tonumber(char)) == "number" then
								CODchars = CODchars .. char
								continue
							elseif type(tonumber(char)) ~= "number" then
								local color = PlayerColors[CODchars]
								CODchars = ""
								if not color then inCOD = false continue end
								local colParams = {}
								colParams[1] = tostring(color.r)
								colParams[2] = tostring(color.g)
								colParams[3] = tostring(color.b)
								table.insert(nickTags, { tagName = "color", params = colParams })
								inCOD = false
								continue
							end
						end
					end

					-- markup

					if not inCOD and nick:match("<(.-)=(.-)>")then
						if char == "<" and not inMarkup then
							inMarkup = true
							continue
						elseif char == "=" and inMarkup and not lookingForParams then
							lookingForParams = true
							continue
						elseif char == ">" and inMarkup then
							table.insert(markupParams, markupParam)
							for k, param in pairs(markupParams) do
								markupParams[k] = param:Trim()
								param = markupParams[k]
								if param:sub(1, 1) == "[" and param:sub(-1, -1) == "]" then
									local exp = param:sub(2, -2)
									if not exp then continue end
									local ok = true
									for _, word in next, blacklist do
										if param:lower():match(word) then ok = false break end
									end
									if ok then
										local func = CompileString("return " .. exp, "nametags_exp", false)
										if type(func) == "function" then
											setfenv(func, lib)
											markupParams[k] = tostring(func())
										end
									end
								end
							end
							table.insert(nickTags, { tagName = markupTag, params = markupParams })
							inMarkup = false
							lookingForParams = false
							markupTag = ""
							markupParams = {}
							markupParam = ""
							continue
						end

						if inMarkup then
							if not lookingForParams then
								markupTag = markupTag .. char
								continue
							elseif lookingForParams and char == "," and not escaping then
								table.insert(markupParams, markupParam)
								markupParam = ""
								continue
							elseif lookingForParams and char == "\\" and not escaping then
								escaping = true
								continue
							else
								markupParam = markupParam .. char
								escaping = false
								continue
							end
						end
					end
				end

				nick = nick:gsub("<(.-)=(.-)>", "¦")
				nick = nick:gsub("(^%d+)", "¦")

				if #nickTags >= 1 then
					for i, tag in next, nickTags do -- for every tag in our name
						local nickTag, nickParams = tag.tagName, tag.params
						for tagName, tagData in next, tags do -- check the list of available tags
							if nickTag == tagName then -- if the tag matches then
								for k, Type in next, tagData.params do
									local param = nickParams[k]
									if param == nil or param == "" or type(types[Type](param)) ~= Type then
										nickParams[k] = tagData.default[k]
									end
								end
								table.insert(nickColor, tagData.callback(nickParams))
								break
							end
						end
					end
				end
			end

			return nick, tag .. "_1", -1, nickColor, alpha, .75, 2
		end,
		titles = function(ply, alpha)
			local title = ply:GetCustomTitle()
			if title ~= "" then
				return ply:GetCustomTitle(), tag .. "_2", 0, color_white, alpha, .75, 3
			end
		end,
		--[[
		health = function(ply, alpha)
			local str = "Healthy"
			local color = Color(64, 255, 64)
			local health = ply:Health()
			if health <= 0 then
				str = "Dead"
				color = Color(255, 64, 64)
			elseif health >= 1 and health <= 25 then
				str = "Near death"
				color = Color(255, 127, 64)
			elseif health >= 26 and health <= 50 then
				str = "Badly wounded"
				color = Color(255, 255, 64)
			elseif health >= 51 and health <= 75 then
				str = "Wounded"
				color = Color(127, 255, 64)
			end
			return str, tag .. "_2", ply:GetCustomTitle() ~= "" and 2.5 or 1.875, color, alpha, .75, 3
		end,
		]]
	}

	local drawLocalPlayer = CreateClientConVar("cl_nametags_drawlocalplayer", "1", true, false)
	local draw = CreateClientConVar("cl_nametags_draw", "1", true, false)

	local people = {}
	hook.Add("PostDrawTranslucentRenderables", tag, function()
		if not draw:GetBool() then return end

		local localPly = LocalPlayer()
		for ply, pfn in next, people do
			if not IsValid(ply) then people[ply] = nil continue end
			if pfn ~= fn - 1 and ply:Alive() or ply:Crouching() then continue end
			-- some variables

			local isLocalPly = ply:EntIndex() == localPly:EntIndex()
			local dist = ply:GetPos():Distance(localPly:GetPos())
			local alpha = 1
			local distAlpha = 1

			-- alpha logic

			if dist <= 64 then
				distAlpha = math.max(0, math.TimeFraction(32, 64, dist))
			elseif dist >= maxRange then
				distAlpha = math.max(0, 1 - math.TimeFraction(maxRange, maxRange + 64, dist))
			end
			alpha = distAlpha
			if drawLocalPlayer:GetBool() and isLocalPly and localPly:ShouldDrawLocalPlayer() or isLocalPly and localPly.IsAFK and localPly:IsAFK() then alpha = 1 end
			if alpha == 0 then continue end

			-- set pos / ang upvalues to be above the head of player

			local plyEnt
			if IsValid(ply:GetRagdollEntity()) and not ply:Alive() then
				plyEnt = ply:GetRagdollEntity()
			else
				plyEnt = ply
			end
			local eyes = plyEnt:GetAttachment(ply:LookupAttachment("eyes"))
			if not eyes then continue end
			pos = eyes.Pos
			ang = Angle()
			ang.p = eyeAng.p
			ang.y = eyeAng.y
			ang.r = eyeAng.r
			ang:RotateAroundAxis(ang:Up(), -90)
			ang:RotateAroundAxis(ang:Forward(), 90)

			-- draw ALL the shit

			for i, tag in next, info do
				local params = {tag(ply, alpha)}
				DrawNameTagText(unpack(params))
			end
		end
	end)

	hook.Add("UpdateAnimation", tag, function(ply)
		people[ply] = fn
	end)

	local function nametagsOptions(panel)
		local nametagsOptions = { Options = {}, CVars = {}, Label = "#Presets", MenuButton = "1", Folder = "nametags_options" }

		nametagsOptions.Options["#Default"] = {
			cl_nametags_draw = true,
			cl_nametags_drawlocalplayer = true,

			cl_nametags_name_font = "Segoe UI",
			cl_nametags_name_weight = 880,
			cl_nametags_name_blursize = 8,

			cl_nametags_title_font = "Roboto",
			cl_nametags_title_weight = 1,
			cl_nametags_title_italic = true,
			cl_nametags_title_blursize = 6,
		}

		nametagsOptions.CVars = {
			"cl_nametags_draw",
			"cl_nametags_drawlocalplayer",

			"cl_nametags_name_font",
			"cl_nametags_name_weight",
			"cl_nametags_name_blursize",

			"cl_nametags_title_font",
			"cl_nametags_title_weight",
			"cl_nametags_title_italic",
			"cl_nametags_title_blursize",
		}

		panel:AddControl("Header", {
			Description = "Nametags are what is displayed above each player, their nickname and their title."
		})

		panel:AddControl("ComboBox", nametagsOptions)

		panel:AddControl("CheckBox", {
			Label = "Enabled",
			Command = "cl_nametags_draw",
		})

		panel:AddControl("CheckBox", {
			Label = "Show your own nametag in third person",
			Command = "cl_nametags_drawlocalplayer",
		})

		panel:AddControl("TextBox", {
			Label = "Name font",
			Command = "cl_nametags_name_font",
			WaitForEnter = "1"
		})
		panel:AddControl("TextBox", {
			Label = "Title font",
			Command = "cl_nametags_title_font",
			WaitForEnter = "1"
		})

		panel:AddControl("Slider", {
			Label = "Name font weight",
			Type = "Integer",
			Command = "cl_nametags_name_weight",
			Min = "1",
			Max = "1024"
		})
		panel:AddControl("Slider", {
			Label = "Title font weight",
			Type = "Integer",
			Command = "cl_nametags_title_weight",
			Min = "1",
			Max = "1024"
		})

		panel:AddControl("Slider", {
			Label = "Name font blur size",
			Type = "Integer",
			Command = "cl_nametags_name_blursize",
			Min = "0",
			Max = "128"
		})
		panel:AddControl("Slider", {
			Label = "Title font blur size",
			Type = "Integer",
			Command = "cl_nametags_title_blursize",
			Min = "0",
			Max = "128"
		})

		panel:AddControl("CheckBox", {
			Label = "Italic titles",
			Command = "cl_nametags_title_italic",
		})

		panel:AddControl("Button", {
			Label = "Apply changes",
			Command = "cl_nametags_font_recreate",
		})

		panel:AddControl("Header", {
			Description = "NOTE: AFK timer font uses title font."
		})
	end

	hook.Add("PopulateToolMenu", "nametagsOptions", function()
		spawnmenu.AddToolMenuOption("Options", "Visuals", "Nametags options", "Nametags options", "", "", nametagsOptions)
	end)
end
