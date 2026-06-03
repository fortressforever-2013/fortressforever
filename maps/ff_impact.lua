-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- global overrides that you can do what you want with
-----------------------------------------------------------------------------


POINTS_PER_CAPTURE = 5
POINTS_PER_TOTAL_CONTROL = 30
POINTS_PER_PERIOD = 1
FORT_POINTS_PER_CAPTURE = 300
FORT_POINTS_PER_TOTAL_CONTROL = 500
FORT_POINTS_PER_PERIOD = 100
DAMAGE_PER_PERIOD = -15
PERIOD_TIME = 1
FLAG_RETURN_TIME = 0
NUMBER_OF_COMMAND_POINTS = 4
INITIAL_ROUND_PERIOD = 60
FLAG_REVERT_PERIOD = 20

DELAY_BEFORE_DEFENSE_PERIOD_SCORING = 30
DEFENSE_PERIOD_TIME = 10
POINTS_PER_DEFENSE_PERIOD = 5
POINTS_PER_DEFENSE_60SEC_BONUS = 30
POINTS_PER_DEFENSE_SHUTOUT = 300 --default, not used if GET_ROUND_PERIOD_FROM_TIMELIMIT is set to true

GET_ROUND_PERIOD_FROM_TIMELIMIT = true
NUMBER_OF_ROUNDS = 4
ROUND_PERIOD = 600 --default, not used if GET_ROUND_PERIOD_FROM_TIMELIMIT is set to true

ATTACKERS_OBJECTIVE_ENTITY = nil

detpack_wall_open = nil

local playerScoringTable = {}

-----------------------------------------------------------------------------
-- global variables and other shit that shouldn't be messed with
-----------------------------------------------------------------------------

current_timer = FLAG_REVERT_PERIOD
current_seconds = 0

attackers = Team.kBlue
defenders = Team.kRed

scoring_team = Team.kRed

-- probably not needed, but works. Test if nessecary later... later!
flags = {"flag"}

local teamdata = {
	[Team.kBlue] = { skin = "0", beamcolour = "0 0 255", flag_icon = "hud_flag_blue.vtf", hud_icon = "hud_cp_blue.vtf" },
	[Team.kRed] = { skin = "1", beamcolour = "255 0 0", flag_icon = "hud_flag_red.vtf", hud_icon = "hud_cp_red.vtf" }
}

command_points = {
	[1] = { controlling_team = Team.kRed, cp_number = 1, hudposx = 0, hudposy = 82, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[2] = { controlling_team = Team.kRed, cp_number = 2, hudposx = -36, hudposy = 60, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[3] = { controlling_team = Team.kRed, cp_number = 3, hudposx = 0, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[4] = { controlling_team = Team.kRed, cp_number = 4, hudposx = 36, hudposy = 60, hudalign = 4, hudwidth = 16, hudheight = 16 }
}

-- stores ID's of attackers in the cap room
local cap_room_collection = Collection()

-- Used to determine whether to swap teams or end map on the end of a round.
phase = 1

-- Used to determine HUD message state for flaginfo function. 
-- 0 = nothing (no attackers present/flags reverted), 1 = attackers count, 2 = countdown to revert
hud_state = 0


-----------------------------------------------------------------------------
-- Entity definitions (flags/command points/backpacks etc.)
-----------------------------------------------------------------------------

-- flags
base_flag = info_ff_script:new({
	name = "Base Flag",
	team = 0,
	model = "models/flag/flag.mdl",
	tosssound = "Flag.Toss",
	modelskin = 0,
	dropnotouchtime = 2,
	capnotouchtime = 2,
	hudicon = "",
	hudx = 5,
	hudy = 180,
	hudwidth = 48,
	hudheight = 48,
	hudalign = 1,
	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

flag = base_flag:new({
	team = Team.kBlue,
	modelskin = 0,
	name = "flag",
	hudicon = "hud_flag_blue.vtf",
	hudx = 5,
	hudy = 180,
	hudwidth = 48,
	hudheight = 48,
	hudalign = 1,
	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed}
})

base_cp_trigger = trigger_ff_script:new({
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
	cp_number = 0,
})

-- command points
cp1_trigger = base_cp_trigger:new({ cp_number = 1 })
cp2_trigger = base_cp_trigger:new({ cp_number = 2 })
cp3_trigger = base_cp_trigger:new({ cp_number = 3 })
cp4_trigger = base_cp_trigger:new({ cp_number = 4 })

-- capture room
base_caproom_trigger = trigger_ff_script:new({
	team = 0,
})

cap_room = base_caproom_trigger:new({team = 0})

-- respawns
attacker_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	return player:GetTeamId() == attackers
end })
defender_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	return player:GetTeamId() == defenders
end })


-----------------------------------------------------------------------------
-- functions that do sh... stuff
-----------------------------------------------------------------------------

-- pretty standard setup, aside from scoring starting
function startup()
	SetGameDescription("Attack Defend the Zone")
	
	-- set up team limits on each team
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	-- No civvies.
	local team = GetTeam( attackers )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( defenders )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kScout, -1 ) -- scout on d? are you mental?
	
	-- set them team names
	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )

	-- get round times if its set to
	if GET_ROUND_PERIOD_FROM_TIMELIMIT == true then
		local timelimit = GetConvar( "mp_timelimit" )
		-- convert mp_timelimit from minutes to seconds and divide by the number of rounds minus initial round period
		ROUND_PERIOD = timelimit * 60 / NUMBER_OF_ROUNDS - INITIAL_ROUND_PERIOD - 1
		POINTS_PER_DEFENSE_SHUTOUT = ROUND_PERIOD / 2
		-- now lock mp_timelimit, so things don't get weird
		AddScheduleRepeating( "set_cvar-mp_timelimit", 1, set_cvar, "mp_timelimit", timelimit )
	end
	
	-- set up team-colored spawn forcefields
	OutputEvent( "forcefield_red", "Enable" )
	OutputEvent( "forcefield_blue", "Disable" )
	
	OutputEvent( "redladder", "Enable" )
	OutputEvent( "blueladder", "Disable" )
	
	-- scheduled message loveliness.
	if INITIAL_ROUND_PERIOD > 30 then AddSchedule( "dooropen30sec" , INITIAL_ROUND_PERIOD - 30 , schedulemessagetoall, "Gate opens in 30 seconds!" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10sec" , INITIAL_ROUND_PERIOD - 10 , schedulemessagetoall, "Gate opens in 10 seconds!" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5sec" , INITIAL_ROUND_PERIOD - 5 , schedulemessagetoall, "5" ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4sec" , INITIAL_ROUND_PERIOD - 4 , schedulemessagetoall, "4" ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3sec" , INITIAL_ROUND_PERIOD - 3, schedulemessagetoall, "3" ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2sec" , INITIAL_ROUND_PERIOD - 2, schedulemessagetoall, "2" ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1sec" , INITIAL_ROUND_PERIOD - 1, schedulemessagetoall, "1" ) end
	
	-- sounds
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen30secsound" , INITIAL_ROUND_PERIOD - 30 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10secsound" , INITIAL_ROUND_PERIOD - 10 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5seccount" , INITIAL_ROUND_PERIOD - 5 , schedulecountdown, 5 ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4seccount" , INITIAL_ROUND_PERIOD - 4 , schedulecountdown, 4 ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3seccount" , INITIAL_ROUND_PERIOD - 3 , schedulecountdown, 3 ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2seccount" , INITIAL_ROUND_PERIOD - 2 , schedulecountdown, 2 ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1seccount" , INITIAL_ROUND_PERIOD - 1 , schedulecountdown, 1 ) end
	
	AddSchedule( "round_start", INITIAL_ROUND_PERIOD, round_start)

	ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cap_room" )
	
	current_timer = INITIAL_ROUND_PERIOD
	
	AddHudTextToAll("gates_text", "Gate Opens:", 0, 58, 4)
	AddHudTimerToAll("gates_timer", current_timer, -1, 0, 70, 4)
	AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, current_timer )
	
	hud_state = 4
	
	-- disable expensive prop shadows
	OutputEvent( "prop_defender", "DisableShadow" )
	OutputEvent( "prop_attacker", "DisableShadow" )
end

function precache()
	PrecacheSound("otherteam.flagstolen") -- doors open
	PrecacheSound("misc.bloop") -- time warnings/flag cap
	PrecacheSound("yourteam.flagreturn") -- defenders scoring sound
	PrecacheSound("misc.doop") -- attackers scoring sound
	PrecacheSound("yourteam.flagcap") -- attackers all cap sound
	PrecacheSound("otherteam.flagcap") -- defenders all cap sound
	PrecacheSound("misc.deeoo") -- flag revert sound
end

-- spawns attackers with flags
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	-- Full H/A on spawn
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 ) 
	player:AddAmmo( Ammo.kShells, 400 ) 
	player:AddAmmo( Ammo.kRockets, 400 ) 
	player:AddAmmo( Ammo.kCells, 400 ) 
	
	-- wtf, scout on d? are you mental?
	if (player:GetClass() == Player.kScout) and (player:GetTeamId() == defenders) then
		local id = player:GetId()
		AddSchedule("force_changemessage"..id, 2, BroadCastMessageToPlayer, player, "No Scouts on defense. Autoswitching to Soldier." )
		AddSchedule("force_change"..id, 2, forcechange, player)
	end
	
	if player:GetTeamId() ~= attackers then
		UpdateObjectiveIcon( player, nil )
		return -- NON-ATTACKERS DO NOT DO THE REST OF THIS FUNCTION!!!!
	else
		UpdateObjectiveIcon( player, ATTACKERS_OBJECTIVE_ENTITY )
	end

	local c = Collection()
	c:GetByName(flags, { CF.kNone } )

	for item in c.items do
		item = CastToInfoScript(item)
		if item:IsInactive() then
			AddHudIcon( player, teamdata[attackers].flag_icon, item:GetName(), flag.hudx, flag.hudy, flag.hudwidth, flag.hudheight, flag.hudalign )
			item:Pickup( player )
			break
		end
	end
	
	-- remove any players not on a team from playertouchedtable
	for playerx, recordx in pairs(playerScoringTable) do
		if GetPlayerByID( playerx ) then
			local playert = GetPlayerByID( playerx )
			if playert:GetTeamId() ~= attackers then
				playerScoringTable[playerx] = nil
			end
		end
	end
	
	if player:GetTeamId() ~= attackers then return end
	
	-- add to table and reset points to 0
	playerScoringTable[player:GetId()] = {points = 0}
end

-- needed so that people who switch team are removed from the cap room collection properly.
function player_switchteam ( player, oldteam, newteam )

	if oldteam == attackers then 
		base_caproom_trigger:onendtouch( player )
	end

	return true
end

function player_killed ( player, damageinfo )

	-- if no damageinfo do nothing
	if not damageinfo then return end

	if IsPlayer(player) then
		player = CastToPlayer(player)
	else
		return
	end

	if player:GetTeamId() == attackers then
		BroadCastMessageToPlayer( player, "You scored "..playerScoringTable[player:GetId()].points.." team points that run" )
		AddScheduleRepeatingNotInfinitely( "timer_return_schedule", .5, BroadCastMessageToPlayer, 4, player, "You scored "..playerScoringTable[player:GetId()].points.." team points that run")
	end

end

-- captures points/works out stuff. Also resupplies on capture
function base_cp_trigger:ontouch( trigger_entity )

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local cp = self.cp_number

		-- No capping if player's team already controls this CP
		if player:GetTeamId() == defenders then return end

		if command_points[self.cp_number].controlling_team == attackers then return end

		-- Player has to have a flag
		local playerhasflag = false
		for i,v in ipairs( flags ) do
			if player:HasItem( v ) then playerhasflag = true end
		end

		if not playerhasflag then return end

		BroadCastSound( "misc.bloop" )
		self:ReturnFlagFromPlayer( player )
		self:ChangeControllingTeam( attackers, player )
	end
end

-- updates the team in control of the point
function base_cp_trigger:ChangeControllingTeam( team, player )
	OutputEvent( "cp" .. self.cp_number .. "_flag", "Skin", teamdata[team].skin )
	OutputEvent( "cp" .. self.cp_number .. "_beam", "Color", teamdata[team].beamcolour )
	command_points[self.cp_number].controlling_team = team

	local cp = command_points[self.cp_number]

	RemoveHudItemFromAll( self.cp_number .. "-icon")
	AddHudIconToAll( teamdata[ cp.controlling_team ].hud_icon , self.cp_number .. "-icon", cp.hudposx, cp.hudposy, cp.hudwidth, cp.hudheight, cp.hudalign)
	
	-- stop defender point countdown
    RemoveSchedule( "defenders_period_scoring" )
    RemoveSchedule( "init_defenders_period_scoring" )

	local sTeam = GetTeam(attackers)
	-- Checks if all command points captured.
	if determine_totalcontrol( attackers ) then
		RemoveSchedule( "shutout" ) -- O scores, no D shutout (put in all O scoring spots for safety, haha)
		sTeam:AddScore(POINTS_PER_TOTAL_CONTROL)
		player:AddFortPoints( FORT_POINTS_PER_TOTAL_CONTROL, "Capturing the last flag" ) 
		playerScoringTable[player:GetId()].points = playerScoringTable[player:GetId()].points + POINTS_PER_TOTAL_CONTROL
		local team = GetTeam( defenders )
		reset_flags( team )
		SmartTeamSound( GetTeam(defenders), "otherteam.flagcap", "yourteam.flagcap" )
		BroadCastMessage( "Attackers capture all flags!" )
	else
		RemoveSchedule( "shutout" ) -- O scores, no D shutout (put in all O scoring spots for safety, haha)
		sTeam:AddScore(POINTS_PER_CAPTURE)
		player:AddFortPoints( FORT_POINTS_PER_CAPTURE, "Capturing a flag" ) 
		playerScoringTable[player:GetId()].points = playerScoringTable[player:GetId()].points + POINTS_PER_CAPTURE
		BroadCastMessage( "Attackers capture a flag!" )
	end

end

-- returns flag from player on capture of point
function base_cp_trigger:ReturnFlagFromPlayer( player )

		-- Get all carried flags and ...
		local c = Collection()
		c:GetByName(flags, { CF.kInfoScript_Carried })

		-- ... return the flag that the player is carrying.
		for flag in c.items do
			flag = CastToInfoScript(flag)
			carrier = flag:GetCarrier()
			if player:GetId() == carrier:GetId() then
				flag:Return()
				RemoveHudItem( player, flag:GetName() )
			end
		end
end


-- returns flag instantly if carrier killed
function base_flag:onownerdie( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript( entity )
	flag:Drop( FLAG_RETURN_TIME, 0.0 )
	local player = CastToPlayer( owner_entity )
	RemoveHudItem( player, flag:GetName() )
end

-- Removes HUD icons when teams switch roles
function base_flag:onloseitem( owner_entity )
	local player = CastToPlayer( owner_entity )
	RemoveHudItem( player, "flag" )
end

-- registers attackers as they enter the cap room
function base_caproom_trigger:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then

		local player = CastToPlayer( trigger_entity )

		if player:GetTeamId() == defenders then return end

		cap_room_collection:AddItem( player )


		if cap_room_collection:Count() == 1 then

			-- resets the timer. Only nessecary on the first attacker's entrance.
			current_timer = FLAG_REVERT_PERIOD
			DeleteSchedule( "timer_schedule" )

			RemoveSchedule( "defenders_period_scoring" )
			RemoveSchedule( "init_defenders_period_scoring" )
			RemoveHudItemFromAll("defender_points_timer")
			RemoveHudItemFromAll("defender_points_text")
			RemoveHudItemFromAll("defender_points_text2")
		  
			AddHudIconToAll( "attackers.vtf", "attacker_hud", -12, 58, 64, 8, 4)
			AddHudTextToAll("attackercount_number", tostring( cap_room_collection:Count() ), 0, 70, 4)
			hud_state = 1
		else
			RemoveHudItemFromAll("attackercount_number")
			AddHudTextToAll("attackercount_number", tostring( cap_room_collection:Count() ), 0, 70, 4)
		end

		if scoring_team ~= attackers then
			RemoveHudItemFromAll("reset_hud")
			RemoveHudItemFromAll("timer")
			DeleteSchedule( "cap_room_timer" )
			local team = GetTeam(attackers)
			AddScheduleRepeating( "period_scoring", PERIOD_TIME, period_scoring, team)
			scoring_team = attackers
		end
	end
end

-- deregisters attackers as they enter the cap room. Checks to see if all attackers have left.
function base_caproom_trigger:onendtouch( trigger_entity )

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		if player:GetTeamId() == defenders then return end

		cap_room_collection:RemoveItem( player )

		local team = GetTeam(defenders)
		if cap_room_collection:Count() == 0 then
			RemoveHudItemFromAll("attacker_hud")
			RemoveHudItemFromAll("attackercount_number")
			
			-- so that the flaginfo function knows if it needs to add a timer or not on player spawn
			if determine_totalcontrol(defenders) and hud_state ~= 4 then
				current_timer = DELAY_BEFORE_DEFENSE_PERIOD_SCORING
				
				AddSchedule( "init_defenders_period_scoring", current_timer, init_defenders_period_scoring )
				
				add_hud_defense_period()
			elseif hud_state ~= 4 then
				hud_state = 2
			end
			
			if scoring_team ~= defenders then
				DeleteSchedule( "period_scoring" )
				scoring_team = defenders
			end

			if determine_totalcontrol( defenders ) == false then
				AddSchedule( "cap_room_timer", FLAG_REVERT_PERIOD , cap_room_timer, team )
				AddHudIconToAll( "flags_reset.vtf", "reset_hud", -8, 58, 64, 8, 4)
				-- current_timer +1 so that the HUD doesn't go from 19 to 0
				AddHudTimerToAll("timer", current_timer +1, -1, 0, 70, 4)
				RemoveSchedule( "timer_schedule" )
				AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, 20)
			end
		else
			RemoveHudItemFromAll("attackercount_number")
			AddHudTextToAll("attackercount_number", tostring( cap_room_collection:Count() ), 0, 70, 4)
		end
	end
end

-- empties the collection if no-one in in the room. Shouldn't really be nessecary.
function base_caproom_trigger:oninactive()
	-- Clear out the flags in the collection
	cap_room_collection:RemoveAllItems()
	RemoveHudItemFromAll("attacker_hud")
	RemoveHudItemFromAll("attackercount_number")
end

-- checks to see if given team owns all command points
function determine_totalcontrol( team )
	local control_count = 0
	for i,v in ipairs( command_points ) do
		if v.controlling_team == team then
			control_count = control_count + 1
		end
	end

	if control_count == NUMBER_OF_COMMAND_POINTS then
		return true
	else
		return false
	end
end

-- I dunno, does something, not sure what!
function RespawnAllPlayers()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end

-- Reverts the flags to the defenders control when all 4 are captured.
function revert_flags( team )
	for i,v in ipairs( command_points ) do
		if v.controlling_team == attackers then
			v.controlling_team = defenders
			RemoveHudItemFromAll( v.cp_number .. "-icon" )
			AddHudIconToAll( teamdata[ v.controlling_team ].hud_icon , v.cp_number .. "-icon", command_points[v.cp_number].hudposx, command_points[v.cp_number].hudposy, command_points[v.cp_number].hudwidth, command_points[v.cp_number].hudheight, command_points[v.cp_number].hudalign)
			OutputEvent( "cp" .. i .. "_flag", "Skin", teamdata[defenders].skin )
			OutputEvent( "cp" .. i .. "_beam", "Color", teamdata[defenders].beamcolour )
			BroadCastSound( "misc.deeoo" )
			--team:AddScore( POINTS_PER_CAPTURE )
			
			current_timer = DELAY_BEFORE_DEFENSE_PERIOD_SCORING - FLAG_REVERT_PERIOD
			
			AddSchedule( "init_defenders_period_scoring", current_timer, init_defenders_period_scoring )
			
			add_hud_defense_period()
		end
	end
end


-- Same as above, but without scoring. Definitly a quick-fix :(
function reset_flags( team )
		for i,v in ipairs( command_points ) do
			if v.controlling_team == attackers then
				v.controlling_team = defenders
				RemoveHudItemFromAll( v.cp_number .. "-icon")
				AddHudIconToAll( teamdata[ v.controlling_team ].hud_icon , v.cp_number .. "-icon", command_points[v.cp_number].hudposx, command_points[v.cp_number].hudposy, command_points[v.cp_number].hudwidth, command_points[v.cp_number].hudheight, command_points[v.cp_number].hudalign)
				OutputEvent( "cp" .. i .. "_flag", "Skin", teamdata[defenders].skin )
				OutputEvent( "cp" .. i .. "_beam", "Color", teamdata[defenders].beamcolour )
			end
		end
end

-------------------------------------------
-- HUD information
-------------------------------------------

function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	for i,v in ipairs(command_points) do
		AddHudIcon( player, teamdata[ v.controlling_team ].hud_icon , v.cp_number .. "-icon", command_points[v.cp_number].hudposx, command_points[v.cp_number].hudposy, command_points[v.cp_number].hudwidth, command_points[v.cp_number].hudheight, command_points[v.cp_number].hudalign)
	end

	--ConsoleToAll("hud_state = " .. hud_state)

	RemoveHudItem(player, "reset_hud")
	RemoveHudItem(player, "timer")
	RemoveHudItem(player, "attacker_hud")
	RemoveHudItem(player, "attackercount_number")
	RemoveHudItem(player, "defender_points_text")
	RemoveHudItem(player, "defender_points_text2")
	RemoveHudItem(player, "defender_points_timer")
	RemoveHudItem(player, "gates_text")
	RemoveHudItem(player, "gates_timer")
	-- hud_state == 0 then nothing more to do
	if hud_state == 0 then
		return
	end

	if hud_state == 1 then
		AddHudIcon( player, "attackers.vtf", "attacker_hud", -12, 58, 64, 8, 4)
		AddHudText(player, "attackercount_number", tostring( cap_room_collection:Count() ), 0, 70, 4)
	end

	if hud_state == 2 then
		AddHudIcon( player, "flags_reset.vtf", "reset_hud", -8, 58, 64, 8, 4)
		AddHudTimer(player, "timer", current_timer +1, -1, 0, 70, 4)
	end
	
	if hud_state == 3 then
		AddHudTextToAll( "defender_points_text", "Defenders", 0, 54, 4 )
		AddHudTextToAll( "defender_points_text2", "Score:", 0, 62, 4)
		AddHudTimerToAll( "defender_points_timer", current_timer +1, -1, 0, 70, 4 )
	end
	
	if hud_state == 4 then
		AddHudText( player, "gates_text", "Gate Opens:", 0, 58, 4)
		AddHudTimer(player, "gates_timer", current_timer, -1, 0, 70, 4)
	end
		
end

-----------------------------------------------------------------------------
-- Scheduled functions that do stuff
-----------------------------------------------------------------------------

function timer_schedule()
	current_timer = current_timer -1
end

-- Sends a message to all after the determined time
function schedulemessagetoall( message )
	BroadCastMessage( message )
end

function schedulespeakall( phrase )
	SpeakAll( phrase )
end

-- Plays a sound to all after the determined time
function schedulesound( sound )
	BroadCastSound( sound )
end

function schedulecountdown( time )
	BroadCastMessage( ""..time.."" )
	SpeakAll( "AD_" .. time .. "SEC" )
end

-- Sends a message to all after the determined time
function schedulechangemessage( player, message )
	if (player:GetClass() == Player.kScout) and (player:GetTeamId() == defenders) then
		BroadCastMessageToPlayer( player, message )
	end
end

-- force a scout/med to switch to soli if they haven't
function forcechange( player )
	if (player:GetClass() == Player.kScout) and (player:GetTeamId() == defenders) then
		ApplyToPlayer( player, { AT.kChangeClassSoldier, AT.kRespawnPlayers } )
	end
end

-- timer triggered "FLAG_REVERT_PERIOD" seconds after cap room is empties of attackers. Resets captured flags.
function cap_room_timer( team )
		revert_flags( team )
		BroadCastMessage( "Control Room defended! All flags reset." )
		RemoveHudItemFromAll("reset_hud")
		RemoveHudItemFromAll("timer")
end

function add_hud_defense_period()
	AddHudTextToAll( "defender_points_text", "Defenders", 0, 54, 4 )
	AddHudTextToAll( "defender_points_text2", "Score:", 0, 62, 4)
	AddHudTimerToAll( "defender_points_timer", current_timer +1, -1, 0, 70, 4 )
	RemoveSchedule( "timer_schedule" )
	AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, current_timer )
	hud_state = 3
end

-- Adds points based on time inside cap room and number of attackers inside cap room
function period_scoring( team )
   for player in cap_room_collection.items do
      player = CastToPlayer(player)
      
      -- Player has to not have a flag
      -- NOTE: This is an expensive way of doing it. we really should be adding the player to the collection when he caps, and then checking for a flag onendtouch.
      local playerhasflag = false
      for i,v in ipairs( flags ) do
        if player:HasItem( v ) then playerhasflag = true end
      end

      if playerhasflag then return end
	  
      RemoveSchedule( "shutout" ) -- O scores, no D shutout (put in all O scoring spots for safety, haha)
      team:AddScore( POINTS_PER_PERIOD )
	  player:AddFortPoints( FORT_POINTS_PER_PERIOD, "Staying in the Control Room" ) 
	  playerScoringTable[player:GetId()].points = playerScoringTable[player:GetId()].points + POINTS_PER_PERIOD
		
      if player ~= nil then
         player:AddHealth(DAMAGE_PER_PERIOD)
      else
         ConsoleToAll("LUA ERROR: player_removehealth: Unable to find player")
      end
   end
	if cap_room_collection:Count() > 0 then
		local aplayerhasnoflag = false
		for player in cap_room_collection.items do
			player = CastToPlayer(player)
			local hasanyflag = false
			for i,v in ipairs( flags ) do
				if player:HasItem( v ) then hasanyflag = true end
			end
			if hasanyflag == false then aplayerhasnoflag = true end
		end
		if aplayerhasnoflag then
			SmartTeamSound( GetTeam(defenders), "yourteam.flagreturn", "misc.doop" )
		end
	end
end

function init_defenders_period_scoring()
	local team = GetTeam( defenders )
	team:AddScore( POINTS_PER_DEFENSE_PERIOD )
	SmartTeamSound( GetTeam(attackers), "yourteam.flagreturn", "misc.doop" )
	
	current_seconds = 30
	
	AddScheduleRepeating( "defenders_period_scoring", DEFENSE_PERIOD_TIME, defenders_period_scoring )
	current_timer = DEFENSE_PERIOD_TIME
	add_hud_defense_period()
end

function defenders_period_scoring( )
	local team = GetTeam( defenders )
	team:AddScore( POINTS_PER_DEFENSE_PERIOD )
	SmartTeamSound( GetTeam(attackers), "yourteam.flagreturn", "misc.doop" )
	
	if current_seconds >= 60 then
		BroadCastMessage( "Defenders get "..POINTS_PER_DEFENSE_60SEC_BONUS.." bonus points" )
		team:AddScore( POINTS_PER_DEFENSE_60SEC_BONUS )
		current_seconds = 0
	else
		current_seconds = current_seconds + 10
	end
	
	current_timer = DEFENSE_PERIOD_TIME
	add_hud_defense_period()
end

function shutout( )

	-- attackers instead of defenders, because the teams switched
	local teamid = attackers

	-- but after the last round, use defenders	
	if phase >= NUMBER_OF_ROUNDS then
		teamid = defenders
	end

	local team = GetTeam( teamid )
	AddSchedule( "defenders_shutout_msg", 3, BroadCastMessage, "The offense did not score any points last round!" )
	team:AddScore( POINTS_PER_DEFENSE_SHUTOUT )
end

-- Opens the gates and schedules the round's end.
function round_start()
	-- Opens the gates and all that lovely stuff
	OpenDoor("frontgate1")

	--OutputEvent( "frontgate2", "Disable" )
	AddSchedule("open_frontgate2",60,open_frontgate2)
	
	BroadCastMessage( "Main gate is open!" )
	BroadCastSound( "otherteam.flagstolen" )

	-- Sets up the end of a round, and the appropriate timed messages
	AddSchedule( "round_end", ROUND_PERIOD, round_end)
	AddSchedule( "shutout", ROUND_PERIOD, shutout)
	AddSchedule( "init_defenders_period_scoring", DELAY_BEFORE_DEFENSE_PERIOD_SCORING, init_defenders_period_scoring )
	
	RemoveHudItemFromAll( "gates_text" )
	RemoveHudItemFromAll( "gates_timer" )
	
	current_timer = DELAY_BEFORE_DEFENSE_PERIOD_SCORING
	
	add_hud_defense_period()
	
	hud_state = 3
	
	if phase < NUMBER_OF_ROUNDS then
		-- Sets up the end of a round, and the appropriate timed messages
		if ROUND_PERIOD > 300 then AddSchedule( "phase" .. phase .. "5minwarn" , ROUND_PERIOD - 300 , schedulemessagetoall, "5 minutes until team switch!" ) end
		if ROUND_PERIOD > 120 then AddSchedule( "phase" .. phase .. "2minwarn" , ROUND_PERIOD - 120 , schedulemessagetoall, "2 minutes until team switch!" ) end
		if ROUND_PERIOD > 60 then AddSchedule( "phase" .. phase .. "1minwarn" , ROUND_PERIOD - 60 , schedulemessagetoall, "1 minute until team switch!" ) end
		if ROUND_PERIOD > 30 then AddSchedule( "phase" .. phase .. "30secwarn" , ROUND_PERIOD - 30 , schedulemessagetoall, "30 seconds until team switch!" ) end
		if ROUND_PERIOD > 10 then AddSchedule( "phase" .. phase .. "10secwarn" , ROUND_PERIOD - 10 , schedulemessagetoall, "Team switch in 10 seconds!" ) end
		if ROUND_PERIOD > 5 then AddSchedule( "phase" .. phase .. "5secwarn" , ROUND_PERIOD - 5 , schedulemessagetoall, "5" ) end
		if ROUND_PERIOD > 4 then AddSchedule( "phase" .. phase .. "4secwarn" , ROUND_PERIOD - 4 , schedulemessagetoall, "4" ) end
		if ROUND_PERIOD > 3 then AddSchedule( "phase" .. phase .. "3secwarn" , ROUND_PERIOD - 3, schedulemessagetoall, "3" ) end
		if ROUND_PERIOD > 2 then AddSchedule( "phase" .. phase .. "2secwarn" , ROUND_PERIOD - 2, schedulemessagetoall, "2" ) end
		if ROUND_PERIOD > 1 then AddSchedule( "phase" .. phase .. "1secwarn" , ROUND_PERIOD - 1, schedulemessagetoall, "1" ) end
		AddSchedule( "phase" .. phase .. "switchmessage" , ROUND_PERIOD, schedulemessagetoall, "Round over - teams switch roles!" )
	else
		if ROUND_PERIOD > 300 then AddSchedule( "phase" .. phase .. "5minwarn" , ROUND_PERIOD - 300 , schedulemessagetoall, "5 minutes until map ends!" ) end
		if ROUND_PERIOD > 120 then AddSchedule( "phase" .. phase .. "2minwarn" , ROUND_PERIOD - 120 , schedulemessagetoall, "2 minutes until map ends!" ) end
		if ROUND_PERIOD > 60 then AddSchedule( "phase" .. phase .. "1minwarn" , ROUND_PERIOD - 60 , schedulemessagetoall, "1 minute until map ends!" ) end
		if ROUND_PERIOD > 30 then AddSchedule( "phase" .. phase .. "30secwarn" , ROUND_PERIOD - 30 , schedulemessagetoall, "30 seconds until map ends!" ) end
		if ROUND_PERIOD > 10 then AddSchedule( "phase" .. phase .. "10secwarn" , ROUND_PERIOD - 10 , schedulemessagetoall, "Map ends in 10 seconds!" ) end
		if ROUND_PERIOD > 5 then AddSchedule( "phase" .. phase .. "5secwarn" , ROUND_PERIOD - 5 , schedulemessagetoall, "5" ) end
		if ROUND_PERIOD > 4 then AddSchedule( "phase" .. phase .. "4secwarn" , ROUND_PERIOD - 4 , schedulemessagetoall, "4" ) end
		if ROUND_PERIOD > 3 then AddSchedule( "phase" .. phase .. "3secwarn" , ROUND_PERIOD - 3, schedulemessagetoall, "3" ) end
		if ROUND_PERIOD > 2 then AddSchedule( "phase" .. phase .. "2secwarn" , ROUND_PERIOD - 2, schedulemessagetoall, "2" ) end
		if ROUND_PERIOD > 1 then AddSchedule( "phase" .. phase .. "1secwarn" , ROUND_PERIOD - 1, schedulemessagetoall, "1" ) end
	end
	
	-- sounds
	if ROUND_PERIOD > 300 then AddSchedule( "phase" .. phase .. "5minwarnsound" , ROUND_PERIOD - 300 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 120 then AddSchedule( "phase" .. phase .. "2minwarnsound" , ROUND_PERIOD - 120 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 60 then AddSchedule( "phase" .. phase .. "1minwarnsound" , ROUND_PERIOD - 60 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 30 then AddSchedule( "phase" .. phase .. "30secwarnsound" , ROUND_PERIOD - 30 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 10 then AddSchedule( "phase" .. phase .. "10secwarnsound" , ROUND_PERIOD - 10 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 5 then AddSchedule( "phase" .. phase .. "5secwarnsound" , ROUND_PERIOD - 5 , schedulecountdown, 5 ) end
	if ROUND_PERIOD > 4 then AddSchedule( "phase" .. phase .. "4secwarnsound" , ROUND_PERIOD - 4 , schedulecountdown, 4 ) end
	if ROUND_PERIOD > 3 then AddSchedule( "phase" .. phase .. "3secwarnsound" , ROUND_PERIOD - 3 , schedulecountdown, 3 ) end
	if ROUND_PERIOD > 2 then AddSchedule( "phase" .. phase .. "2secwarnsound" , ROUND_PERIOD - 2 , schedulecountdown, 2 ) end
	if ROUND_PERIOD > 1 then AddSchedule( "phase" .. phase .. "1secwarnsound" , ROUND_PERIOD - 1 , schedulecountdown, 1 ) end
	
	if phase == 1 then
		AddSchedule( "phase" .. phase .. "switchmessage" , ROUND_PERIOD, schedulemessagetoall, "Round over - teams switch roles!" )
	end

end

-- open the 2nd gate
function open_frontgate2()
	OpenDoor("frontgate2")
	BroadCastMessage( "Secondary gate is open!" )
	BroadCastSound( "otherteam.flagstolen" )
end

-- Checks to see if it's the first or second round, then either swaps teams, or ends the game.
function round_end()

	-- moved up above map ending stuff so shutout can tell if the map's over
	phase = phase + 1

	if phase > NUMBER_OF_ROUNDS then
		DeleteSchedule( "cap_room_timer" )
		DeleteSchedule( "period_scoring" )
		DeleteSchedule( "defenders_period_scoring" )
		DeleteSchedule( "init_defenders_period_scoring" )
		DeleteSchedule( "set_cvar-mp_timelimit" )
		GoToIntermission()
		return
	end

	RemoveSchedule( "open_frontgate2" )
	CloseDoor("frontgate1")
	CloseDoor("frontgate2")
	--if detpack_wall_open == true then
	--	OutputEvent( "frontgate2", "Enable" )
	--	detpack_wall_open = nil
	--end

	if attackers == Team.kBlue then
		attackers = Team.kRed
		defenders = Team.kBlue
		
		OutputEvent( "forcefield_red", "Disable" )
		OutputEvent( "forcefield_blue", "Enable" )
		
		OutputEvent( "redladder", "Disable" )
		OutputEvent( "blueladder", "Enable" )
		
	else
		attackers = Team.kBlue
		defenders = Team.kRed
		
		OutputEvent( "forcefield_red", "Enable" )
		OutputEvent( "forcefield_blue", "Disable" )
		
		OutputEvent( "redladder", "Enable" )
		OutputEvent( "blueladder", "Disable" )
	end

	-- switch them team names
	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )
	
	-- reset them limits
	team = GetTeam(defenders)
	team:SetClassLimit(Player.kScout, -1)
	
	team = GetTeam(attackers)
	team:SetClassLimit(Player.kScout, 0)
	
	respawnturret_attackers = base_respawnturret:new({ team = attackers })

	local c = Collection()
	c:GetByName(flags, { CF.kNone })
	for flag in c.items do
		flag = CastToInfoScript(flag)
		flag:Return()
		flag:SetSkin( tonumber( teamdata[attackers].skin ) )
	end

	local dTeam = GetTeam( defenders )
	reset_flags( dTeam )

	-- switches some prop model's skins so teams spawn in appropriatly-coloured rooms.
	OutputEvent( "prop_defender", "Skin", teamdata[defenders].skin )
	OutputEvent( "prop_attacker", "Skin", teamdata[attackers].skin )
	OutputEvent( "pfrbeam", "Color", teamdata[defenders].beamcolour )
	OutputEvent( "yardbeam", "Color", teamdata[defenders].beamcolour )
	OutputEvent( "cp2_beam2", "Color", teamdata[defenders].beamcolour )
	OutputEvent( "cp3_beam2", "Color", teamdata[defenders].beamcolour )

	-- Makes sure that the HUD messages are removed. Probably redundant.
	RemoveHudItemFromAll("reset_hud")
	RemoveHudItemFromAll("timer")
	RemoveHudItemFromAll("attacker_hud")
	RemoveHudItemFromAll("attackercount_number")
	RemoveHudItemFromAll("defender_points_timer")
	RemoveHudItemFromAll("defender_points_text")
	RemoveHudItemFromAll("defender_points_text2")
	
	hud_state = 4

	RespawnAllPlayers()
	
	current_timer = INITIAL_ROUND_PERIOD
	
	AddHudTextToAll("gates_text", "Gate Opens:", 0, 58, 4)
	AddHudTimerToAll("gates_timer", current_timer, -1, 0, 70, 4)
	RemoveSchedule( "timer_schedule" )
	AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, current_timer )

	-- reset schedules to the defending team's advantage
	DeleteSchedule( "defenders_period_scoring" )
	DeleteSchedule( "init_defenders_period_scoring" )
	DeleteSchedule( "cap_room_timer" )
	DeleteSchedule( "period_scoring" )
	local team = GetTeam(defenders)
	scoring_team = defenders

	-- scheduled message loveliness.
	if INITIAL_ROUND_PERIOD > 30 then AddSchedule( "dooropen30sec" , INITIAL_ROUND_PERIOD - 30 , schedulemessagetoall, "Gate opens in 30 seconds!" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10sec" , INITIAL_ROUND_PERIOD - 10 , schedulemessagetoall, "Gate opens in 10 seconds!" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5sec" , INITIAL_ROUND_PERIOD - 5 , schedulemessagetoall, "5" ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4sec" , INITIAL_ROUND_PERIOD - 4 , schedulemessagetoall, "4" ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3sec" , INITIAL_ROUND_PERIOD - 3, schedulemessagetoall, "3" ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2sec" , INITIAL_ROUND_PERIOD - 2, schedulemessagetoall, "2" ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1sec" , INITIAL_ROUND_PERIOD - 1, schedulemessagetoall, "1" ) end
	
	-- sounds
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen30secsound" , INITIAL_ROUND_PERIOD - 30 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10secsound" , INITIAL_ROUND_PERIOD - 10 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5seccount" , INITIAL_ROUND_PERIOD - 5 , schedulecountdown, 5 ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4seccount" , INITIAL_ROUND_PERIOD - 4 , schedulecountdown, 4 ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3seccount" , INITIAL_ROUND_PERIOD - 3 , schedulecountdown, 3 ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2seccount" , INITIAL_ROUND_PERIOD - 2 , schedulecountdown, 2 ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1seccount" , INITIAL_ROUND_PERIOD - 1 , schedulecountdown, 1 ) end
	
	AddSchedule( "round_start", INITIAL_ROUND_PERIOD, round_start)
end


-----------------------------------------------------------------------------
-- respawn shields
-----------------------------------------------------------------------------
hurt = trigger_ff_script:new({ team = Team.kUnassigned })
function hurt:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == attackers then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red lasers hurt blue and vice-versa

red_laser_hurt = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- det message
-----------------------------------------------------------------------------
--det_trigger = trigger_ff_script:new({ })
--function det_trigger:allowed( allowed_entity )
--	if IsPlayer( allowed_entity ) then
--		local player = CastToPlayer( allowed_entity )
--		if player:GetTeamId() == attackers and detpack_wall_open == nil then
--			BroadCastMessageToPlayer( player, "This gate can be detonated from the other side, or opens one minute after the first one" )
--			return EVENT_ALLOWED
--		end
--	end
--
--	return EVENT_DISALLOWED
--end

-----------------------------------------------------------------------------
-- backpacks, doors, etc. etc. 
-----------------------------------------------------------------------------

impact_pack = genericbackpack:new({
	health = 50,
	armor = 100,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 20,
	cells = 100,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function impact_pack:dropatspawn() return false end


-----------------------------------------------------------------------------
-- detable frontgate2
-----------------------------------------------------------------------------

--frontgate2_trigger = trigger_ff_script:new({ })

--function frontgate2_trigger:onexplode( trigger_entity  ) 
--	if IsDetpack( trigger_entity ) then 
--		OutputEvent( "frontgate2", "Disable" )
--		OutputEvent( "frontgate2_gibs", "Shoot" )
--		BroadCastMessage("gate 2 blown open!")
--		detpack_wall_open = true
--	end 
--	return EVENT_ALLOWED
--end
--function frontgate2_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
--end

-----------------------------------------------------------------------------
-- respawn turrets
-----------------------------------------------------------------------------

respawnturret_attackers = base_respawnturret:new({ team = attackers })

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

loc_dspawn = location_info:new({ text = "D spawn", team = Team.kUnassigned })
loc_rr = location_info:new({ text = "ramp room", team = Team.kUnassigned })
loc_aspawn = location_info:new({ text = "A spawn", team = Team.kUnassigned })
loc_baseyrd = location_info:new({ text = "base yard", team = Team.kUnassigned })
loc_fr = location_info:new({ text = "flag room", team = Team.kUnassigned })
