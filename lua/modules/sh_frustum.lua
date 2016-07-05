
-----------------------------------------------------
module("frustum", package.seeall)

local PROFILE_TIMINGS = false
local VISUAL_TEST = false

local geometry = nil

local function scaleFOVByWidthRatio(fov, ratio)
	local half = fov * ( math.rad(0.5) )
	local t = math.tan( half ) * ratio
	return math.deg( math.atan( t ) ) * 2.0
end

local standard4by3inv = 1.0 / ( 4.0 / 3.0 )
local function buildPerspective(near, far, fov, width, height, m)
	local aspect = (width / height)
	fov = scaleFOVByWidthRatio(fov, aspect * standard4by3inv)
	local wscale = 1 / math.tan(math.rad(fov * .5))
	local hscale = aspect * wscale
	m:Identity()
	m:SetField(1,1,wscale)
	m:SetField(2,2,hscale)
	m:SetField(3,3,far / (near - far))
	m:SetField(3,4,near * far / (near - far))
	m:SetField(4,3,-1)
	m:SetField(4,4,0)
	return m
end


local FMeta = {}
FMeta.__index = FMeta

function New()
	return setmetatable({}, FMeta):Init()
end

function FMeta:Init()
	self.perspectiveMatrix = Matrix()
	self.viewMatrix = Matrix()
	self.invViewMatrix = Matrix()
	self.invViewMatrixTable = self.invViewMatrix:ToTable()
	self.txpoints = {}
	self.txplanes = {}

	--precache vector objects
	for i=1,8 do self.txpoints[i] = Vector(0,0,0) end

	--precache plane objects
	for k,v in pairs(geometry.planeIndices) do 
		self.txplanes[k] = {
			normal = Vector(0,0,0),
			absnormal = Vector(0,0,0),
			dist = 0
		}
	end

	return self
end

function FMeta:Setup(near, far, fov, width, height)
	buildPerspective(near, far, fov, width, height, self.perspectiveMatrix):Invert()
	self:BuildBox()
	self:BuildPlanes()
	return self
end

function FMeta:Orient(pos, angles)
	local f = angles:Forward()
	local r = angles:Right()
	local u = angles:Up()

	self.viewMatrix:SetForward(r)
	self.viewMatrix:SetRight(u)
	self.viewMatrix:SetUp(f * -1)
	self.viewMatrix:SetTranslation(pos)

	self.invViewMatrix:Set(self.viewMatrix)
	self.invViewMatrix:Invert()
	self.invViewMatrixTable = self.invViewMatrix:ToTable()
end

local _svec4in = {}
local _svec4out = {}
function FMeta:BuildBox()
	for k,v in pairs(geometry.points) do
		_svec4in[1] = v.x
		_svec4in[2] = v.y
		_svec4in[3] = v.z
		_svec4in[4] = 1

		local p = self.perspectiveMatrix:Transform4(_svec4in, _svec4out)
		local w = 1 / p[4]
		self.txpoints[k].x = p[1] * w
		self.txpoints[k].y = p[2] * w
		self.txpoints[k].z = p[3] * w
	end
end

function FMeta:TransformPoint(p, o)
	local mv = self.invViewMatrixTable

	o.x = mv[1][1] * p.x + mv[1][2] * p.y + mv[1][3] * p.z + mv[1][4]
	o.y = mv[2][1] * p.x + mv[2][2] * p.y + mv[2][3] * p.z + mv[2][4]
	o.z = mv[3][1] * p.x + mv[3][2] * p.y + mv[3][3] * p.z + mv[3][4]

	return o
end

function FMeta:BuildPlanes()

	--Trying not to make any vectors here
	for k,v in pairs(geometry.planeIndices) do
		local v1,v2,v3 = self.txpoints[v[1]], self.txpoints[v[2]], self.txpoints[v[3]]

		local plane = self.txplanes[k]
		plane.normal.x = (v2.y - v1.y) * (v3.z - v1.z) - (v2.z - v1.z) * (v3.y - v1.y)
		plane.normal.y = (v2.z - v1.z) * (v3.x - v1.x) - (v2.x - v1.x) * (v3.z - v1.z)
		plane.normal.z = (v2.x - v1.x) * (v3.y - v1.y) - (v2.y - v1.y) * (v3.x - v1.x)

		local invlen = 1 / plane.normal:Length()
		plane.normal.x = plane.normal.x * invlen
		plane.normal.y = plane.normal.y * invlen
		plane.normal.z = plane.normal.z * invlen

		plane.absnormal.x = math.abs(plane.normal.x)
		plane.absnormal.y = math.abs(plane.normal.y)
		plane.absnormal.z = math.abs(plane.normal.z)

		plane.dist = plane.normal:Dot(v1)
	end

end

local _spoint = Vector(0,0,0)
function FMeta:TestPoint(p)
	self:TransformPoint( p, _spoint )
	for k,v in pairs(self.txplanes) do

		if _spoint:Dot(v.normal) > v.dist then
			return false
		end

	end
	return true
end

local _saabbcenter = Vector(0,0,0)
local _saabbtxcenter = Vector(0,0,0)
local _saabbextent = Vector(0,0,0)
function FMeta:TestAABB(mins, maxs)
	_saabbcenter.x = (maxs.x + mins.x) * .5
	_saabbcenter.y = (maxs.y + mins.y) * .5
	_saabbcenter.z = (maxs.z + mins.z) * .5

	_saabbextent.x = (maxs.x - mins.x) * .5
	_saabbextent.y = (maxs.y - mins.y) * .5
	_saabbextent.z = (maxs.z - mins.z) * .5

	self:TransformPoint( _saabbcenter, _saabbtxcenter )

	local res = 0
	for k,v in pairs(self.txplanes) do
		local d = _saabbtxcenter:Dot(v.normal) - _saabbextent:Dot(v.absnormal) - v.dist
		if d < 0 then res = res + 1 end
	end
	return res == 6
end

function FMeta:TestEntity( ent )
	local mins, maxs = ent:GetRotatedAABB( ent:OBBMins(), ent:OBBMaxs() )
	local pos = ent:GetPos()
	mins.x = mins.x + pos.x
	mins.y = mins.y + pos.y
	mins.z = mins.z + pos.z

	maxs.x = maxs.x + pos.x
	maxs.y = maxs.y + pos.y
	maxs.z = maxs.z + pos.z

	return self:TestAABB(mins, maxs)
end

function FMeta:CullEntities( entities )

	for i=#entities, 1, -1 do
		local e = entities[i]
		if not IsValid(e) or not self:TestEntity(e) then
			table.remove(entities, i)
		end
	end

	return entities

end

function FMeta:Draw( color, wire )

	color = color or Color(255,255,255,255)

	if wire then

		for k,v in pairs(geometry.indices) do
			local a = self.viewMatrix:Transform3(self.txpoints[v[1]], 1)
			local b = self.viewMatrix:Transform3(self.txpoints[v[2]], 1)

			Debug3D.DrawLine( a, b, 16, color )
		end

	else

		cam.PushModelMatrix(self.viewMatrix)

		pcall(function()
			render.SetColorMaterial()
			mesh.Begin( MATERIAL_QUADS, #geometry.quads * 4 );

			for _,quad in pairs(geometry.quads) do

				for i=4, 1, -1 do
					local v = self.txpoints[quad[i]]
					mesh.Position( v )
					mesh.Color( color.r, color.g, color.b, color.a )
					mesh.AdvanceVertex()
				end

				for i=1, 4 do
					local v = self.txpoints[quad[i]]
					mesh.Position( v )
					mesh.Color( color.r, color.g, color.b, color.a )
					mesh.AdvanceVertex()
				end

			end

			mesh.End();
		end)

		cam.PopModelMatrix()

	end

end

geometry = {
	points = {
		Vector(-1,-1,-1),
		Vector(1,-1,-1),
		Vector(1,1,-1),
		Vector(-1,1,-1),
		Vector(-1,-1,1),
		Vector(1,-1,1),
		Vector(1,1,1),
		Vector(-1,1,1),
	},
	quads = {
		{4,3,2,1},
		{1,2,6,5},
		{2,3,7,6},
		{3,4,8,7},
		{4,1,5,8},
		{5,6,7,8},
	},
	indices = {
		{1,2},
		{2,3},
		{3,4},
		{4,1},

		{5,6},
		{6,7},
		{7,8},
		{8,5},

		{1,5},
		{2,6},
		{3,7},
		{4,8},
	},
	planeIndices = {
		right = {4,5,1},
		left = {2,7,3},
		bottom = {1,6,2},
		top = {4,7,8},
		near = {4,2,3},
		far = {8,7,6},
	}
}

if PROFILE_TIMINGS then
	local myFrustum = New():Setup(100, 800, 90, 1280, 720)
	local mins,maxs = Vector(-10,-10,-10), Vector(10,10,10)
	local pl = player.GetAll()[1]

	local clock = os.clock()
	for i=1, 100000 do myFrustum:TestAABB(mins, maxs) end
	print("Test 100000 AABB in " .. (os.clock() - clock) .. " seconds.")

	local clock = os.clock()
	for i=1, 100000 do myFrustum:TestEntity(pl) end
	print("Test 100000 Entities in " .. (os.clock() - clock) .. " seconds.")

	local clock = os.clock()
	for i=1, 100000 do myFrustum:TestPoint(mins) end
	print("Test 100000 Points in " .. (os.clock() - clock) .. " seconds.")

	local clock = os.clock()
	for i=1, 100000 do myFrustum:Orient(pl:EyePos(), pl:EyeAngles()) end
	print("Test 100000 Re-Orients in " .. (os.clock() - clock) .. " seconds.")

	local clock = os.clock()
	local elist
	for i=1, 1 do elist = myFrustum:CullEntities(ents.GetAll()) end
	print("Test Cull " .. #ents.GetAll() .. " Entities in " .. (os.clock() - clock) .. " seconds [ to " .. #elist .. " entities ].")

	--setups are more expensive, but won't be called often
	local clock = os.clock()
	for i=1, 10000 do myFrustum:Setup(100, 800, 90, 1280, 720) end
	print("Test 10000 Setups in " .. (os.clock() - clock) .. " seconds.")
end

--myFrustum:Orient(LocalPlayer():EyePos(), LocalPlayer():EyeAngles())


if SERVER then return end

local myFrustum = nil
if VISUAL_TEST then
	myFrustum = New():Setup(10, 5000, 90, ScrW(), ScrH())
end

hook.Add("CalcView", "viewfrustumtest", function( ply, pos, angles, fov )

	if VISUAL_TEST and input.IsMouseDown(MOUSE_LEFT) then
		myFrustum:Orient(LocalPlayer():EyePos(), LocalPlayer():EyeAngles())
	end

end)


hook.Add("PostDrawOpaqueRenderables", "planeTest", function()

	if VISUAL_TEST then

		myFrustum:Draw(Color(255,100,100), true)

		for k,v in pairs(ents.FindByClass("gmt_mapboard")) do

			if v.SetNoDraw then

				if not myFrustum:TestEntity(v) then
					v:SetNoDraw(true)
				else
					v:SetNoDraw(false)
				end

			end

		end

	end

end)