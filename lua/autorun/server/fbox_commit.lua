function FBCheckGitHub()
	http.Fetch("https://api.github.com/repos/B1IS/FlexBoxV2/commits",
	function(data)
		timer.Simple(.5, function()
			local tab = util.JSONToTable(data)[1]
			
			if cookie.GetNumber( "github_latest", 0 ) == tab["updated"] then return end
			cookie.Set( "newsbot440_date", tab["date"] )
			ChatAddText("================================================")
			ChatAddText(
				Color(255, 255, 255),
				"<texture=icon16/arrow_merge.png>",
				Color(200, 0, 100), 
				tab['commit']['author']['name'], 
				Color(255, 255, 255), 
				" commited <", 
				Color(200, 200, 0), 
				string.sub( tab['sha'], 1, 7 ), 
				Color(255, 255, 255), 
				">:"
			)
			ChatAddText(tab['commit']['message'])
			ChatAddText("================================================")
			
			snd = "garrysmod/save_load" .. math.random(1, 4) .. ".wav"
			BroadcastLua("surface.PlaySound(\"" .. snd .. "\")")
		end)
	end,
	function(f)
		print"failed to load github request!"
	end)
end

timer.Create("FBCheckGitHub", 120, 0, FBCheckGitHub)