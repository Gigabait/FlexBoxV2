aowl.AddCommand({"settime","time"}, function(ply,line,time)

	if not SW then
		PrintMessage(3, "Uh-oh! Simple Weather couldn't be detected!")
		return false
	end
	if not time then
		return false, "Syntax: !(set)time [hours|on/off]"
	end

	time = time:Trim()
	time = time:lower()
	local otime = time
	time = tonumber(time)

	local flm = ("%s*([0-9%A%.]+)")

	if isnumber(time) then
		SW.SetTime(tonumber(time))
		PrintMessage(3, "Time set to " .. time .."")
		return true
	elseif otime == "off" then
		SW.TimePaused = true
		PrintMessage(3, "Automatic time disabled")
		return true
	elseif otime == "on" then
		SW.TimePaused = false
		PrintMessage(3, "Automatic time enabled")
		return true
	elseif otime:match(flm.."off") or otime:match("off"..flm)  then
		local _time = tonumber(otime:match(flm.."off")) or tonumber(otime:match("off"..flm))
		SW.TimePaused = true
		SW.SetTime(_time)
		PrintMessage(3,("Automatic time disabled, time set to " .. _time))
		return true
	elseif otime:match(flm.."on") or otime:match("on"..flm)  then
		local _time = tonumber(otime:match(flm.."on")) or tonumber(otime:match("on"..flm))
		SW.TimePaused = false
		SW.SetTime(_time)
		if _time > 24 then
			return false, "Invalid input!"
		end
		PrintMessage(3,("Automatic time enabled, time set to " .. _time))
		return true
	else
		return false, "Invalid input!"
	end
end, "moderators")

aowl.AddCommand({"setweather","weather"}, function(ply,line,weather)

	if not weather then
		return false, "Invalid input!"
	end

	if not SW then
		PrintMessage(3,"Uh-oh! Simple Weather couldn't be detected!")
		return false
	end

	weather = weather:Trim():lower()

	if #weather < 1 then
		return false, "Invalid input!"
	end

	if (weather:match("none") or weather:match("clear")) and not weather:match("offnone") then
		SW.SetWeather(0)
		PrintMessage(3,"Weather set to \"" .. weather .. "\"")
		return true
	elseif weather:match"rain" then
		SW.SetWeather(1)
		PrintMessage(3,"Weather set to \"rain\"")
		return true
	elseif weather:match"storm" then
		SW.SetWeather(3)
		PrintMessage(3,"Weather set to \"storm\"")
		return true
	elseif weather:match"snow" then
		SW.SetWeather(2)
		PrintMessage(3,"Weather set to \"snow\"")
		return true
	elseif weather == "off" then
		SW.AutoWeatherEnabled = false
		PrintMessage(3,"Automatic weather disabled")
		return true
	elseif weather == "on" then
		SW.AutoWeatherEnabled = true
		PrintMessage(3,"Automatic weather enabled")
		return true
	elseif weather:match("^offnone$") or weather:match("^noneoff$")  then
		SW.AutoWeatherEnabled = false
		SW.SetWeather(0)
		PrintMessage(3,"Automatic weather disabled, weather set to \"none\"")
		return true
	else
		return false, "Invalid input!"
	end
end, "moderators")

aowl.AddCommand("fixlightmaps",function()
    if !luadev then
    assert("no luadev? what?")
    end

    luadev.RunOnClients("render.RedownloadAllLightmaps()")
end,"moderators")
