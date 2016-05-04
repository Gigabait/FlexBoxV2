function FBCheckGitHub()
	http.Fetch("https://api.github.com/repos/B1IS/FlexBoxV2/commits",
	function(data)
		timer.Simple(.5, function()
			local tab = util.JSONToTable(data)[1]

			if cookie.GetString( "github_latest", "" ) == tab["sha"] then return end
			cookie.Set( "github_latest", tab["sha"] )
			ChatAddText(Color(255,255,255),"Latest Github Commit:")
			ChatAddText(Color(255, 255, 255),"<texture=icon16/page_edit.png> ",Color(220,70,100),string.format("Commit %s by %s",tab["sha"],tab["commit"]["author"]["name"]))
			ChatAddText(Color(255, 255, 255),tab["commit"]["message"])

			http.Fetch("https://api.github.com/repos/B1IS/FlexBoxV2/commits/"..tab["sha"],
			function(data)
				local files = util.JSONToTable(data).files

				for _,file in pairs(files) do
					local stat = file.status == "added" and "A" or file.status == "deleted" and "D" or "M"
					ChatAddText(Color(255,255,255),string.format("\t%s %s",stat,file.filename))
				end
			end,
			function(f)
				print"failed to get commit data"
			end)

			snd = "garrysmod/save_load" .. math.random(1, 4) .. ".wav"
			BroadcastLua("surface.PlaySound(\"" .. snd .. "\")")
		end)
	end,
	function(f)
		print"failed to load github request!"
	end)
end

timer.Create("FBCheckGitHub", 120, 0, FBCheckGitHub)