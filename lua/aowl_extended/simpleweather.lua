aowl.AddCommand("weather",function(ply)
    if( line == "none" ) then
    	SW.SetWeather( SW_NOWEATHER )
    elseif( line == "rain" ) then
    	SW.SetWeather( SW_RAIN )
    elseif( line == "storm" ) then
    	SW.SetWeather( SW_STORM )
    elseif( line == "snow" ) then
    	SW.SetWeather( SW_SNOW )
    end
end,"moderators")

aowl.AddCommand("stopweather",function(ply)
    SW.SetWeather( SW_NOWEATHER )
end,"moderators")

aowl.AddCommand("autoweather",function(ply,line)
    if line == "1" or line == "true" then
        SW.AutoWeatherEnabled = true
    else
        SW.AutoWeatherEnabled = false
    end
end,"moderators")

aowl.AddCommand("settime",function(ply,time)
    SW.SetTime = time
end,"moderators")
