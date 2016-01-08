--[[
FlexBox Commit Grab v1
By Flex
Feel free to modify
--]]
local Tag = "CommitGrab"
CommitGrab = CommitGrab or {}
CommitGrab.Repos = {
	"B1IS/FlexBoxV2",
	"LUModder/FWP",
}
CommitGrab.Data = {}
CommitGrab.OldData = {}
CommitGrab.CommitData = {}
CommitGrab.OldCommitData = {}
CommitGrab.LatestCommit = {}

for _,repo in pairs(CommitGrab.Repos) do
	http.Fetch("https://api.github.com/repos/"..repo.."/commits",
	function(body)
		CommitGrab.Data[repo] = util.JSONToTable(body)
		CommitGrab.LatestCommit[repo] = CommitGrab.Data[repo][1]
	end,
	function(err)
		MsgC(Color(100,200,100),"[CommitGrab] ",color_white,"Error getting data: "..err.."(repo: "..repo..")\n")
	end)
end

function CommitGrab.GrabData()
	for _,repo in pairs(CommitGrab.Repos) do
		http.Fetch("https://api.github.com/repos/"..repo.."/commits",
		function(body)
			CommitGrab.OldData[repo] = CommitGrab.Data[repo]
			CommitGrab.Data[repo] = util.JSONToTable(body)
		end,
		function(err)
			MsgC(Color(100,200,100),"[CommitGrab] ",color_white,"Error getting data: "..err.."(repo: "..repo..")\n")
		end)
	end
end

function CommitGrab.GrabCommitData()
	for _,repo in pairs(CommitGrab.Repos) do
		http.Fetch("https://api.github.com/repos/"..repo.."/commits/"..CommitGrab.LatestCommit[repo].sha,
		function(body)
			CommitGrab.OldCommitData[repo] = CommitGrab.CommitData[repo]
			CommitGrab.CommitData[repo] = util.JSONToTable(body)
		end,
		function(err)
			MsgC(Color(100,200,100),"[CommitGrab] ",color_white,"Error getting data: "..err.." (repo: "..repo..")\n")
		end)
	end
end

function CommitGrab.AnnounceCommit(repo)
	for _,pl in pairs(player.GetAll()) do
			pl:PrintMessage(3,"<color=100,200,100>Latest commit for <color=255,255,255>"..repo.."<color=100,200,100>:")
			pl:PrintMessage(3,"<color=100,200,100>Commit <color=255,255,255>"..CommitGrab.LatestCommit[repo].sha.." <color=100,200,100>by <color=255,255,255>"..CommitGrab.LatestCommit[repo].commit.author.name)
			pl:PrintMessage(3,"<color=255,255,255>\t"..CommitGrab.LatestCommit[repo].commit.message)
			pl:PrintMessage(3,"<color=100,200,100>Files:")
			for _,f in pairs(CommitGrab.CommitData[repo].files) do
				if f.additions == 0 then prefix = "D"
				elseif f.deletions == 0 then prefix = "A"
				else prefix = "U" end
				pl:PrintMessage(3,"<color=255,255,255>"..prefix.."\t"..f.filename)
			end
	end
end

--hook.Add("Tick",Tag..".UpdateCommits",function()
timer.Create(Tag..".UpdateCommits",0,0,function()
	CommitGrab.GrabData()
	CommitGrab.GrabCommitData()
	timer.Simple(10,function()
		for _,repo in pairs(CommitGrab.Repos) do
			if CommitGrab.Data[repo][1].sha != CommitGrab.LatestCommit[repo].sha then
				CommitGrab.LatestCommit[repo] = CommitGrab.Data[repo][1]
				timer.Simple(1,function()
					CommitGrab.AnnounceCommit(repo)
				end)
			end
		end
	end)
end)