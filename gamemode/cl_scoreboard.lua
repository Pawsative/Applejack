include("scoreboard/scoreboard.lua")

local CityRPScoreBoard = nil

-- Create the scoreboard.
function GM:CreateScoreboard()
	if ScoreBoard then
		ScoreBoard:Remove()
		ScoreBoard = nil
	end

	CityRPScoreBoard = vgui.Create("ScoreBoard")
end

-- Show the scoreboard.
function GM:ScoreboardShow()
	if !(LocalPlayer():GetNSVar("cityrp_Points")) then LocalPlayer():ChatPrint("You can't open the scoreboard until you've spawned for the first time") return end
	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker(true)

	if not CityRPScoreBoard then
		self:CreateScoreboard()
	end

	CityRPScoreBoard:SetVisible(true)
	CityRPScoreBoard:UpdateScoreboard(true)
end

-- Hide the scoreboard.
function GM:ScoreboardHide()
	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker(false)
	if(CityRPScoreBoard) then
		CityRPScoreBoard:SetVisible(false)
	end;
end