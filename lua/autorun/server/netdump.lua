net.ChannelStatistics = net.ChannelStatistics or {}
net.ProfileStartTime = SysTime()

function net.Incoming( len, client )
	local i = net.ReadHeader()
	local channelName = util.NetworkIDToString( i )
	
	if not channelName then return end
	
	local handler = net.Receivers[ string.lower( channelName ) ]
	if not handler then return end

	-- Keep track of biggest shit.
	if not net.ChannelStatistics[channelName] then
		net.ChannelStatistics[channelName] =
		{
			Name            = channelName,
			Count           = 0,
			AverageInterval = 0,
			TotalLength     = 0,
			MaximumLength   = 0,
			MeanLength      = 0,
			TotalTime       = 0,
			MaximumTime     = 0,
			MeanTime        = 0
		}
	end
	local channelStatistics = net.ChannelStatistics[channelName]
	
	channelStatistics.Count = channelStatistics.Count + 1
	
	channelStatistics.MaximumLength = math.max( channelStatistics.MaximumLength, len / 8 + 6 )
	channelStatistics.TotalLength = channelStatistics.TotalLength + len / 8 + 6
	channelStatistics.MeanLength = channelStatistics.TotalLength / channelStatistics.Count
	
	channelStatistics.AverageInterval = (SysTime() - net.ProfileStartTime) / channelStatistics.Count
	
	local t0 = SysTime()
	handler( len - 16, client )
	local dt = SysTime() - t0
	
	channelStatistics.MaximumTime = math.max( channelStatistics.MaximumTime, dt )
	channelStatistics.TotalTime = channelStatistics.TotalTime + dt
	channelStatistics.MeanTime = channelStatistics.TotalTime / channelStatistics.Count
end

local function sorted_pairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local function PadLeft (s, n)
	s = tostring (s)
	return string.rep( " ", n - #s ) .. s
end

local function PadRight (s, n)
	s = tostring (s)
	return s .. string.rep( " ", n - #s )
end

function net.DumpStats(sortKey)
	local sortKey = sortKey or "Count"
	if sortKey ~= "Count" and
	   sortKey ~= "AverageInterval" and
	   sortKey ~= "TotalLength" and
	   sortKey ~= "MaximumLength" and
	   sortKey ~= "MeanLength"  and
	   sortKey ~= "TotalTime" and
	   sortKey ~= "MaximumTime" and
	   sortKey ~= "MeanTime" then 
		sortKey = "Count"
	end
	
	print("Net dump [" .. table.Count(net.ChannelStatistics) .. "] over " .. string.format ( "%.2f s", SysTime () - net.ProfileStartTime ) .. ":")
	
	for k, v in sorted_pairs(net.ChannelStatistics, function(t, a, b) return t[a][sortKey] > t[b][sortKey] end) do
		print("  " .. PadRight( k, 36 ) .. ", " ..
		      "Count: "           .. PadLeft( v.Count, 6 ) .. ", " .. 
		      "AverageInterval: " .. PadLeft( string.format( "%.2f s", v.AverageInterval ), 9 ) .. ", " ..
			  "TotalLength: "     .. PadLeft( string.format( "%.2f", v.TotalLength   ), 11 ) .. " B, " ..
			  "MaximumLength: "   .. PadLeft( string.format( "%.2f", v.MaximumLength ),  8 ) .. " B, " ..
			  "MeanLength: "      .. PadLeft( string.format( "%.2f", v.MeanLength    ),  8 ) .. " B, " ..
			  "TotalTime: "       .. PadLeft( string.format( "%.3f ms", v.TotalTime   * 1000 ), 13 ) .. ", " ..
			  "MaximumTime: "     .. PadLeft( string.format( "%.3f ms", v.MaximumTime * 1000 ), 11 ) .. ", " ..
			  "MeanTime: "        .. PadLeft( string.format( "%.3f ms", v.MeanTime    * 1000 ), 11 ))
	end
end

concommand.Add("netdump" .. (CLIENT and "_cl" or ""),
	function(ply, cmd, args)
		net.DumpStats(args[1]) 
	end,
	nil,
	"netdump [<sort key: Count, AverageInterval, TotalLength, MaximumLength, MeanLength, TotalTime, MaximumTime, MeanTime>]"
)