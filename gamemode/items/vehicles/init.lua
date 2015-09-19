CAT.Name = "Vehicles";
CAT.Description = "The latest in compactable transportation";
if (not (GM or GAMEMODE):GetPlugin("vehicles")) then
	CAT.NoShow = true;
end