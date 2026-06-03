-- ff_2morforever.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_location");
IncludeScript("base_respawnturret");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------
-- hudalign and hudstatusiconalign : 0 = HUD_LEFT, 1 = HUD_RIGHT, 2 = HUD_CENTERLEFT, 3 = HUD_CENTERRIGHT 
-- (pixels from the left / right of the screen / left of the center of the screen / right of center of screen,
-- AfterShock

blue_flag = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue.vtf",
						 hudx = 5,
						 hudy = 114,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed,AllowFlags.kYellow,AllowFlags.kGreen}})

red_flag = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red.vtf",
						 hudx = 5,
						 hudy = 162,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen}})
						  
yellow_flag = baseflag:new({team = Team.kYellow,
						 modelskin = 2,
						 name = "Yellow Flag",
						 hudicon = "hud_flag_yellow.vtf",
						 hudx = 5,
						 hudy = 210,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
						 hudstatusiconhome = "hud_flag_home_yellow.vtf",
						 hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kRed,AllowFlags.kGreen} })

green_flag = baseflag:new({team = Team.kGreen,
						 modelskin = 3,
						 name = "Green Flag",
						 hudicon = "hud_flag_green.vtf",
						 hudx = 5,
						 hudy = 258,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_green.vtf",
						 hudstatusiconhome = "hud_flag_home_green.vtf",
						 hudstatusiconcarried = "hud_flag_carried_green.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kRed,AllowFlags.kYellow} })						  

-- red cap point
red_cap = basecap:new({team = Team.kRed,
					   item = {"blue_flag","yellow_flag","green_flag"}})

-- blue cap point					   
blue_cap = basecap:new({team = Team.kBlue,
						item = {"red_flag","yellow_flag","green_flag"}})

-- yellow cap point						
yellow_cap = basecap:new({team = Team.kYellow,
						item = {"blue_flag","red_flag","green_flag"}})

-- green cap point						
green_cap = basecap:new({team = Team.kGreen,
						item = {"blue_flag","red_flag","yellow_flag"}})

-----------------------------------------------------------------------------
-- map handlers
-----------------------------------------------------------------------------
function startup()
	SetGameDescription("Capture the Flag")
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, -1)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, 0)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kGreen)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end

function precache()
	-- precache sounds
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("vox.yourcap")
	PrecacheSound("vox.enemycap")
	PrecacheSound("vox.yourstole")
	PrecacheSound("vox.enemystole")
	PrecacheSound("vox.yourflagret")
	PrecacheSound("vox.enemyflagret")
end



-----------------------------------------------------------------------------
-- team restrictions
-----------------------------------------------------------------------------
--SetPlayerLimit( Team.kBlue, -1 )
--SetPlayerLimit( Team.kRed, 0)
--SetPlayerLimit( Team.kYellow, -1)
--SetPlayerLimit( Team.kGreen, 0 )

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 50
-----------------------------------------------------------------------------

--flaginfo runs whenever the player spawns or uses the flaginfo command.
--Right now it just refreshes the HUD items; this ensures that players who just joined the server have the right information.
function flaginfo( player_entity )
	flaginfo_base(player_entity) --see base_teamplay.lua
end

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_yard = location_info:new({ text = "Yard", team = NO_TEAM })
location_yardwater = location_info:new({ text = "Yard Water", team = NO_TEAM })

location_redspawn = location_info:new({ text = "Red Spawn", team = Team.kRed })
location_redgreatroom = location_info:new({ text = "Red Great Room", team = Team.kRed })
location_redflagroom = location_info:new({ text = "Red Flag Room", team = Team.kRed })
location_redcatwalks = location_info:new({ text = "Red Catwalks", team = Team.kRed })
location_redstairs = location_info:new({ text = "Red Stairs", team = Team.kRed })
location_redsniperdeck = location_info:new({ text = "Red Sniper Deck", team = Team.kRed })
location_redbattlements = location_info:new({ text = "Red Battlements", team = Team.kRed })
location_redtunneloflove = location_info:new({ text = "Red Tunnel of Love", team = Team.kRed })
location_redelevator = location_info:new({ text = "Red Elevator", team = Team.kRed })
location_redwatertunnels = location_info:new({ text = "Red Water Tunnels", team = Team.kRed })
location_redbasement = location_info:new({ text = "Red Basement", team = Team.kRed })

location_greenspawn = location_info:new({ text = "Green Spawn", team = Team.kGreen })
location_greengreatroom = location_info:new({ text = "Green Great Room", team = Team.kGreen })
location_greenflagroom = location_info:new({ text = "Green Flag Room", team = Team.kGreen })
location_greencatwalks = location_info:new({ text = "Green Catwalks", team = Team.kGreen })
location_greenstairs = location_info:new({ text = "Green Stairs", team = Team.kGreen })
location_greensniperdeck = location_info:new({ text = "Green Sniper Deck", team = Team.kGreen })
location_greenbattlements = location_info:new({ text = "Green Battlements", team = Team.kGreen })
location_greentunneloflove = location_info:new({ text = "Green Tunnel of Love", team = Team.kGreen })
location_greenelevator = location_info:new({ text = "Green Elevator", team = Team.kGreen })
location_greenwatertunnels = location_info:new({ text = "Green Water Tunnels", team = Team.kGreen })
location_greenbasement = location_info:new({ text = "Green Basement", team = Team.kGreen })