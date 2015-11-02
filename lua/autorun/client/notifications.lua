surface.CreateFont( "NotificationTitle", {
	font	= "Segoe UI",
	size	= 20,
	weight	= 500
})

surface.CreateFont( "NotificationText", {
	font	= "Tahoma",
	size	= 16,
	weight	= 500
})

NOTIFY_GENERIC	= 0
NOTIFY_ERROR	= 1
NOTIFY_UNDO		= 2
NOTIFY_HINT		= 3
NOTIFY_CLEANUP	= 4

module("notification",package.seeall)

local Notices = {}

function AddLegacy( text, type, length )

	local parent = nil
	if ( GetOverlayPanel ) then parent = GetOverlayPanel() end

	local Panel = vgui.Create( "FNotification", parent )
	Panel.StartTime = SysTime()
	Panel.Length = length
	Panel.VelX = -5
	Panel.VelY = 0
	Panel.fx = ScrW() + 200
	Panel.fy = ScrH()
	Panel:SetAlpha( 255 )
	Panel:SetText( text )
	Panel:SetLegacyType( type )
	Panel:SetPos( Panel.fx, Panel.fy )

	if string.find(text,"aowl: ") then
		Panel.Title:SetText("aowl")
		Panel.Title:SetTextColor(Color(147,63,147))
		Panel:SetText(string.gsub(text,"aowl: ",""))
		Panel:SizeToContents()
	elseif string.find(text,"vote") then
		Panel.Title:SetText("Vote")
		Panel.Title:SetTextColor(Color(100,200,200))
		Panel:SizeToContents()
	elseif type == NOTIFY_GENERIC then
		Panel.Title:SetText("Notification")
		Panel.Title:SetTextColor(Color(0,255,0))
		Panel:SizeToContents()
	elseif type == NOTIFY_ERROR then
		Panel.Title:SetText("Error")
		Panel.Title:SetTextColor(Color(255,0,0))
		Panel:SizeToContents()
	elseif type == NOTIFY_UNDO then
		Panel.Title:SetText("Undo")
		Panel.Title:SetTextColor(Color(0,128,255))
		Panel:SizeToContents()
	elseif type == NOTIFY_HINT then
		Panel.Title:SetText("Hint")
		Panel.Title:SetTextColor(Color(255,255,0))
		Panel:SizeToContents()
	elseif type == NOTIFY_CLEANUP then
		Panel.Title:SetText("Cleanup")
		Panel.Title:SetTextColor(Color(255,128,0))
		Panel:SizeToContents()
	else
		Panel.Title:SetText("Notification")
		Panel.Title:SetTextColor(Color(0,255,0))
		Panel:SizeToContents()
	end


	table.insert( Notices, Panel )

end

local function UpdateNotice( i, Panel, Count )

	local x = Panel.fx
	local y = Panel.fy

	local w = Panel:GetWide()
	local h = Panel:GetTall()

	w = w + 16
	h = h + 16

	local ideal_y = ScrH() - (Count - i) * (h-12) - 150
	local ideal_x = ScrW() - w - 20

	local timeleft = Panel.StartTime - (SysTime() - Panel.Length)

	-- Cartoon style about to go thing
	if ( timeleft < 0.7  ) then
		ideal_x = ideal_x - 50
	end

	-- Gone!
	if ( timeleft < 0.2  ) then

		ideal_x = ideal_x + w * 2

	end

	local spd = FrameTime() * 15

	y = y + Panel.VelY * spd
	x = x + Panel.VelX * spd

	local dist = ideal_y - y
	Panel.VelY = Panel.VelY + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(Panel.VelY) < 0.1) then Panel.VelY = 0 end
	local dist = ideal_x - x
	Panel.VelX = Panel.VelX + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(Panel.VelX) < 0.1) then Panel.VelX = 0 end

	-- Friction.. kind of FPS independant.
	Panel.VelX = Panel.VelX * (0.95 - FrameTime() * 8 )
	Panel.VelY = Panel.VelY * (0.95 - FrameTime() * 8 )

	Panel.fx = x
	Panel.fy = y
	Panel:SetPos( Panel.fx, Panel.fy )

end


local function Update()

	if ( !Notices ) then return end

	local i = 0
	local Count = table.Count( Notices )
	for key, Panel in pairs( Notices ) do

		i = i + 1
		UpdateNotice( i, Panel, Count )

	end

	for k, Panel in pairs( Notices ) do

		if ( !IsValid(Panel) || Panel:KillSelf() ) then Notices[ k ] = nil end

	end

end

hook.Add( "Think", "NotificationThink", Update )

local PANEL = {}

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:DockPadding( 3, 3, 3, 3 )

	self.Title = vgui.Create( "DLabel", self )
	self.Title:SetText("Notification")
	self.Title:Dock( TOP )
	self.Title:DockMargin(2,2,0,0)
	self.Title:SetFont( "NotificationTitle" )
	self.Title:SetTextColor( Color( 0, 255, 0, 255 ) )
	self.Title:SetContentAlignment( 5 )

	self.Label = vgui.Create( "DLabel", self )
	self.Label:Dock( TOP )
	self.Label:SetFont( "NotificationText" )
	self.Label:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.Label:SetContentAlignment( 5 )

	self:SetBackgroundColor( Color( 20, 20, 20, 255*0.6) )
end

function PANEL:SetText( txt )

	self.Label:SetText( txt )
	self.Label:SizeToContents()
	self.Title:SizeToContents()
	self:SizeToContents()

end

function PANEL:SizeToContents()

	self.Label:SizeToContents()

	local width = self.Title:GetWide() > self.Label:GetWide() and self.Title:GetWide() or self.Label:GetWide()

	if ( IsValid( self.Image ) ) then

		width = width + 32 + 8

	end

	width = width + 20
	self:SetWidth( width )

	self:SetHeight( 48 )

	self:InvalidateLayout()

end

function PANEL:SetLegacyType( t )

	self:SizeToContents()

end


function PANEL:SetProgress()

	self.Paint = function( s, w, h )

		self.BaseClass.Paint( self, w, h )


		surface.SetDrawColor( 0, 100, 0, 150 )
		surface.DrawRect( 4, self:GetTall() - 10, self:GetWide() - 8, 5 )

		surface.SetDrawColor( 0, 50, 0, 255 )
		surface.DrawRect( 5, self:GetTall() - 9, self:GetWide() - 10, 3 )

		local w = self:GetWide() * 0.25
		local x = math.fmod( SysTime() * 200, self:GetWide() + w ) - w

		if ( x + w > self:GetWide() - 11 ) then w = ( self:GetWide() - 11 ) - x end
		if ( x < 0 ) then w = w + x; x = 0 end

		surface.SetDrawColor( 0, 255, 0, 255 )
		surface.DrawRect( 5 + x, self:GetTall() - 9, w, 3 )

	end

end

function PANEL:KillSelf()

	if ( self.StartTime + self.Length < SysTime() ) then

		self:Remove()
		return true

	end

	return false
end

vgui.Register( "FNotification", PANEL, "DPanel" )
