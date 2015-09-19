local Laser = Material( "tripmine_laser" )

local SPRITE = Material('sprites/redglow8')

function EFFECT:Init( effectdata )
 
self.Pos = effectdata:GetOrigin()
self.Entity:SetPos( self.Pos )

self.Weapon = effectdata:GetEntity()

self.Alpha = 0--0

self.rot = math.random(-100, 100)

self.MAlpha = 150

self.Spawntime = CurTime()
self.Lifetime = 2
 
end 

function EFFECT:Think()
	
	if !self.Weapon:IsValid() then return false end

	self.Pos = self:GetPos()
	self:SetPos( self.Pos )
	
	local lifeleft = self.Spawntime + self.Lifetime - CurTime()
	if lifeleft < 0.8 then self.Alpha = lifeleft/0.8 * self.MAlpha end
	
	local livelived = CurTime() - self.Spawntime
	if livelived < 0.9 then self.Alpha = (livelived - 0.1)/0.8 * self.MAlpha end
	
	if livelived < 0.1 then self.Alpha = 0 end
	
	return CurTime() <= (self.Spawntime + self.Lifetime)
	
end


function EFFECT:Render()
	
	if self.Alpha == 0 then return end
	local origin = self.Pos
	local target
	local normal
	
	traceres = self.Weapon:GetOwner():GetEyeTrace()
	target = traceres.HitPos
	normal = traceres.HitNormal
	
	while (traceres.MatType == MAT_GLASS) do
		local trace = {}
		
		trace.start = traceres.HitPos + (self.Weapon:GetOwner():GetAimVector() * 16)
		trace.endpos = trace.start + (self.Weapon:GetOwner():GetAimVector() * 4096)
		
		traceres = util.TraceLine(trace)
		target = traceres.HitPos
		normal = traceres.HitNormal
	end
	
	render.SetMaterial( SPRITE )
	render.DrawSprite( target + normal * 1, 5, 5, Color(255, 255, 255, self.Alpha * 0.7) )
	render.DrawQuadEasy( target + normal * 0.5, normal, 6, 6, Color(255, 255, 255, self.Alpha), CurTime() * self.rot )
end
