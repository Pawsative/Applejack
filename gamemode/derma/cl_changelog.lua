--[[
Name: "cl_changelog.lua".
	~ Applejack ~
--]]

local PANEL = {};

-- Store the changelog in a string.
PANEL.changelog = [[
[18/09/2010]
[Changed] The quartermaster now has no timelimit
[12/09/2010]
[Changed] Sniper Rounds are now Penetration Rounds
[Changed] Deagles now use Penetration Rounds not Pistol Rounds
[Changed] Nerfed the deagle power a bit and upped the recoil a little
[Changed] Buffed the g3sg1's power a bit more and gave it an extra zoom mode
[02/07/2010]
[Added] Vuvuzelas
[Changed] Vuvuzelas are now illegal
[11/04/2010]
[Fixed] Some stamina exploits
[Fixed] The gamemode being a twat
[Fixed] Some issues with weapon returns
[Fixed] Untying
[Added] A tied player can be untied with a single knife stroke
[Changed] Untying emotes
[30/03/2010]
[Changed] Halved the minimum money drop amount, doubled the wait.
[Fixed] Any Official could unwarrant people. Now only the commander / mayor can.
[28/03/2010]
[Changed] Lowered movement speed by 100 inches/s for added realism
[Changed] Halved stamina drain to reduce complaints, increased stamina restore time for balance.
[23/03/2010]
[Added] /notify and /notifyall commands.
[16/03/2010]
[Changed] Lowered health regen in sleep.
[Changed] Health regen is no longer disabled when dying from hunger. (Hunger does 10x the damage regen'd, so why bother?)
[Code] Rewrote every function in cider.player and either made them use the player metatable or be part of the 'player' library.
[13/03/2010]
[Remvoed] Unarrest SWep
[Changed] Arrested players can now be lockpicked to be unarrested
[Changed] Rewrote lockpick SWep, it now makes lockpicky noises, emotes text and works better.
[13/02/2010]
[Added] A 'cleancars' command to remove all spawned cars on the server.
[09/02/2010]
[Fixed] Potentially fixed players being given an infinite cooldown timer after picking their cars up
[Changed] New loader for libraries and metatables.
[03/02/1010]
[Changed] Various wordings in the Officials plugin
[Changed] The lockdown commands now send a request to the mayor when used by non-mayorial people
[Code] New plugin system ahoy.
[02/02/1010]
[Changed] Spawnpoints are now placed where you are standing rather than looking, to prevent wall based errors.
[29/01/2010]
[Changed] You now start with 50HP if you die of hunger.
[Changed] You cannot see your hunger when it is paused by jail/tying.
[Code] Rewrote doors plugin.
[23/01/2010]
[Added] A new killbox
[Changed] Items are now nocollided with each other
[20/01/2010]
[Fixed] Some hand abuse glitches - you can no longer pick up constrained entities or chairs. :/
[Fixed] It was possible to kill other players with notes/contraband/items.
[Fixed] Knocked out players could be killed by someone tripping on them
[Fixed] Notes wern't given to the player that made them
[Fixed] Mayor could use Police Weapons
[19/01/2010- culminative update]
[Added] Lots of new food items
[Added] Stimulants item - wake unconsious players up
[Changed] Medical supplies are now drugs - and doctors sell 'em
[Changed] Tranq now uses Tranq Darts as ammo instead of sniper ammo.
[Changed] Massively changed how items are loaded/used by the code
[Changed] You can now use some items in cars
[Fixed] Sprint+Use not instausing dropped items
[Murdered] The stupid hook library.
[08/01/2010]
[Changed] Invisible command is now on a whitelist and can be applied to other people
[Changed] Stunstick now stuns for 2 minutes instead of 30 seconds
[Removed] /drop command
[03/01/2010]
[Fixed] Hopefully fixed a baton exploit
[Fixed] Broken penetration calculations causing bullets to go sideways
[Changed] Reduced the force requirement for undamped penetration - bullets will fly truer than before
[27/12/2009]
[Fixed] Chairs throwing you int he ground
[20/12/2009]
[Fixed] Tripmines not kill crediting
[Changed] Got rid of the useless core/ folder
[Added] Moonshine's timer module
[Added] Lots of doors to the GHQ
[Removed] Autolock as it made lockpicks useless
[18/12/2009]
[Code] Various bits of code cleanup, removing old commented out codes and unnecessary things
[Removed] The ability to freeze chairs
[17/12/2009]
[Changed] Golfs and Corvettes have differing speeds according to colour
[Fixed] Non-prop doors could only be breached once
[Advert] Do you want any game from Steam for free? If so, draw a picture of your favourite character from Half Life 2 and email it with the game you want, your username and password to GabeN@valvesoftwarecom!
[Rewrote] Help system's back-end
[06/12/2009]
[Changed] Rewrote item and contraband sents to use dtvars instead of nwvars
[Changed] Rewrote Vehicles plugin
[15/11/2009]
[Changed] Fixed the prop protection menu not showing up
[Changed] How emotes are handled slightly
[Revealed] The mystery item!
[13/11/2009]
[Changed] Mods can now demote
[Changed] When the mayor dies, all his props are cleaned up
[Changed] Added to the rules a bit
[07/11/2009]
[Changed] Rewrote Door STool and made it Door STool V2
[Fixed] Bug with the remover tool and spawned doors
[14/10/2009]
[Removed] Keypads
[Removed] The ability to open doors with the numpad
[Removed] Lockpick from Rogue/Renegade Leaders
[Changed] Lockpicks now take longer
[Changed] Lockpicks are $50 more expensive
[Changed] Doors have a minimum autoclose time of 5 seconds
[Fixed] Bug where inventories could become so full they broke
[04/09/2009]
[Added] Packaging system and packaging items
[Added] Autoclose setting for items that want to close the main menu when they're used
[Fixed] The 'Set Name' button in the access menu didn't work
[Changed] Penetration 'bounces' are less wild now
[Changed] The container menu works better and is based on wether or not you can still see the container rather than if you're still in the same place
[01/09/2009]
[Fixed] Map doors being cleared up by the prop protection
[Fixed] Pocket bug
[Fixed] Server lag/crash if a large amount of items were destroyed
[Fixed] Hopefully fixed an issue with the typing plugin and the esp lines
[Fixed] Typo that caused sealed doors to remain sealed forever
[Changed] Instead of telling you that "You cannot drop the item that far away!", it will create the item floating in the air, the max distance away
[21/08/2009]
[Fixed] Weapon viewmodels disapearing if you wern't allowed to switch weapons
[20/08/2009]
[Changed] Police commander's time limit from 30 to 60
[Changed] Lockpick price from 5k to 550
[Fixed] A large amount of Lua errors~
[19/08/2009]
[Added] Cops can destroy contra with one stunstick hit
[Changed] Door tax $100->$50
[Changed] Linked doors no longer lock each other
[Removed] Experemental door keyvalue settings
[Fixed] 'lack of models' bug
[OCD] Cleaned up all the item files
[OCD] Cider (Roleplay) -> Applejack (Roleplay)
[18/08/2009]
[Fixed] A container exploit
[16/08/2009]
[Added] Time-limits to all gun-selling classes
[Added] A time-limit to the Police Commander
[Added] Missing 'access changed' notification on team change
[Fixed] Clientside ricochette prediction
[Fixed] Physgun prop protection glitch
[Fixed] /unownable was a bit messed up
[Fixed] Gangmembers were being incorrectly denied access to their doors
[Fixed] Players in vehicles were invincible
[Changed] Item prices somewhat at Clown's insistence
[Changed] Steroids now only give 50 stamina and deal 10 damage when taken
[Changed] how spoken commands are handled
[Changed] Various doors no longer open on touch
[Removed] Cop weapon spawns, at Clown's insistence
[15/08/2009]
[Fixed] Weapons taking up twice as much 'space' as they should in the limit calculator
[Fixed] Ragdolls being immortal for 5 seconds
[Fixed] Knife leaving two impacts on doors
[Fixed] Being able to drop pockets and be left with negative space
[Fixed] Chairs knocked people over like cars
[Fixed] OOC was unavailable while dead
[Fixed] Grammar on some singular dropped items
[Fixed] Users could become over encumbered by dropping/destroying pockets
[Fixed] Money could not be put in containers
[Changed] Moved a lot of server-side code to server-side only files
[Changed] Ragdolls are now immortal for 2 seconds when knocked out by the knockout baton
[14/08/2009]
[Fixed] Headcrab spawning error
[Fixed] Various Lua errors
[13/08/2009]
[Changed] How calling plugin functions works They can now return values, in pretty much the same way hooks can
[Fixed] People can no longer spawn vehicles inside other things
[23/07/2009]
[Added] Slave doors
[Added] Door sealing
[Added] Door titles
[Added] Added /setowner
[Added] Doors plugin to save the above
[21/07/2009]
[Fixed] Bug that caused doors to incorrectly report access after being sold
[20/07/2009]
[Added] Some logging that I'd forgotton
[Added] Unpack support for command callbacks - allowing much neater command registration
[Fixed] Bug where vehicles could potentially be lost after a server crash
[15/07/2009]
[Added] A backend to the access menu
[Changed] Notes are now removed after 5 minutes
[Changed] Instead of notifying you if a string is too long, the script will simply truncate it
[14/07/2009]
[Added] An awesome new access menu allowing adding teams and gangs to your entity's access list as well as people
[13/07/2009]
[Added] A massive penalty for your stamina dropping under 2
[Changed] How stamina affects your movement etc
[Changed] Punching now takes 0 stamina
[12/07/2009]
[Added] Container spawning
[Added] Container-player interaction
[Fixed] log tab lag
[Fixed] A bunch of null entity errors reguarding breaches and padlocks
[10/07/2009]
[Added] The ability to drop more than one item at once from the inventory menu
[09/07/2009]
[Added] Concommand sppa_info to find the owner of a prop
[Added] Ricochets to bullets
[Added] The ability to open all unlocked doors with the use key
[Changed] The amount of penetrations/ricochets is determined by the power of the weapon
[Changed] Gun counts are now handled by the weapons rather than the code, to ensure it's always right
[Changed] Silenced weapons no longer penetrate
[Changed] Silenced weapons do half the damage as when they aren't
[Changed] Items are now loaded like sweps and entities
[Changed] All built in maps now close after 20 seconds
[06/07/2009]
[Added] A random element to penetrating bullets
[Changed] Penetration is now done on a bullet-by-bullet basis with callbacks instead of the unpredictable (and 99% wrong) trace system used before
[Fixed] Shotgun was fireable while reloading
[Fixed] Penetration issues with multiple bullets
[02/07/2009]
[Fixed] Some errors with penetration and fences Fences are now completely ignored by bullets rather than only being ignored by penetrating bullets
[23/06/2009]
[Changed] Rejigged the /door commands to actually use MultiOwn
[22/06/2009]
[Added] Padlock item - Halves the chance of a successful lockpick
[Changed] The lockpick is all about chance now, rather than hits
[Changed] Breaches now always go in the centre of doors and have a display on them
[Changed] Instead of being killed you are knocked flying when hit by a car
[Changed] Vehicles now use multiown
[Changed] Hands now apply acceleration instead of force, creating a standard throw/punch speed for all objects
[19/06/2009]
[Removed] The ability to open doors with the numpad
[Changed] Breaches - They now explode and blow the door off it's hinges
[18/06/2009]
[Forgot] to update the changelog for a while Whoops <_<
[Hope] I can remember everything added
[Added] /fallover - trip without moving
[Added] Brand new entity ownership system
[Added] Container system
[Added] Awesome new weapons system
[Changed] how damage in cars work - You now have to shoot the person rather than the car
[01/06/2009]
[Added] Police Weapons category
[Added] Rule P8: Quartermasters may *NOT* sell weapons to anyone other than the police If you are caught doing this, you will be perma-blacklisted from the job and banned for an hour
[Added] Rule 32: Do not ask to be killed or deliberately kill yourself
[Changed] Recoil on pistols
[Changed] All ironsights to work better
[Changed] The city laws to reflect aditions
[Removed] Crosshairs from guns
[31/05/2009]
[Fixed] /demote and /mutiny by fixing ciderteamhasAccessGroup
[29/05/2009]
[Fixed] Cops could jam any door with thier baton
[28/05/2009]
[Added] /action, allowing you to specify an environmental emote
[Added] /globalaction, allowing moderators+ to create an environmental emote for the whole map
[23/05/2009]
[Added] a /whenisdrugsmodgoingtobedone command
[Fixed] You could still nocollide cameras
[Fixed] Spawning chairs errored out
[Fixed] A few blocking props broken
[Fixed] REMOVEME door not being removed
[Removed] func_breakable door in abandoned house
[22/05/2009]
[Added] /restartmap command for admins
[Added] Colours to console logs whooo~
[Added] support for logfiles (sv_logecho 0 is a good plan)
[Added] A function that will notify you within 3 seconds of timers all failing on the server
[Changed] Logging system about a lot
[Fixed] Vehicle blacklist bug
[Fixed] Entire blacklist system Whoops!
[21/05/2009]
[Added] Some datestamps to some errors They are american formatted though Bah
[Changed] You can now no longer use any tool other than remover on doors, cameras and chairs
[19/05/2009]
[Added] ESPPaint hook to allow plugins to use the new ESP
[Changed] If a keypad is broken it will automatically comit suicide
[Fixed] A variety of serverside lua errors
[18/05/2009]
[Fixed] Players not showing up
[Changed] Laws and added a rule
[Changed] Laws now show you the old ones while editing
[Changed] Notes are now immaterial to stop people abusing them
[Fixed] Laws not letting you set long laws
[17/05/2009]
[Added] New ESP-like vision
[Added] /details
[Added] Custom flavour to easy-use items
[Added] Loads of new trafic calming props to mainstreet
[Fixed] If someone died while in a chair they were trapped
[Fixed] All weapons being stripped if you were tied while unconscious
[Removed] Police ESP
[12/05/2009]
[Fixed] Demotes not notifying players
[09/05/2009]
[Added] Details plugin
[Fixed] Exploit where donators could remove breaches
[Fixed] Contraband not being deleted when players leave
[Changed] Nexus to Government HQ
[Changed] Money printer prop for easier stacking and for a model deny
[Fixed] Officials not getting radio
[Fixed] Corpses not working properly
[Fixed] Big office chairs always putting you in the floor
[Fixed] Plugins not working with the filesystem
[08/05/2009]
[Added] AFK kicker
[Added] Anti-Prop-DM measures
[Added] The ability to drop money while tied/arrested so you can bribe your way out of situations
[Changed] A few salaries about
[Fixed] Admins/Mods not being told who owns props
[Fixed] Details for cars not showing up
[Fixed] Players not getting their weapons back when untied
[Fixed] Unconsious players not dropping weapons when killed
[Fixed] Players not receiving damage in cars
[Fixed] Server crash on /unownable remove
[02/05/2009]
[Added] Headcrabs
[Added] Tying up
[Fixed] Hands Read the new sexy instructions
[Fixed] Abuse of 'stuck in world' glitch - you now respawn with the health you had at the time and can't damage anything while 'stuck'
[Fixed] Glitch where you could pick up more items than you had room for
[01/05/2009]
[Changed] Increased salaries a lot
[Changed] Nerfed the shotgun's long range abilities
[Removed] Zombies
[24/04/2009]
[Added] Limits to the number of weapons you can have out at once
[23/04/2009]
[Added] Item bases - Less redundant code - You will notice nothing new
[Changed] Generic to Officials o/
[21/04/2009]
[Removed] SPP's prop info message for non-admins
[Added] New icons for various weapons
[19/04/2009]
[Added] All tab to log - see everything in order as it happens
[Changed] The model you see in the spawnicon is the model you will be
[18/04/2009]
[Added] Various optimisations: Should lag less now
[13/04/2009]
[Added] Base Groups and Gangs system
[Changed] How you interact with the character menu - Only jobs you are able to switch to will be visible
[Changed] Updated Rules'n'Laws
[Changed] Baton damage happens when you hold use, not sprint, due to multiple complaints
[12/04/2009]
[Changed] You must now be looking at a vehicle's doors to get in
[Fixed] Blacklisted players could get in vehicles if they tried hard enough
[Fixed] GPS not updating while in a vehicle
[07/04/2009]
[Fixed] Various sandbox functions wern't being called for admins
[Fixed] Health regen while dead
[Changed] Hunger kills you if you are unconsious
[Changed] Kudomiku to kuromeku
[06/04/2009]
[Changed] Made the log tab less laggy by having it update every 5s instead of frame (oops)
[03/04/2009]
[Fixed] sv_download now works, clients are sent the correct textures
[02/04/2009]
[Changed] Jeep is replaced by Trabbi, which now costs half that of a Jeep For the next two weeks, selling your Trabbi will give you a full refund
[01/04/2009]
[Added] Bunch of new cars - Bus, Trabbi, A Truck and a Citroen 7CV
[Changed] Drastic changes to the serverside parts of the vehicle plugin Getting in/out should now be a lot smoother, and the GPS should work properly now
[Fixed] The chairs threw you into the celing, now they will try to place you in front,behind, to the left, the right and below before placing you above
[Changed] Redefined all the custom exits to actually put you near the doors rather than at random points
[Changed] Damage reports now include the vehicle's name
[Changed] The main menu now opens on the character setup screen whenever you connect If you don't want this feature, cider_startupmenu 0 in console will turn it off
[29/03/2009]
[Added] GPS item - Finds your car
[Added] A few hints when looking at items
[Added] The driver's name to the vehicle description
[Changed] people's cars are removed when they die
[Fixed] Knocking out/Arresting people in cars
[Fixed] Bug where new players couldn't pick anything up
[Changed] Pocket limit to 10
[Changed] Increased inventory size to 40
[Changed] All cars now weigh 5
[Changed] Reduced the golf's max speed This should stop it flipping
[Fixed] Bug where emptying your inventory of an item would not show up
[Changed] When you breach a door, it won't shut for the next minute
[27/03/2009]
[Added] You can flip an upsidown car by locking it and pressing e
[Added] New access level, 'S', shows all speech on the server
[Removed] All physics props from the map
[Removed] Headlights
[Added] Configuration variable to say if hunger kills (it's set to 'no' atm)
[Added] Notifications for fall and hunger damage for admins
[Fixed] Broken fall damage
[26/03/2009]
[Added] Golf GTI
[Added] White and Silver Corvettes They don't go faster than the blue one, but damn do they look nice
[24/03/2009]
[Changed] Knockout times in various sweps - Now all use the config var
[Fixed] Various hands sound bugs
[Fixed] Typing not showing up
[Fixed] Doors no longer spaz out if shut while shut,
[Added] Notifications for picking up money and items
[23/03/2009]
[Fixed] People are woken up when arrested
[Removed] RPG until it's kinks are worked out
[22/03/2009]
[Fixed] Vehicle passenger seats
[Fixed] Log menu should be less laggy, with new entries at the top
[Fixed] Chloroform works
[Fixed] Rare glitch with timed sleeping
[21/03/2009]
[Added] Officially added the RPG
[Added] Log tab
[Added] Chloroform (with no testing! Fuck yeah~)
[20/03/2009]
[Added] The ability for items to use skins
[Changed] 50% off cars for this weekend only!
[Fixed] Car Keys Exploit
[18/03/2009]
[Added] Two new corvette colours
[Changed] Temporarily disabled picking up ragdolls due to crashing exploit
[Changed] Back to citrus ULX Fails *SIGH*
[Fixed] Contraband exploit
[11/03/2009]
[Changed] We now use ULX instead of citrus
[10/03/2009]
[Added] More phx explosives to blacklist
[Fixed] People could push props through the world
[09/03/2009]
[Added] Legs
[Added] Flavour text for automated actions
[Added] Very experemental tying up feature (TODO: Client HUD)
[Fixed] Glitch that allowed players to teleport objects from one end of the map to the other with hands
[Fixed] Props are now nocollided when picked up, to prevent the player getting stuck in them
[Fixed] Entities are no longer slightly rotated when picked up by the hands
[Fixed] Ironsights
[Fixed] Keypad
[08/03/2009]
[Added] Custom keypad swep, in keeping with the server rules
[Added] Custom job, clan and admin status to scoreboard
[Added] and OOC timer
[Changed] Shift-use on items will allow you to equip an item on the floor
[Changed] Integrated Stunbaton, Knockout/Wakeup, Arrest/Unarrest and Ram into Baton
[Fixed] Flashing weapon icons, and made some weapons use the correct icon (Did you know, the flashing was deliberate?)
[07/03/2009]
[Changed] Integrated keys, gravgun and hands into one swep
[05/03/2009]
[Fixed] Admins can no longer move the buildings blocking the cave
[Removed] A button that allowed people to spam physics props, eventually crashing the server
[02/03/2009]
[Changed] Massively optimised cl_initlua Thanks avon!
[Changed] Bars don't show up unless they need to
[Changed] Knockout system to use a modified version of thegrb93's Deathfix for ragdolls and Jinto's RagSpec for a first-person view (Yes, I have got DeathFix and RagSpec working together Touch me Not there Stop it, I don't like it)
[01/03/2009]
[Added] Powerful new prop size denial system
[Changed] Only superadmins can pick up cars Jesus christ you guys abuse a lot :|
[Fixed] Completely fixed the lagspike-on-death issue Ungracefully, need to work on it some more
[28/02/2009]
[Added] Black Market Dealer
[Added] The ability to lock your car while you are in it
[Added] A /trip command, to allow you to fall over without going blind
[Added] /setmodel name model, for those times when you want to be a toaster
[Changed] You can no longer hear IC messages while asleep or dead
[Changed] The way vehicles work a bit Nothing new your end
[Changed] Only superadmins can freeze cars now
[Changed] Only admins can remove cars now
[Changed] Tranq gun to scout model
[Fixed] Admins could not set laws
[Fixed] Demote menu said 'save' not 'demote'
[Fixed] People in cars should take 25 damage from players and 10 damage from everything else
[Fixed] Inventories didn't show up
[Fixed] Police commander dropped mp5 when he died
[Fixed] Keys didn't work
[Fixed] Props wouldn't freeze
[Fixed] Inventories didn't show up
[27/02/2009]
[Added] Two new classes - Rogues and Renegades
[Added] A config variable to allow weapons to drop when you are shot by the police
[Added] Tranq gun
[Removed] Rebels
[Changed] Ammo must be used before a weapon may be equipped
[Changed] Commands are no longer case sensitive
[Changed] Lots of commands now work while you are dead
[Changed] The sleep system quite a lot You can't see anything while asleep, but you gain 1HP/s while sleeping Use /sleep
[Changed] The 'kick/ban' buttons in the scoreboard now use citrus instead of raw commands
[Potential Fixed] Modified vehicle exiting/entering code again Hopefully fixed corvette
[Fixed] If a passenger was driven into the restricted zone, they were fired out of the map
[26/02/2009]
[Added] Laws tab, allowing the Mayor to lay down city-wide rules
[Added] Builder Class
[Added] The ability for admins to blacklist people from using OOC
[Changed] Some weapons are now illegal
[Changed] Jobs can have timers
[Changed] Police now only start with glocks However, they will still start with rifle ammo, so if they wish to use their own guns, they may
[Changed] Category system Nothing new on your end
[24/02/2009]
[Changed] City Administrator to Mayor Everyone called him the Mayor anyway, so it seemed silly to have his name different
[22/02/2009]
[Notice] You may not have noticed, but there's a 'TODO' section at the bottom of this
[Fixed] Spelling mistake prevented the 'no kill while holding' fix working Should do now
[Fixed] Breaches/lockpicks were not actually fixed They are now
[Potential Fixed] With any luck the getting out of corvette bug is fixed Haven't had time to test
[Change] You must wait 5 minutes after picking up a vehicle before you can spawn another one
[21/02/2009]
[Fixed] Fixed passengers not getting out of corvette
[Fixed] Sniper rifles now use sniper ammo
[Fixed] Broke breaches in last update They work now
[19/02/2009]
[Added] Corvette
[Changed] Updated the rules
[Removed] All forcefields known on rp_evocity_v2d
[18/02/2009]
[Fixed] Fixed cars not saving
[17/02/2009]
[Added] Configuration variables for hunger/stamina drain
[Changed] Vehicles are easier to get in now
[Changed] Integrated door stool with cider a bit
[Fixed] Some events had not been switched to the new log system
[Fixed] Forgot to format rules correctly
[Fixed] Messed up a bit in super hands re various ents
[Fixed] If an admin was killed while holding someone with their physgun, that person would get noclip Now noclipping players cannot damage anything, and you cannot be damaged while holding another player
[Fixed] Logging events were not being sent to clients
[Fixed] Hacky fix to force new players to rejoin to prevent pickup bug
[14/02/2009]
[Added] Preliminarys of the logging system
[Changed] Everyone earns their contrabad and salary at the same time now
[Changed] Classes about a bit
[Changed] The police can be give search warrants
[Fixed] Error where people would be stuck in vehicles
[Fixed] Various coding feckups that allowed people to be blacklisted indefinitely/have infinite pockets/resurrect the dead and such
[10/02/2009]
[Added] The ability for admins to punchwhore spectacularly
[Changed] Vehicles into a proper plugin
[Fixed] Feckton of bugs with cars
[08/02/2009]
[Added] A second seat to the Jeep
[Added] A credits tab
[Added] The ability to sell your car
[Added] A save command for superadmins
[Changed] Blacklist now allows admins to blacklist people from using categories
[Changed] Rewrote how cars are handled, seperated it out into a library and plugin
[Changed] NPCs are now Super Admin only
[Changed] Admins can pick up props and punt with Gravity Gun
[Changed] Fucktons of serverside code
[06/02/2009]
[Added] Categories
[Added] New job - Supplier - Makes misc items
[Changed] All items to work with categories instead of jobs
[05/02/2009]
[Added] Introduced the changelog
[Added] An item deny system
[Added] New configurations to change how the Police interact with contraband
[Changed] The Combine to the Police
[Changed] The City Administrator can no longer use weaponry
[Changed] The Police can no longer use breaches
[Changed] Various serverside improvements, which should increase speed, stability and pave the way for more cars!
[Other] And much much more But this is only the stuff I did today ~Lexi

[TODO - Noticed bugs and planned features]

[Feature] Storage system - Long Term Storage - Crate Storage - Re-Usable storage
[Feature] Inventory viewer for admins
]]

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(cider.menu.width, cider.menu.height - 8);

	-- Create a panel list to store the items.
	self.itemsList = vgui.Create("DPanelList", self);
 	self.itemsList:SizeToContents();
 	self.itemsList:SetPadding(2);
 	self.itemsList:SetSpacing(3);
	self.itemsList:StretchToParent(4, 4, 12, 44);
	self.itemsList:EnableVerticalScrollbar();

	-- Get the exploded text.
	local exploded = string.Explode("\n", self.changelog);
	local changes = {};
	local key = 0;

	-- Loop through our changes.
	for k, v in pairs(exploded) do
		if (k < #exploded or v ~= "") then
			if (string.sub(v, 1, 1) == "[" and string.sub(v, -1) == "]") then
				key = key + 1;

				-- Insert a new changelog date.
				changes[key] = { date = string.sub(v, 2, -2), changes = {} };
			else
				if ( changes[key] ) then
					local wrapped = {};

					-- Wrap the text to the width of the menu.
					cider.chatBox.wrapText(v, "Default", cider.menu.width - 48, 0, wrapped);

					-- Loop through the wrapped text.
					for k2, v2 in pairs(wrapped) do table.insert(changes[key].changes, v2); end
				end
			end
		end
	end

	-- Loop through our changes.
	for k, v in pairs(changes) do
		local header = vgui.Create("cider_Changelog_Header", self);

		-- Set the text of the header label and add it to the item list.
		header.label:SetText(v.date); self.itemsList:AddItem(header);

		-- Create the text for this date.
		local text = vgui.Create("cider_Changelog_Text", self);

		-- Set the changes for this date and add it to the item list.
		text:SetText(v.changes); self.itemsList:AddItem(text);
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0);
	self.itemsList:StretchToParent(0, 0, 0, 0);
end

-- Register the panel.
vgui.Register("cider_Changelog", PANEL, "Panel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init() self.labels = {}; end

-- Set Text.
function PANEL:SetText(text)
	for k, v in pairs(self.labels) do v:Remove(); end

	-- Define our x and y positions.
	local y = 5;

	-- Loop through the text we're given.
	for k, v in pairs(text) do
		local label = vgui.Create("DLabel", self);

		-- Set the text of the label.
		label:SetText( v );
		label:SetTextColor( Color(0, 0, 0, 255) );
		label:SizeToContents();


		-- Insert the label into our labels table.
		table.insert(self.labels, label);

		-- Increase the y position.
		y = y + label:GetTall() + 8
	end

	-- Set the size of the panel.
	self:SetSize(cider.menu.width, y);
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	local y = 5;

	-- Loop through all of our labels.
	for k, v in pairs(self.labels) do
		-- self.labels[k]:SetPos(self:GetWide() / 2 - self.labels[k]:GetWide() / 2, y);
		self.labels[k]:SetPos(8, y);

		-- Increase the y position.
		y = y + self.labels[k]:GetTall() + 8
	end
end

-- Register the panel.
vgui.Register("cider_Changelog_Text", PANEL, "DPanel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.label = vgui.Create("DLabel", self);
	self.label:SetText("N/A");
	self.label:SetFont("ChatFont");
	self.label:SetTextColor( Color(0, 0, 0, 255) );
	self.label:SizeToContents();
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.label:SetPos(self:GetWide() / 2 - self.label:GetWide() / 2, self:GetTall() / 2 - self.label:GetTall() / 2);
	self.label:SizeToContents();
end

-- Register the panel.
vgui.Register("cider_Changelog_Header", PANEL, "DPanel");