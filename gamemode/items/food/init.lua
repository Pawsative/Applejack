CAT.Name = "Food";
CAT.Description = "Patented Anti-Starvation Consumables";
if (not (GM or GAMEMODE):GetPlugin("hunger")) then
	CAT.NoShow = true;
end