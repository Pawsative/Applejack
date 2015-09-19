

function EFFECT:Init(data)

	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()


	if not IsValid(self.WeaponEnt) or not self.WeaponEnt:GetOwner() or self.WeaponEnt == NULL or self.WeaponEnt:GetOwner() == NULL then return end


	local AddVel = self.WeaponEnt:GetOwner():GetVelocity()

	local emitter = ParticleEmitter(self.Position)

		local particle = emitter:Add("sprites/heatwave", self.Position - self.Forward*4)
		particle:SetVelocity(30*self.Forward + 5*VectorRand() + 1.05*AddVel)
		particle:SetDieTime(math.Rand(0.05,0.07))
		particle:SetStartSize(math.random(3,6))
		particle:SetEndSize(2)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetGravity(Vector(0,0,100))
		particle:SetAirResistance(80)

		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(50*self.Forward + 1.1*AddVel)
		particle:SetDieTime(math.Rand(0.28,0.34))
		particle:SetStartAlpha(math.Rand(30,40))
		particle:SetStartSize(math.random(3,4))
		particle:SetEndSize(math.Rand(16,23))
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(245,245,245)
		particle:SetLighting(true)
		particle:SetAirResistance(80)

	emitter:Finish()

end


function EFFECT:Think()

	return false

end


function EFFECT:Render()


end



