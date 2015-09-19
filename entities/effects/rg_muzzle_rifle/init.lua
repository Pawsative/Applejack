

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
		particle:SetVelocity(80*self.Forward + 20*VectorRand() + 1.05*AddVel)
		particle:SetDieTime(math.Rand(0.18,0.25))
		particle:SetStartSize(math.random(5,10))
		particle:SetEndSize(3)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetGravity(Vector(0,0,100))
		particle:SetAirResistance(160)

		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(80*self.Forward + 1.1*AddVel)
		particle:SetDieTime(math.Rand(0.36,0.38))
		particle:SetStartAlpha(math.Rand(50,60))
		particle:SetStartSize(math.random(3,4))
		particle:SetEndSize(math.Rand(17,28))
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(245,245,245)
		particle:SetLighting(true)
		particle:SetAirResistance(80)


	for i=-1,1,2 do
		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(80*i*self.Right + 1.1*AddVel)
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

		if math.random(1,4) == 1 then
			for j=1,2 do
				for i=-1,1,2 do
					local particle = emitter:Add("effects/muzzleflash"..math.random(1,4), self.Position - 3*self.Forward + 2*j*i*self.Right)
					particle:SetVelocity(60*j*i*self.Right + AddVel)
					particle:SetGravity(AddVel)
					particle:SetDieTime(0.1)
					particle:SetStartAlpha(150)
					particle:SetStartSize(j)
					particle:SetEndSize(4*j)
					particle:SetRoll(math.Rand(180,480))
					particle:SetRollDelta(math.Rand(-1,1))
					particle:SetColor(255,255,255)
				end
			end
		end

	emitter:Finish()

end


function EFFECT:Think()

	return false

end


function EFFECT:Render()


end



