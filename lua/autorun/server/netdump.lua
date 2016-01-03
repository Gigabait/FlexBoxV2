net.PacketStats = {}
net.ProfileTime = SysTime()

function net.Incoming( len, client )

	local i = net.ReadHeader()
	local strName = util.NetworkIDToString( i )

	if ( !strName ) then return end

	local func = net.Receivers[ strName:lower() ]
	if ( !func ) then return end

	len = len - 16

	-- Keep track of biggest shit.
	local cur = net.PacketStats[strName] or { Name = strName, Count = 0, Len = 0, Freq = 0, CbTime = 0 }

	if len > cur.Len then
		cur.Len = len
	end

	cur.Count = cur.Count + 1

	local timeElapsed = SysTime() - net.ProfileTime
	local frequency = timeElapsed / cur.Count

	cur.Freq = frequency

	local cbTimeStart = SysTime()
	func( len, client )
	local cbTime = SysTime() - cbTimeStart

	if cbTime > cur.CbTime then
		cur.CbTime = cbTime
	end

	net.PacketStats[strName] = cur

end

local function spairs(t, order)
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

function net.DumpStats(sortKey)

	local sortKey = sortKey or "Count"
	if sortKey ~= "Count" and sortKey ~= "Freq" and sortKey ~= "Len" and sortKey ~= "CbTime" then
		sortKey = "Count"
	end

	print("Net Dump: " .. table.Count(net.PacketStats))

	for k,v in spairs(net.PacketStats, function(t, a, b) return t[a][sortKey] > t[b][sortKey] end) do

		v.CbTime = v.CbTime or 0
		print("  " .. k .. ", Count: " .. v.Count .. ", Freq: " .. v.Freq .. ", Len: " .. v.Len .. " b, Callback Time: " .. v.CbTime)

	end

end

concommand.Add("netdump", function(ply, cmd, args)
	net.DumpStats(args[1])
end, nil, "netdump [<sort key: Count, Freq, Len, CbTime>]")