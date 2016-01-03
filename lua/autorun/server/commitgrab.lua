--[[
FlexBox Commit Grab v1
By Flex
Feel free to modify
]]--
local Tag = "CommitGrab"
CommitGrab = CommitGrab or {}

http.Fetch("https://api.github.com/repos/B1IS/FlexBoxV2/commits",
function(body)
	CommitGrab.Data = util.JSONToTable(body)
	CommitGrab.LatestCommit = CommitGrab.Data[1]
end,
function(err)
	MsgC(Color(100,200,100),"[CommitGrab] ",color_white,"Error getting data: "..err)
end)

function CommitGrab.GrabData()
	http.Fetch("https://api.github.com/repos/B1IS/FlexBoxV2/commits",
	function(body)
		CommitGrab.OldData = CommitGrab.Data
		CommitGrab.Data = util.JSONToTable(body)
	end,
	function(err)
		MsgC(Color(100,200,100),"[CommitGrab] ",color_white,"Error getting data: "..err)
	end)
end

function CommitGrab.GrabCommitData()
	http.Fetch("https://api.github.com/repos/B1IS/FlexBoxV2/commits/"..CommitGrab.LatestCommit.sha,
	function(body)
		CommitGrab.OldCommitData = CommitGrab.CommitData
		CommitGrab.CommitData = util.JSONToTable(body)
	end,
	function(err)
		MsgC(Color(100,200,100),"[CommitGrab] ",color_white,"Error getting commit data: "..err)
	end)
end

function CommitGrab.AnnounceCommit()
	for _,pl in pairs(player.GetAll()) do
		pl:PrintMessage(3,"Latest FlexBox repo commit:")
		pl:PrintMessage(3,"Commit "..CommitGrab.LatestCommit.sha.." by "..CommitGrab.LatestCommit.commit.author.name)
		pl:PrintMessage(3,"\t"..CommitGrab.LatestCommit.commit.message)
		pl:PrintMessage(3,"Files:")
		for _,f in pairs(CommitGrab.CommitData.files) do
			if f.additions == 0 then prefix = "D"
			elseif f.deletions == 0 then prefix = "A"
			else prefix = "U" end
			pl:PrintMessage(3,prefix.."\t"..f.filename)
		end
	end
end

timer.Create(Tag..".UpdateCommits",60,0,function()
	CommitGrab.GrabData()
	CommitGrab.GrabCommitData()
	timer.Simple(10,function()
		if CommitGrab.Data[1].sha != CommitGrab.LatestCommit.sha then
			CommitGrab.LatestCommit = CommitGrab.Data[1]
			timer.Simple(1,function()
				CommitGrab.AnnounceCommit()
			end)
		end
	end)
end)