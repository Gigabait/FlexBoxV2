easylua.StartEntity("lua_npc_wander")

ENT.Base 					= "base_ai"
ENT.Type 					= "ai"
ENT.Author					= "Potatofactory, Flex, Mare"
ENT.Spawnable 				= false
ENT.AdminSpawnable 			= false
ENT.PrintName 				= "Citizen"
ENT.LastProp				= "error.mdl"
ENT.dropped					= false

if CLIENT then
	ENT.lobbyok = true
	ENT.PhysgunDisabled = true
	ENT.m_tblToolsAllowed = {}
	function ENT:CanConstruct() return true end
	function ENT:CanTool() return true end
	function ENT:Draw()
		self:DrawModel()
	end
end

-- names
local function namestr(l)
	local t={}
	for n in l:gmatch'[^%s]+' do
		t[#t+1] = n
	end
	return t
end

local names = {
	male = namestr[[MIKE STANLEY LEONARD NATHAN DALE MANUEL RODNEY CURTIS NORMAN ALLEN MARVIN VINCENT GLENN JEFFERY TRAVIS JEFF CHAD JACOB LEE MELVIN ALFRED KYLE FRANCIS BRADLEY JESUS HERBERT FREDERICK RAY JOEL EDWIN DON EDDIE TROY RANDALL BARRY ALEXANDER BERNARD MARIO LEROY FRANCISCO MARCUS MICHEAL THEODORE CLIFFORD MIGUEL OSCAR JAY JIM TOM CALVIN ALEX JON RONNIE BILL LLOYD TOMMY LEON DEREK WARREN DARRELL JEROME FLOYD LEO ALVIN TIM WESLEY GORDON DEAN GREG JORGE DUSTIN PEDRO DERRICK DAN LEWIS ZACHARY COREY HERMAN MAURICE VERNON ROBERTO CLYDE GLEN HECTOR SHANE RICARDO SAM RICK LESTER BRENT RAMON CHARLIE TYLER GILBERT GENE MARC REGINALD GABE ADAM]],
	female = namestr[[AMY ANNA REBECCA VIRGINIA PAMELA MARTHA DEBRA AMANDA STEPHANIE CAROLYN CHRISTINE MARIE JANET CATHERINE FRANCES ANN JOYCE DIANE ALICE JULIE HEATHER TERESA DORIS GLORIA EVELYN JEAN CHERYL MILDRED KATHERINE JOAN ASHLEY JUDITH ROSE JANICE KELLY NICOLE JUDY CHRISTINA KATHY THERESA DENISE TAMMY IRENE JANE LORI RACHEL MARILYN ANDREA LOUISE SARA ANNE JACQUELINE WANDA BONNIE JULIA RUBY LOIS TINA PHYLLIS NORMA PAULA DIANA ANNIE LILLIAN EMILY ROBIN PEGGY CRYSTAL GLADYS RITA DAWN CONNIE FLORENCE TRACY EDNA TIFFANY CARMEN ROSA CINDY GRACE WENDY VICTORIA EDITH KIM SHERRY SYLVIA JOSEPHINE SHANNON ETHEL ELLEN ELAINE MARJORIE CARRIE CHARLOTTE MONICA ESTHER PAULINE EMMA JUANITA ANITA RHONDA HAZEL AMBER EVA DEBBIE APRIL LESLIE CLARA LUCILLE JAMIE JOANNE ELEANOR VALERIE DANIELLE MEGAN ALICIA SUZANNE MICHELE GAIL LINDSEY LINDA]],
	last = namestr[[SUGAR NUWELL OLDENBURGER FREEMAN STEGEMANN WILSON POTATO MANN KRISTINE DOE BRACKET KNIFING HALO OCTOPUS PROXY DESTANY POCO HILL PLAYER]]
}

function ENT:RandomName(gender)
	local gender = gender and "male" or "female"
	local n = names[gender][math.random(1, #names[gender])]
	local l = names["last"][math.random(1, #names["last"])]
	n = n:sub(1,1)..n:sub(2,-1):lower()
	l = l:sub(1,1)..l:sub(2,-1):lower()
	return string.format("%s %s", n, l)
end

function ENT:GetCitizenName()
	return self:RandomName(self:GetGender() == "male" and true or false) or "Citizen"
end

function ENT:GetGender()
	self.__gender = self:GetModel():lower():find("female",1,true)
		and "female" or "male"
	return self.__gender
end

if SERVER then
	ENT.AutomaticFrameAdvance	= true


	ENT.sounds = {
		female = {
			greet = {
				"vo/npc/female01/hi01.wav",
				"vo/npc/female01/hi02.wav",
				"vo/coast/odessa/female01/nlo_cheer01.wav",
				"vo/npc/female01/excuseme01.wav",
				"vo/npc/female01/excuseme02.wav",
				"vo/trainyard/female01/cit_hit04.wav",
				"vo/npc/female01/pardonme01.wav",
				"vo/npc/female01/pardonme02.wav",
				"vo/npc/female01/answer32.wav",
				"vo/npc/female01/answer30.wav",
				"vo/npc/female01/answer09.wav",
				"vo/npc/female01/answer01.wav",
				"vo/npc/female01/nice01.wav",
				"vo/npc/female01/outofyourway02.wav",
				"vo/trainyard/female01/cit_window_use01.wav",
				"vo/npc/female01/ohno.wav",
				--random on touch chatter goes here
			},
			bench = {
				"vo/trainyard/female01/cit_bench01.wav",
				"vo/trainyard/female01/cit_bench02.wav",
				"vo/trainyard/female01/cit_bench03.wav",
				"vo/trainyard/female01/cit_bench04.wav",
			},
			player_hit = {
				"vo/npc/female01/startle01.wav",
				"vo/npc/female01/startle02.wav",
				"vo/trainyard/female01/cit_hit01.wav",
				"vo/trainyard/female01/cit_hit02.wav",
				"vo/trainyard/female01/cit_hit03.wav",
				"vo/trainyard/female01/cit_hit04.wav",
				"vo/trainyard/female01/cit_hit05.wav",
				"vo/npc/female01/hitingut01.wav",
				"vo/npc/female01/hitingut02.wav",
				"vo/npc/female01/mygut02.wav",
				"vo/npc/female01/imhurt01.wav",
				"vo/npc/female01/imhurt02.wav",
				"vo/npc/female01/ow01.wav",
				"vo/npc/female01/ow02.wav",
				"vo/npc/alyx/gasp02.wav",
				"vo/npc/alyx/gasp03.wav",
				"vo/npc/female01/stopitfm.wav",
			},
			npc_hit = {
				-- Combine
				["npc_metropolice"] = {
					"vo/npc/female01/cps01.wav",
					"vo/npc/female01/cps02.wav",
					"vo/npc/female01/civilprotection01.wav",
					"vo/npc/female01/civilprotection02.wav",
				},
				["npc_combine_s"] = {
					"vo/npc/female01/combine01.wav",
					"vo/npc/female01/combine02.wav",
					"vo/npc/female01/heretheycome01.wav",
					"vo/npc/female01/incoming02.wav",
				},
				["npc_manhack"] = {
					"vo/npc/female01/hacks01.wav",
					"vo/npc/female01/hacks02.wav",
					"vo/npc/female01/herecomehacks01.wav",
					"vo/npc/female01/herecomehacks02.wav",
					"vo/npc/female01/thehacks01.wav",
					"vo/npc/female01/thehacks02.wav",
				},
				["npc_combinegunship"] = {
					"vo/coast/barn/female01/lite_gunship01.wav",
					"vo/coast/barn/female01/lite_gunship02.wav",
					"vo/npc/female01/incoming02.wav",
					"vo/npc/female01/strider_run.wav",
				},
				["npc_strider"] = {
					"vo/npc/female01/strider.wav",
					"vo/npc/female01/strider_run.wav",
				},

				-- Xen Creatures
				["npc_headcrab"] = {
					"vo/npc/female01/headcrabs01.wav",
					"vo/npc/female01/headcrabs02.wav"
				},
				["npc_headcrab_fast"] = {
					"vo/npc/female01/headcrabs01.wav",
					"vo/npc/female01/headcrabs02.wav"
				},
				["npc_headcrab_black"] = {
					"vo/npc/female01/headcrabs01.wav",
					"vo/npc/female01/headcrabs02.wav"
				},
				["npc_zombie"] = {
					"vo/npc/female01/zombies01.wav",
					"vo/npc/female01/zombies02.wav",
					"vo/canals/female01/stn6_shellingus.wav"
				},
				["npc_fastzombie"] = {
					"vo/npc/female01/zombies01.wav",
					"vo/npc/female01/zombies02.wav",
					"vo/canals/female01/stn6_shellingus.wav"
				},
				["npc_poisonzombie"] = {
					"vo/npc/female01/zombies01.wav",
					"vo/npc/female01/zombies02.wav",
					"vo/canals/female01/stn6_shellingus.wav"
				},
				["npc_zombie_torso"] = {
					"vo/npc/female01/zombies01.wav",
					"vo/npc/female01/zombies02.wav",
					"vo/canals/female01/stn6_shellingus.wav"
				},
				["npc_fastzombie_torso"] = {
					"vo/npc/female01/zombies01.wav",
					"vo/npc/female01/zombies02.wav",
					"vo/canals/female01/stn6_shellingus.wav"
				},
				["npc_fastzombie_torso"] = {
					"vo/npc/female01/zombies01.wav",
					"vo/npc/female01/zombies02.wav",
					"vo/canals/female01/stn6_shellingus.wav"
				},
				["npc_mine_zombie"] = {
					"vo/npc/female01/zombies01.wav",
					"vo/npc/female01/zombies02.wav",
				},

				-- eh

				["other"] = {
					"vo/npc/female01/hitingut01.wav",
					"vo/npc/female01/hitingut02.wav",
					"vo/npc/female01/imhurt01.wav",
					"vo/npc/female01/imhurt02.wav",
					"vo/npc/female01/ow01.wav",
					"vo/npc/female01/ow02.wav",
				},

			},
			death = {
				"vo/npc/female01/moan01.wav",
				"vo/npc/female01/moan02.wav",
				"vo/npc/female01/moan03.wav",
				"vo/npc/female01/moan04.wav",
				"vo/npc/female01/moan05.wav",
			},
			death_react = {
				"vo/npc/female01/gordead_ques01.wav",
				"vo/npc/female01/gordead_ques02.wav",
				"vo/npc/female01/gordead_ques06.wav",
				"vo/npc/female01/gordead_ques06.wav",
				"vo/npc/female01/gordead_ques11.wav",
				"vo/npc/female01/gordead_ques14.wav",
				"vo/npc/female01/gordead_ans01.wav",
				"vo/npc/female01/gordead_ans02.wav",
				"vo/npc/female01/gordead_ans04.wav",
				"vo/npc/female01/gordead_ans05.wav",
				"vo/npc/female01/gordead_ans06.wav",
				"vo/npc/female01/gordead_ans07.wav",
				"vo/npc/female01/gordead_ans08.wav",
				"vo/npc/female01/gordead_ans12.wav",
				"vo/npc/female01/gordead_ans15.wav",
				"vo/npc/female01/gordead_ans19.wav",
				"vo/npc/female01/gordead_ans19.wav",
				"vo/npc/female01/gordead_ans19.wav",
			},
			scared = {
				"vo/canals/female01/stn6_incoming.wav",
				"vo/coast/odessa/female01/nlo_cubdeath01.wav",
				"vo/coast/odessa/female01/nlo_cubdeath02.wav",
				"vo/npc/female01/notthemanithought02.wav",
				"vo/npc/female01/notthemanithought01.wav",
				"vo/npc/female01/imhurt02.wav",
				"vo/npc/female01/help01.wav",
				"vo/npc/female01/stopitfm.wav",
				--scared voice goes here
			},
			conversation = {
				"vo/canals/female01/gunboat_owneyes.wav",
				"vo/canals/female01/gunboat_justintime.wav",
				"vo/npc/female01/question02.wav",
				"vo/npc/female01/question04.wav",
				"vo/npc/female01/question06.wav",
				"vo/npc/female01/question07.wav",
				"vo/npc/female01/question10.wav",
				"vo/npc/female01/question14.wav",
				"vo/npc/female01/question16.wav",
				"vo/npc/female01/question20.wav",
				"vo/npc/female01/question22.wav",
				"vo/npc/female01/question23.wav",
				"vo/npc/female01/squad_greet01.wav",
				"vo/npc/female01/squad_greet04.wav",
				"vo/npc/female01/squad_greet04.wav",
			}
		},
		male = {
			greet = {
				"vo/npc/male01/hi01.wav",
				"vo/npc/male01/hi02.wav",
				"vo/npc/male01/excuseme01.wav",
				"vo/npc/male01/excuseme02.wav",
				"vo/npc/male01/busy02.wav",
				"vo/npc/male01/answer40.wav",
				"vo/npc/male01/answer39.wav",
				"vo/npc/male01/answer30.wav",
				"vo/npc/male01/answer05.wav",
				--random on touch chatter goes here
			},
			bench = {
				"vo/trainyard/male01/cit_bench01.wav",
				"vo/trainyard/male01/cit_bench02.wav",
				"vo/trainyard/male01/cit_bench03.wav",
				"vo/trainyard/male01/cit_bench04.wav",
			},
			player_hit = {
				"vo/npc/male01/startle01.wav",
				"vo/npc/male01/startle02.wav",
				"vo/trainyard/male01/cit_hit01.wav",
				"vo/trainyard/male01/cit_hit02.wav",
				"vo/trainyard/male01/cit_hit03.wav",
				"vo/trainyard/male01/cit_hit04.wav",
				"vo/trainyard/male01/cit_hit05.wav",
				"vo/npc/male01/hitingut01.wav",
				"vo/npc/male01/hitingut02.wav",
				"vo/npc/male01/mygut02.wav",
				"vo/npc/male01/imhurt01.wav",
				"vo/npc/male01/imhurt02.wav",
				"vo/npc/male01/ow01.wav",
				"vo/npc/male01/ow02.wav",
				"vo/npc/male01/stopitfm.wav",
			},
			npc_hit = {
				-- Combine
				["npc_metropolice"] = {
					"vo/npc/male01/cps01.wav",
					"vo/npc/male01/cps02.wav",
					"vo/npc/male01/civilprotection01.wav",
					"vo/npc/male01/civilprotection02.wav",
				},
				["npc_combine_s"] = {
					"vo/npc/male01/combine01.wav",
					"vo/npc/male01/combine02.wav",
					"vo/npc/male01/heretheycome01.wav",
					"vo/npc/male01/incoming02.wav",
				},
				["npc_manhack"] = {
					"vo/npc/male01/hacks01.wav",
					"vo/npc/male01/hacks02.wav",
					"vo/npc/male01/herecomehacks01.wav",
					"vo/npc/male01/herecomehacks02.wav",
					"vo/npc/male01/thehacks01.wav",
					"vo/npc/male01/thehacks02.wav",
				},
				["npc_combinegunship"] = {
					"vo/coast/barn/male01/lite_gunship01.wav",
					"vo/coast/barn/male01/lite_gunship02.wav",
					"vo/npc/male01/incoming02.wav",
					"vo/npc/male01/strider_run.wav",
				},
				["npc_strider"] = {
					"vo/npc/male01/strider.wav",
					"vo/npc/male01/strider_run.wav",
				},

				-- Xen Creatures
				["npc_headcrab"] = {
					"vo/npc/male01/headcrabs01.wav",
					"vo/npc/male01/headcrabs02.wav"
				},
				["npc_headcrab_fast"] = {
					"vo/npc/male01/headcrabs01.wav",
					"vo/npc/male01/headcrabs02.wav"
				},
				["npc_headcrab_black"] = {
					"vo/npc/male01/headcrabs01.wav",
					"vo/npc/male01/headcrabs02.wav"
				},
				["npc_zombie"] = {
					"vo/npc/male01/zombies01.wav",
					"vo/npc/male01/zombies02.wav",
					"vo/canals/male01/stn6_shellingus.wav"
				},
				["npc_fastzombie"] = {
					"vo/npc/male01/zombies01.wav",
					"vo/npc/male01/zombies02.wav",
					"vo/canals/male01/stn6_shellingus.wav"
				},
				["npc_poisonzombie"] = {
					"vo/npc/male01/zombies01.wav",
					"vo/npc/male01/zombies02.wav",
					"vo/canals/male01/stn6_shellingus.wav"
				},
				["npc_zombie_torso"] = {
					"vo/npc/male01/zombies01.wav",
					"vo/npc/male01/zombies02.wav",
					"vo/canals/male01/stn6_shellingus.wav"
				},
				["npc_fastzombie_torso"] = {
					"vo/npc/male01/zombies01.wav",
					"vo/npc/male01/zombies02.wav",
					"vo/canals/male01/stn6_shellingus.wav"
				},
				["npc_fastzombie_torso"] = {
					"vo/npc/male01/zombies01.wav",
					"vo/npc/male01/zombies02.wav",
					"vo/canals/male01/stn6_shellingus.wav"
				},
				["npc_mine_zombie"] = {
					"vo/npc/male01/zombies01.wav",
					"vo/npc/male01/zombies02.wav",
				},

				-- eh

				["other"] = {
					"vo/npc/male01/hitingut01.wav",
					"vo/npc/male01/hitingut02.wav",
					"vo/npc/male01/imhurt01.wav",
					"vo/npc/male01/imhurt02.wav",
					"vo/npc/male01/ow01.wav",
					"vo/npc/male01/ow02.wav",
				},

			},
			death = {
				"vo/npc/male01/moan01.wav",
				"vo/npc/male01/moan02.wav",
				"vo/npc/male01/moan03.wav",
				"vo/npc/male01/moan04.wav",
				"vo/npc/male01/moan05.wav",
			},
			death_react = {
				"vo/npc/male01/gordead_ques01.wav",
				"vo/npc/male01/gordead_ques02.wav",
				"vo/npc/male01/gordead_ques06.wav",
				"vo/npc/male01/gordead_ques06.wav",
				"vo/npc/male01/gordead_ques11.wav",
				"vo/npc/male01/gordead_ques14.wav",
				"vo/npc/male01/gordead_ans01.wav",
				"vo/npc/male01/gordead_ans02.wav",
				"vo/npc/male01/gordead_ans04.wav",
				"vo/npc/male01/gordead_ans05.wav",
				"vo/npc/male01/gordead_ans06.wav",
				"vo/npc/male01/gordead_ans07.wav",
				"vo/npc/male01/gordead_ans08.wav",
				"vo/npc/male01/gordead_ans12.wav",
				"vo/npc/male01/gordead_ans15.wav",
				"vo/npc/male01/gordead_ans19.wav",
				"vo/npc/male01/gordead_ans19.wav",
				"vo/npc/male01/gordead_ans19.wav",
			},
			scared = {
				"vo/trainyard/male01/cit_hit01.wav",
				"vo/trainyard/male01/cit_hit02.wav",
				"vo/trainyard/male01/cit_hit03.wav",
				"vo/trainyard/male01/cit_hit04.wav",
				"vo/trainyard/male01/cit_hit05.wav",
				"vo/Streetwar/sniper/male01/c17_09_help01.wav",
				"vo/Streetwar/sniper/male01/c17_09_help02.wav",
				"vo/npc/male01/notthemanithought02.wav",
				"vo/npc/male01/heretohelp02.wav",
				"vo/npc/male01/stopitfm.wav",
				--scared voice goes here
			},
			conversation = {
				"vo/canals/male01/gunboat_owneyes.wav",
				"vo/canals/male01/gunboat_justintime.wav",
				"vo/npc/male01/question02.wav",
				"vo/npc/male01/question04.wav",
				"vo/npc/male01/question06.wav",
				"vo/npc/male01/question07.wav",
				"vo/npc/male01/question10.wav",
				"vo/npc/male01/question14.wav",
				"vo/npc/male01/question16.wav",
				"vo/npc/male01/question20.wav",
				"vo/npc/male01/question22.wav",
				"vo/npc/male01/question23.wav",
			}
		},
	}


	ENT.walktable = FBoxMapData[game.GetMap()].nodes and FBoxMapData[game.GetMap()].nodes.wanderer and FBoxMapData[game.GetMap()].nodes.wanderer.walktable or {Vector(0,0,0),}


	ENT.sittable = true

	ENT.sittable = FBoxMapData[game.GetMap()].nodes.sittable or {}

	local function RandomNPC()
		local npcs = ents.FindByClass("lua_npc_wander")
		local spawn = table.Random(FBoxMapData[game.GetMap()].nodes.wanderer.spawns)
		if #npcs >= 20 or not spawn then return end

		local wander = ents.Create("lua_npc_wander")
		wander:SetPos(spawn)
		wander:Spawn()
		wander:Activate()
	end

	timer.Create("ms_spawn_npcs", 4, 0, RandomNPC)

	local ENT=ENT

	function ENT:GetSittable()
		local t= ENT._sittable
		if t ==nil then
			t = self.sittable
			if t and t~=true then t=table.Copy(t) end
			ENT._sittable = t
		end
		return t
	end

	function ENT:GetWalktable()
		return self.walktable
	end

	ENT.PhysgunDisabled				= false
	ENT.Spawnable					= false
	ENT.m_tblToolsAllowed 			= {}
	function ENT:CanConstruct() return true end
	function ENT:CanTool() return true end
	ENT.AutomaticFrameAdvance		= true
	ENT.IsMSNPC						= true
	ENT.lobbyok						= true

	ENT.SoundDelay					= 4
	ENT.ScareDelay					= 20
	ENT.iDelay						= 0

	ENT.ANIM_sit = ai_schedule.New("anim_sit")
	ENT.ANIM_sit:AddTask("AlignSit")
	ENT.ANIM_sit:AddTask("PlaySequence", {Name="d1_t01_BreakRoom_Sit02_Entry", Speed = 0}) -- Sit down
	ENT.ANIM_sit:AddTask("PlaySequence", {Name="d1_t02_Plaza_Sit02", Dur = 1}) --Sitting
	ENT.ANIM_sit:AddTask("AlignSit", {fwd = -20} )
	ENT.ANIM_sit:AddTask("PlaySequence", {Name="d1_t02_Plaza_Sit02", Dur = 20}) --Sitting
	ENT.ANIM_sit:AddTask("PlaySequence", {Name="d1_t01_BreakRoom_Sit02_Exit", Speed = 0}) --stand up
	ENT.ANIM_sit:AddTask("EndSit")


	ENT.ANIM_talk01 = ai_schedule.New("talk01")
	ENT.ANIM_talk01:AddTask("PlaySequence", {Name="LineIdle01", Dur = 2, Speed = .25})
	ENT.ANIM_talk01:AddTask("EndWave")

	ENT.ANIM_talk02 = ai_schedule.New("talk02")
	ENT.ANIM_talk02:AddTask("PlaySequence", {Name="LineIdle02", Dur = 2, Speed = .25})
	ENT.ANIM_talk02:AddTask("EndWave")

	ENT.ANIM_talk03 = ai_schedule.New("talk03")
	ENT.ANIM_talk03:AddTask("PlaySequence", {Name="LineIdle03", Dur = 2, Speed = .25})
	ENT.ANIM_talk03:AddTask("EndWave")

	ENT.ANIM_wave = ai_schedule.New("anim_wave")
	ENT.ANIM_wave:AddTask("PlaySequence", {Name="Wave",ID = 77, Speed = 0, Dur = 5})
	ENT.ANIM_wave:AddTask("EndWave")

	ENT.REACT_pain = ai_schedule.New("pain")
	ENT.REACT_pain:AddTask("PlaySequence", {Name="Fear_Reaction"})

	function ENT:DBG(...)
		--Msg("[Wanderer "..tostring(self:EntIndex())..'] ') print(...)
	end
	function ENT:OnPlayerGreeting(pl,halloween_bag)
		local lg = self.actioncool or 0
		local now = CurTime()

		self:DBG("ongreet",pl,halloween_bag and "hwn" or "")
		if now-lg<3 then self:DBG("timeout",pl) return end
		if self:GetNPCState() == NPC_STATE_ALERT then self:DBG("alert",pl) return end

		self:DBG("hello",pl)

		self.actioncool = now

		local a = pl:GetPos() - self:GetPos()
		a:Normalize()
		self:SetAngles(a:Angle())
		self:PlayAnim(self.ANIM_wave)
		self:EmitSound("vo/npc/"..self:GetGender().."01/hi0"..math.random(1,2)..".wav")
	end

	function ENT:TaskStart_AlignSit(data)
		local fwd = 0
		local tracedown = util.TraceLine( {
			start = self:GetPos(),
			endpos = self:GetPos() - Vector(0, 0, 1e0),
		} )
		if data then
			fwd = data.fwd
		end
		self:TaskComplete()
		if not self.gotosit then return end
		self:SetAngles(self.gotosit[2])
		self.gotosit[1].Z = tracedown.HitPos.Z
		self:SetPos(self.gotosit[1] + self:GetForward() * fwd)
		self.bSitting = true
	end

	function ENT:TaskStart_StartTyping()
		self:TaskComplete()
		if not self.gotosit then return end
		self:SetPos(self.gototyping[1])
		self:SetAngles(self.gototyping[2])
		self.bTyping = true
	end

	function ENT:TaskStart_EndTyping()
		self:TaskComplete()
		self:SetNPCState(NPC_STATE_IDLE)
		self.gototyping = nil
		self.bTyping = false
	end

	function ENT:TaskStart_EndSit()
		self:SetPos(self:GetPos() + self:GetForward() * 5)
		self:TaskComplete()
		self:SetNPCState(NPC_STATE_IDLE)
		self.bSit = false
		if not self.gotosit then return end
		self:SetAngles(self.gotosit[2])
		self.gotosit[3] = false
		self.gotosit = nil
		self.bSitting = false
	end

	function ENT:TaskStart_EndWave(data)
		self:TaskComplete()
		self:SetNPCState(NPC_STATE_IDLE)
	end

	function ENT:Task_AlignSit()
		return
	end

	ENT.Task_EndSit, ENT.Task_EndWave = ENT.Task_AlignSit, ENT.Task_AlignSit

end

ENT.Models = {
	"male_01",
	"male_02",
	"male_03",
	"male_04",
	"male_05",
	"male_06",
	"male_07",
	"male_08",
	"male_09",
	"female_01",
	"female_02",
	"female_03",
	"female_04",
	"female_06",
	"female_07",
}

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	if SERVER then
		if tobool(math.random(0, 1)) then
			self:SetModel(math.random(1, 100) ~= 100 and "models/humans/group02/" .. table.Random(self.Models) .. ".mdl" or "models/gman_high.mdl")
			if self:GetModel() == "models/gman_high.mdl" then
				self:Give("weapon_citizensuitcase")
			else
				self:Give(table.Random({"weapon_citizensuitcase","weapon_citizenpackage"}))
			end
		elseif tobool(math.random(0, 1)) then
			self:SetModel("models/humans/group01/" .. table.Random(self.Models) .. ".mdl")
			self:Give(table.Random({"weapon_citizensuitcase","weapon_citizenpackage"}))
		else
			self:SetModel("models/humans/group03/" .. table.Random(self.Models) .. ".mdl")
			self:Give(table.Random({
				"weapon_ar2",
				"weapon_smg1",
				"weapon_357",
				"weapon_pistol",
			}))
		end
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetLagCompensated( true )
		self:SetTrigger(true)
		self:CapabilitiesAdd(bit.bor( CAP_USE , CAP_AUTO_DOORS , CAP_OPEN_DOORS , CAP_ANIMATEDFACE , CAP_TURN_HEAD , CAP_MOVE_GROUND, CAP_USE_WEAPONS, CAP_AIM_GUN, CAP_WEAPON_RANGE_ATTACK1 ))
		self:SetMaxYawSpeed(20)
		self:SetHealth(60)
		self:SetNPCState(NPC_STATE_IDLE)
		if self:GetModel() == "models/gman_high.mdl" then
			self:SetNWString("CitizenName", "G-Man")
		else
			self:SetNWString("CitizenName", self:GetCitizenName())
		end
		self.LastSound = CurTime()
		self.next_alert = CurTime()
	end
end

if SERVER then
	ENT.next_alert = 0

	function ENT:PlaySound(type, npc)
		if self.LastSound > CurTime() then return end
		local sound = table.Random(self.sounds[self:GetGender()][type])
		if isstring(sound) then
			self:EmitSound(sound, math.random(90,100), math.random(90,110))
			self.busy = true
			self.LastSound = CurTime() + self.SoundDelay
		else
			sound = self.sounds[self:GetGender()][type]
			if math.random(1, 10) > 1 and sound[npc] then
				self:EmitSound(table.Random(sound[npc]), math.random(90,100), math.random(90,110))
				self.busy = true
				self.LastSound = CurTime() + self.SoundDelay
			else
				self:EmitSound(table.Random(sound["other"]), math.random(90,100), math.random(90,110))
				self.busy = true
				self.LastSound = CurTime() + self.SoundDelay
			end
		end
	end

	function ENT:PlayAnim(anim)
		self:SetNPCState(NPC_STATE_SCRIPT)
		self:StopMoving()
		self:StartSchedule(anim)
	end

	function ENT:GotoBench()
		local tab = self:GetSittable()
		local function FindClosestProp()
			local match = {
				distance = 1e9,
				ent = nil
			}
			local name = table.KeyFromValue(tab, table.Random(tab))
			if #ents.FindByModel(name) ~= 0 then
				for _, ent in pairs(ents.FindByModel(name)) do
					if self:GetPos():Distance(ent:GetPos()) <= match.distance and ent ~= self.LastProp then
						match.distance = self:GetPos():Distance(ent:GetPos())
						match.ent = ent
					end
				end
			else
				self:GotoBench()
			end

			if not match.ent then
				match.ent = self.LastProp
			end

			self.LastProp = match.ent

			return { match.ent:GetForward() * match.ent:LocalToWorld(table.Random(tab[match.ent:GetModel()])), match.ent:GetAngles() }
		end

		local t = FindClosestProp()

		self.gotosit = {
			t[1],
			t[2],
			false,
		}
		if self.gotosit then
			self:SetLastPosition( self.gotosit[1] )
			self:SetSchedule( SCHED_FORCED_GO )
			self.bSit = true
		end
	end

	local ai_disabled = GetConVar 'ai_disabled'
	function ENT:Think()
		local ang = self:GetAngles() --fix funny walking
		ang.p, ang.r = 0, 0
		self:SetAngles(ang)

		if ai_disabled:GetBool() or self:GetNPCState() == NPC_STATE_DEAD or self:GetNPCState() == NPC_STATE_SCRIPT or self.iDelay > RealTime() then return end

		if self.bSit and not self.bSitting and self:GetPos():Distance(self.gotosit[1]) > 22 and self.iDelay - RealTime() <= 0 then
			self.bSit = false -- Fuck it, It's too far
		else
			if self.bSit and self:GetPos():Distance(self.gotosit[1]) < 22 and not self.bSitting then
				self:PlayAnim(self.ANIM_sit)
			elseif not self.bSit then
				if self:GetNPCState() == NPC_STATE_ALERT and self.bScared then
					self:SetNPCState( NPC_STATE_IDLE )
					self.bScared = nil
				elseif self:GetNPCState() == NPC_STATE_NONE then
					self:SetNPCState( NPC_STATE_IDLE )
					self:SetExpression("scenes/Expressions/Citizenidle.vcd")
				end
				self:SelectSchedule()
			end
		end
	end

	function ENT:SelectSchedule()
		local state = self:GetNPCState()
		if self.iDelay - RealTime() > 0 or state == NPC_STATE_SCRIPT or self.bSit then
			return
		elseif state == NPC_STATE_IDLE then
			if self:GetModel() == "models/gman_high.mdl" then
				self:SetSched( SCHED_FORCED_GO )
			end
			if math.random(1, 10) == 1 then
				self:GotoBench()
				self.iDelay = RealTime() + 30
			else
				self:SetLastPosition(table.Random(self:GetWalktable()) + Vector( 0, 0, 40 ))
				if math.random(1, 10) == 1 then
					self:SetSched( SCHED_FORCED_GO_RUN )
					self.iDelay = RealTime() + 10
				else
					self:SetSched( SCHED_FORCED_GO )
					self.iDelay = RealTime() + 20
				end
			end
		elseif state == NPC_STATE_ALERT then
			self:SetLastPosition( table.Random(self:GetWalktable()) + Vector( 0, 0, 40 ) )
			self:SetSchedule( SCHED_FORCED_GO_RUN )
			self.iDelay = RealTime() + self.ScareDelay
			self.bScared = true
		end
	end

	function ENT:AlertOthers()

		if self:Health() > 0 then
			self:PlayAnim(self.REACT_pain)
		end

		local isalert = self:GetNPCState() == NPC_STATE_ALERT

		if isalert and self.next_alert > CurTime() then
			return
		end

		self.next_alert = CurTime() + 4

		local class=self:GetClass()

		for k,v in next,ents.FindInSphere(self:GetPos(),1024) do
			if v:GetClass()==class then
				if v ~= self then
					if math.random(0, 2) == 1 then
						if self:Health() <= 0 then
							v:PlaySound("death_react")
						else
							v:PlaySound("scared")
						end
					end
				end

				if v.bSit then
					v:TaskStart_EndSit()
				end
				v:SetExpression("scenes/Expressions/citizen_scared_idle_01.vcd")
				v:SetNPCState( NPC_STATE_ALERT )
				v.iDelay = 0
				v.next_alert = CurTime() + 5
				v:SelectSchedule()
			end
		end

	end

	function ENT:OnTakeDamage(dmg)
		if self:GetModel() == "models/gman_high.mdl" then
			dmg:GetAttacker():EmitSound("vo/Citadel/gman_exit02.wav")
			dmg:GetAttacker():Kill()
			self:Remove()
			return
		end

		if self:Health() <= 0 then return end

		if math.random(0, 1) == 1 and IsValid(self:GetActiveWeapon()) and not self.dropped then
			self.dropped = true
			local old = {
				model = self:GetActiveWeapon():GetModel(),
				pos = self:GetActiveWeapon():GetPos(),
				ang = self:GetActiveWeapon():GetAngles(),
			}
			self:GetActiveWeapon():Remove()
			if old.model == "models/weapons/w_package.mdl" then
				local droppedwep = ents.Create("item_healthkit")
				droppedwep:SetPos(old.pos + Vector(0, 0, 50))
				droppedwep:SetAngles(old.ang)
				droppedwep:Spawn()
				droppedwep:SetModel(old.model)
				droppedwep:Activate()
				droppedwep.NeedsToBeCollected = true
				timer.Simple(300, function()
					if IsValid(droppedwep) then
						droppedwep:Remove()
					end
				end)
			elseif old.model == "models/weapons/w_suitcase_passenger.mdl" then
				local droppedwep = ents.Create("prop_physics")
				droppedwep:SetPos(old.pos + Vector(0, 0, 50))
				droppedwep:SetAngles(old.ang)
				droppedwep:SetModel(old.model)
				droppedwep:Spawn()
				droppedwep:Activate()
				droppedwep.NeedsToBeCollected = true
				timer.Simple(10, function()
					if IsValid(droppedwep) then
						droppedwep:Remove()
					end
				end)

				for i = 1,math.random(1,10) do
					local droppedwep = ents.Create("lua_money_pickup")
					droppedwep:SetPos(old.pos + Vector(0, 0, 50))
					droppedwep:SetAngles(old.ang)
					droppedwep:Spawn()
					droppedwep:Activate()
					droppedwep.NeedsToBeCollected = true
					timer.Simple(300, function()
						if IsValid(droppedwep) then
							droppedwep:Remove()
						end
					end)
				end
			else
				local droppedwep = ents.Create("prop_physics")
				droppedwep:SetPos(old.pos + Vector(0, 0, 50))
				droppedwep:SetAngles(old.ang)
				droppedwep:Spawn()
				droppedwep:Activate()
				droppedwep.NeedsToBeCollected = true
				timer.Simple(10, function()
					if IsValid(droppedwep) then
						droppedwep:Remove()
					end
				end)
			end
		end

		self:SpawnBlood(dmg)
		self:SetExpression("scenes/Expressions/citizen_scared_alert_01.vcd")
		self:SetHealth(self:Health() - dmg:GetDamage())
		self:AlertOthers()

		local attacker = dmg:GetAttacker()

		if self:Health() <= 0 and self:GetNPCState() ~= NPC_STATE_DEAD then
			self:PlaySound("death")
			self:OnDamageDied(dmg)
		elseif self.LastSound < CurTime() then
			if attacker:IsNPC() then
				self:PlaySound("npc_hit", attacker:GetClass())
			else
				self:PlaySound("player_hit")
			end
			self.LastSound = CurTime() + self.SoundDelay
		end
	end

	function ENT:OnNPCKilled( attacker, inflictor )

		if self:GetNWString("CitizenName") == "G-Man" and SERVER then
			local hl2e = ents.Create("weapon_crowbar")
			hl2e:SetPos(self:GetPos() + Vector(0, 0, 10))
			hl2e:Spawn()
		end

		-- Convert the inflictor to the weapon that they're holding if we can.
		if ( inflictor and inflictor ~= NULL and attacker == inflictor and (inflictor:IsPlayer() or inflictor:IsNPC()) ) then

			inflictor = inflictor:GetActiveWeapon()
			if ( attacker == NULL ) then inflictor = attacker end

		end

		local InflictorClass = "World"
		local AttackerClass = "World"

		if ( IsValid( inflictor ) ) then InflictorClass = inflictor:GetClass() end
		if ( IsValid( attacker ) ) then

			AttackerClass = attacker:GetClass()

			if ( attacker:IsVehicle() and IsValid( attacker:GetDriver() ) ) then
				attacker = attacker:GetDriver()
			end

			if ( attacker:IsPlayer() ) then

				umsg.Start( "PlayerKilledNPC" )

					umsg.String( self:GetNWString("CitizenName") )
					umsg.String( InflictorClass )
					umsg.Entity( attacker )

				umsg.End()

				return
			end

		end

		umsg.Start( "NPCKilledNPC" )
			umsg.String( self:GetNWString("CitizenName") )
			umsg.String( InflictorClass )
			umsg.String( AttackerClass )
		umsg.End()

	end

	local nullf=function() end
	function ENT:OnDamageDied(dmg)

		local ent = dmg:GetAttacker()

		if ent:IsPlayer() then
			ent:SetFrags(ent:Frags() + 1)
		end
--
		--if string.find(self:GetNWString("CitizenName"), "Alien Citizen") then
		--	if ent:IsPlayer() then
		--		Say(ent:Nick() .. " helped make America better again!")
		--	elseif ent:IsNPC() then
		--		Say(ent:GetClass() .. " helped make America better again!")
		--	else
		--		Say("Donald Trump helped make America better again!")
		--	end
		--end

		local items = {
			{"prop_physics", "models/props_phx/misc/potato_launcher_explosive.mdl"},
			{"prop_physics", "models/props_phx/misc/potato.mdl"},
			{"prop_physics", "models/props_phx/misc/potato_launcher_explosive.mdl"},
			{"prop_physics", "models/Items/grenadeAmmo.mdl"},
			{"item_healthvial"},
			{"item_battery"},
			{"npc_headcrab"},
		}

		if IsValid(self:GetActiveWeapon()) and not self.dropped then
			local old = {
				model = self:GetActiveWeapon():GetModel(),
				pos = self:GetActiveWeapon():GetPos(),
				ang = self:GetActiveWeapon():GetAngles(),
			}
			local droppedwep = ents.Create("prop_physics")
			droppedwep:SetPos(old.pos + Vector(0, 0, 50))
			droppedwep:SetAngles(old.ang)
			droppedwep:SetModel(old.model)
			droppedwep:Spawn()
			droppedwep:Activate()
			droppedwep.NeedsToBeCollected = true
			timer.Simple(3, function()
				if IsValid(droppedwep) then
					droppedwep:Remove()
				end
			end)
		elseif string.find(self:GetNWString("CitizenName"), "Alien Citizen") then
			local old = {
				pos = self:GetPos(),
				ang = self:GetAngles(),
			}
			local dat = table.Random(items)
			local droppedwep = ents.Create(dat[1])
			droppedwep:SetPos(old.pos + Vector(0, 0, 50))
			droppedwep:SetAngles(old.ang)
			if dat[2] then
				droppedwep:SetModel(dat[2])
			end
			droppedwep:Spawn()
			droppedwep:Activate()
			droppedwep.NeedsToBeCollected = true
			timer.Simple(30, function()
				if IsValid(droppedwep) then
					droppedwep:Remove()
				end
			end)
		end
		--hook.Call("OnNPCKilled", GAMEMODE, self, dmg:GetAttacker(), dmg:GetInflictor())
		self:OnNPCKilled(ent,dmg:GetInflictor())

		--self:ClearSchedule()
		self:SetNPCState( NPC_STATE_DEAD )
		self:SetSchedule( SCHED_FALL_TO_GROUND )
	end

	function ENT:OnRemove()
		if self.bSit then
			self:TaskStart_EndSit()
		end
	end

	function ENT:SetSched( sched )
		if not self:IsCurrentSchedule( sched ) then
			self:SetSchedule( sched )
		end
	end

	function ENT:SpawnBlood(dmg)
		local bloodeffect = ents.Create( "info_particle_system" )
		bloodeffect:SetKeyValue( "effect_name", "blood_impact_red_01")
		bloodeffect:SetPos( dmg:GetDamagePosition() )
		bloodeffect:Spawn()
		bloodeffect:Activate()
		bloodeffect:Fire( "Start", "", 0 )
		bloodeffect:Fire( "Kill", "", 0 )
	end

	function ENT:Touch(ent)
		if self:GetModel() == "models/gman_high.mdl" and ent:IsPlayer() then
			ent:EmitSound("vo/Citadel/gman_exit10.wav")
			self:Remove()
			return
		end
		if ent:GetClass() == "func_door" then
			ent:Fire("unlock")
			ent:Fire("open")
			self:TaskComplete()
			self:SetNPCState(NPC_STATE_IDLE)
			return
		end
		if ent:GetClass() == "trigger_lua" then
			print(self:GetNWString("CitizenName") .. " has touched " .. ent.AreaData["Name"])
			self:SetLocation(ent.AreaData["Name"])
			return
		end
		if ent:GetClass() == "rpg_missile" then -- Fix for the RPG exploit, Instead mimic the effect
			local explode = ents.Create( "env_explosion" )
			explode:SetPos( ent:GetPos() )
			explode:SetOwner( ent:GetOwner() )
			explode:Spawn()
			explode:SetKeyValue( "iMagnitude", "100" )
			explode:Fire( "Explode", 0, 0 )
			explode:EmitSound( "ambient/explosions/explode_4.wav", 400, 400 )
			ent:StopSound("Missile.Ignite")
			ent:Fire("Kill")
		end
		if ent:IsNPC() or ent:IsPlayer() then
			if self:GetNPCState() ~= NPC_STATE_ALERT then
				if math.random()<1/5 then
					if self.bSitting then
						self:PlaySound("bench")
					else
						self:PlaySound("greet")
					end
				end
			else
				self:PlaySound("scared")
			end
		end
	end

	function ENT:AcceptInput(what,who,who2)
		if self:GetModel() == "models/gman_high.mdl" then
			who:EmitSound("vo/Citadel/gman_exit10.wav")
			self:Remove()
			return
		end
		if what=="Use" then
			--self:Touch(who)
			if who:IsPlayer() then
				if (self.actioncool and self.actioncool or CurTime()) > CurTime() then return end
				local lg = self.actioncool or 0
				local now = CurTime()

				if now-lg<3 then self:DBG("timeout",who) return end
				if self:GetNPCState() == NPC_STATE_ALERT then self:DBG("alert",who) return end

				if who:GetPos():DistToSqr(self:GetPos())> 512*512 then return end

				self:DBG("hello",who)

				self.actioncool = now + 10

				local a = who:GetPos() - self:GetPos()
				a:Normalize()
				local seq_l =
				{
					self.ANIM_talk01,
					self.ANIM_talk02,
					self.ANIM_talk03,

				}
				self:PlayAnim(seq_l[math.random(1, 3)])
				self:PlaySound("conversation")
				self:SetSchedule(SCHED_TARGET_FACE)
				self:SetTarget(who)
			end
		end
	end


	function ENT:TaskStart_PlaySequence( data )

		local SequenceID = data.ID

		if ( data.Name ) then
			local seq = self:LookupSequence( data.Name )
			if seq and seq>=0 then
				SequenceID = seq
			end
		end

		if not SequenceID then ErrorNoHalt("Invalid sequence for "..tostring(self)..'\n' ) return end

		self:ResetSequence( SequenceID )
		self:SetNPCState( NPC_STATE_SCRIPT )

		local Duration = self:SequenceDuration()

		if ( data.Speed and data.Speed > 0 ) then

			SequenceID = self:SetPlaybackRate( data.Speed )
			Duration = Duration / data.Speed

		end
		Duration = data.Dur or Duration
		self.TaskSequenceEnd = CurTime() + Duration

	end

	function ENT:Task_PlaySequence( data )

		-- Wait until sequence is finished
		if ( CurTime() < (self.TaskSequenceEnd and self.TaskSequenceEnd or CurTime()) ) then return end

		self:TaskComplete()
		self:SetNPCState( NPC_STATE_NONE )

		-- Clean up
		self.TaskSequenceEnd = nil

	end

end
--local t = ents.FindByClass"lua_npc_wander" for k,v in next,t do v:Remove() end

easylua.EndEntity(false,false)