
function newplayer_menu()
	local ply = LocalPlayer();
	local frame = vgui.Create("DFrame");
		frame:SetSize(400, 500)
		frame:Center()
		frame:SetDraggable(false)
		frame:ShowCloseButton(true) -- for now, aka testing...
		frame:MakePopup();
	local welcome = vgui.Create("DLabel", frame)
		welcome:SetText([[Welcome to First Class Roleplay! 
		Before you can start playing, 
		you need to enter a roleplay name, 
		and a few other details.
		Hit enter on all the text boxes to apply changes.]]);
		welcome:SizeToContents();
		welcome:SetPos(50, 50);
		welcome:SetTextColor(Color(0, 0, 0, 255));
		welcome:SetFont("Ariel");
	local rpnamel = vgui.Create("DLabel", frame)
		rpnamel:SetText([[Roleplay Name: ]]);
		rpnamel:SetPos(40, 60);
		rpnamel:SizeToContents();
		rpnamel:SetFont("Ariel");
	local rpnamee = vgui.Create("DTextEntry", frame)
		rpnamee:SetText("");
		rpnamee:SetSize(50, 25)
		rpnamee:SetPos(50, 60)
		local function rpt()
			return rpnamee:GetText();
		end
		rpnamee.OnEnter = function()
			if(rpt()== "" or rpt() == nil) then
				chat.AddText(Color(255, 0, 0, 255), "Error, you must enter a name!");
				return
			end
			RunConsoleCommand("say", "/rpname "..rpt())
		end
	local descl = vgui.Create("DLabel", frame)
		descl:SetText([[Description: ]]);
		descl:SetPos(40, 70)
		descl:SizeToContents()
	local desc = vgui.Create("DTextEntry", frame)
		desc:SetText("");
		desc:SetSize(50, 25);
		desc:SetPos(50, 70);
		local function dt()
			return desc:GetText()
		end

		desc.OnEnter = function()
			if(dt()== "" or dt()== nil) then
				chat.AddText(Color(255, 0, 0, 255), "Error, you must enter a description!");
				return
			end
			RunConsoleCommand("say", "/description "..dt())
		end
	local button = vgui.Create("DButton", frame)
		button:SetText("Done! Now let me play!");
		button:SizeToContents()
		button:SetPos(100, 50)
		button.DoClick = function()
			if(dt()== "" or dt()== nil or rpt() == "" or rpt() == nil) then
				chat.AddText(Color(255, 0, 0, 255), "You must enter values! You are not done!");
				return
			end
			frame:Close();
		end
end

net.Receive("cider_NewPlayer_openframe", function(len, ply)
	newplayer_menu();
end)
concommand.Add("testing_derm", newplayer_menu)