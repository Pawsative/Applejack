 --[[
Name: "sh_configuration.lua".
	~ Applejack ~
--]]
local config = {};

-- Player Defaults
config["Default Money"]				= 50000; -- The money that each player starts with.
config["Default Job"]				= "Citizen"; -- The job that each player starts with.
config["Default Clan"]				= ""; -- The clan that each player belongs to by default.
config["Default rpname"]            = "John Doe"; -- Default rpname
config["Inventory Size"]			= 65; -- The default inventory size.
config["Default Access"]			= "beptp"; -- The access that each player begins with.

-- Command
config["Command Prefix"]			= "/"; -- The prefix that is used for chat commands.
config["Maximum Notes"]				= 10; -- The maximum amount of notes a player can write.
config["Advert Cost"]				= 150; -- The money that it costs to advertise.
config["Advert Timeout"]			= 60 -- How many seconds between adverts
config["OOC Timeout"]				= 8 -- How many seconds between OOC messages
config["Item Timer"]				= 2 -- How many seconds between item uses
config["Item Timer (S)"]			= 10 -- How many seconds between specific item uses
config["Note Fade Speed"]			= 30 -- How many minutes after being spawned notes should dissapear.

-- Door related things
config["Door Cost"]					= 150; -- The money that it costs to purchase a door.
config["Door Tax"]					= false; -- Whether door taxing is be enabled.
config["Door Tax Amount"]			= 50; -- The amount of money a player is charged in tax per door.
config["Maximum Doors"]				= 15; -- The maximum amount of doors a player can own.
config["Jam Time"]					= 60 -- How many seconds a door is jammed open for
config["Door Autoclose Time"]		= 15 -- How many seconds a door should autoshut after

-- Player Stuff
config["Walk Speed"]				= 150; -- The speed that players walk at.
config["Run Speed"]					= 275; -- The speed that players run at.
config["Incapacitated Speed"]		= 100; -- The speed arrested/tied/carrying players walk/run at.
config["Jump Power"]				= 160; -- Player's jump power. Don't mess with it unless you know what you're doing
config["Spawn Time"]				= 13; -- The time that a player has to wait before they can spawn again (seconds).
config["Bleed Time"]				= 5; -- The time that a player bleeds for when they get damaged.
config["Knock Out Time"]			= 30; -- The time that a player gets knocked out for (seconds).
config["Sleep Waiting Time"]		= 10; -- The time that a player has to stand still for before they can fall asleep (seconds).
config["Arrest Time"]				= 300; -- The time that a player is arrested for (seconds).
config["Earning Interval"]			= 300; -- The interval that players receive money from their contraband (seconds).
config["Search Warrant Expire Time"]= 300; -- The time that a player's search warrant expires (seconds)
config["Arrest Warrant Expire Time"]= 300; -- The time that a player's arrest warrant expires (seconds)

-- Unused entries
config["Death Penalty"]				= 2; -- The percentage of money players lose when they die.
config["Rope struggles"]			= 5 -- How many 'struggles' it takes for you to undo your rope
config["Tying Struggles"]			= 1 -- How many struggles it takes to get out of being tied up
config["Tying Struggles Timeout"]	= 30 -- How many seconds it takes for your struggle meter to fill

-- Voice
config["Local Voice"]				= true; -- Players can only hear a player's voice if they are near them.
config["Talk Radius"]				= 256; -- The radius of each player that other players have to be in to hear them talk (units).

-- Damage
config["Scale Ragdoll Damage"]		= 1; -- How much to scale ragdolled player damage by.
config["Scale Head Damage"]			= 5; -- How much to scale head damage by.
config["Scale Chest Damage"]		= 2; -- How much to scale chest damage by.
config["Scale Limb Damage"]			= 0.75; -- How much to scale limb damage by.
config["Anti propkill"]				= true -- Disables damage recieved from prop_physics', unless it's fall damage.

-- Other
config["Website URL"]				= "http://c1yd3i.com/"; -- The website URL drawn at the bottom of the screen.
config["Cleanup Decals"]			= true; -- Whether or not to automatically cleanup decals every minute.
config["Model Choices Timeout"]		= 30 -- Number of seconds to wait before reconnecting if model choices aren't sent.
config["Autokick time"]				= 15 * 60 -- Number of seconds a player has to do something in to avoid being kicked

-- SWEP related
config["Lockpick Break Chance"]		= 0.01; -- The probaility to add to the lockpick snapping on a hit for each lock successfully picked.
config["Maximum Lockpick Hits"]		= 30; -- The maximum amount of hits a lock takes to pick
config[TYPE_LARGE]					= 1 --Number of 'big' weapons that can be carried at once. Putting this above 1 will provide strange results, so don't.
config[TYPE_SMALL]					= 2 --Number of 'small' weapons that can be carried at once

-- Plugins
config["Officials Contraband"]		= false; -- Whether city officials, i.e. City Admin, CP get contraband payments.
config["Need Warrant"]				= false; -- Whether city officials need warrants to destroy contraband.
config["Police Kill Drop"]			= false -- Whether or not weapons should drop when a player is killed by the police.

config["Hunger Minutes"]			= 30 -- The number of minutes it takes before your hunger is full.
config["Hunger Damage"]				= 5 -- The amount of damage a second you are dealt while starving
config["Hunger Death"]				= true -- Whether or not you can starve to death

config["Stamina Drain"]				= 0.35 -- The amount of stamina lost every 0.1 seconds while running
config["Stamina Restore"]			= 0.15 -- The amount of stamina restored every 0.1 seconds while not running.

config["Car Doors"]					= true -- whether or not you must be looking at a car door to gain entry

-- Props
config["Prop Limit"]				= 30 -- The amount of props donators can spawn
config["Builder Prop Limit"]		= 30 -- The amount of props builders can spawn
config["Builder Prop Cost"]			= 0 -- The price of each prop a builder spawns

-- Job related
config["Master Race"]				= false -- All group changes must go through one base class
config["Minimum to demote"]			= 5 -- Minimum players in a gang before the leader can demote people from it
config["Minimum to mutiny"]			= 4 -- Minimum players in a gang before the leader can be mutinied against
config["Mutiny Percentage"]			= 0.75 -- Minimum percentage of positive mutinies

-- Tying System
config["Tying Timeout"]				= 5 -- How many seconds it takes to tie someone up
config["UnTying Timeout"]			= 5 -- How many seconds it takes to untie someone

-- Tables

config["Back Weapons"] = {
	[TYPE_LARGE] = true
} -- Which weapons go on your back when not deployed.
config["Weapon Timers"] = {
	["deploytime"] = {
		[TYPE_LARGE] = 2,
		[TYPE_SMALL] = 1
	},
	["redeploytime"] = {
		[TYPE_LARGE] = 30,
		[TYPE_SMALL] = 20
	},
	["reholstertime"] = {
		[TYPE_LARGE] = 10,
		[TYPE_SMALL] = 5
	},
	["deploymessage"] = { -- 1 gun type, 2 gender
		[TYPE_LARGE] = "pulls a %s off %s back",
		[TYPE_SMALL] = "pulls a %s out of %s pocket"
	},
	["equiptime"] = {
		[TYPE_LARGE] = 5,
		[TYPE_SMALL] = 2
	},
	["Equip Message"] = {
		["Start"] = "starts rummaging through %s backpack",
		["Final"] = "pulls out a %s gun and puts %s backpack back on",
		["Abort"] = "gives up and pulls %s backpack back on",
		["Plugh"] = "slides the %s gun back into %s backpack and puts it back on"
		--[[
		 -- 1 gun type, 2 gender
		[TYPE_LARGE] = "Pulls out a %s and puts %s backpack back on",
		[TYPE_SMALL] = "Pulls out a %s and puts %s backpack back on"]]
	},
	["holstermessage"] = {	 -- 1 gun type, 2 gender
		[TYPE_LARGE] = "puts the %s back on %s back",
		[TYPE_SMALL] = "puts the %s back in %s pocket"
	}
} --

config["sv_tags"] = {
	"applejack", -- Please always leave this in
	"rp",
	"roleplay",
	"semi-serious",
	"semi-srsrp",
	"semi-srs",
	"cider" -- Never forget your origins
} -- tags you want added to the sv_tags convar
config["Usable Commands"] = {
	"demote","blacklist","unblacklist","giveaccess","takeaccess","giveitem","save","pm","job","clan","gender","laws","ooc","looc",
	"knockout","knockoutall","wakeup","wakeupall","arrest","unarrest","spawn","awarrant","tie","untie"
}; -- Commands that players may use at any time
config["Default Inventory"] = {
	health_vial = 5,
	chinese_takeout = 5
}; -- The inventory that each player starts with.
config["Contraband"] = {
	cider_drug_lab = {maximum = 5, money = 50, name = "Drug Lab", health = 100, energy = 5},
	cider_money_printer = {maximum = 2, money = 150, name = "Money Printer", health = 100, energy = 5}
}; -- The different types of contraband.
config["Male Citizen Models"] = {
	"models/player/Group01/male_01.mdl",
	"models/player/Group01/male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/male_04.mdl",
	"models/player/Group01/male_05.mdl",
	"models/player/Group01/male_06.mdl",
	"models/player/Group01/male_07.mdl",
	"models/player/Group01/male_08.mdl",
	"models/player/Group01/male_09.mdl"
}; -- The male citizen models.
config["Female Citizen Models"] = {
	"models/player/Group01/female_01.mdl",
	"models/player/Group01/female_02.mdl",
	"models/player/Group01/female_03.mdl",
	"models/player/Group01/female_04.mdl",
	"models/player/Group01/female_06.mdl",
	"models/player/Group01/female_07.mdl"
}; -- The male citizen models.
config["Banned Props"] = {
	"models/props_phx/empty_barrel.mdl",
	"models/props_c17/consolebox01a.mdl",
	"models/props_combine/combine_mine01.mdl",
	"models/props_c17/gravestone_coffinpiece002a.mdl",
	"models/props_c17/gravestone_coffinpiece001a.mdl",
	"models/props_borealis/mooring_cleat01.mdl",
	"models/props_canal/canal_bridge02.mdl",
	"models/props_canal/canal_bridge01.mdl",
	"models/props_canal/canal_bridge03a.mdl",
	"models/props_canal/canal_bridge03b.mdl",
	"models/props_wasteland/cargo_container01.mdl",
	"models/props_wasteland/cargo_container01c.mdl",
	"models/props_wasteland/cargo_container01b.mdl",
	"models/props_c17/column02a.mdl",
	"models/cranes/crane_frame.mdl",
	"models/props_c17/fence04a.mdl",
	"models/props_c17/fence03a.mdl",
	"models/props_c17/oildrum001_explosive.mdl",
	"models/props_combine/weaponstripper.mdl",
	"models/props_combine/combinetrain01a.mdl",
	"models/props_combine/combine_train02a.mdl",
	"models/props_combine/combine_train02b.mdl",
	"models/props_trainstation/train005.mdl",
	"models/props_trainstation/train004.mdl",
	"models/props_trainstation/train003.mdl",
	"models/props_trainstation/train001.mdl",
	"models/props_trainstation/train001.mdl",
	"models/props_wasteland/buoy01.mdl",
	"models\\props/cs_militia/coveredbridge01_top.mdl",
	"models\\props/cs_militia/coveredbridge01_left.mdl",
	"models\\props/cs_militia/coveredbridge01_bottom.mdl",
	"models\\props/cs_militia/silo_01.mdl",
	"models/props/cs_assault/money.mdl",
	"models/props/cs_assault/dollar.mdl",
	"models/props/de_nuke/ibeams_bombsitea.mdl",
	"models/props/de_nuke/fuel_cask.mdl",
	"models/props/de_nuke/ibeams_bombsitec.mdl",
	"models/props/de_nuke/ibeams_bombsite_d.mdl",
	"models/props/de_nuke/ibeams_ctspawna.mdl",
	"models/props/de_nuke/ibeams_ctspawnb.mdl",
	"models/props/de_nuke/ibeams_ctspawnc.mdl",
	"models/props/de_nuke/ibeams_tspawna.mdl",
	"models/props/de_nuke/ibeams_tspawnb.mdl",
	"models/props/de_nuke/ibeams_tunnela.mdl",
	"models/props/de_nuke/ibeams_tunnelb.mdl",
	"models/props/de_nuke/storagetank.mdl",
	"models/props/de_nuke/truck_nuke.mdl",
	"models/props/de_nuke/powerplanttank.mdl",
	"models/combine_helicopter.mdl",
	"models/props_trainstation/train002.mdl",
	"models/props_junk/gascan001a.mdl",
	"models/props_junk/propane_tank001a.mdl",
	"models/props_explosive/explosive_butane_can.mdl",
	"models/props_explosive/explosive_butane_can02.mdl",
	"models/props_phx/oildrum001_explosive.mdl",
	"models/props_phx/cannonball.mdl",
	"models/props_phx/ww2bomb.mdl",
	"models/props_phx/mk-82.mdl",
	"models/props_phx/torpedo.mdl",
	"models/props_phx/ball.mdl",
	"models/props_phx/misc/potato_launcher_explosive.mdl",
	"models/props_phx/misc/flakshell_big.mdl",
	"models/props_phx/playfield.mdl",
	"models/props_phx/amraam.mdl",
	"models/props_mining/techgate01_outland03.mdl",
	"models/props_mining/techgate01.mdl",
	"models/props/cs_office/light_ceiling.mdl"

}; -- Props that are not allowed to be spawned.
config["Rules"] = [[
<Rules>
[General]
1. Do not break NLR. NLR is a new life rule. You forgot everything of your past life.
2. Don't spam.
3. Do not RDM - RDM stands for Random Death Match. Do not just randomly kill people which will fllow to a ban.
4. Follow FearRP - If someone has a gun on your head you are to do what they say.
5. Do no failRP - If your a gun dealer you don't randomly steal peoples cars. You roleplay to what your job is. Custom jobs are to follow the same thing.
6. Do not Random Arrest(RDA) - You have to have a reasoning behind it.
7. Do not randomly steal cars(RGTA) - If your say some kind of rebel or mafia you must have a reasoning behind stealing the car.
8. No Random Raiding(RR) - You must have a reason behind it. A RP Reason. Laws are a reason to raid or dictaorship.
9. If you are to have anything like [FF] which is what the admins use you will be asked to remove it, if you don't you will be banned perminantly as this is impersonating a member of Staff.
10. The president can not random warrant people for search or arrest. There must be a reasoning behind it like contraban/money printers. (or not complying to the laws after warning by a Police Officer.)
11. Prop Spamming/Surfing/Pushing/Blocking/Throwing and Flipping is all against the rules. If you break this rule you will be instantly ban by a staff member for 1 day and if this continues it will lead to a week then a month.
12. There no arguing or sexual talk to be had in OOC.
13. No one way see threw props. Do not let us catch you doing this. We will remove your Prop permissions.
14. If anyone is to enter the cave at the lake. You will be permenatly ban as this crashes the server!
15. Do not metagame. When you approuch someone you do not know there name. You do not ask people where they are in OOC. You use /pm. Also if someone you know like your friend or someone is a Police officer, President or any job you can't randomly kill them. This is metagaming. You don't know them in RP and you can't RDM them over a real life situation. This will result on a day ban and so on and so forth.
16. Do not backseat adminstrate. If someone is say CDMing you do not shoot them or handle it with death or CDMing them back. You call a admin to the situation or screenshot them breaking the rules. Then you would tell me intill I have set up our website with a ban request section of the fourms.
17. Do not random tase. This goes for all the jobs. This goes toward FailRP and FearRP. If your being arrested and they have a taser on you. You comply to what they tell you to do.
18. Do not minge. Minging is purposly trying to ruin roleplay and other peoples memorys on the server. These examples are hitting people with axes, random tasing and the rules above.
19. No mic spamming or spamming the chats in general.
20. You have 1 warning, after this you will be banned for a day. Read the rules or be banned.
21. Our staff team is to be chosen by the High up Staff members. Asking for staff is not a option. You will be denied your chance.
22. Rasism and Harassment is not accepted here. If you want to do this stuff go do it some where else. I and my staff do not tolerate this. Perminant ban.
23. The pointshop suits and dresses will be based on how good your rp's are. You can share your rp experiences and builds on the fourms. If people relpy with good feedback and comments on the fourms/post, and how we see the roleplay as amazing, fun, well built you will be given a point for the pointshop. The models will cost more then 1 point. It's not going to be easy. Roleplay well and you will be rewarded.
24. Do not public build without a staff member giving you the ok to build this.
25. If you ask to be a staff member you will be automatically denied and you will have to start from the beggining of gaining our trust.
26. you get <b>one</b> warning after reading this rule. After you break this one warning you will be ban the next time. All suggestions are to be given to any higher up staff.
27. Enjoy and Roleplay. Remember the rules as these come in handy :). Please share and tell your friends to join and have fun with this new community.
]]; -- The rules for the server.
config["Laws"] = [[
[Permanent Laws0]
Contraband is illegal. Anyone found with it will be arrested. Any police found with it will be demoted on the spot.
Murder is illegal.
Assault is illegal.
Breaking into other people's property is illegal.
Stealing cars is illegal.
Explosives are illegal.
Tying people up without their explicit consent is illegal.
You must drive on the right hand side of the road.
You may not walk in the road - Always walk on the pavement or on the zebera crossings.
If you hit something while driving, you are liable for all damages.
Observe the speedlimit. The use of turbo devices is illegal.
You must obey all traffic signals.
Civilians may not enter the inner Government HQ (behind the desk) at any time, unless being escorted by two officers. They must report this to the Mayor immediately.
Civilians may not enter the main Government HQ in times of crisis.
Civilians may not unholster weapons in the Government HQ at any time.
Civilians may not build in a public area without permission.
Civilians may not block any offical thoroughfare without written consent from the mayor.
Civilians may not use silenced weapons
Any civilian seen with an illegal or police weapon will be arrested on the spot.
Anyone who uses a Vuvuzela is to be shot on sight.
[Temporary Laws1]
]]

GM.Config = config;