

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

		local particle = emitter:Add("sprites/heatwave", self.Position - self.Forward*4)
		particle:SetVelocity(80*self.Forward + 20*VectorRand() + 1.05*AddVel)
		particle:SetDieTime(math.Rand(0.2,0.25))
		particle:SetStartSize(math.random(15,20))
		particle:SetEndSize(3)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetGravity(Vector(0,0,100))
		particle:SetAirResistance(160)

	for i=1,3 do
		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(30*i*self.Forward + 10*VectorRand() + 1.1*AddVel)
		particle:SetDieTime(math.Rand(0.36,0.38))
		particle:SetStartAlpha(math.Rand(60,70))
		particle:SetStartSize(math.random(1,2)*i)
		particle:SetEndSize(math.Rand(5,7)*i)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(245,245,245)
		particle:SetLighting(true)
		particle:SetAirResistance(140)
	end

	for i=1,4 do
		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(math.Rand(20,30)*self.Forward + 40*VectorRand() + 1.1*AddVel)
		particle:SetDieTime(math.Rand(0.36,0.38))
		particle:SetStartAlpha(math.Rand(50,60))
		particle:SetStartSize(math.random(2,3))
		particle:SetEndSize(math.Rand(12,14))
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(245,245,245)
		particle:SetLighting(true)
		particle:SetAirResistance(160)
	end

	for i=1,2 do
		local particle = emitter:Add("effects/muzzleflash"..math.random(1,4), self.Position + 8*self.Forward)
		particle:SetVelocity(350*self.Forward + 1.1*AddVel)
		particle:SetDieTime(0.18)
		particle:SetStartAlpha(160)
		particle:SetEndAlpha(0)
		particle:SetStartSize(12*i)
		particle:SetEndSize(8*i)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(255,255,255)
		particle:SetAirResistance(160)
	end

	emitter:Finish()

end


function EFFECT:Think()

	return false

end


function EFFECT:Render()


end



