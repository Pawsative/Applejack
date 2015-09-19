--[[
Name: "cl_init.lua".
	~ Applejack ~
--]]

include("sh_init.lua")

surface.CreateFont("breachtxt", {
	font = "Lucida Console",
	size = 15,
	weight = 400,
	antialias = true
})

function ENT:Draw()
	self.Entity:DrawModel()
	local ang = self.Entity:GetAngles()
	ang:RotateAroundAxis(ang:Up(), -90)
	cam.Start3D2D(self.Entity:GetPos() + self.Entity:GetUp() * 8.8, ang ,0.1)
		surface.SetTextColor(255,0,0,math.abs(math.sin(CurTime()*7)*255))
		surface.SetFont("breachtxt")
		surface.SetTextPos(20,-38)
		surface.DrawText("Active")
	cam.End3D2D()
end