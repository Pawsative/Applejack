

function EFFECT:Init(data)

	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	self.Up = self.Angle:Up()

	if not IsValid(self.WeaponEnt) or not self.WeaponEnt:GetOwner() or self.WeaponEnt == NULL or self.WeaponEnt:GetOwner() == NULL then return end

	local AddVel = self.WeaponEnt:GetOwner():GetVelocity()

	local emitter = ParticleEmitter(self.Position)


	for i=1,2 do
		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(40*i*self.Forward + 10*VectorRand() + AddVel)
		particle:SetDieTime(math.Rand(0.36,0.38))
		particle:SetStartAlpha(math.Rand(60,70))
		particle:SetStartSize(math.random(2,3)*i)
		particle:SetEndSize(math.Rand(7,10)*i)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(245,245,245)
		particle:SetLighting(true)
		particle:SetAirResistance(140)
	end

	emitter:Finish()

end


function EFFECT:Think()

	return false

end


function EFFECT:Render()


end



