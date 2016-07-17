surface.CreateFont("HUDRainbowHeader", {
	font = "Consolas",
	size = ScrW() * .05,
	weight = 100
})

surface.CreateFont("HUDRainbowText", {
	font = "Lucida Console",
	size = ScrW() * .025,
	weight = 100
})

--@luadev please don't broadcast, thx
module("HUDPrint", package.seeall)
text = "Hold on! You're losing connection to our server!"

sine = {
	speed = 10,
	valleys = 5
}

local charCount = 0
local timeLimit = 0
local inprogress = false
control = {}
control.chatTimelimit = 10
control.spacing = 0
control.hueTimeSlow = 4
control.hueSize = .025

--@luadev ++31 /control
--@luadev --34 /control  
function AddTimed(text, timelimit)
	if timelimit < 1 then
		ErrorNoHalt("Message duration cannot be less than 1 second!")

		return
	end

	hook.Remove("HUDPrintComplete", "internalAddTimedQueue")
	--@luadev l^ GAMEMODE continue

	if inprogress then
		Stop()

		hook.Add("HUDPrintComplete", "internalAddTimedQueue", function()
			--@luadev l^ GAMEMODE continue
			AddTimed(text, timelimit)
		end)

		return
	end

	surface.SetFont("HUDRainbowText")
	inprogress = true
	local baseY = ScrH() / 3
	local baseX = 0
	local centrX = 0
	local tblText = text:ToTable()
	local printTbl = {}

	for k, char in pairs(tblText) do
		local w, h = surface.GetTextSize(char)

		table.insert(printTbl, {
			char = char,
			pos = baseX,
			char_width = w,
			char_height = h
		})

		baseX = baseX + w -- DO this AFTER
	end

	centrX = ScrW() / 2 - baseX / 2
	timeLimit = -1 * (SysTime() + timelimit)
	local startTime = SysTime()

	hook.Add("HUDPaint", "RainbowSineText", function()
		charCount = 0

		for k, tbl in pairs(printTbl) do
			local time = -SysTime() * sine.speed + k

			if -SysTime() + (k / 20) < timeLimit then
				if tbl.Visible then
					tbl.Visible = false
					sound.Play("ambient/machines/keyboard" .. math.random(1, 7) .. "_clicks.wav", LocalPlayer():GetPos(), 75, 100, .5)
				end

				continue
				--@luadev l^ /continue/break
			end

			charCount = charCount + 1

			if SysTime() - startTime >= k / 20 then
				if not tbl.Visible then
					tbl.Visible = true
					sound.Play("ambient/machines/keyboard" .. math.random(1, 7) .. "_clicks.wav", LocalPlayer():GetPos(), 75, 100, .5)
				end

				local char_y = math.sin(time)
				draw.SimpleText(tbl.char, "HUDRainbowText", centrX + tbl.pos + char_y * 2 + 2, baseY + char_y * sine.valleys + 2, Color(0, 0, 0), TEXT_ALIGN_LEFT)
				draw.SimpleText(tbl.char, "HUDRainbowText", centrX + tbl.pos + char_y * 2, baseY + char_y * sine.valleys, HSVToColor(math.sin(CurTime() / control.hueTimeSlow - (k * control.hueSize)) * 360, 1, 1), TEXT_ALIGN_LEFT)
			end
		end

		if charCount == 0 then
			inprogress = false
			hook.Call("HUDPrintComplete", GAMEMODE)
			--@luadev l^ GAMEMODE continue
			hook.Remove("HUDPaint", "RainbowSineText")
		end
	end)
end

function Start()
	if inprogress then return end
	surface.SetFont("HUDRainbowText")
	inprogress = true
	local baseY = ScrH() / 3
	local baseX = 0
	local centrX = 0
	local tblText = text:ToTable()
	local printTbl = {}

	for k, char in pairs(tblText) do
		local w, h = surface.GetTextSize(char)

		table.insert(printTbl, {
			char = char,
			pos = baseX,
			char_width = w,
			char_height = h
		})

		baseX = baseX + w -- DO this AFTER
	end

	centrX = ScrW() / 2 - baseX / 2
	timeLimit = -1 * (SysTime() + 1e9)
	local startTime = SysTime()

	hook.Add("HUDPaint", "RainbowSineText", function()
		charCount = 0

		for k, tbl in pairs(printTbl) do
			local time = -SysTime() * sine.speed + k

			if -SysTime() + (k / 20) < timeLimit then
				if tbl.Visible then
					tbl.Visible = false
					sound.Play("ambient/machines/keyboard" .. math.random(1, 7) .. "_clicks.wav", LocalPlayer():GetPos(), 75, 100, .5)
				end

				continue
			end

			charCount = charCount + 1

			if SysTime() - startTime >= k / 20 then
				if not tbl.Visible then
					tbl.Visible = true
					sound.Play("ambient/machines/keyboard" .. math.random(1, 7) .. "_clicks.wav", LocalPlayer():GetPos(), 75, 100, .5)
				end

				local char_y = math.sin(time)
				draw.SimpleText(tbl.char, "HUDRainbowText", centrX + tbl.pos + char_y * 2 + 2, baseY + char_y * sine.valleys + 2, Color(0, 0, 0), TEXT_ALIGN_LEFT)
				draw.SimpleText(tbl.char, "HUDRainbowText", centrX + tbl.pos + char_y * 2, baseY + char_y * sine.valleys, HSVToColor(math.sin(CurTime() / control.hueTimeSlow - (k * control.hueSize)) * 360, 1, 1), TEXT_ALIGN_LEFT)
			end
		end
	end)
end

function Stop()
	if not inprogress then return end
	timeLimit = -1 * SysTime()

	if charCount == 0 then
		inprogress = false
		hook.Call("HUDPrintComplete", GAMEMODE)
		--@luadev l^ GAMEMODE continue
		hook.Remove("HUDPaint", "RainbowSineText")
	end
end