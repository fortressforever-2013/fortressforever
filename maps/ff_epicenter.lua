
-- ff_epicenter lua file.

IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60
INITIAL_ROUND_LENGTH = 90

-- Keeps count of caps, 3 caps = victory
BLUE_WINS = 0
RED_WINS = 0

-----------------------------------------------------------------------------
-- No more whining about full armour on spawn
-----------------------------------------------------------------------------
function player_spawn( player_id )
	local player = GetPlayer(player_id)
	player:AddArmor( 400 )
	player:AddHealth( 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
end

------------------------------------------------------------------------------
-- This table is defines the position of hud icons that keep track of caps in a row. 1-3 blue, 4-6 red
-- Team.kUnassigned used to denote a non-capture, and is default state for all icons defined here.
------------------------------------------------------------------------------
hud_status = {
	[1] = { team = Team.kUnassigned, hudslot = 1, hudposx = 60, hudposy = 24, hudalign = 2, hudwidth = 16, hudheight = 16 },
	[2] = { team = Team.kUnassigned, hudslot = 2, hudposx = 80, hudposy = 24, hudalign = 2, hudwidth = 16, hudheight = 16 },
	[3] = { team = Team.kUnassigned, hudslot = 3, hudposx = 100, hudposy = 24, hudalign = 2, hudwidth = 16, hudheight = 16 },
	[4] = { team = Team.kUnassigned, hudslot = 4, hudposx = 60, hudposy = 24, hudalign = 3, hudwidth = 16, hudheight = 16 },
	[5] = { team = Team.kUnassigned, hudslot = 5, hudposx = 80, hudposy = 24, hudalign = 3, hudwidth = 16, hudheight = 16 },
	[6] = { team = Team.kUnassigned, hudslot = 6, hudposx = 100, hudposy = 24, hudalign = 3, hudwidth = 16, hudheight = 16 }
}


-- defines which icons to use for each team (saves repeating this info exactly for each entry in above table).
icons = {
	[Team.kBlue] = { teamicon = "hud_cp_blue.vtf" },
	[Team.kRed] = { teamicon = "hud_cp_red.vtf" },
	[Team.kUnassigned] = { teamicon = "hud_cp_neutral.vtf" }
}


-----------------------------------------------------------------------------
-- flag definitions
-----------------------------------------------------------------------------
blue_flag = baseflag:new({team = Team.kBlue,
						 modelskin = 1,
						 name = "Blue Flag",
						 hudicon = "hud_flag_red.vtf",
						 hudx = 5,
						 hudy = 162,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 status = "home",
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed,AllowFlags.kYellow,AllowFlags.kGreen}})

red_flag = baseflag:new({team = Team.kRed,
						 modelskin = 0,
						 name = "Red Flag",
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
						 status = "home",
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen}})


-----------------------------------------------------------------------------
-- startup 
-----------------------------------------------------------------------------
function startup()
	SetGameDescription("Reverse CTF")
	
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 ) 

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )	

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )

	--setup_door_timer("flag_wall", )
	setup_door_timer(Team.kUnassigned, INITIAL_ROUND_LENGTH)

end


-----------------------------------------------------------------------------
-- Altered flag functions. Mostly to remove flag stolen messages.
-----------------------------------------------------------------------------	
function baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	if player:GetTeamId() ~= self.team then

		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
		RemoveHudItemFromAll( flag:GetName() .. "_h" )
		RemoveHudItemFromAll( flag:GetName() .. "_d" )
		AddHudIconToAll( self.hudstatusiconhome, ( flag:GetName() .. "_h" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
		AddHudIconToAll( self.hudstatusiconcarried, ( flag:GetName() .. "_c" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )

	end
end

function baseflag:ondrop( owner_entity )
	local player = CastToPlayer( owner_entity )
	local flag = CastToInfoScript(entity)
	flag:EmitSound(self.tosssound)
end

-----------------------------------------------------------------------------
-- capture stuff - reset flags, players and return walls
-----------------------------------------------------------------------------
function setup_door_timer(team, duration)
	-- In AddSchedule, the first parameter is the name for the schedule, second is the duration of the schedule and 3rd is the function that is called.
	-- The 4th, 5th, ... and so on are the parameters for the function that will be called
	AddSchedule("round_start" .. team, duration, round_start, team)
	if duration > 65 then AddSchedule("round_warn_60", duration-60, round_warn, team, 60) end
	if duration > 35 then AddSchedule("round_warn_30", duration-30, round_warn, team, 30) end
	if duration > 15 then AddSchedule("round_warn_10", duration-10, round_warn, team, 10) end
end


-- This now does different things depending on who capped a flag, or if it's starting a new round for both teams
function round_start(team)
	if ( team == Team.kBlue ) then
		BroadCastMessage("Blue flag is now available!")
		OpenDoor("blue_flag_wall")
	elseif ( team == Team.kRed ) then
		BroadCastMessage("Red flag is now available!")
		OpenDoor("red_flag_wall")
	else
		BroadCastMessage("The flags are now available!")
		OpenDoor("blue_flag_wall")
		OpenDoor("red_flag_wall")
	end
end


-- I combined all the warning functions into one.
function round_warn(team, duration)
	if ( team == Team.kBlue ) then
		BroadCastMessage(duration .. " seconds until blue flag is available")
	elseif ( team == Team.kRed ) then
		BroadCastMessage(duration .. " seconds until red flag is available")
	else
		BroadCastMessage(duration .. " seconds until the round starts")
	end
end


function reset_door(doorname)
	CloseDoor(doorname)
end


-- This now does different things depending on who captures the flag, and if the team has captured 3 flags
function basecap:oncapture(player, item)
	
	if ( player:GetTeamId() == Team.kBlue ) then
		CloseDoor("blue_flag_wall")
		setup_door_timer(Team.kBlue, 65)
		BLUE_WINS = BLUE_WINS + 1
		hud_update (Team.kBlue, BLUE_WINS)
	else
		CloseDoor("red_flag_wall")
		setup_door_timer(Team.kRed, 65)
		RED_WINS = RED_WINS + 1
		-- Red wins + 3 so as to update the HUD correctly. Hardcoded to 6 unfortunatly at the moment
		hud_update (Team.kRed, (RED_WINS + 3))
	end

	-- This might require some changes for the flags, I just changed the "ApplyToAll" to "ApplyToPlayer"
	--ApplyToPlayer({ AT.kReturnCarriedItems, AT.kReturnDroppedItems, AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kRespawnPlayers})


	if  BLUE_WINS == 3  then
		-- let the teams know that a capture occured - Change these to something like "Your team wins the round", "The enemy team wins the round" or something
		SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
		SmartSound(player, "vox.yourcap", "vox.yourcap", "vox.enemycap")
		SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")
		
		-- Victory for blue team
		end_game(Team.kBlue)

	elseif  RED_WINS == 3  then
		-- let the teams know that a capture occured - Change these to something like "Your team wins the round", "The enemy team wins the round" or something
		SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
		SmartSound(player, "vox.yourcap", "vox.yourcap", "vox.enemycap")
		SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")

		-- Victory for red team
		end_game(Team.kRed)

	else
		-- let the teams know that a capture occured
		SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
		SmartSound(player, "vox.yourcap", "vox.yourcap", "vox.enemycap")
		SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")
	end
end

-- This is called when a team captures 3 flags.
function end_game(team)
	if (team == Team.kBlue) then
		CloseDoor("red_flag_wall") -- Because blue door was already closed when the flag was capped
	else
		CloseDoor("blue_flag_wall") -- Because red was already closed when the flag was capped
	end
	
	-- Reset wins
	BLUE_WINS = 0;
	RED_WINS = 0;

	-- Loops through all HUD icons and resets them. Hardcoded to 6 icons atm :(
	for i=1, 6 do
		hud_update (Team.kUnassigned, i)
	end

	-- Respawn all players and return flags
	ApplyToAll({ AT.kReturnCarriedItems, AT.kReturnDroppedItems, AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kRespawnPlayers})
	
	setup_door_timer(Team.kUnassigned, 65)
end


----------------------------------------
-- HUD Status Icons (caps out of 3) 
----------------------------------------
function hud_update( team, capture_number )

		local hudicon = hud_status[capture_number]

		-- need to alter the team in control of the icon so that flaginfo works correctly for people who just connected/teamswitched
		hudicon.team = team

		--remove old flaginfo icons and add new ones
		RemoveHudItemFromAll( capture_number .. "-status" )

		AddHudIconToAll( icons[ hudicon.team ].teamicon, hudicon.hudslot .. "-status", hudicon.hudposx, hudicon.hudposy, hudicon.hudwidth, hudicon.hudheight, hudicon.hudalign)
end

----------------------------------------
-- Flag information (initialises HUD Icons on player connect/teamswitch etc.). Mostly copied from base_ctf.
----------------------------------------
function flaginfo( player_entity )

	local player = CastToPlayer( player_entity )

	RemoveHudItem( player, blue_flag.name .. "_c" )
	RemoveHudItem( player, blue_flag.name .. "_d" )

	RemoveHudItem( player, red_flag.name .. "_c" )
	RemoveHudItem( player, red_flag.name .. "_d" )

	-- copied from blue_flag variables
	
	local flag = GetInfoScriptByName("blue_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, blue_flag.hudstatusiconcarried, ( blue_flag.name.. "_c" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, blue_flag.hudstatusicondropped, ( blue_flag.name.. "_d" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	else
		AddHudIcon( player, blue_flag.hudstatusiconhome, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )	
	end

	flag = GetInfoScriptByName("red_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, red_flag.hudstatusiconcarried, ( red_flag.name.. "_c" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, red_flag.hudstatusicondropped, ( red_flag.name.. "_d" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	else
			AddHudIcon( player, red_flag.hudstatusiconhome, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )	
	end

	-- Added to deal with the 3-cap HUD icons needed for Epicenter
	for i,v in ipairs(hud_status) do
		AddHudIcon( player, icons[ v.team ].teamicon , v.hudslot .. "-status", v.hudposx, v.hudposy, v.hudwidth, v.hudheight, v.hudalign)
	end
end


-----------------------------------------------------------------------------
-- Ammo Kit (backpack-based) **Adjusted from base lua as I am lazy**
-----------------------------------------------------------------------------
ammobackpack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function ammobackpack:dropatspawn() return false end



-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_bluespawn = location_info:new({ text = "Blue Spawn", team = Team.kBlue })
location_bluecap = location_info:new({ text = "Blue Cap Area", team = Team.kBlue })
location_blueyard = location_info:new({ text = "Blue Yard", team = Team.kBlue })
location_bluestreets = location_info:new({ text = "Blue Streets", team = Team.kBlue })
location_bluebalc = location_info:new({ text = "Blue Balcony", team = Team.kBlue })
location_bluebuild = location_info:new({ text = "Blue Building", team = Team.kBlue })

location_redspawn = location_info:new({ text = "Red Spawn", team = Team.kRed })
location_redcap = location_info:new({ text = "Red Cap Area", team = Team.kRed })
location_redyard = location_info:new({ text = "Red Yard", team = Team.kRed })
location_redstreets = location_info:new({ text = "Red Streets", team = Team.kRed })
location_redbalc = location_info:new({ text = "Red Balcony", team = Team.kRed })
location_redbuild = location_info:new({ text = "Red Building", team = Team.kRed })

location_bridge = location_info:new({ text = "The Bridge", team = NO_TEAM })