IncludeScript("base_ad");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

POINTS_PER_PERIOD = 5
PERIOD_TIME = 60

POINTS_PER_CAPTURE = 30;
NUM_PHASES = 3
INITIAL_ROUND_LENGTH = 90
POSTCAP_TIMER = 2
ATTACKERS = Team.kYellow
DEFENDERS = Team.kBlue

ATTACKERS_OBJECTIVE_ENTITY = nil

MAP_LENGTH = 1436 -- 23 minutes 56 seconds.
TELE_ACTIVATE = 718 -- default of half MAP_LENGTH

allow_win = true
phase = 1

tele_tried_activate = false
tele_can_activate = false
tele_is_active = false


-- Respawn turrets. Initial state. alpha and beta will be changed as the game progresses.
respawnturret_start = respawnturret:new({team = Team.kYellow})
respawnturret_alpha = respawnturret:new({team = Team.kBlue})
respawnturret_beta = respawnturret:new({team = Team.kBlue})
respawnturret_final = respawnturret:new({team = Team.kBlue})


function precache()
	PrecacheSound("ff_anticitizen.warningbell1")
	PrecacheSound("ff_anticitizen.beam_shoot")
	PrecacheSound("ff_anticitizen.explode_4")
	PrecacheSound("ff_anticitizen.explode_3")
	PrecacheSound("ff_anticitizen.shutdown")
	PrecacheSound("ff_anticitizen.winddown")
	PrecacheSound("ff_anticitizen.suckin")
	PrecacheSound("ff_anticitizen.3minutestosingularity")
	PrecacheSound("ff_anticitizen.2minutestosingularity")
	PrecacheSound("ff_anticitizen.1minutetosingularity")
	PrecacheSound("ff_anticitizen.45sectosingularity")
	PrecacheSound("ff_anticitizen.30sectosingularity")
	PrecacheSound("ff_anticitizen.15sectosingularity")
	PrecacheSound("ff_anticitizen.10sectosingularity")
end

function startup()
	SetGameDescription("Attack Defend")
	-- set up team limit
	-- disable all teams	
	for i = Team.kBlue, Team.kGreen do
		local team = GetTeam( i )
		if i then
			team:SetPlayerLimit( -1 )	
		end
	end
	
	-- then re-enable attackers/defenders
	local team = GetTeam( ATTACKERS )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	local team = GetTeam( DEFENDERS )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 ) 

	-- Should this be map specific?
	SetTeamName( ATTACKERS, "Attackers" )
	SetTeamName( DEFENDERS, "Defenders" )

	-- start the timer for the points
	AddScheduleRepeating( "addpoints", PERIOD_TIME, addpoints )
	AddSchedule("teleporter", TELE_ACTIVATE, teleporter_activate)

	setup_door_timer("cp1_gate", INITIAL_ROUND_LENGTH)
	setup_map_timers()
	
	allow_win = true

	cp1_flag.enabled = true
	cp1_flag.team = ATTACKERS
	for i,v in ipairs({"cp1_flag", "cp2_flag", "cp3_flag"}) do
		local flag = GetInfoScriptByName(v)
		if flag then
			flag:SetModel(_G[v].model)
			flag:SetSkin(teamskins[ATTACKERS])
			if i == 1 then
				flag:Restore()
			else
				flag:Remove()
			end
		end
	end

	-- Remove future phase flags
	flag_remove( "cp2_flag" )
	flag_remove( "cp3_flag" )

	RemoveYellowArmor()

	ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" )
	UpdateTeamObjectiveIcon( GetTeam(ATTACKERS), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(DEFENDERS), ATTACKERS_OBJECTIVE_ENTITY )
end


-----------------------------------------
-- Removes Yellow armor on startup
-----------------------------------------

function RemoveYellowArmor()

	local remove = Collection()
	remove:GetByName({"acarmorkit_alpha_yellow", "acarmorkit_beta_yellow"}, { CF.kNone })
	for item in remove.items do
		item = CastToInfoScript(item)
		item:Remove()
	end

end


-----------------------------------------
-- Swaps out blue armor for yellow when CP is captured
-- variables passed are the name of the entities used for that CP
-----------------------------------------

function SwapCPArmor(bluearmor, yellowarmor)

	-- Removes blue armor
	local remove = Collection()
	remove:GetByName({bluearmor}, { CF.kNone })
	for item in remove.items do
		item = CastToInfoScript(item)
		item:Remove()
	end

	-- Restores yellow armor
	local restore = Collection()
	restore:GetByName({yellowarmor}, { CF.kNone })
	for item in restore.items do
		item = CastToInfoScript(item)
		item:Restore()
	end

end


-----------------------------------------
-- 
-----------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	-- Remove stuff
	player:RemoveAmmo( Ammo.kNails, 400 )
	player:RemoveAmmo( Ammo.kShells, 400 )
	player:RemoveAmmo( Ammo.kRockets, 400 )
	player:RemoveAmmo( Ammo.kCells, 400 )
	player:RemoveAmmo( Ammo.kGren2, 4 )

	-- Add items (similar to both teams)
	player:AddAmmo( Ammo.kShells, 200 )
	player:AddAmmo( Ammo.kRockets, 30 )
	player:AddAmmo( Ammo.kNails, 200 )

	-- Defenders get...
	if player:GetTeamId() == DEFENDERS then
		-- Player is at full armor now, so we can
		-- easily reduce by some percent
		-- but were not going to because
		-- theres no reason to do so
		-- player:RemoveArmor( ( player:GetArmor() * .25 ) )

		player:RemoveAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kCells, 65 )
	elseif player:GetTeamId() == ATTACKERS then
		-- Attackers get...
		player:AddAmmo( Ammo.kCells, 200 )
	end

	-- Gives Yellow scouts/medics 1 conc at spawn on final CP
	if phase == 3 and player:GetTeamId() == Team.kYellow then
		pClass = player:GetClass()
		if pClass == Player.kScout or pClass == Player.kMedic then
			player:AddAmmo( Ammo.kGren2, 1)
		end
	end

--	if player:GetTeamId() == ATTACKERS then
		UpdateObjectiveIcon( player, ATTACKERS_OBJECTIVE_ENTITY )
--	elseif player:GetTeamId() == DEFENDERS then
--		UpdateObjectiveIcon( player, nil )
--	end
end

-- timed function started on startup, to run halfway through the timelimit. 
-- will activate teleporter if 2 minutes after cp2 opening has passed before half of map time
-- will fail if that has not happened, and try again later.
function teleporter_activate()

	if tele_is_active == true then return; end

	tele_tried_activate = true

	if tele_can_activate == true then
		-- Activates teleporter.
		OutputEvent( "p2_teleporter_trigger", "Trigger")
		BroadCastMessage("The Teleporter has been activated!")
		tele_is_active = true
	end
end


-- timed function run at 2 mins after cp2's gates open
-- will activate teleporter if half map time has passed already
-- If half map time has not passed, will allow the above funtion to work.
function enable_teleporter()

	if tele_is_active == true then return; end

	if tele_tried_activate == true then
		-- Activates teleporter.
		OutputEvent( "p2_teleporter_trigger", "Trigger")
		BroadCastMessage("The Teleporter has been activated!")
		tele_is_active = true
	else
		tele_can_activate = true
	end
end


-----------------------------------------
-- anticitizen flag
-----------------------------------------
base_ad_flag.modelskin = teamskins[ATTACKERS]
base_ad_flag.team = ATTACKERS
base_ad_flag.hudicon = team_hudicons[ATTACKERS]
base_ad_flag.touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kYellow}


-----------------------------------------
-- anticitizen capture point
-----------------------------------------
base_ad_cap.team = ATTACKERS

function base_ad_cap:oncapture(player, item)

	if phase == 1 then
		map_cap1()
		OutputEvent( "cp1_capped", "trigger" )
		SwapCPArmor("acarmorkit_alpha_blue", "acarmorkit_alpha_yellow")
	elseif phase == 2 then
		map_cap2()
		OutputEvent( "cp2_capped", "trigger" )
		SwapCPArmor("acarmorkit_beta_blue", "acarmorkit_beta_yellow")
	else
		OutputEvent( "cp3_capped", "trigger" )
		allow_win = false
		map_attackers_win()
	end

	player:AddFortPoints(500, "#FF_FORTPOINTS_CAPTUREPOINT")

	if self.closedoor then
		CloseDoor(self.closedoor)
	end

	-- remove objective icon
	ATTACKERS_OBJECTIVE_ENTITY = nil
	UpdateTeamObjectiveIcon( GetTeam(ATTACKERS), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(DEFENDERS), ATTACKERS_OBJECTIVE_ENTITY )

	-- Remove previous phase flag
	flag_remove( item )

	-- Delay for a couple seconds after the cap
	AddSchedule( "cap_delay_timer", POSTCAP_TIMER, cap_delay_timer, self )
end


-----------------------------------------
-- waste a couple seconds before respawning/ending
-----------------------------------------
function cap_delay_timer( cap )	
	if phase == NUM_PHASES then
		-- it's the last round. end and stuff
		GoToIntermission()
		RemoveSchedule( "addpoints" )
		RemoveSchedule( "set_cvar-mp_timelimit" )
		if OLD_MP_TIMELIMIT ~= nil then
			set_cvar( "mp_timelimit", OLD_MP_TIMELIMIT )
		end
	else
		phase = phase + 1

		-- setup double cap points for the last round
		if phase == NUM_PHASES then
			POINTS_PER_CAPTURE = POINTS_PER_CAPTURE * 2
		end

		-- Restore next flag
		if phase == 2 then
			flag_restore( "cp2_flag" )
			-- Give the turret new targetting info
			respawnturret_alpha = respawnturret:new({team = Team.kYellow})
		elseif phase == 3 then
			flag_restore( "cp3_flag" )
			-- Give the turret new targetting info
			respawnturret_beta = respawnturret:new({team = Team.kYellow})
		end

		-- update objective icon
		ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" )

		setup_door_timer( cap.doorname, cap.duration)
		ApplyToAll( { AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips } )
	end
end

function round_start(doorname)
	BroadCastMessage("#FF_AD_GATESOPEN")
	-- BroadCastSound("otherteam.flagstolen")
	OpenDoor(doorname)

	OutputEvent( "p1_begin", "trigger" )
	OutputEvent( "startnoise", "PlaySound" )

	if phase == 2 then
		AddSchedule("enable_teleporter", 120, enable_teleporter)
	elseif phase == 3 then
		if tele_is_active == false then
			tele_is_active = true
		end
	end
end

function round_60secwarn()
	BroadCastMessage("#FF_ROUND_60SECWARN")
	OutputEvent( "warnnoise", "PlaySound" )
end

function round_30secwarn()
	BroadCastMessage("#FF_ROUND_30SECWARN")
	OutputEvent( "warnnoise", "PlaySound" )
end

function round_10secwarn()
	BroadCastMessage("#FF_ROUND_10SECWARN")
	OutputEvent( "warnnoise", "PlaySound" )

	if phase == 1 then
		SpeakAll("AD_RADIO_1")
	elseif phase == 2 then
		SpeakAll("AD_RADIO_2")
	else
		SpeakAll("AD_RADIO_3")
	end
	
end


----------------
-- map timers --
----------------

function setup_map_timers()
	local timelimit = MAP_LENGTH

	AddSchedule( "map_10mintimer", timelimit-600, map_timewarn, 600 )
	AddSchedule( "map_5mintimer", timelimit-300, map_timewarn, 300 )
	AddSchedule( "map_3mintimer", timelimit-180, map_timewarn, 180 )
	AddSchedule( "map_60sectimer", timelimit-60, map_timewarn, 60 )		
	-- AddSchedule( "map_30sectimer", timelimit-30, map_timewarn, 30 )
	-- AddSchedule( "map_10sectimer", timelimit-10, map_timewarn, 10 )
	-- AddSchedule( "map_9sectimer", timelimit-9, map_timewarn, 9 )
	-- AddSchedule( "map_8sectimer", timelimit-8, map_timewarn, 8 )
	-- AddSchedule( "map_7sectimer", timelimit-7, map_timewarn, 7 )
	-- AddSchedule( "map_6sectimer", timelimit-6, map_timewarn, 6 )
	-- AddSchedule( "map_5sectimer", timelimit-5, map_timewarn, 5 )
	-- AddSchedule( "map_4sectimer", timelimit-4, map_timewarn, 4 )
	-- AddSchedule( "map_3sectimer", timelimit-3, map_timewarn, 3 )
	-- AddSchedule( "map_2sectimer", timelimit-2, map_timewarn, 2 )
	-- AddSchedule( "map_1sectimer", timelimit-1, map_timewarn, 1 )
	AddSchedule( "map_timer", timelimit, map_defenders_win )

	if OLD_MP_TIMELIMIT == nil then
		OLD_MP_TIMELIMIT = GetConvar( "mp_timelimit" )
	end

	AddScheduleRepeating( "set_cvar-mp_timelimit", 1, set_cvar, "mp_timelimit", 24.0 )

	AddSchedule( "p3_winddown_pitch", timelimit-179, alter_pitch )

	AddSchedule( "map_2mintimer", timelimit-120, map_timewarn, 120 )
end

function map_attackers_win( )
	RemoveSchedule( "map_10mintimer" )
	RemoveSchedule( "map_5mintimer" )
	RemoveSchedule( "map_2mintimer" )
	RemoveSchedule( "map_60sectimer" )
	--RemoveSchedule( "map_30sectimer" )
	--RemoveSchedule( "map_10sectimer" )
	--RemoveSchedule( "map_9sectimer" )
	--RemoveSchedule( "map_8sectimer" )
	--RemoveSchedule( "map_7sectimer" )
	--RemoveSchedule( "map_6sectimer" )
	--RemoveSchedule( "map_5sectimer" )
	--RemoveSchedule( "map_4sectimer" )
	--RemoveSchedule( "map_3sectimer" )
	--RemoveSchedule( "map_2sectimer" )
	--RemoveSchedule( "map_1sectimer" )
	RemoveSchedule( "map_timer" )
	--BroadCastSound( "yourteam.flagcap" )	
	--BroadCastMessage("#FF_AD_" .. TeamName(ATTACKERS) .. "WIN")
	BroadCastMessage( "Yellow team captured blue base!" )
	--SpeakAll( "AD_" .. TeamName( ATTACKERS ) .. "CAP".. TeamName( DEFENDERS ) )
	SpeakAll("AD_AC_CAP")
	OutputEvent( "cp3_capped", "trigger" )
end

function map_defenders_win( )
	if allow_win == false then
		return false
	end

	--BroadCastSound("yourteam.flagcap")
	BroadCastMessage("Blue team holds blue base!")
	--SpeakAll( "AD_HOLD_" .. TeamName(DEFENDERS) )
	SpeakAll("AD_AC_HOLD")
	allow_win = false
	--Defenders wins, call Intermission!
	phase = NUM_PHASES
	RemoveSchedule( "addpoints" )
	addpoints()
	AddSchedule( "cap_delay_timer", POSTCAP_TIMER, cap_delay_timer, self )
end


function alter_pitch()
	-- Alters the pitch of some of the voice stuff. I dunno.
	OutputEvent( "p3_winddown", "Pitch", "80")
end

function map_timewarn( time )
	ConsoleToAll("map_timewarn(), seconds = " .. time )
	
	if time > 180 then
		BroadCastMessage("#FF_MAP_" .. time .. "SECWARN")
		SpeakAll("AD_" .. time .. "SEC")
	end
	
	-- starting at 3 minutes..
	if time == 180 then
		BroadCastSound ( "ff_anticitizen.3minutestosingularity" )
		OutputEvent( "p3_noises", "trigger")
	elseif time == 120 then
		BroadCastSound ( "ff_anticitizen.2minutestosingularity" )
	elseif time == 60 then
		BroadCastSound ( "ff_anticitizen.1minutetosingularity" )
	elseif time == 45 then
		BroadCastSound ( "ff_anticitizen.45sectosingularity" )
	elseif time == 30 then
		BroadCastSound ( "ff_anticitizen.30sectosingularity" )
	elseif time == 15 then
		BroadCastSound ( "ff_anticitizen.15sectosingularity" )
	elseif time == 10 then
		BroadCastSound ( "ff_anticitizen.10sectosingularity" )
	end

end

function map_cap1()
	--BroadCastSound( "yourteam.flagcap" )
	BroadCastMessage( "Yellow team secured command point one" )
	SpeakAll( "AD_AC_CP1" )
	--SpeakAll("AD_CP1_" .. TeamName(ATTACKERS))
	OutputEvent( "cp1_capped", "trigger" )
end

function map_cap2()
	--BroadCastSound( "yourteam.flagcap" )
	BroadCastMessage( "Yellow team secured command point two" )
	SpeakAll( "AD_AC_CP2" )
	--SpeakAll("AD_CP2_" .. TeamName(ATTACKERS))
	OutputEvent( "cp2_capped", "trigger" )
end


-----------------------------------------
-- Packs 'n Stuff
-----------------------------------------

achealthkit = genericbackpack:new({
	health = 50,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch"
})

acammopack = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 130,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function acammopack:dropatspawn() return false end

acgrenadepackone = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 65,
	mancannons = 1,
	detpacks = 1,
	gren1 = 4,
	gren2 = 4,
	armor = 100,
	health = 300,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function acgrenadepackone:dropatspawn() return false end

acammotypeone = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 65,
	armor = 60,
	health = 40,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function acammotypeone:dropatspawn() return false end

acammotypetwo = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 30,
	armor = 30,
	health = 80,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function acammotypetwo:dropatspawn() return false end

acammotypethree = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 30,
	armor = 30,
	health = 30,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function acammotypethree:dropatspawn() return false end

-----------------------
-- Armor kits (alpha and beta have team coloured varieties)
-----------------------

acarmorkit_start = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	modelskin = 3,
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})

acarmorkit_alpha_blue = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	modelskin = 0,
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})

acarmorkit_alpha_yellow = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	modelskin = 3,
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})

acarmorkit_beta_blue = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	modelskin = 0,
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})

acarmorkit_beta_yellow = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	modelskin = 3,
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})

acarmorkit_final = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	modelskin = 0,
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})