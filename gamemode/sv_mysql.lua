function ReconnectSQL(sid,ip,pw,cl,name)
	if #player.GetAll() < 1 then
		MySQLite.initialize()
		GAMEMODE:Query("SELECT 1+1");
	end
end