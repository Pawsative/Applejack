--[[
Name: "cl_propprotection.lua".
	~ Applejack ~
--]]
cider.menu.pp = {}
cider.menu.pp.AdminCPanel = nil
cider.menu.pp.ClientCPanel = nil

CreateClientConVar("sppa_check", 1, false, true)
CreateClientConVar("sppa_admin", 1, false, true)
--CreateClientConVar("sppa_use", 1, false, true)
--CreateClientConVar("sppa_edmg", 1, false, true)
CreateClientConVar("sppa_pgr", 1, false, true)
CreateClientConVar("sppa_awp", 0, false, true)
CreateClientConVar("sppa_dpd", 1, false, true)
CreateClientConVar("sppa_dae", 1, false, true)
CreateClientConVar("sppa_delay", 120, false, true)
function cider.menu.pp.AdminPanel(Panel)
	print"admin called"
	Panel:ClearControls()
	
	if(!LocalPlayer():IsAdmin()) then
		Panel:AddControl("Label", {Text = "You are not an admin"})
		return
	end
	
	if(!cider.menu.pp.AdminCPanel) then
		cider.menu.pp.AdminCPanel = Panel
	end
	
	Panel:AddControl("Label", {Text = "SPP - Admin Panel - Applejack version - Spacetech/Lexi"})
	
	Panel:AddControl("CheckBox", {Label = "Prop Protection", Command = "sppa_check"})
	Panel:AddControl("CheckBox", {Label = "Admins Can Do Everything", Command = "sppa_admin"})
--	Panel:AddControl("CheckBox", {Label = "Use Protection", Command = "sppa_use"})	--Should always be off
--	Panel:AddControl("CheckBox", {Label = "Entity Damage Protection", Command = "sppa_edmg"})	--Should always be off
	Panel:AddControl("CheckBox", {Label = "Physgun Reload Protection", Command = "sppa_pgr"})
	Panel:AddControl("CheckBox", {Label = "Admins Can Touch World Prop", Command = "sppa_awp"})	
	Panel:AddControl("CheckBox", {Label = "Disconnect Prop Deletion", Command = "sppa_dpd"})
	Panel:AddControl("CheckBox", {Label = "Delete Admin Entities", Command = "sppa_dae"})
	Panel:AddControl("Slider", {Label = "Deletion Delay (Seconds)", Command = "sppa_delay", Type = "Integer", Min = "10", Max = "500"})
	Panel:AddControl("Button", {Text = "Apply Settings", Command = "sppa_apply"})
	
	Panel:AddControl("Label", {Text = "Cleanup Panel"})
	
	for k, ply in pairs(player.GetAll()) do
		if(ply and ply:IsValid()) then
			Panel:AddControl("Button", {Text = ply:Nick(), Command = "sppa_cleanupprops "..ply:EntIndex()})
		end
	end
	
	Panel:AddControl("Label", {Text = "Other Cleanup Options"})
	Panel:AddControl("Button", {Text = "Cleanup Disconnected Players Props", Command = "sppa_cdp"})
end

function cider.menu.pp.ClientPanel(Panel)
	print"client called"
	Panel:ClearControls()
	
	if(!cider.menu.pp.ClientCPanel) then
		cider.menu.pp.ClientCPanel = Panel
	end
	
	Panel:AddControl("Label", {Text = "SPP - Client Panel - Applejack version - Spacetech/Lexi"})
	
	Panel:AddControl("Button", {Text = "Cleanup Props", Command = "sppa_cleanupprops"})
	Panel:AddControl("Label", {Text = "Friends Panel"})
	
	local Players = player.GetAll()
	if(table.Count(Players) == 1) then
		Panel:AddControl("Label", {Text = "No Other Players Are Online"})
	else
		for k, ply in pairs(Players) do
			if(ply and ply:IsValid() and ply ~= LocalPlayer()) then
				local FriendCommand = "sppa_friend_"..ply:GetNWString("SPPSteamID")
				if(!LocalPlayer():GetInfo(FriendCommand)) then
					CreateClientConVar(FriendCommand, 0, false, true)
				end
				Panel:AddControl("CheckBox", {Label = ply:Nick(), Command = FriendCommand})
			end
		end
		Panel:AddControl("Button", {Text  = "Apply Settings", Command = "sppa_applyfriends"})
	end
	Panel:AddControl("Button", {Text  = "Clear Friends", Command = "sppa_clearfriends"})
end

function cider.menu.pp.SpawnMenuOpen()
	if(cider.menu.pp.AdminCPanel) then
		cider.menu.pp.AdminPanel(cider.menu.pp.AdminCPanel)
	end
	if(cider.menu.pp.ClientCPanel) then
		cider.menu.pp.ClientPanel(cider.menu.pp.ClientCPanel)
	end
end
hook.Add("SpawnMenuOpen", "cider.menu.pp.SpawnMenuOpen", cider.menu.pp.SpawnMenuOpen)

function cider.menu.pp.PopulateToolMenu()
	spawnmenu.AddToolMenuOption("Utilities", "Simple Prop Protection (Applejack)", "Admin", "Admin", "", "", cider.menu.pp.AdminPanel)
	spawnmenu.AddToolMenuOption("Utilities", "Simple Prop Protection (Applejack)", "Client", "Client", "", "", cider.menu.pp.ClientPanel)
end
hook.Add("PopulateToolMenu", "cider.menu.pp.PopulateToolMenu", cider.menu.pp.PopulateToolMenu)
