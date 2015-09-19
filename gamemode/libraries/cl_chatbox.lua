--[[
name: "cl_chatbox.lua".
Product: "Cider (Roleplay)"
--]]

-- FUCKING EVOLVE.
function chat.AddText(...)
	local str = "[Admin] ";
	for _, word in pairs{...} do
		if (type(word) == "Player") then
			str = str .. word:Name();
		elseif (type(word) == "string") then
			str = str .. word;
		end
	end
	local sound = "ambient/water/drip2.wav"; -- 'drip' generic notification
	surface.PlaySound("ambient/water/drip2.wav");
	-- Add the notification using Garry's system.
	GAMEMODE:AddNotify(str, 0, 10);
	print(str);
end

cider.chatBox = {};

-- Create some client convars that we'll need.
CreateClientConVar("cider_chatbox_ooc", "0", true, true);
CreateClientConVar("cider_chatbox_ic", "0", true, true);
CreateClientConVar("cider_chatbox_joinleave", "0", true, true);

-- Create the font used for all text.
surface.CreateFont("cider_chatBox_MainText", {
	font = "Tahoma",
	size = 14,
	weight = 600,
	antialias = true
})

-- Create a table to store the messages, derma, and join spam attempts.
cider.chatBox.maximumLines = 8;
cider.chatBox.joinSpam = {};
cider.chatBox.messages = {};
cider.chatBox.derma = {};

-- Create a table to story the chat history.
cider.chatBox.history = {};
cider.chatBox.history.messages = {};
cider.chatBox.history.position = 0;

-- Hook into when a player message is sent from the server.
usermessage.Hook("cider.chatBox.playerMessage", function(msg)
	local player = msg:ReadEntity();
	local filter = msg:ReadString();
	local text = msg:ReadString();
	--print(player, "ar", filter, text);
	-- Check to see if the player is a player.
	if ( player:IsPlayer() ) then
		cider.chatBox.chatText(player:EntIndex(), player:Name(), text, filter);
	end
end)

-- Hook into when a message is sent from the server.
usermessage.Hook("cider.chatBox.message", function(msg)
	local filter = msg:ReadString();
	local text = msg:ReadString();

	-- Chat Text.
	cider.chatBox.chatText(nil, nil, text, filter);
end);

-- Get the position of the chat area.
function cider.chatBox.getPosition()
	local x, y = 8, ScrH() - (ScrH() / 4);

	-- Check if we have a custom chat area position set.
	if (cider.chatBox.position) then
		x = cider.chatBox.position.x;
		y = cider.chatBox.position.y;
	end

	-- Return the x and y position.
	return x, y;
end

-- Get the x position of the chat area.
function cider.chatBox.getX()
	local x, y = cider.chatBox.getPosition();

	-- Return the x position.
	return x;
end

-- Get the y position of the chat area.
function cider.chatBox.getY()
	local x, y = cider.chatBox.getPosition();

	-- Return the y position.
	return y;
end

-- Get the spacing between messages.
function cider.chatBox.getSpacing() return 20; end


-- Return a table of wrapped text (thanks to SamuraiMushroom for this function).
function cider.chatBox.wrapText(text, font, width, overhead, base)
	surface.SetFont(font);

	-- Save the original width for the next line and take the overhead from the width.
	local original = width; width = width - (overhead or 0);

	-- Check to see if the width of the text is greater than the width we specified.
	if (surface.GetTextSize( string.gsub(text, "&", "U") ) > width) then
		local length = 0;
		local exploded = {};
		local seperator = "";

		-- Check if the text has any spaces in it.
		if ( string.find(text, " ") ) then
			exploded = string.Explode(" ", text);
			seperator = " ";
		else
			exploded = string.ToTable(text);
			seperator = "";
		end

		-- Create a variable to store the current position of the text.
		local i = 1;

		-- Keep looping while the length of the text is smaller than our specified width.
		while (length < width) do
			local block = table.concat(exploded, seperator, 1, i);

			-- Set the length to be the length of this block of text.
			length = surface.GetTextSize( string.gsub(block, "&", "U") );

			-- Increase the iterator so that we can move on to the next block of text.
			i = i + 1;
		end

		-- Insert the first line into our out table.
		table.insert( base, table.concat(exploded, seperator, 1, i - 2) );

		-- Get the second line of the text which we may need to wrap again.
		text = table.concat(exploded, seperator, i - 1);

		-- Check to see if the size of the second line is greater than our specified width.
		if (surface.GetTextSize( string.gsub(text, "&", "U") ) > original) then
			cider.chatBox.wrapText(text, font, original, nil, base);
		else
			table.insert(base, text);
		end
	else
		table.insert(base, text);
	end
end

-- Create all the derma panels.
function cider.chatBox.createDermaAll()
	cider.chatBox.createDermaPanel();
	cider.chatBox.createDermaCheckBoxes();
	cider.chatBox.createDermaButtons();
	cider.chatBox.createDermaFilters();
	cider.chatBox.createDermaTextEntry();

	-- Hide the main chat panel.
	cider.chatBox.derma.panel.hide();
end

-- Create the derma buttons.
function cider.chatBox.createDermaButtons()
	if (!cider.chatBox.derma.buttons) then
		cider.chatBox.derma.buttons = {};

		-- Create a derma button to scroll up the chat box.
		cider.chatBox.createDermaButton("Up", "+", 434, 16, "Scroll up the message area.", function()
			cider.chatBox.history.position = cider.chatBox.history.position - 1;
		end, function(self)
			if (cider.chatBox.history.messages[cider.chatBox.history.position - cider.chatBox.maximumLines]) then
				self:SetDisabled(false);
			else
				self:SetDisabled(true);
			end
		end);

		-- Create a derma button to scroll down the chat box.
		cider.chatBox.createDermaButton("Down", "-", 454, 16, "Scroll down the message area.", function()
			cider.chatBox.history.position = cider.chatBox.history.position + 1;
		end, function(self)
			if (cider.chatBox.history.messages[cider.chatBox.history.position + 1]) then
				self:SetDisabled(false);
			else
				self:SetDisabled(true);
			end
		end);

		-- Create a derma button to go to the bottom of the chat box.
		cider.chatBox.createDermaButton("Bottom", "*", 474, 16, "Goto the bottom of the message area.", function()
			cider.chatBox.history.position = #cider.chatBox.history.messages;
		end, function(self)
			if (cider.chatBox.history.position < #cider.chatBox.history.messages) then
				self:SetDisabled(false);
			else
				self:SetDisabled(true);
			end
		end);

		-- Create a derma button for the filters.
		cider.chatBox.createDermaButton("Filters", "Filters", 494, 80, "Enable or disable message filters.", function()
			local IsVisible = cider.chatBox.derma.filters:IsVisible();

			-- Check Is Visible.
			if (IsVisible) then
				cider.chatBox.derma.filters:SetVisible(false);
			else
				cider.chatBox.derma.filters:SetVisible(true);
			end
		end, function(self) end);
	end
end

-- Create a derma button parented to the chat panel.
function cider.chatBox.createDermaButton(name, text, x, width, toolTip, doClick, think)
	if (!cider.chatBox.derma.buttons[name]) then
		cider.chatBox.derma.buttons[name] = vgui.Create("DButton", cider.chatBox.derma.panel);
		cider.chatBox.derma.buttons[name]:SetText(text);
		cider.chatBox.derma.buttons[name]:SetSize(width, 16);
		cider.chatBox.derma.buttons[name]:SetPos(x, 4);
		cider.chatBox.derma.buttons[name]:SetToolTip(toolTip);
		cider.chatBox.derma.buttons[name].DoClick = doClick;
		cider.chatBox.derma.buttons[name].Think = think;
	end
end

-- Create the derma check boxes.
function cider.chatBox.createDermaCheckBoxes()
	if (!cider.chatBox.derma.checkBoxes) then cider.chatBox.derma.checkBoxes = {} end
end

-- Create a derma check box parented to the chat panel.
function cider.chatBox.createDermaCheckBox(name, conVar, x, toolTip, label, parent, y)
	if (!cider.chatBox.derma.checkBoxes[name]) then
		parent = parent or cider.chatBox.derma.panel;
		y = y or 4;

		-- Check if a label was defined.
		if (label) then
			cider.chatBox.derma.checkBoxes[name] = vgui.Create("DCheckBoxLabel", parent);
			cider.chatBox.derma.checkBoxes[name]:SetText(label);
		else
			cider.chatBox.derma.checkBoxes[name] = vgui.Create("DCheckBox", parent);
		end

		-- Set the position and other settings of the check box.
		cider.chatBox.derma.checkBoxes[name]:SetPos(x, y);
		cider.chatBox.derma.checkBoxes[name]:SetToolTip(toolTip);
		cider.chatBox.derma.checkBoxes[name]:SetConVar(conVar);

		-- Check if a label was defined.
		if (Label) then
			cider.chatBox.derma.checkBoxes[name]:SizeToContents();
		else
			cider.chatBox.derma.checkBoxes[name]:SetSize(16, 16);
		end
	end
end

-- Create the derma text entry parented to the chat panel.
function cider.chatBox.createDermaTextEntry()
	if (!cider.chatBox.derma.textEntry) then
		cider.chatBox.derma.textEntry = vgui.Create("DTextEntry", cider.chatBox.derma.panel);
		cider.chatBox.derma.textEntry:SetPos(34, 4);
		cider.chatBox.derma.textEntry:SetSize(396, 16);
		cider.chatBox.derma.textEntry.OnEnter = function()
			local message = cider.chatBox.derma.textEntry:GetValue();

			-- Check if the message is valid.
			if (message and message ~= "") then
				cider.chatBox.history.position = #cider.chatBox.history.messages;
				--print("Original: '" .. message .. "', replaced: '" .. string.Replace(message, "\"", "$q") .. "'.");
				-- Send our message to the server to validate it.
				RunConsoleCommand( "say", string.Replace(message, "\"", "$q").."" );

				-- Set the text to an empty string to reset it.
				cider.chatBox.derma.textEntry:SetText("");
			end

			-- Hide the derma chat panel.
			cider.chatBox.derma.panel.hide();
		end

		-- Called every frame.
		function cider.chatBox.derma.textEntry:Think()
			local message = self:GetValue();

			-- Check if the length of the message is greater than the maximum allowed.
			if (string.len(message) > 126) then
				self:SetValue(string.sub(message, 1, 126));
				self:SetCaretPos(126);

				-- Play a sound to alert the player that they're over the character limit.
				surface.PlaySound("common/talk.wav");
			end
		end
	end
end

-- Create the derma text filters parented to the chat panel.
function cider.chatBox.createDermaFilters()
	if (!cider.chatBox.derma.filters) then
		cider.chatBox.derma.filters = vgui.Create("EditablePanel");
		cider.chatBox.derma.filters:SetSize(116, 72);

		-- Called every time the panel should be painted.
		function cider.chatBox.derma.filters:Paint()
			local backgroundColor = Color(0, 0, 0, 150);
			local titleColor = Color(50, 255, 50, 255);
			local textColor = Color(255, 255, 255, 255);
			local cornerSize = 4;

			-- Draw a rounded box which the filter check boxes will go on.
			draw.RoundedBox(cornerSize, 0, 0, self:GetWide(), self:GetTall(), backgroundColor);
		end

		-- Called every frame.
		function cider.chatBox.derma.filters:Think()
			local x = cider.chatBox.derma.panel.x + cider.chatBox.derma.panel:GetWide() + 4;
			local y = cider.chatBox.derma.panel.y + cider.chatBox.derma.panel:GetTall() - self:GetTall();

			-- Set the position of the filters box.
			self:SetPos(x, y);
		end

		-- Create the derma check boxes parented to the filters panel.
		cider.chatBox.createDermaCheckBox("OOC", "cider_chatbox_ooc", 8, "Filter out-of-character messages.", "Filter OOC", cider.chatBox.derma.filters, 8);
		cider.chatBox.createDermaCheckBox("IC", "cider_chatbox_ic", 8, "Filter in-character messages.", "Filter IC", cider.chatBox.derma.filters, 28);
		cider.chatBox.createDermaCheckBox("Join/Leave", "cider_chatbox_joinleave", 8, "Filter join/leave messages.", "Filter Join/Leave", cider.chatBox.derma.filters, 48);
	end
end

-- Create the derma chat panel.
function cider.chatBox.createDermaPanel()
	if (!cider.chatBox.derma.panel) then
		cider.chatBox.derma.panel = vgui.Create("EditablePanel");
		cider.chatBox.derma.panel:SetSize(576, 24);
		cider.chatBox.derma.panel.show = function()
			cider.chatBox.derma.panel:SetKeyboardInputEnabled(true);
			cider.chatBox.derma.panel:SetMouseInputEnabled(true);

			-- Set all panels connected to this one to be visible.
			cider.chatBox.derma.scroll:SetVisible(true);
			cider.chatBox.derma.panel:SetVisible(true);
			cider.chatBox.derma.panel:MakePopup();

			-- Set the history position to the latest.
			cider.chatBox.history.position = #cider.chatBox.history.messages;

			-- Request focus so that we can type into the text entry panel directly.
			cider.chatBox.derma.textEntry:RequestFocus();

			-- Call a hook so plugins can get when the chat box is opened.
			hook.Call("OpenChatBox",GAMEMODE);
		end

		-- A function to hide the chat panel.
		cider.chatBox.derma.panel.hide = function()
			cider.chatBox.derma.panel:SetKeyboardInputEnabled(false);
			cider.chatBox.derma.panel:SetMouseInputEnabled(false);

			-- Set the text of the text entry to an empty string to reset it.
			cider.chatBox.derma.textEntry:SetText("");

			-- Set the panels connected to this to be invisible.
			cider.chatBox.derma.panel:SetVisible(false);
			cider.chatBox.derma.scroll:SetVisible(false);
			cider.chatBox.derma.filters:SetVisible(false);

			-- Call a hook so plugins can get when the chat box is closed.
			hook.Call("CloseChatBox",GAMEMODE);
		end

		-- Called every time the panel should be painted.
		function cider.chatBox.derma.panel:Paint()
			local backgroundColor = Color(0, 0, 0, 150);
			local cornerSize = 4;
			local titleColor = Color(50, 255, 50, 255);
			local textColor = Color(255, 255, 255, 255);

			-- Draw a rounded box for the text entry to go on.
			draw.RoundedBox(cornerSize, 0, 0, self:GetWide(), self:GetTall(), backgroundColor);

			-- Set the font of the text.
			surface.SetFont("cider_chatBox_MainText");

			-- Get the width of the text.
			local width = surface.GetTextSize("Say");

			-- Check if we're sending a message to our team.
			if (cider.chatBox.sayTeam) then
				width = surface.GetTextSize("Say Team");

				-- Draw text to tell us that we're sending a message to our team.
				draw.SimpleText("Say Team", "cider_chatBox_MainText", 5, 13, Color(0, 0, 0, 255), 0, 1);
				draw.SimpleText("Say Team", "cider_chatBox_MainText", 4, 12, titleColor, 0, 1);

				-- Set the position and size of the text entry.
				cider.chatBox.derma.textEntry:SetPos(74, 4);
				cider.chatBox.derma.textEntry:SetSize(356, 16);
			else
				draw.SimpleText("Say", "cider_chatBox_MainText", 5, 13, Color(0, 0, 0, 255), 0, 1);
				draw.SimpleText("Say", "cider_chatBox_MainText", 4, 12, titleColor, 0, 1);

				-- Set the position and size of the text entry.
				cider.chatBox.derma.textEntry:SetPos(34, 4);
				cider.chatBox.derma.textEntry:SetSize(396, 16);
			end

			-- Draw a colon after the chat prefix.
			draw.SimpleText(":", "cider_chatBox_MainText", 5 + width, 13, Color(0, 0, 0, 255), 0, 1);
			draw.SimpleText(":", "cider_chatBox_MainText", 4 + width, 12, textColor, 0, 1);
		end

		-- Called eveyr frame.
		function cider.chatBox.derma.panel:Think()
			local x, y = cider.chatBox.getPosition();

			-- Set the position of the chat panel.
			cider.chatBox.derma.panel:SetPos(x, y + 6);

			-- Check if the main panel is visible.
			if (self:IsVisible() and input.IsKeyDown(KEY_ESCAPE)) then cider.chatBox.derma.panel.hide(); end
		end

		-- Create the scroll panel.
		cider.chatBox.derma.scroll = vgui.Create("Panel");
		cider.chatBox.derma.scroll:SetPos(0, 0);
		cider.chatBox.derma.scroll:SetSize(0, 0);

		-- Called when the panel is scrolled with the mouse wheel.
		function cider.chatBox.derma.scroll:OnMouseWheeled(delta)
			local isVisible = cider.chatBox.derma.panel:IsVisible();

			-- Check if the chat panel is visible.
			if (isVisible) then
				if (delta > 0) then
					if (cider.chatBox.history.messages[cider.chatBox.history.position - cider.chatBox.maximumLines]) then
						cider.chatBox.history.position = cider.chatBox.history.position - 1;
					end
				else
					if (cider.chatBox.history.messages[cider.chatBox.history.position + 1]) then
						cider.chatBox.history.position = cider.chatBox.history.position + 1;
					end
				end
			end
		end
	end
end

-- Called when a player presses a bind.
function cider.chatBox.playerBindPress(player, bind, press)
	if (bind == "toggleconsole") then
		cider.chatBox.derma.panel.hide();
	elseif ( (bind == "messagemode" or bind == "messagemode2") and press ) then
		cider.chatBox.derma.panel.show();

		-- Return true because we don't want it to perform the default action.
		return true;
	end
end

-- Add the hook.
hook.Add("PlayerBindPress", "cider.chatBox.playerBindPress", cider.chatBox.playerBindPress);

-- Add a new message to the message queue.
function cider.chatBox.messageAdd(title, name, text, filtered, icon)
	local message = {};

	-- Check if a title was specified.
	if (title) then
		message.title = {};
		message.title.text = title[1];
		message.title.color = title[2] or Color(255, 255, 255, 255);
	end

	-- Check if a name was specified.
	if (name) then
		message.name = {};
		message.name.text = name[1];
		message.name.color = name[2] or Color(255, 255, 255, 255);
	end

	-- Set some information and settings about the message.
	message.timeStart = CurTime();
	message.timeFade = message.timeStart + 10;
	message.timeFinish = message.timeFade + 1;
	message.spacing = 0;
	message.blocks = {};
	message.color = text[2] or Color(255, 255, 255, 255);
	message.alpha = 255;
	message.lines = 1;
	message.text = text[1];
	message.icon = icon;

	-- Extract the types from the message and print them to the console.
	cider.chatBox.extractClasses(message);
	cider.chatBox.printConsole(message);

	-- Check if the message is filtered.
	if (filtered) then return; end

	-- Check the position of the history to see if it's the latest one.
	if (cider.chatBox.history.position == #cider.chatBox.history.messages) then
		cider.chatBox.history.position = #cider.chatBox.history.messages + 1;
	end

	-- Check if we've reached the maximum lines.
	if (#cider.chatBox.messages == cider.chatBox.maximumLines) then
		table.remove(cider.chatBox.messages, cider.chatBox.maximumLines);
	end

	-- Get a copy of the message for the history.
	local copy = table.Copy(message);

	-- Insert the message into both the messages table and the history table.
	table.insert(cider.chatBox.messages, 1, message);
	table.insert(cider.chatBox.history.messages, copy);

	-- Play a sound to let us know we've got a new message.
	surface.PlaySound("common/talk.wav");
end

-- Print the message to the console.
function cider.chatBox.printConsole(message)
	local total = "";

	-- Check if we have an icon specified.
	if (message.icon) then total = total.."("..message.icon[2]..") "; end
	if (message.title) then total = total..message.title.text.." "; end
	if (message.name) then total = total..message.name.text..": "; end

	-- Loop through the message's blocks.
	for k, v in pairs(message.blocks) do
		local space = " ";

		-- Check if we're at the last key, if we're breaking, and if we're a text type.
		if (k == #message.blocks) then space = ""; end
		if (v.newline) then space = ""; end
		if (v.class == "Text") then total = total..v.text..space; end

		-- Check if we're breaking.
		if (v.newline) then
			print(total);

			-- Reset the string so we can do the next line.
			total = "";
		end
	end

	-- Check if our total is not an empty string.
	if (total ~= "") then print(total); end
end

-- Extract classes.
function cider.chatBox.extractClasses(message)
	local width = 0;

	-- Set the font of the text.
	surface.SetFont("cider_chatBox_MainText");

	-- Check if we have an icon specified.
	if (message.icon) then width = width + 16 + surface.GetTextSize(" "); end
	if (message.title) then width = width + surface.GetTextSize( string.gsub(message.title.text.." ", "&", "U") ); end
	if (message.name) then width = width + surface.GetTextSize( string.gsub(message.name.text.." ", "&", "U") ); end

	-- Create a table to store the wrapped text and then get the wrapped text.
	local wrapped = {};

	-- Wrap the text into our table.
	cider.chatBox.wrapText(message.text, "cider_chatBox_MainText", 576, width, wrapped);

	-- Loop through the wrapped text.
	for k, v in pairs(wrapped) do
		if (v ~= "") then
			if (k == #wrapped) then
				table.insert( message.blocks, {class = "Text", text = v} );
			else
				table.insert( message.blocks, {class = "Text", text = v, newline = true} );

				-- Increase the number of lines.
				message.lines = message.lines + 1;
			end
		end
	end

	-- Loop through our blocks.
	for k, v in pairs(message.blocks) do
		if (v.newline) then
			if (!message.blocks[k + 1]) then
				message.blocks[k].newline = false;

				-- Reduce the number of lines.
				message.lines = message.lines - 1;
			end
		end
	end
end

-- Called every frame.
function cider.chatBox.think()
	local curTime = CurTime();

	-- Loop though our messages.
	for k, v in pairs(cider.chatBox.messages) do
		if (curTime >= v.timeFade) then
			local fadeTime = v.timeFinish - v.timeFade;
			local timeLeft = v.timeFinish - curTime;
			local alpha = math.Clamp((255 / fadeTime) * timeLeft, 0, 255);

			-- Check if we are completely transparent.
			if (alpha == 0) then
				table.remove(cider.chatBox.messages, k);
			else
				v.alpha = alpha;
			end
		end
	end
end

-- Add the hook.
hook.Add("Think", "cider.chatBox.think", cider.chatBox.think);

-- Called when the HUD should be painted.
function cider.chatBox.hudPaint()
	local x, y = cider.chatBox.getPosition();

	-- Set the font of the text.
	surface.SetFont("cider_chatBox_MainText");

	-- Get the size of a space with this font.
	local space = surface.GetTextSize(" ");
	local box = {width = 0, height = 0};

	-- Set the table that we're using to our messages table.
	local messages = cider.chatBox.messages;
	local isVisible = cider.chatBox.derma.panel:IsVisible();

	-- Check if our chat panel is visible.
	if (isVisible) then
		messages = {};

		-- Loop through our maximum number of history messages.
		for i = 0, (cider.chatBox.maximumLines - 1) do
			table.insert(messages, cider.chatBox.history.messages[cider.chatBox.history.position - i]);
		end
	else
		if (#cider.chatBox.history.messages > 100) then
			local amount = #cider.chatBox.history.messages - 100;

			-- Loop through the amount of histroy messages that we are over by.
			for i = 1, amount do table.remove(cider.chatBox.history.messages, 1); end
		end
	end

	-- Loop through our messages.
	for k, v in pairs(messages) do
		if (messages[k - 1]) then y = y - messages[k - 1].spacing; end

		-- Get whether our chat panel is visible.
		local isVisible = cider.chatBox.derma.panel:IsVisible();

		-- Check if our main chat panel is visible or we're the first key in the table.
		if (!isVisible and k == 1) then
			y = y - ((cider.chatBox.getSpacing() + v.spacing) * (v.lines - 1)) + 14;
		else
			if (k == 1) then y = y + 2; end

			-- Increase y by our spacing multiplied by the lines we have.
			y = y - ((cider.chatBox.getSpacing() + v.spacing) * v.lines);
		end

		-- Set our x and y position for this message.
		local messageX = x;
		local messageY = y;

		-- Check if the player is a icon.
		if (v.icon) then
			surface.SetTexture( surface.GetTextureID( v.icon[1] ) );
			surface.SetDrawColor(255, 255, 255, v.alpha);
			surface.DrawTexturedRect(messageX, messageY - 1, 16, 16);

			-- Increase our x position with our space size.
			messageX = messageX + 16 + space;
		end

		-- Check if we have a title specified.
		if (v.title) then
			local width = surface.GetTextSize( string.gsub(v.title.text, "&", "U") );

			-- Get the title color for our text.
			local titleColor = Color(v.title.color.r, v.title.color.g, v.title.color.b, v.alpha);

			-- Draw our text with the necessary settings.
			draw.SimpleText(v.title.text, "cider_chatBox_MainText", messageX + 1, messageY + 1, Color(0, 0, 0, v.alpha), 0, 0);
			draw.SimpleText(v.title.text, "cider_chatBox_MainText", messageX, messageY, titleColor, 0, 0);

			-- Increase our x position with our space size.
			messageX = messageX + width + space;
		end

		-- Check if we have a name specified.
		if (v.name) then
			local width = surface.GetTextSize( string.gsub(v.name.text, "&", "U") );

			-- Get the color of the name.
			local nameColor = Color(v.name.color.r, v.name.color.g, v.name.color.b, v.alpha);

			-- Draw our text with the necessary settings.
			draw.SimpleText(v.name.text, "cider_chatBox_MainText", messageX + 1, messageY + 1, Color(0, 0, 0, v.alpha), 0, 0);
			draw.SimpleText(v.name.text, "cider_chatBox_MainText", messageX, messageY, nameColor, 0, 0);

			-- Increase our x position with our width.
			messageX = messageX + width;

			-- Get the width of a colon with this font.
			local width = surface.GetTextSize(":");

			-- Draw our text with the necessary settings.
			draw.SimpleText(":", "cider_chatBox_MainText", messageX + 1, messageY + 1, Color(0, 0, 0, v.alpha), 0, 0);
			draw.SimpleText(":", "cider_chatBox_MainText", messageX, messageY, Color(255, 255, 255, v.alpha), 0, 0);

			-- Increase our x position with our space size.
			messageX = messageX + width + space;
		end

		-- Get the text color.
		local textColor = Color(v.color.r, v.color.g, v.color.b, v.alpha);

		-- Loop through our blocks.
		for k2, v2 in pairs(v.blocks) do
			if (v2.class == "Text") then
				local width = surface.GetTextSize( string.gsub(v2.text, "&", "U") );

				-- Draw our text with the necessary settings.
				draw.SimpleText(v2.text, "cider_chatBox_MainText", messageX + 1, messageY + 1, Color(0, 0, 0, v.alpha), 0, 0);
				draw.SimpleText(v2.text, "cider_chatBox_MainText", messageX, messageY, textColor, 0, 0);

				-- Increase our x position with our space size.
				messageX = messageX + width + space;
			end

			-- Check if the width is greater than the width of the box.
			if (messageX - 8 > box.width) then box.width = messageX - 8; end

			-- Check if our y position is greater than the height of the box.
			if (cider.chatBox.getY() - y > box.height) then box.height = cider.chatBox.getY() - y; end

			-- Check if we need to create a new line here.
			if (v2.newline) then
				messageY = messageY + cider.chatBox.getSpacing() + v.spacing;
				messageX = x;
			end
		end
	end

	-- Set the position of our scroll panel.
	cider.chatBox.derma.scroll:SetPos(x, y);
	cider.chatBox.derma.scroll:SetSize(box.width, box.height);
end

-- Add the hook.
hook.Add("HUDPaint", "cider.chatBox.hudPaint", cider.chatBox.hudPaint);

-- Explode a string by tags.
function cider.chatBox.explodeByTags(variable, seperator, open, close)
	local results = {};
	local current = "";
	local tag = false;

	-- Loop through each individual character of the string.
	for i = 1, string.len(variable) do
		local character = string.sub(variable, i, i);

		-- Check to see if we're currently handling a tag.
		if (!tag) then
			if (character == open) then
				current = current..character; tag = true;
			elseif (character == Seperator) then
				results[#results + 1] = current; current = "";
			else
				current = current..character;
			end
		else
			current = current..character;

			-- Check to see if this character is the close tag.
			if (character == close) then tag = false; end
		end
	end

	-- Check to see if the current current is not an empty string.
	if (current ~= "") then results[#results + 1] = current; end

	-- Return our new exploded results as a table.
	return results;
end

-- Called when a player says something or a message is received from the server.
function cider.chatBox.chatText(index, name, text, filter)
	local class = filter;
	local filtered = false;

	-- Check if it is a valid filter.
	if (filter == "arrested" or filter == "yell"
	 or filter == "whisper" or filter == "me"
	 or filter == "advert" or filter == "request"
	 or filter == "radio" or filter == "loudradio"
	 or filter == "tied" or filter == "action") then
		filter = "ic";
	elseif (filter == "ooc" or filter == "looc" or filter == "pm" or filter == "notify") then
		filter = "ooc";
	end

	-- Check if a convar exists for this filter.
	if (ConVarExists("cider_chatbox_"..filter) and GetConVarNumber("cider_chatbox_"..filter) == 1) then
		filtered = true;
	elseif filter == "ic" and !(LocalPlayer():Alive() or LocalPlayer()._Sleeping) then --Kant stop the music.
		--print("Test")
		return
	end

	-- Get a player by the index.
	local player = player.GetByID(index);

	-- Fix Valve's errors.
	text = string.Replace(text, " ' ", "'");

	-- Check if the player is a valid entity.
	if ( IsValid(player) ) then
		local teamIndex = player:Team();
		local teamColor = team.GetColor(teamIndex);
		local icon = nil;

		-- Check if the player is a super admin.
		if ( player:IsSuperAdmin() ) then
			icon = {"gui/silkicons/shield", "^"};
		elseif ( player:IsAdmin() ) then
			icon = {"gui/silkicons/star", "*"};
		elseif ( player:IsModerator() ) then
			icon = {"gui/silkicons/emoticon_smile", ":)"};
		elseif ( player:GetNetworkedBool("Donator") ) then
			icon = {"gui/silkicons/heart", "<3"};
		end

		-- Check if the class is valid.
		if (class == "chat") then
			cider.chatBox.messageAdd(nil, {name, teamColor}, {text}, filtered);
		elseif (class == "ic") then
			cider.chatBox.messageAdd(nil, nil, { name..": "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "me") then
			cider.chatBox.messageAdd(nil, nil, { "*** "..name.." "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "action" and name == nil) then
			cider.chatBox.messageAdd(nil,nil,{"*** "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "action") then
			cider.chatBox.messageAdd({"(Action: "..name..")", Color(255, 75, 75, 255)},nil,{"*** "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "advert") then
			cider.chatBox.messageAdd( {"(Advert) "..player:GetNWInt("RPName")..":"}, nil, { text, Color(200, 150, 225, 255) }, filtered);
		elseif (class == "yell") then
			cider.chatBox.messageAdd( {"(Yell)"}, nil, { name..": "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "whisper") then
			cider.chatBox.messageAdd( {"(Whisper)"}, nil, { name..": "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "looc") then
			cider.chatBox.messageAdd( {"(Local OOC)", Color(255, 75, 75, 255) }, nil, { name..": "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "arrested") then
			cider.chatBox.messageAdd( {"(Arrested)"}, nil, { name..": "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "tied") then
			cider.chatBox.messageAdd( {"(Tied)"}, nil, { name..": "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "broadcast") then
			cider.chatBox.messageAdd( {"(Broadcast)"}, nil, { name..": "..text, Color(255, 75, 75, 255) }, filtered);
		elseif (class == "request") then
			cider.chatBox.messageAdd( {"(Request)"}, nil, { name..": "..text, Color(125, 200, 255, 255) }, filtered);
		elseif (class == "radio") then
			cider.chatBox.messageAdd( {"(Radio)"}, nil, { name..": "..text, Color(150, 225, 75, 255) }, filtered);
		elseif (class == "loudradio") then
			cider.chatBox.messageAdd( {"(Radio)"}, nil, { name..": "..text, Color(255, 255, 150, 255) }, filtered);
		elseif (class == "pm") then
			cider.chatBox.messageAdd( {"(OOC)", Color(255, 75, 75, 255) },{"(PM)"}, { name..": "..text, Color(255, 150, 125, 255) }, filtered);
		elseif (class == "achievement") then
			cider.chatBox.messageAdd( {"(Achievement)", Color(255, 75, 75, 255) },{ name, teamColor}, { "just earned the achievement '"..text.."'!", Color(255, 150, 125, 255) }, filtered);
		elseif (class == "ooc") then
			cider.chatBox.messageAdd( {"(OOC)", Color(255, 75, 75, 255) }, { name, teamColor}, {text}, filtered, icon);
		elseif (class == "achat") then
			cider.chatBox.messageAdd( {"(@Admins)", Color(255, 75, 75, 255) }, { name, teamColor}, {text}, filtered, icon);
		elseif (class == "mchat") then
			cider.chatBox.messageAdd( {"(@Mods)", Color(255, 75, 75, 255) }, { name, teamColor}, {text}, filtered, icon);
		end
	else
		if (name == "Console" and class == "chat") then
			if string.find(text,"@@@@@@") then return false end
			cider.chatBox.messageAdd( {"(OOC)"}, {"Console", Color(150, 150, 150, 255) }, {text}, filtered);
		elseif (class == "joinleave") then
			text = text..".";

			-- Check if we find brackets in the text.
			if (string.find(text, "%(") and string.find(text, "%)")) then
				text = string.gsub(text, "Kicked by Console :", "Kicked by Console:", 1);
				text = string.gsub(text, "%.%)", ")");

				-- Add the edited message.
				cider.chatBox.messageAdd(nil, nil, {text, Color(255, 75, 75, 255) }, filtered);
			else
				if (!cider.chatBox.joinSpam[text] or CurTime() > cider.chatBox.joinSpam[text]) then
					cider.chatBox.messageAdd(nil, nil, {text, Color(175, 255, 125, 255) }, filtered);

					-- Set the next available join for this player to be 5 seconds from now.
					cider.chatBox.joinSpam[text] = CurTime() + 5;
				end
			end
		elseif (class == "notify") then
			cider.chatBox.messageAdd(nil, nil, {text, Color(255, 100, 200, 255) }, filtered);
		else
			cider.chatBox.messageAdd(nil, nil, {text, Color(255, 255, 150, 255) }, filtered);
		end
	end
end

-- Create all the derma panels.
cider.chatBox.createDermaAll();