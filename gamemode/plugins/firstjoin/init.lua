
util.AddNetworkString("cider_NewPlayer_openframe")
function cider_PlayerFirstSpawn(ply)
	if(ply:GetNetworkedBool("new")== true) then
		net.Start("cider_NewPlayer_openframe");
		net.Send(ply)
		ply:SetNetworkedBool("new", false)
	else
		return
	end
end
hook.Add("PlayerIntialSpawn", "firstjoined_cider", cider_PlayerFirstSpawn);