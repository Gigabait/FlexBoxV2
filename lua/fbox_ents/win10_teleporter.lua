//Teleporters

easylua.StartEntity("win10_teleporter")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Teleporter"
ENT.Author = "Win7yes"
ENT.Spawnable = true
ENT.Category = "Other"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Address")
	self:NetworkVar("String", 1, "TName")
	self:NetworkVar("String", 2, "Index")
	self:NetworkVar("Bool", 0, "Private")
end

if SERVER then

	function ENT:SpawnFunction( ply, tr, ClassName )

		if ( !tr.Hit ) then return end

		local SpawnPos = tr.HitPos + tr.HitNormal * 10
		local SpawnAng = ply:EyeAngles()
		SpawnAng.p = 0
		SpawnAng.y = SpawnAng.y + 180

		local ent = ents.Create( ClassName )
		ent:SetCreator( ply )
		ent:SetPos( SpawnPos )
		ent:SetAngles( SpawnAng )
		ent:Spawn()
		ent:Activate()

		ent:DropToFloor()

		return ent

	end

	function ENT:Initialize()
		//print("Teleporter",self:EntIndex(),"is initializing")
		self:SetIndex(tostring(self:EntIndex()))
		self:SetModel("models/props_lab/teleportframe.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
		self:GetPhysicsObject():EnableMotion(false)
		util.AddNetworkString("openui"..self:GetIndex())
		util.AddNetworkString("DoTP"..self:GetIndex())
		util.AddNetworkString("UIClosed"..self:GetIndex())
		util.AddNetworkString("ValueChanges"..self:GetIndex())

		self:SetAddress("TP"..tostring(self:EntIndex()))
		self:SetTName("TPN"..tostring(self:EntIndex()))

		self.platform = ents.Create("prop_physics")
		self.platform:SetCreator(self:GetCreator())
		self.platform:SetModel("models/props_lab/teleplatform.mdl")
		self.platform:SetPos(self:LocalToWorld(Vector(35,0,12)))
		self.platform:SetAngles(self:GetAngles())
		self.platform:SetParent(self)
		self.platform:Spawn()
		self.platform:SetMoveType(MOVETYPE_NONE)
		self.platform:GetPhysicsObject():EnableMotion(false)
		constraint.NoCollide(self,self.platform,0,0)
		self.platform.PhysgunDisabled = true	
		self.platpos = 0
		self.PlatMoveSound = CreateSound(self.platform,"ambient/machines/engine4.wav")
		self.ringloop = CreateSound(self.platform,"ambient/levels/labs/machine_ring_resonance_loop1.wav")
		self.ringloop:ChangePitch(0)
		self.teleportloop = CreateSound(self.platform,"ambient/levels/labs/teleport_active_loop1.wav")
		self.platform:SetTrigger(true)
		self.touchingents = {}

		self.ring1 = ents.Create("prop_physics")
		self.ring1:SetModel("models/props_lab/teleportring.mdl")
		self.ring1:SetPos(self:LocalToWorld(Vector(35,0,20)))
		self.ring1:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
		self.ring1:SetParent(self.platform)

		self.ring2 = ents.Create("prop_physics")
		self.ring2:SetModel("models/props_lab/teleportring.mdl")
		self.ring2:SetPos(self:LocalToWorld(Vector(35,0,32)))
		self.ring2:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
		self.ring2:SetParent(self.platform)

		self.ring3 = ents.Create("prop_physics")
		self.ring3:SetModel("models/props_lab/teleportring.mdl")
		self.ring3:SetPos(self:LocalToWorld(Vector(35,0,44)))
		self.ring3:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
		self.ring3:SetParent(self.platform)

		self.ring4 = ents.Create("prop_physics")
		self.ring4:SetModel("models/props_lab/teleportring.mdl")
		self.ring4:SetPos(self:LocalToWorld(Vector(35,0,56)))
		self.ring4:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
		self.ring4:SetParent(self.platform)

		self.nofail = true
	end

	function ENT:ElevatePlatform(ply,callback)
		if self.platpos == 26 then
			if callback then
				callback()
			end
			return
		end
		local origpos = self.platform:GetPos()
		if timer.Exists("tp_platdown") then
			timer.Destroy("tp_platdown")
		end
		self.PlatMoveSound:Play()
		timer.Create("tp_platup"..self:GetIndex(),0.1,26,function()
			//ply:ChatPrint(self.platpos)
			if not self or not self.platform then return end
			self.platform:SetPos(self.platform:LocalToWorld(Vector(0,0,5)))
			//ply:SetPos(ply:LocalToWorld(Vector(0,0,5)))
			for k,v in pairs(self.touchingents) do
				v:SetPos(self.platform:LocalToWorld(Vector(0,0,2)))
			end
			self.platpos = self.platpos + 1
			if self.platpos == 25 then
				self.PlatMoveSound:Stop()
				self.platform:EmitSound("doors/garage_stop1.wav")
				if callback then
					callback()
				end
			end
		end)
	end

	function ENT:LowerPlatform(ply)
		if timer.Exists("tp_platup") then
			timer.Destroy("tp_platup")
		end
		self.PlatMoveSound:Play()
		timer.Create("tp_platdown"..self:GetIndex(),0.1,26,function()
			if not self or not self.platform then return end
			if self.platpos == 0 then return end
			self.platform:SetPos(self.platform:LocalToWorld(Vector(0,0,-5)))
			/*if ply then
				ply:SetPos(ply:LocalToWorld(Vector(0,0,-5)))
			end*/
			for k,v in pairs(self.touchingents) do
				v:SetPos(self.platform:LocalToWorld(Vector(0,0,2)))
			end
			self.platpos = self.platpos - 1
			if self.platpos == 0 then
				self.PlatMoveSound:Stop()
				self.platform:EmitSound("doors/garage_stop1.wav")
				timer.Simple(3,function() if not IsValid(self) then return end self:ResetRings() end)
			end
		end)
	end

	function ENT:ResetRings()
		if not self.ring1 or not self.ring2 or not self.ring3 or not self.ring4 or not self then return end
		self.ring1:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
		self.ring2:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
		self.ring3:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
		self.ring4:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
		self.ring1:SetSkin(0)
		self.ring2:SetSkin(0)
		self.ring3:SetSkin(0)
		self.ring4:SetSkin(0)
		if timer.Exists("w7tp-ringsstop"..self:GetIndex()) then
			timer.Destroy("w7tp-ringsstop"..self:GetIndex())
		end
		//self.ringloop:ChangePitch(100)
		self.ringloop:Stop()
		if not self.touchingents == {} then
			self.touchingents = {}
		end
	end

	function ENT:SpinRings(stoptime)
		local speed = 10
		self.ringloop:Play()
		if timer.Exists("w7tp-ringsstop"..self:GetIndex()) then
			timer.Destroy("w7tp-ringsstop"..self:GetIndex())
		end
		if not IsValid(self) or not self then return end
		timer.Create("w7tp-rings"..self:GetIndex(),0.1,stoptime*11,function()
			if not self.ring1 or not self.ring2 or not self.ring3 or not self.ring4 or not self then return end
			self.ring4:SetAngles(self.ring4:LocalToWorldAngles(Angle(0,speed,0)))
			speed = speed + 5
			if speed > 150 then
				speed = 150
			end
			if speed > 50 then
				self.ring3:SetAngles(self.ring3:LocalToWorldAngles(Angle(0,speed,0)))
			end
			if speed > 70 then
				self.ring2:SetAngles(self.ring2:LocalToWorldAngles(Angle(0,speed,0)))
			end
			if speed > 80 then
				self.ring1:SetAngles(self.ring1:LocalToWorldAngles(Angle(0,speed,0)))
			end
			if speed == 150 then
				self.ring4:SetSkin(1)
				self.ring3:SetSkin(1)
				self.ring2:SetSkin(1)
				self.ring1:SetSkin(1)
				self.ringloop:ChangePitch(speed-50)
			else
				if speed-50 < 0 then
					self.ringloop:ChangePitch(20)
				else
					self.ringloop:ChangePitch(speed-50)
				end
			end
		end)
		timer.Create("w7tp-ringsend"..self:GetIndex(),stoptime,1,function()
			if not IsValid(self) or not self then return end
			timer.Create("w7tp-ringsstop"..self:GetIndex(),0.1,stoptime*11,function()
				if not self.ring1 or not self.ring2 or not self.ring3 or not self.ring4 or not self then return end
				self.ring1:SetAngles(self.ring1:LocalToWorldAngles(Angle(0,speed,0)))
				self.ring3:SetAngles(self.ring3:LocalToWorldAngles(Angle(0,speed,0)))
				self.ring2:SetAngles(self.ring2:LocalToWorldAngles(Angle(0,speed,0)))
				self.ring4:SetAngles(self.ring4:LocalToWorldAngles(Angle(0,speed,0)))
				speed = speed - 5
				if speed < 0 then
					speed = 0
				end
				if speed < 39 then
					self.ring1:SetSkin(0)
				end
				if speed < 49 then
					self.ring2:SetSkin(0)
				end
				if speed < 59 then
					self.ring3:SetSkin(0)
				end
				if speed == 0 then
					self.ring4:SetSkin(0)
				end
				self.ringloop:ChangePitch(speed)
			end)
		end)
	end

	function ENT:DoTeleport(ply,dest)
		if not self or not self.teleportloop then return end
		self.teleportloop:Stop()
		self:EmitSound("ambient/levels/labs/teleport_winddown1.wav")
		self:EmitSound("ambient/levels/labs/teleport_postblast_winddown1.wav")
		if not IsValid(dest) or #self.touchingents == 0 or self.fail == true then
			self:EmitSound("buttons/button8.wav")
			self:EmitSound("vo/k_lab/kl_fiddlesticks.wav")
			ply:ChatPrint("Teleportation Failed! Resetting Teleport.")
			self:LowerPlatform()
			dest:LowerPlatform()
			self.teleporting = false
			return
		end
		local sounds = {
			"ambient/machines/teleport1.wav",
			"ambient/machines/teleport3.wav",
			"ambient/machines/teleport4.wav",
		}
		local rand = math.Round(math.Rand(1,#sounds))
		self:EmitSound(sounds[rand])
		dest:EmitSound(sounds[rand])
		for k,v in pairs(self.touchingents) do
			v:SetPos(dest.platform:LocalToWorld(Vector(0,0,5)))
			if v:IsPlayer() then
				v:EmitSound(sounds[rand])
				local pitch = dest:GetAngles().x
				local yaw = dest:GetAngles().y
				v:SetEyeAngles(Angle(pitch,yaw,0))
				
			end
		end
		self:LowerPlatform()
		dest:LowerPlatform()
		self.teleporting = false
	end

	function ENT:TPSeq(ply,dest,quick)
		//print("[Win10-Teleporters] Attempting Teleportation from",tostring(self:GetAddress()),"to",tostring(dest:GetAddress()))
		if dest == self then
			ply:ChatPrint("You can't teleport to the teleporter you're using!")
		elseif dest:GetClass() ~= "win10_teleporter" then
			print("[Win10 Teleporter]",self,"tried to teleport to a non-teleporter entity, this shouldn't happen!")
		elseif quick == false then
			dest:ElevatePlatform()
			self:ElevatePlatform(ply,function()
				self.teleporting = true
				self:SpinRings(20)
				dest:SpinRings(20)
				self.teleportloop:Play()
				self:EmitSound("ambient/levels/labs/teleport_mechanism_windup2.wav")

				timer.Simple(13,function()
					if not self or not self.platform then return end
					self:EmitSound("vo/k_lab/kl_finalsequence02.wav")
					self.platform:EmitSound("ambient/levels/labs/teleport_mechanism_windup3.wav")
					self:EmitSound("ambient/levels/labs/teleport_mechanism_windup5.wav")
				end)
				timer.Simple(20,function()
					self:DoTeleport(ply,dest)
				end)
			end)
		elseif quick then
			dest:ElevatePlatform()
			self:ElevatePlatform(ply,function()
				self.teleportloop:Play()
				self:SpinRings(5)
				dest:SpinRings(5)
				self.teleporting = true
				timer.Simple(5,function()
					self:DoTeleport(ply,dest)
				end)
			end)
		end
	end

	function ENT:StartTouch(ent)
		table.insert(self.touchingents,ent)
	end

	function ENT:EndTouch(ent)
		table.remove(self.touchingents)
	end

	function ENT:Use(ply)
		//local msg = ""
		found = ents.FindByClass("win10_teleporter")
		/*msg = string.format("I have found %s that are basically me.",tostring(found))
		ply:ChatPrint(msg)*/
		net.Start("openui"..self:GetIndex())
		net.WriteTable(found)
		net.WriteEntity(self:GetCreator())
		net.WriteEntity(ply)
		net.Send(ply)
		//self:ElevatePlatform(ply)
	end

	function ENT:Think()
		net.Receive("DoTP"..self:GetIndex(),function(len,ply)
			local address = net.ReadString()
			local play = net.ReadEntity()
			local quick = net.ReadBool()
			local ent = net.ReadEntity()
			local tpent = ent

			if not IsValid(ent) then
				for k,v in pairs(ents.FindByClass("win10_teleporter")) do
					if v:GetAddress() == address then
						tpent = v
					end
				end
			end
			self:TPSeq(ply,tpent,quick)
		end)
		net.Receive("ValueChanges"..self:GetIndex(),function(len,ply)
			local addr = net.ReadString()
			local tname = net.ReadString()
			local priv = net.ReadBool()
			self:SetAddress(addr)
			self:SetTName(tname)
			self:SetPrivate(priv)
		end)
		if self.ringloop:GetPitch() < 0 then
			self.ringloop:ChangePitch(1)
		end
		net.Receive("UIClosed"..self:GetIndex(),function(len,ply)
		end)
		if self.platpos < 0 then
			self.platpos = 0
		end
		if self.platpos > 26 then
			self.platpos = 25
		end
		local failchance = math.random(1,100)
		if not self.nofail then
			if failchance > 40 and failchance < 70 then
				self.fail = true
			else
				self.fail = false
			end
		end
		/*if self.teleporting == true then
			win10:ChatPrint(tostring(self.fail))
		end*/
	end

	function ENT:OnRemove()
		self.PlatMoveSound:Stop()
		self.PlatMoveSound = nil
		self.teleportloop:Stop()
		self.teleportloop = nil
		self.ringloop:Stop()
		self.ringloop = nil
	end

	/*function ENT:ReinitTP()
		local oldname = self:GetTName()
		local oldaddr = self:GetAddress()
		local oldpriv = self:GetPrivate()
		if self.platform then
			self.platform:Remove()
		end
		self:OnRemove()
		self:Initialize()
		self:SetTName(oldname)
		self:SetAddress(oldaddr)
		self:SetPrivate(oldpriv)
	end*/
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
	function ENT:Initialize()
		/*self.bulk = ents.CreateClientProp()
		self.bulk:SetModel("models/props_lab/teleportbulk.mdl")
		self.bulk:SetPos(self.platform:LocalToWorld(Vector(200,10,175)))
		self.bulk:SetAngles(self.platform:LocalToWorldAngles(Angle(0,0,0)))
		self.bulk:SetParent(self.platform)
		self.bulk:Spawn()*/
	end
	function ENT:Think()
		net.Receive("openui"..self:GetIndex(),function(len,ply)
			local found = net.ReadTable()
			local creator = net.ReadEntity()
			local ply = net.ReadEntity()
			local addresslist = {}

			self.frame = vgui.Create("DFrame")
			self.frame:SetSize(500,400)
			self.frame:Center()
			self.frame:MakePopup()
			self.frame:SetTitle("Teleporter GUI")

			function self.frame.OnClose()
				net.Start("UIClosed"..self:GetIndex())
				net.SendToServer()
			end

			self.tplist = vgui.Create("DListView",self.frame)
			self.tplist:Dock(FILL)
			self.tplist:AddColumn("Address")
			self.tplist:AddColumn("Name")
			function self.tplist.RefreshItems()
				self.tplist:Clear()
				for k,v in pairs(found) do
					if v:GetPrivate() == true or v == self then
					else
						local line = self.tplist:AddLine(v:GetAddress(),v:GetTName() == "" and "None" or v:GetTName())
						local address = v:GetAddress()
						table.insert(addresslist,{address,v})
					end
				end
				self.tplist:SelectFirstItem()
			end
			self.tplist.RefreshItems()
			self.tplist:SetMultiSelect(false)

			local tpframe = vgui.Create("DPanel",self.frame)
			tpframe:Dock(BOTTOM)

			self.addrbox = vgui.Create("DTextEntry",tpframe)
			self.addrbox:Dock(FILL)
			self.addrbox:RequestFocus()
			if addresslist[1] then
				self.addrbox:SetText(addresslist[self.tplist:GetSelectedLine()][1])
			end
			function self.tplist.OnRowSelected(index)
				self.addrbox:SetText(addresslist[self.tplist:GetSelectedLine()][1])
			end

			function self.addrbox.OnChange(addr)
				addr:SetText(addr:GetText():upper())
				addr:SetCaretPos(#addr:GetText())
				for k,v in pairs(addresslist) do
					if v[1] == self.addrbox:GetText() then
						self.tplist:ClearSelection()
						self.tplist:SelectItem(self.tplist:GetLine(k))
					else
						self.tplist:ClearSelection()
					end
				end
			end

			self.tpbutton = vgui.Create("DButton",tpframe)
			self.tpbutton:SetText("Start Teleport")
			self.tpbutton:Dock(RIGHT)
			function self.tpbutton.DoClick(button)
				net.Start("DoTP"..self:GetIndex())
				net.WriteString(self.addrbox:GetText())
				net.WriteEntity(ply)
				net.WriteBool(false)
				if self.tplist:GetSelectedLine() then
					net.WriteEntity(addresslist[self.tplist:GetSelectedLine()][2])
				end
				net.SendToServer()
				self.frame:Close()
			end

			self.quicktp = vgui.Create("DButton",tpframe)
			self.quicktp:SetText("Quick Teleport")
			self.quicktp:SetWide(self.quicktp:GetWide()+15)
			self.tpbutton:SetWide(self.tpbutton:GetWide()+15)
			self.quicktp:Dock(RIGHT)
			function self.quicktp.DoClick(button)
				net.Start("DoTP"..self:GetIndex())
				net.WriteString(self.addrbox:GetText())
				net.WriteEntity(ply)
				net.WriteBool(true)
				if self.tplist:GetSelectedLine() then
					net.WriteEntity(addresslist[self.tplist:GetSelectedLine()][2])
				end
				net.SendToServer()
				self.frame:Close()
			end

			function self.quicktp.Think(button)
				if not self.tplist:GetSelectedLine() and self.addrbox:GetText() == "" then
					button:SetEnabled(false)
				else
					button:SetEnabled(true)
				end
			end
			function self.tpbutton.Think(button)
				if not self.tplist:GetSelectedLine() and self.addrbox:GetText() == "" then
					button:SetEnabled(false)
				else
					button:SetEnabled(true)
				end
			end

			if creator == ply then
				self.proppanel = vgui.Create("DPanel",self.frame)
				self.proppanel:Dock(RIGHT)
				self.proppanel:SetWide(200)

				self.props = vgui.Create("DProperties",self.proppanel)
				self.props:Dock(FILL)

				local newname = self:GetTName()
				local newaddress = self:GetAddress()
				local newpriv = self:GetPrivate()


				self.NameProp = self.props:CreateRow("Settings","Name")
				self.NameProp:Setup("Generic")
				self.NameProp:SetValue(newname)
				self.NameProp.DataChanged = function(_,val) newname = val end

				self.addprop = self.props:CreateRow("Settings","Address")
				self.addprop:Setup("Generic")
				self.addprop:SetValue(newaddress)
				self.addprop.DataChanged = function(_,val) newaddress = val end

				self.privprop = self.props:CreateRow("Settings","Private?")
				self.privprop:Setup("Boolean")
				self.privprop:SetValue(self:GetPrivate())
				self.privprop.DataChanged = function(_,val) newpriv = val end

				self.ApplyBtn = vgui.Create("DButton",self.proppanel)
				self.ApplyBtn:SetText("Apply Settings")
				self.ApplyBtn:Dock(BOTTOM)

				function self.ApplyBtn.DoClick(btn)
					/*self:SetTName(newname)
					self:SetAddress(newaddress)
					self:SetPrivate(tobool(newpriv))*/
					net.Start("ValueChanges"..self:GetIndex())
						net.WriteString(newaddress)
						net.WriteString(newname)
						net.WriteBool(newpriv)
					net.SendToServer()
					self.tplist.RefreshItems()
					LocalPlayer():ChatPrint("Teleporter Settings Saved")
				end
			end
		end)
	end
	function ENT:OnRemove()
		//self.bulk:Remove()
	end
end


easylua.EndEntity(false,false)