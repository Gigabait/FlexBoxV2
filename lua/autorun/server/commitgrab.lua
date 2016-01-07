--[[
FlexBox Commit Grab v1
By Flex
Feel free to modify
]]--
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
		MsgC(Color(100,200,100),"[CommitGrab] ",color_white,"Error getting data: "..err.."(repo: "..repo..")")
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
			MsgC(Color(100,200,100),"[CommitGrab] ",color_white,"Error getting data: "..err.."(repo: "..repo..")")
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
			MsgC(Color(100,200,100),"[CommitGrab] ",color_white,"Error getting data: "..err.."(repo: "..repo..")")
		end)
	end
end

function CommitGrab.AnnounceCommit(repo)
	for _,pl in pairs(player.GetAll()) do
			pl:PrintMessage(3,"Latest commit for "..repo..":")
			pl:PrintMessage(3,"Commit "..CommitGrab.LatestCommit[repo].sha.." by "..CommitGrab.LatestCommit[repo].commit.author.name)
			pl:PrintMessage(3,"\t"..CommitGrab.LatestCommit[repo].commit.message)
			pl:PrintMessage(3,"Files:")
			for _,f in pairs(CommitGrab.CommitData[repo].files) do
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