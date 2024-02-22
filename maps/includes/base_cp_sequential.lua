-- base_cp.lua

-- if you want base cp with the default setup, 
-- include base_cp_default.lua in your map's lua file 
-- and then include base_cp.lua

if OBJECTIVE_TEAM1 == nil then OBJECTIVE_TEAM1 = nil end
if OBJECTIVE_TEAM2 == nil then OBJECTIVE_TEAM2 = nil end

function startup()
	SetGameDescription( "Sequential Control Points" )

	-- disable certain teams
	for i,v in pairs(disabled_teams) do
		SetPlayerLimit( v, -1 )
	end

	-- set up team limits
	for i1,v1 in pairs(teams) do
		local team = GetTeam(v1)
		for i2,v2 in ipairs(team_info[team:GetTeamId()].class_limits) do
			team:SetClassLimit( i2, v2 )
		end
	end

	RemoveAllCPAmmoAndArmor()

	ChangeCPDefendingTeam( 1, TEAM1 )
	ChangeCPDefendingTeam( CP_COUNT, TEAM2 )
	
	for i,v in ipairs(command_points) do
		RemoveSchedule( "cp" .. v.cp_number .. "_cap_timer" )
		ResetCPCapping( v )
		AddScheduleRepeating( "cp" .. v.cp_number .. "_cap_zone_timer", CAP_ZONE_TIMER_INTERVAL, cap_zone_timer, v )
	end
	
	OBJECTIVE_TEAM1 = "cp2_zone"
	OBJECTIVE_TEAM2 = "cp4_zone"
	UpdateTeamObjectiveIcon( GetTeam(TEAM1), GetEntityByName( OBJECTIVE_TEAM1 ) )
	UpdateTeamObjectiveIcon( GetTeam(TEAM2), GetEntityByName( OBJECTIVE_TEAM2 ) )
end

function player_spawn( player_entity ) 
	local player = CastToPlayer( player_entity ) 

	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )

	if player:GetTeamId() == TEAM1 then
		UpdateObjectiveIcon( player, GetEntityByName( OBJECTIVE_TEAM1 ) )
	elseif player:GetTeamId() == TEAM2 then
		UpdateObjectiveIcon( player, GetEntityByName( OBJECTIVE_TEAM2 ) )
	end
end

function precache()

	-- precache the cap sounds
	for i in pairs(good_cap_sounds) do
		PrecacheSound(good_cap_sounds[i])
		PrecacheSound(bad_cap_sounds[i])
	end

	PrecacheSound("misc.thunder")

	PrecacheSound("Buttons.snd9")
	PrecacheSound("Buttons.snd45")

	PrecacheSound("ff_cz2.teleport_exit")

	PrecacheSound("k_lab.teleport_post_winddown")
	PrecacheSound("novaprospekt.teleport_post_thunder")
	PrecacheSound("NPC_Ichthyosaur.AttackGrowl")
	PrecacheSound("Streetwar.d3_c17_11_die")
	PrecacheSound("streetwar.Ba_UseConsoleSounds")

	PrecacheSound("misc.thunder")
	PrecacheSound("misc.woop")
	PrecacheSound("misc.bloop")

	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
end

function PlayerStartTouchingCapZone( touch_entity, cp )

	local player = CastToPlayer(touch_entity)

	if PLAYER_TOUCHING_CP_ZONE[player:GetId()] == cp then return end

	if player:GetTeamId() == TEAM1 then
		if cp.cp_number > 1 then
			local last_team1_cp = cp.cp_number - 1
			if command_points[last_team1_cp].defending_team ~= TEAM1 then return end
		end
	elseif player:GetTeamId() == TEAM2 then
		if cp.cp_number < CP_COUNT then
			local last_team2_cp = cp.cp_number + 1
			if command_points[last_team2_cp].defending_team ~= TEAM2 then return end
		end
	end

	local team_number = player:GetTeamId()

	PLAYER_TOUCHING_CP_ZONE[player:GetId()] = cp

	cp.touching_players[team_number]:AddItem( player )
	cp.former_touching_players[team_number]:RemoveItem( player )
	if player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic then
		cp.cap_speed[team_number] = cp.cap_speed[team_number] + ( player:MaxSpeed() * 1.5 / 10 )
	else
		cp.cap_speed[team_number] = cp.cap_speed[team_number] + ( player:MaxSpeed() / 10 )
	end

	if team_number ~= cp.defending_team then
		player:SetCloakable( false )
	end

	local cp_zone_hudicon = cp_zone_icons[team_number]
	AddHudIcon( player, cp_zone_hudicon.hudicon, cp_zone_hudicon.hudicon, cp_zone_hudicon.hudx, cp_zone_hudicon.hudy, cp_zone_hudicon.hudwidth, cp_zone_hudicon.hudheight, cp_zone_hudicon.hudalign )
	
	event_StartTouchingCP( touch_entity, cp )
end

function PlayerStopTouchingCapZone( touch_entity, cp )

	local player = CastToPlayer(touch_entity)

	if PLAYER_TOUCHING_CP_ZONE[player:GetId()] == nil then return end

	local team_number = player:GetTeamId()

	PLAYER_TOUCHING_CP_ZONE[player:GetId()] = nil

	cp.touching_players[team_number]:RemoveItem( player )
	cp.former_touching_players[team_number]:AddItem( player )
	
	if player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic then
		cp.cap_speed[team_number] = cp.cap_speed[team_number] - ( player:MaxSpeed() * 1.5 / 10 )
	else
		cp.cap_speed[team_number] = cp.cap_speed[team_number] - ( player:MaxSpeed() / 10 )
	end

	-- clamp
	if cp.cap_speed[team_number] < 0 then
		cp.cap_speed[team_number] = 0
	end

	player:SetCloakable( true )

	RemoveHudItem( player, cp_zone_icons[team_number].hudicon )

	event_StopTouchingCP( touch_entity, cp )
	
end


function DrawCCAlarmIcon( cc_team_number )

	-- check whether command centers are enabled
	if not ENABLE_CC then return end

	-- turn on alarm
	if team_info[cc_team_number].cc_touch_count > 0 then

		RemoveHudItemFromAll( cc_team_number .. "-ccalarmicon_neutral" )
		AddHudIconToAll( team_info[cc_team_number].ccalarmicon, cc_team_number .. "-ccalarmicon", team_info[cc_team_number].ccalarmiconx, team_info[cc_team_number].ccalarmicony, team_info[cc_team_number].ccalarmiconwidth, team_info[cc_team_number].ccalarmiconheight, team_info[cc_team_number].ccalarmiconalign )

	-- turn off alarm
	else

		RemoveHudItemFromAll( cc_team_number .. "-ccalarmicon" )
		AddHudIconToAll( team_info[Team.kUnassigned].ccalarmicon, cc_team_number .. "-ccalarmicon_neutral", team_info[cc_team_number].ccalarmiconx, team_info[cc_team_number].ccalarmicony, team_info[cc_team_number].ccalarmiconwidth, team_info[cc_team_number].ccalarmiconheight, team_info[cc_team_number].ccalarmiconalign )

	end

end

function EntityStartTouchingCC( touch_entity, cc_team_number )

	if ENTITY_TOUCHING_CC[touch_entity:GetId()] ~= nil then return end

	ENTITY_TOUCHING_CC[touch_entity:GetId()] = cc_team_number

	team_info[cc_team_number].cc_touch_count = team_info[cc_team_number].cc_touch_count + 1

	-- turn on alarm
	if team_info[cc_team_number].cc_touch_count > 0 then

		event_StartTouchingCC( touch_entity, cc_team_number )

	end

	DrawCCAlarmIcon( cc_team_number )

end

function EntityStopTouchingCC( touch_entity, cc_team_number )

	if ENTITY_TOUCHING_CC[touch_entity:GetId()] == nil then return end

	ENTITY_TOUCHING_CC[touch_entity:GetId()] = nil

	team_info[cc_team_number].cc_touch_count = team_info[cc_team_number].cc_touch_count - 1

	-- turn off alarm
	if team_info[cc_team_number].cc_touch_count <= 0 then

		team_info[cc_team_number].cc_touch_count = 0

		event_StopTouchingCC( touch_entity, cc_team_number )

	end

	DrawCCAlarmIcon( cc_team_number )

end

function player_disconnected( player )

	if PLAYER_TOUCHING_CP_ZONE[player:GetId()] ~= nil then
		PlayerStopTouchingCapZone( player, PLAYER_TOUCHING_CP_ZONE[player:GetId()] )
	end

	if ENTITY_TOUCHING_CC[player:GetId()] ~= nil then
		EntityStopTouchingCC( player, ENTITY_TOUCHING_CC[player:GetId()] )
	end

end

function player_switchteam( player, currentteam, desiredteam )

	if PLAYER_TOUCHING_CP_ZONE[player:GetId()] ~= nil then
		PlayerStopTouchingCapZone( player, PLAYER_TOUCHING_CP_ZONE[player:GetId()] )
	end

	if ENTITY_TOUCHING_CC[player:GetId()] ~= nil then
		EntityStopTouchingCC( player, ENTITY_TOUCHING_CC[player:GetId()] )
	end

	return true

end

-----------------------------------------------------------------------------
-- timed scoring
-----------------------------------------------------------------------------
function cp_score_timer( cp_number, team_number )

	local team = GetTeam(team_number)
	team:AddScore(command_points[cp_number].point_value[team_number])

end

-----------------------------------------------------------------------------
-- notify the players of the total cap.
-- Also, create a logic_relay in your map named fullcap_trigger to pass outputs to your entities.
-----------------------------------------------------------------------------
function complete_control_notification ( team_number )
	local team = GetTeam(team_number)
	SmartTeamSound(team, "yourteam.flagcap", "otherteam.flagcap")
	SmartTeamSpeak(team, "CZ_GOTALL", "CZ_THEYGOTALL")
	SmartTeamMessage(team, "#FF_CZ2_YOURTEAM_COMPLETE", "#FF_CZ2_OTHERTEAM_COMPLETE", Color.kGreen, Color.kRed)
	OutputEvent( "fullcap_trigger", "Trigger" )
	
	OBJECTIVE_TEAM1 = "cp2_zone"
	OBJECTIVE_TEAM2 = "cp4_zone"
	UpdateTeamObjectiveIcon( GetTeam(TEAM1), GetEntityByName( OBJECTIVE_TEAM1 ) )
	UpdateTeamObjectiveIcon( GetTeam(TEAM2), GetEntityByName( OBJECTIVE_TEAM2 ) )
end

-----------------------------------------------------------------------------
-- reset everything after the total cap.
-----------------------------------------------------------------------------
function complete_control_respawn ()
	ApplyToAll( { AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, kReloadClips } )
end

-----------------------------------------------------------------------------
-- emit a sound from an entity
-----------------------------------------------------------------------------
function EmitSound( entity, sound )

	entity:EmitSound(sound)

end

-----------------------------------------------------------------------------
-- remove all the ammo and armor from the entire map
-----------------------------------------------------------------------------
function RemoveAllCPAmmoAndArmor()

	-- Remove all ammo and armor from CPs
	local c = Collection()
	c:GetByName(cp_ammo_and_armor_names, { CF.kNone })
	for item in c.items do
		item = CastToInfoScript(item)
		item:Remove()
	end

end

-----------------------------------------------------------------------------
-- does the player have a flag?
-----------------------------------------------------------------------------
function PlayerHasFlag( player )

	-- check if the player has a flag
	for i,v in ipairs(flags) do
		if player:HasItem(v) then
			-- player has a flag
			return true
		end
	end

	-- player doesn't have a flag
	return false

end

-----------------------------------------------------------------------------
-- return carried flags
-----------------------------------------------------------------------------
function ReturnFlagFromPlayer( player )

		-- Get all carried flags and ...
		local c = Collection()
		c:GetByName(flags, { CF.kInfoScript_Carried, })

		-- ... return the flag that the player is carrying.
		for item in c.items do
			item = CastToInfoScript(item)
			carrier = item:GetCarrier()
			if player:GetId() == carrier:GetId() then
				item:Return()
			end
		end

end

-----------------------------------------------------------------------------
-- resupply a player when a cp is capped
-----------------------------------------------------------------------------
function CapResupply( player, scale, givethegoodshit )

	-- give the player health and armor
	if cap_resupply.health ~= nil and cap_resupply.health ~= 0 then player:AddHealth( cap_resupply.health * scale ) end
	if cap_resupply.armor ~= nil and cap_resupply.armor ~= 0 then player:AddArmor( cap_resupply.armor * scale ) end

	-- give the player ammo
	if cap_resupply.nails ~= nil and cap_resupply.nails ~= 0 then player:AddAmmo( Ammo.kNails, cap_resupply.nails * scale ) end
	if cap_resupply.shells ~= nil and cap_resupply.shells ~= 0 then player:AddAmmo( Ammo.kShells, cap_resupply.shells * scale ) end
	if cap_resupply.rockets ~= nil and cap_resupply.rockets ~= 0 then player:AddAmmo( Ammo.kRockets, cap_resupply.rockets * scale ) end
	if cap_resupply.cells ~= nil and cap_resupply.cells ~= 0 then player:AddAmmo( Ammo.kCells, cap_resupply.cells * scale ) end

	if givethegoodshit then
		-- give the player the good shit
		if cap_resupply.detpacks ~= nil and cap_resupply.detpacks ~= 0 then player:AddAmmo( Ammo.kDetpack, cap_resupply.detpacks * scale ) end
		if cap_resupply.mancannons ~= nil and cap_resupply.mancannons ~= 0 then player:AddAmmo( Ammo.kManCannon, cap_resupply.mancannons * scale ) end
		if cap_resupply.gren1 ~= nil and cap_resupply.gren1 ~= 0 then player:AddAmmo( Ammo.kGren1, cap_resupply.gren1 * scale ) end
		if cap_resupply.gren2 ~= nil and cap_resupply.gren2 ~= 0 then player:AddAmmo( Ammo.kGren2, cap_resupply.gren2 * scale ) end
	end

end

function player_killed ( player_victim, damageinfo )

	-- if no damageinfo do nothing
	if not damageinfo then return end

	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()
  
	-- If no attacker do nothing
	if not attacker then return end
  
	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
	elseif IsSentrygun(attacker) then
		attacker = CastToSentrygun(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDetpack(attacker) then
		attacker = CastToDetpack(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDispenser(attacker) then
		attacker = CastToDispenser(attacker)
		player_attacker = attacker:GetOwner()
	end

	-- if still no attacking player after all that, try the inflictor
	if not player_attacker then

		-- Entity that is attacking
		local inflictor = damageinfo:GetInflictor()

		if inflictor then
			if IsSentrygun(inflictor) then
				inflictor = CastToSentrygun(inflictor)
				player_attacker = inflictor:GetOwner()
			elseif IsDetpack(inflictor) then
				inflictor = CastToDetpack(inflictor)
				player_attacker = inflictor:GetOwner()
			elseif IsDispenser(inflictor) then
				inflictor = CastToDispenser(inflictor)
				player_attacker = inflictor:GetOwner()
			end
		end

	end

	-- if still no attacking player after all that, forget about it
	if not player_attacker then return end

	-- if victim killed self or teammate do nothing
	if (player_victim:GetId() == player_attacker:GetId()) or (player_victim:GetTeamId() == player_attacker:GetTeamId()) then return end

	local player_victim_touching_cp = PLAYER_TOUCHING_CP_ZONE[player_victim:GetId()]
	local player_attacker_touching_cp = PLAYER_TOUCHING_CP_ZONE[player_attacker:GetId()]

	-- the victim is standing in a zone
	if player_victim_touching_cp ~= nil then

		-- the victim is defending a cp or trying to capture a neutral cp
		if player_victim:GetTeamId() == player_victim_touching_cp.defending_team or player_victim_touching_cp.defending_team == Team.kUnassigned then

			--CapResupply( player_attacker, 0.25, false )
			player_attacker:AddFortPoints((player_victim_touching_cp.point_value[player_attacker:GetTeamId()]) * 50, "#FF_FORTPOINTS_CAPTUREPOINT_ASSIST")

		-- the victim is trying to capture the attacker's cp
		else

			--CapResupply( player_attacker, 0.25, false )
			player_attacker:AddFortPoints((player_victim_touching_cp.point_value[player_attacker:GetTeamId()]) * 50, "#FF_FORTPOINTS_DEFENDPOINT")

		end

	end

	-- the attacker is standing in a zone
	if player_attacker_touching_cp ~= nil then

		-- the attacker is defending a cp
		if player_attacker:GetTeamId() == player_attacker_touching_cp.defending_team then

			--CapResupply( player_attacker, 0.25, false )
			player_attacker:AddFortPoints((player_attacker_touching_cp.point_value[player_attacker:GetTeamId()]) * 50, "#FF_FORTPOINTS_DEFENDPOINT")

		-- the attacker is trying to capture a cp
		else

			--CapResupply( player_attacker, 0.25, false )
			player_attacker:AddFortPoints((player_attacker_touching_cp.point_value[player_attacker:GetTeamId()]) * 50, "#FF_FORTPOINTS_CAPTUREPOINT_ASSIST")

		end

	end

	-- loop through all former players of each command point
	for k,v in ipairs(command_points) do

		-- victim's team
		for i in v.former_touching_players[player_victim:GetTeamId()].items do

			i = CastToPlayer( i )

			-- the victim was in an active zone
			if i:GetId() == player_victim:GetId() then

				-- the victim is defending a cp or trying to capture a neutral cp
				if player_victim:GetTeamId() == v.defending_team or v.defending_team == Team.kUnassigned then

					--CapResupply( player_attacker, 0.25, false )
					player_attacker:AddFortPoints((v.point_value[player_attacker:GetTeamId()]) * 25, "#FF_FORTPOINTS_CAPTUREPOINT_ASSIST")

				-- the victim is trying to capture the attacker's cp
				else

					--CapResupply( player_attacker, 0.25, false )
					player_attacker:AddFortPoints((v.point_value[player_attacker:GetTeamId()]) * 25, "#FF_FORTPOINTS_DEFENDPOINT_ASSIST")

				end

			end

		end

		-- attacker's team
		for i in v.former_touching_players[player_attacker:GetTeamId()].items do

			i = CastToPlayer( i )

			-- the attacker was in an active zone
			if i:GetId() == player_attacker:GetId() then

				-- the attacker is defending a cp
				if player_attacker:GetTeamId() == v.defending_team then

					--CapResupply( player_attacker, 0.25, false )
					player_attacker:AddFortPoints((v.point_value[player_attacker:GetTeamId()]) * 25, "#FF_FORTPOINTS_DEFENDPOINT_ASSIST")

				-- the attacker is trying to capture a cp
				else

					--CapResupply( player_attacker, 0.25, false )
					player_attacker:AddFortPoints((v.point_value[player_attacker:GetTeamId()]) * 25, "#FF_FORTPOINTS_CAPTUREPOINT_ASSIST")

				end

			end

		end

	end

end

-----------------------------------------------------------------------------
-- change the cp's defending team, its related visuals, and its scoring
-----------------------------------------------------------------------------
function ChangeCPDefendingTeam( cp_number, new_defending_team )

	local cp = command_points[cp_number]
	
	if cp_number > 1 and cp_number < CP_COUNT then
		if new_defending_team == TEAM1 then
			ResetCPCapping( command_points[cp_number - 1] )
		elseif new_defending_team == TEAM2 then
			ResetCPCapping( command_points[cp_number + 1] )
		end
	end

	event_ChangeCPDefendingTeam( cp_number, new_defending_team )
	
	-- remove old flaginfo icons and add new ones
	RemoveHudItemFromAll( cp_number .. "-background-" .. cp.defending_team )
	RemoveHudItemFromAll( cp_number .. "-foreground-" .. cp.defending_team )

	AddHudIconToAll( icons[ new_defending_team ].teamicon, cp_number .. "-background-" .. new_defending_team, cp.hudposx, cp.hudposy, cp.hudwidth, cp.hudheight, cp.hudalign)
	AddHudIconToAll( cp.hudstatusicon, cp_number .. "-foreground-" .. new_defending_team, cp.hudposx, cp.hudposy, cp.hudwidth, cp.hudheight, cp.hudalign)

	local schedule_name = "cp" .. cp_number .. "_score_timer"

	-- stop an existing timer
	if cp.defending_team ~= Team.kUnassigned then
		RemoveSchedule( schedule_name )
	end

	-- only worry with score timer for TEAM1 and TEAM2
	if new_defending_team ~= Team.kUnassigned then

		-- start the score timer
		AddScheduleRepeating( schedule_name, cp.score_timer_interval[new_defending_team], cp_score_timer, cp_number, new_defending_team )

	end

	cp.defending_team = new_defending_team

end

-----------------------------------------------------------------------------
-- restore all items in a CP
-----------------------------------------------------------------------------
function RestoreCPItems( cp_number, old_defending_team, new_defending_team )

		local c = Collection()
		c:GetByName( { "cp_cp" .. cp_number .. "_ammo", "cz2_cp" .. cp_number .. "_ammo", "cp_cp" .. cp_number .. "_armor", "cz2_cp" .. cp_number .. "_armor" }, { CF.kNone } )
		for item in c.items do
			item = CastToInfoScript(item)

			-- restore this CP's ammo and armor
			item:Restore()

			-- Also set the touchflags so only the defending team can use the packs
			item:SetTouchFlags(team_info[new_defending_team].touchflags)
		end

end

-----------------------------------------------------------------------------
-- reset team cp capping stuff
-----------------------------------------------------------------------------
function ResetTeamCPCapping( cp, team_number, do_total_reset, set_next_cap_zone_timer )

	cp.cap_status[team_number] = 0
	cp.next_cap_zone_timer[team_number] = set_next_cap_zone_timer

	RemoveHudItemFromAll( cp.cp_number .. "-capstatusicon-" .. team_number )
	RemoveHudItemFromAll( cp.cp_number .. "-caplockicon-" .. team_number )
	event_ResetTeamCPCapping( cp, team_number )

	if cp.former_touching_players[team_number]:Count() > 0 then
		cp.former_touching_players[team_number]:RemoveAllItems()
	end

	if do_total_reset then
		if cp.touching_players[team_number]:Count() > 0 then
			cp.touching_players[team_number]:RemoveAllItems()
		end

		cp.cap_speed[team_number] = 0
	end

end

-----------------------------------------------------------------------------
-- reset all cp capping stuff
-----------------------------------------------------------------------------
function ResetCPCapping( cp )

	for i,v in pairs(teams) do
		ResetTeamCPCapping( cp, v, true, 0 )
	end

end

-----------------------------------------------------------------------------
-- reset and lock a capture point for a certain amount of time
-----------------------------------------------------------------------------
function LockCPCapping( cp, lock_time )

	for i,v in pairs(teams) do
		ResetTeamCPCapping( cp, v, true, lock_time )
	end

end

-----------------------------------------------------------------------------
-- reset and lock a capture point for a certain amount of time
-----------------------------------------------------------------------------
function StopCPScoring( cp_number )

	local cp = command_points[cp_number]
	
	if cp.defending_team ~= Team.kUnassigned then
		RemoveSchedule( "cp" .. cp_number .. "_score_timer" )
	end

end

-----------------------------------------------------------------------------
-- the cp has definitely been captured
-----------------------------------------------------------------------------
function CaptureCP( cp_number, new_defending_team )

	local cp = command_points[cp_number]
	local old_defending_team = cp.defending_team

	RestoreCPItems(cp_number, old_defending_team, new_defending_team)		

	-- Give points to team and player
	local team = GetTeam(new_defending_team)
	team:AddScore(cp.point_value[new_defending_team])

	-- Find out if any team has complete control
	local team_with_complete_control = Team.kUnassigned
	local control_count = { [TEAM1] = 0, [TEAM2] = 0 }
	control_count[new_defending_team] = 1
	for i,v in ipairs(command_points) do
		if v.defending_team ~= Team.kUnassigned and v.cp_number ~= cp_number then
			control_count[v.defending_team] = control_count[v.defending_team] + 1
		end
		if control_count[v.defending_team] == CP_COUNT then
			team_with_complete_control = v.defending_team
			break
		end
	end

	-- update objective icons if not all cp's captured
	if team_with_complete_control == Team.kUnassigned then
		if new_defending_team == TEAM1 then
			OBJECTIVE_TEAM1 = "cp"..(cp_number+1).."_zone"
			if old_defending_team ~= Team.kUnassigned then
				OBJECTIVE_TEAM2 = "cp"..(cp_number).."_zone"
			end
		elseif new_defending_team == TEAM2 then
			OBJECTIVE_TEAM2 = "cp"..(cp_number-1).."_zone"
			if old_defending_team ~= Team.kUnassigned then
				OBJECTIVE_TEAM1 = "cp"..(cp_number).."_zone"
			end
		end
		UpdateTeamObjectiveIcon( GetTeam(TEAM1), GetEntityByName( OBJECTIVE_TEAM1 ) )
		UpdateTeamObjectiveIcon( GetTeam(TEAM2), GetEntityByName( OBJECTIVE_TEAM2 ) )
	end

	if team_with_complete_control ~= Team.kUnassigned then

		if ENABLE_COMPLETE_CONTROL_POINTS then
			-- Bonus points for complete control
			team:AddScore(POINTS_FOR_COMPLETE_CONTROL)
		end

		if ENABLE_COMPLETE_CONTROL_RESET then

			AddSchedule("complete_control_notification", 0.1, complete_control_notification, team_with_complete_control)

			if ENABLE_COMPLETE_CONTROL_RESPAWN then
			
				-- change the team of the capped cp
				ChangeCPDefendingTeam(cp_number, new_defending_team)
			
				-- Lock all command points
				-- Stop periodic scoring for all command points
				for i,v in ipairs(command_points) do
					StopCPScoring( i )
					LockCPCapping( v, COMPLETE_CONTROL_RESPAWN_DELAY )
				end
			
				AddSchedule("complete_control", COMPLETE_CONTROL_RESPAWN_DELAY, TeamCompleteControl, team_with_complete_control )
			else
				TeamCompleteControl( team_with_complete_control )
			end

			-- get out now if resetting
			return

		end

	end

	ChangeCPDefendingTeam(cp_number, new_defending_team)

	-- change the colors this team's respawn beams
	--local beam_team = team_info[new_defending_team]
	--beam_team.respawnbeam_color[beam_team.color_index] = beam_team.respawnbeam_color[Team.kUnassigned] + (control_count[new_defending_team] * 35)
	--OutputEvent( beam_team.team_name .. "_respawn_beam", "Color", beam_team.respawnbeam_color[0] .. " " .. beam_team.respawnbeam_color[1] .. " " .. beam_team.respawnbeam_color[2] )

	SmartTeamMessage( team, "#FF_CZ2_YOURTEAM_CP" .. cp_number, "#FF_CZ2_OTHERTEAM_CP" .. cp_number, Color.kGreen, Color.kRed )

	-- sounds will get more and more crazy
	--SmartTeamSound( team, good_cap_sounds[control_count[new_defending_team]], bad_cap_sounds[control_count[new_defending_team]] )

	-- caes: changed it to announce the cp number captured/lost
	SmartTeamSpeak( team, good_cap_sounds[cp_number], bad_cap_sounds[cp_number] )
end

function TeamCompleteControl( control_team )

		-- Reset all command points
		for i,v in ipairs(command_points) do
			ChangeCPDefendingTeam(v.cp_number, Team.kUnassigned)
			ResetCPCapping( v )
		end
		
		ChangeCPDefendingTeam( 1, TEAM1 )
		ChangeCPDefendingTeam( CP_COUNT, TEAM2 )

		-- reset colors of respawn beams
		--OutputEvent( team_info[TEAM1].team_name .. "_respawn_beam", "Color", team_info[Team.kUnassigned].respawnbeam_color[0] .. " " .. team_info[Team.kUnassigned].respawnbeam_color[1] .. " " .. team_info[Team.kUnassigned].respawnbeam_color[2] )
		--OutputEvent( team_info[TEAM2].team_name .. "_respawn_beam", "Color", team_info[Team.kUnassigned].respawnbeam_color[0] .. " " .. team_info[Team.kUnassigned].respawnbeam_color[1] .. " " .. team_info[Team.kUnassigned].respawnbeam_color[2] )

		if ENABLE_FLAGS then
			-- Return all flags
			local c = Collection()
			c:GetByName(flags, { CF.kNone })
			for item in c.items do
				item = CastToInfoScript(item)
				item:Return()
			end
		end

		RemoveAllCPAmmoAndArmor()
		
		if ENABLE_COMPLETE_CONTROL_RESPAWN then
			complete_control_respawn()
		end
		
end


-----------------------------------------------------------------------------
-- a cp's defending team successfully defended or capped
-----------------------------------------------------------------------------
function SuccessfulCPDefense( cp, team_number, is_a_cap )

	-- reward the touching players
	for i in cp.touching_players[team_number].items do
		i = CastToPlayer( i )
		if is_a_cap then
			CapResupply( i, 0.50, is_a_cap )
			i:AddFortPoints((cp.point_value[team_number]) * 100, "#FF_FORTPOINTS_CAPTUREPOINT")
			i:SetCloakable( true )
		else
			--CapResupply( i, 0.50, is_a_cap )
			i:AddFortPoints((cp.point_value[team_number]) * 50, "#FF_FORTPOINTS_DEFENDPOINT")
		end
	end

	-- reward the former touching players
	for i in cp.former_touching_players[team_number].items do
		i = CastToPlayer( i )
		if is_a_cap then
			--CapResupply( i, 0.50, is_a_cap )
			i:AddFortPoints((cp.point_value[team_number]) * 50, "#FF_FORTPOINTS_CAPTUREPOINT_ASSIST")
		else
			--CapResupply( i, 0.25, is_a_cap )
			i:AddFortPoints((cp.point_value[team_number]) * 25, "#FF_FORTPOINTS_DEFENDPOINT_ASSIST")
		end
	end

	-- no need to keep them around for future rewards
	cp.former_touching_players[team_number]:RemoveAllItems()

end


-----------------------------------------------------------------------------
-- timed cp capping
-----------------------------------------------------------------------------
function cap_zone_timer( cp )

	local new_defending_team = Team.kUnassigned
	local other_team = Team.kUnassigned
	local last_cap_status = {}
	local total_cap_speed = 0
	local total_cap_status = 0

	for i,v in pairs(teams) do
		total_cap_speed = total_cap_speed + cp.cap_speed[v]
		total_cap_status = total_cap_status + cp.cap_status[v]
	end

	for i,v in pairs(teams) do

		-- don't bother doing some stuff if nothing has changed
		last_cap_status[v] = cp.cap_status[v]

		-- after one team caps a cp, the other team can't touch that cp for X seconds
		if cp.next_cap_zone_timer[v] > 0 then
			
			cp.next_cap_zone_timer[v] = cp.next_cap_zone_timer[v] - CAP_ZONE_TIMER_INTERVAL
			
			local lock_percent = math.min( 1.0, cp.next_cap_zone_timer[v] / cp.delay_before_retouch[v] )
			local minlockhudwidth = cp.hudwidth * 0.333
			local minlockhudheight = cp.hudheight * 0.333
			
			AddHudIconToAll( icons[v].lockicon, cp.cp_number .. "-caplockicon-" .. v, cp.hudposx, cp.hudposy + cp_zone_icons[v].hudposy_offset, minlockhudwidth + ( (cp.hudwidth - minlockhudwidth) * lock_percent ), minlockhudheight + ( (cp.hudheight - minlockhudheight) * lock_percent ), cp.hudalign)
			
			-- clamp
			if cp.next_cap_zone_timer[v] <= 0 then
				cp.next_cap_zone_timer[v] = 0
				RemoveHudItemFromAll( cp.cp_number .. "-caplockicon-" .. v )
			end

		-- this team is standing in the zone
		elseif cp.cap_speed[v] > 0 then

			-- don't bother with cap_status calculations for the defending team
			if v == cp.defending_team then

				cp.cap_status[v] = cp.cap_requirement[v]

			-- calculate cap status
			else

				-- every vote counts
				local affected_cap_speed = cp.cap_speed[v] - ( total_cap_speed - cp.cap_speed[v] )

				cp.cap_status[v] = cp.cap_status[v] + affected_cap_speed

				-- clamp
				if cp.cap_status[v] < 0 then

					cp.cap_status[v] = 0

				-- potential capping team
				elseif cp.cap_status[v] >= cp.cap_requirement[v] then

					new_defending_team = v

					-- clamp
					cp.cap_status[v] = cp.cap_requirement[v]

				end
			end

		-- this team is not standing in the zone
		else
			if v == cp.defending_team then
				-- don't bother with cap_status calculations for the defending team
				cp.cap_status[v] = 0
			else
				-- decrease cap status
				cp.cap_status[v] = cp.cap_status[v] - ( CAP_ZONE_NOTOUCH_SPEED + total_cap_speed )

				-- clamp
				if cp.cap_status[v] < 0 then
					cp.cap_status[v] = 0
				end
			end
		end

		-- don't bother doing some stuff if nothing has changed
		if cp.cap_status[v] ~= last_cap_status[v] then

			-- draw the cap status icon
			if cp.cap_status[v] > 0 then

				local cap_percent = cp.cap_status[v] / cp.cap_requirement[v]
				local minhudwidth = cp.hudwidth * 0.333
				local minhudheight = cp.hudheight * 0.333
				AddHudIconToAll( cp_zone_icons[v].hudicon, cp.cp_number .. "-capstatusicon-" .. v, cp.hudposx, cp.hudposy + cp_zone_icons[v].hudposy_offset, minhudwidth + ( (cp.hudwidth - minhudwidth) * cap_percent ), minhudheight + ( (cp.hudheight - minhudheight) * cap_percent ), cp.hudalign)
				-- only do this event once, when the team first starts capping
				if last_cap_status[v] <= 0 then
					event_StartTeamCPCapping( cp, v )
				end

			-- remove the cap status icon, remove former touching players, and reward defenders
			else

				-- reward the defenders
				if v ~= cp.defending_team and cp.defending_team ~= Team.kUnassigned then
					SuccessfulCPDefense( cp, cp.defending_team, false )
				end

				-- reset the other team's cp capping stuff
				ResetTeamCPCapping( cp, v, false, 0 )

			end

		end

		if new_defending_team ~= v then
			other_team = v
		end

	end

	-- someone capped this cp
	if new_defending_team ~= Team.kUnassigned then

		-- cap the cp
		SuccessfulCPDefense( cp, new_defending_team, true )
		CaptureCP( cp.cp_number, new_defending_team )

		-- reset the other team's cp capping stuff
		ResetTeamCPCapping( cp, other_team, false, cp.delay_before_retouch[other_team] )

	end

end


-----------------------------------------------------------------------------
-- triggers
-----------------------------------------------------------------------------

cp_base_trigger = trigger_ff_script:new({ team = Team.kUnassigned, failtouch_message = "" })

function cp_base_trigger:allowed( allowed_entity )

	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function cp_base_trigger:onfailtouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer( player, failtouch_message )
	end
end

cp_team1_door_trigger = cp_base_trigger:new({ team = TEAM1 , failtouch_message = "#FF_NOTALLOWEDDOOR" })
cp_team2_door_trigger = cp_base_trigger:new({ team = TEAM2 , failtouch_message = "#FF_NOTALLOWEDDOOR" })


-----------------------------------------------------------------------------
-- packs
-----------------------------------------------------------------------------
cp_base_pack = genericbackpack:new({
	health = 100,
	armor = 300,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	detpacks = 0,
	mancannons = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 1,
	touchflags = team_info[Team.kUnassigned].touchflags,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	cp_number = 0,
	botgoaltype = Bot.kBackPack_Ammo,
})

function cp_base_pack:dropatspawn() return false end

cp_team1_respawn_pack = cp_base_pack:new( { touchflags = team_info[TEAM1].touchflags } )
cp_team2_respawn_pack = cp_base_pack:new( { touchflags = team_info[TEAM2].touchflags } )

cp_cp1_ammo = ammobackpack:new({cp_number = 1})
cp_cp2_ammo = ammobackpack:new({cp_number = 2})
cp_cp3_ammo = ammobackpack:new({cp_number = 3})
cp_cp4_ammo = ammobackpack:new({cp_number = 4})
cp_cp5_ammo = ammobackpack:new({cp_number = 5})

cp_cp1_armor = armorkit:new({cp_number = 1})
cp_cp2_armor = armorkit:new({cp_number = 2})
cp_cp3_armor = armorkit:new({cp_number = 3})
cp_cp4_armor = armorkit:new({cp_number = 4})
cp_cp5_armor = armorkit:new({cp_number = 5})


-----------------------------------------------------------------------------
-- grenade packs
-----------------------------------------------------------------------------
cp_base_grenade_pack = cp_base_pack:new({
	detpacks = 1,
	mancannons = 1,
	gren1 = 4,
	gren2 = 4,
	respawntime = 15,
	touchflags = team_info[Team.kUnassigned].touchflags,
	botgoaltype = Bot.kBackPack_Grenades,
})

cp_team1_grenade_pack = cp_base_grenade_pack:new( { touchflags = team_info[TEAM1].touchflags } )
cp_team2_grenade_pack = cp_base_grenade_pack:new( { touchflags = team_info[TEAM2].touchflags } )


-----------------------------------------------------------------------------
-- cp zones
-----------------------------------------------------------------------------

cp_base_cp_zone = trigger_ff_script:new({
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
	cp_number = 0,
})

function cp_base_cp_zone:ontrigger( trigger_entity )

	-- check whether flags are used, and in turn wheter these triggers are used
	if ENABLE_FLAGS or not ENABLE_CP_TELEPORTERS then return end

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		-- Allow players on defending team to teleport back to base
		if player:GetTeamId() == command_points[self.cp_number].defending_team then

			if player:IsInUse() then
				-- respawn the player
				ApplyToPlayer( player, { AT.kRespawnPlayers, kReloadClips } )

				OutputEvent( "cp" .. self.cp_number .. "_respawn_enter_sound", "PlaySound" )
				AddSchedule("cp" .. self.cp_number .. "_respawn_" .. player:GetId(), 0.1, EmitSound, player, "ff_cz2.teleport_exit")
			else
				BroadCastMessageToPlayer(player, "#FF_CZ2_USE_RESPAWN")
			end

		end

	end

end

function cp_base_cp_zone:ontouch( trigger_entity )

	-- check whether flags are used, and in turn wheter these zones are used
	if ENABLE_FLAGS then return end

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local cp = command_points[self.cp_number]
		PlayerStartTouchingCapZone( player, cp )
	end

end

function cp_base_cp_zone:onendtouch( trigger_entity )

	-- check whether flags are used, and in turn wheter these zones are used
	if ENABLE_FLAGS then return end

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local cp = command_points[self.cp_number]
		PlayerStopTouchingCapZone( player, cp )
	end
end

cp_cp1_cp_zone = cp_base_cp_zone:new({ cp_number = 1 })
cp_cp2_cp_zone = cp_base_cp_zone:new({ cp_number = 2 })
cp_cp3_cp_zone = cp_base_cp_zone:new({ cp_number = 3 })
cp_cp4_cp_zone = cp_base_cp_zone:new({ cp_number = 4 })
cp_cp5_cp_zone = cp_base_cp_zone:new({ cp_number = 5 })


-----------------------------------------------------------------------------
-- cp triggers
-----------------------------------------------------------------------------

cp_base_cp_trigger = trigger_ff_script:new({
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
	cp_number = 0,
})

function cp_base_cp_trigger:ontrigger( trigger_entity )

	-- check whether flags are used, and in turn wheter these triggers are used
	if not ENABLE_FLAGS or not ENABLE_CP_TELEPORTERS then return end

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		-- Allow players on defending team to teleport back to base
		if player:GetTeamId() == command_points[self.cp_number].defending_team then

			if player:IsInUse() then
				-- check if the player has a flag
				for i,v in ipairs(flags) do
					-- return the flag
					if player:HasItem(v) then ReturnFlagFromPlayer(player) end
				end

				-- respawn the player
				ApplyToPlayer( player, { AT.kRespawnPlayers, kReloadClips } )

				OutputEvent( "cp" .. self.cp_number .. "_respawn_enter_sound", "PlaySound" )
				AddSchedule("cp" .. self.cp_number .. "_respawn_" .. player:GetId(), 0.1, EmitSound, player, "ff_cz2.teleport_exit")
			else
				BroadCastMessageToPlayer(player, "#FF_CZ2_USE_RESPAWN")
			end

		end

	end

end

function cp_base_cp_trigger:ontouch( trigger_entity )

	-- check whether flags are used, and in turn wheter these triggers are used
	if not ENABLE_FLAGS then return end

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local cp = command_points[self.cp_number]

		-- No capping if player's team already defends this CP
		if player:GetTeamId() == cp.defending_team then return end

		-- get out if player doesn't have flag
		if not PlayerHasFlag(player) then return end

		ReturnFlagFromPlayer(player)

		CaptureCP(self.cp_number, player:GetTeamId())
		player:AddFortPoints((cp.point_value[player:GetTeamId()]) * 100, "#FF_FORTPOINTS_CAPTUREPOINT")
	end

end

cp_cp1_cp_trigger = cp_base_cp_trigger:new({ cp_number = 1 })
cp_cp2_cp_trigger = cp_base_cp_trigger:new({ cp_number = 2 })
cp_cp3_cp_trigger = cp_base_cp_trigger:new({ cp_number = 3 })
cp_cp4_cp_trigger = cp_base_cp_trigger:new({ cp_number = 4 })
cp_cp5_cp_trigger = cp_base_cp_trigger:new({ cp_number = 5 })


-----------------------------------------------------------------------------
-- flags
-----------------------------------------------------------------------------

cp_base_flag = info_ff_script:new({
	name = "Base Flag",
	team = 0,
	model = "models/flag/flag.mdl",
	tosssound = "Flag.Toss",
	modelskin = 0,
	dropnotouchtime = 2,
	capnotouchtime = 2,
	botgoaltype = Bot.kFlag,
	hudicon = "",
	hudx = 5,
	hudy = 180,
	hudalign = 1,
	touchflags = team_info[Team.kUnassigned].touchflags
})

function cp_base_flag:precache()
	PrecacheSound(self.tosssound)
	info_ff_script.precache(self)
end

function cp_base_flag:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
end

function cp_base_flag:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule(self.name .. "-" .. player_id, duration, self.removenotouch, self, player_id)
end

function cp_base_flag.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

function cp_base_flag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )

	if player:GetTeamId() ~= self.team then return end

	-- pickup if they can
	if self.notouch[player:GetId()] then return end

	-- make sure they don't have any flags already
	for i,v in ipairs(flags) do
		if player:HasItem(v) then return end
	end

	-- if the player is a spy, then force him to lose his disguise
	player:SetDisguisable( false )
	player:SetCloakable( false )

	-- note: this seems a bit backwards (Pickup verb fits Player better)
	local flag = CastToInfoScript(entity)
	flag:Pickup(player)
	player:AddEffect( EF.kSpeedlua1, -1, 0, FLAG_CARRIER_SPEED )
	AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
end

function cp_base_flag:onownerdie( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, 0.0)
end

function cp_base_flag:onownerfeign( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, 0.0)
end
function cp_base_flag:onownercloak( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, 0.0)
end
function cp_base_flag:dropitemcmd( owner_entity )
	-- throw the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, FLAG_THROW_SPEED)
end	

function cp_base_flag:ondrop( owner_entity )
	local flag = CastToInfoScript(entity)
	flag:EmitSound(self.tosssound)
end

function cp_base_flag:onloseitem( owner_entity )
	-- let the player that lost the flag put on a disguise
	local player = CastToPlayer( owner_entity )
	player:SetDisguisable(true)
	player:SetCloakable(true)

	self:addnotouch(player:GetId(), self.capnotouchtime)

	--player:RemoveEffect( EF.kSpeedlua1 )
	-- remove flag icon from hud
	local flag = CastToInfoScript(entity)
	RemoveHudItem( player, flag:GetName() )
end

function cp_base_flag:onreturn( )
end

cp_team1_flag = cp_base_flag:new({
	team = TEAM1,
	modelskin = 0,
	name = team_info[TEAM1].team_name .. " flag",
	hudicon = "hud_flag_" .. team_info[TEAM1].team_name .. ".vtf",
	hudx = 5,
	hudy = 180,
	hudwidth = 48,
	hudheight = 48,
	touchflags = team_info[TEAM1].touchflags
})

cp_team2_flag = cp_base_flag:new({
	team = TEAM2,
	modelskin = 1,
	name = team_info[TEAM2].team_name .. " flag",
	hudicon = "hud_flag_" .. team_info[TEAM2].team_name .. ".vtf",
	hudx = 5,
	hudy = 180,
	hudwidth = 48,
	hudheight = 48,
	touchflags = team_info[TEAM2].touchflags
})


-----------------------------------------------------------------------------
-- flag dispensers
-----------------------------------------------------------------------------
cp_base_flag_dispenser = trigger_ff_script:new({
	name = "Base Flag Dispenser",
	team = Team.kUnassigned,
	dropnotouchtime = 2,
	botgoaltype = Bot.kFlag,
	hudicon = "",
	hudx = 5,
	hudy = 180,
	hudwidth = 48,
	hudheight = 48,
	hudalign = 1,
	flags = {"flag"}
})

function cp_base_flag_dispenser:allowed ( allowed_entity )

	-- check whether flags are used, and in turn wheter these triggers are used
	if not ENABLE_FLAGS then return EVENT_DISALLOWED end

	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then

			-- Player can't have a flag
			local playerhasflag = false

			for i,v in ipairs(self.flags) do
				if player:HasItem(v) then
					playerhasflag = true
					break
				end
			end

			-- get out if player doesn't have flag
			if not playerhasflag then
				return EVENT_ALLOWED
			end
		end
	end
	return EVENT_DISALLOWED
end

function cp_base_flag_dispenser:ontouch( trigger_entity )

	-- check whether flags are used, and in turn wheter these triggers are used
	if not ENABLE_FLAGS then return end

	if IsPlayer( trigger_entity ) then

		local player = CastToPlayer( trigger_entity )

		local c = Collection()
		c:GetByName( self.flags, { CF.kNone } )
		-- give the player an inactive flag
		for item in c.items do
			item = CastToInfoScript(item)
			if item:IsInactive() then
				-- if the player is a spy, then force him to lose his disguise
				player:SetDisguisable( false )
				player:SetCloakable( false )

				-- note: this seems a bit backwards (Pickup verb fits Player better)
				item:Pickup(player)
				player:AddEffect( EF.kSpeedlua1, -1, 0, FLAG_CARRIER_SPEED )
				AddHudIcon( player, self.hudicon, item:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )

				player:EmitSound("Buttons.snd9")

				-- all done
				break
			end
		end
	end
end

cp_team1_flag_dispenser = cp_base_flag_dispenser:new({
	name = team_info[TEAM1].team_name .. " flag dispenser",
	team = TEAM1,
	hudicon = "hud_flag_" .. team_info[TEAM1].team_name .. ".vtf",
	flags = { team_info[TEAM1].team_name .. "_flag" }
})

cp_team2_flag_dispenser = cp_base_flag_dispenser:new({
	name = team_info[TEAM2].team_name .. " flag dispenser",
	team = TEAM2,
	hudicon = "hud_flag_" .. team_info[TEAM2].team_name .. ".vtf",
	flags = { team_info[TEAM2].team_name .. "_flag" }
})


-----------------------------------------------------------------------------
-- command centers
-----------------------------------------------------------------------------

cp_base_command_center = trigger_ff_script:new({ team = Team.kUnassigned, enemy_team = Team.kUnassigned })
function cp_base_command_center:onexplode( explosion_entity )

	-- check whether command centers are enabled
	if not ENABLE_CC then return EVENT_ALLOWED end

	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack(explosion_entity)

		-- don't let assholes destroy their own team's command center
		if detpack:GetTeamId() == self.team then return EVENT_ALLOWED end

		local points = CC_DESTROY_POINTS
		for i,v in ipairs(command_points) do
			if v.defending_team == self.team then
				-- taking CP 1 away from team2 is worth more than taking CP 5 away from them
				points = points + v.point_value[self.team]

				-- Remove all ammo and armor from CPs
				local c = Collection()
				c:GetByName({"cp_cp" .. v.cp_number .. "_ammo", "cz2_cp" .. v.cp_number .. "_ammo", "cp_cp" .. v.cp_number .. "_armor", "cz2_cp" .. v.cp_number .. "_armor"}, { CF.kNone })
				for item in c.items do
					item = CastToInfoScript(item)
					item:Remove()
				end

				-- reset the CP
				ChangeCPDefendingTeam(v.cp_number, Team.kUnassigned)
			end

			-- reset the other team's cp capping stuff
			ResetTeamCPCapping( v, self.team, false, v.delay_before_retouch[self.team] * 2.0 )
		end

		local team = detpack:GetTeam()
		team:AddScore(points)

		local player = detpack:GetOwner()
		player:AddFortPoints(points * 100, "#FF_FORTPOINTS_DESTROY_CC" )

		SmartSound(player, "misc.thunder", "misc.thunder", "misc.thunder")
		SmartMessage(player, "#FF_CZ2_YOU_CC", "#FF_CZ2_YOURTEAM_CC", "#FF_CZ2_OTHERTEAM_CC", Color.kGreen, Color.kGreen, Color.kRed)
		SpeakAll( team_info[self.team].detcc_sentence )

--		EntityStopTouchingCC( detpack, self.team )

	end

	return EVENT_ALLOWED
end

function cp_base_command_center:ontouch( trigger_entity )

	-- check whether command centers are enabled
	if not ENABLE_CC then return end

--	if IsDetpack( trigger_entity ) then
--		local detpack = CastToDetpack( trigger_entity )
--		if detpack:GetTeamId() ~= self.team then
--			EntityStartTouchingCC( detpack, self.team )
--		end
--	end

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		if player:GetTeamId() ~= self.team then
			EntityStartTouchingCC( player, self.team )
		end
	end

end

function cp_base_command_center:onendtouch( trigger_entity )

	-- check whether command centers are enabled
	if not ENABLE_CC then return end

--	if IsDetpack( trigger_entity ) then
--		local detpack = CastToDetpack( trigger_entity )
--		if detpack:GetTeamId() ~= self.team then
--			EntityStopTouchingCC( detpack, self.team )
--		end
--	end

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		if player:GetTeamId() ~= self.team then
			EntityStopTouchingCC( player, self.team )
		end
	end
end

cp_team1_command_center = cp_base_command_center:new({ team = TEAM1, enemy_team = TEAM2 })
cp_team2_command_center = cp_base_command_center:new({ team = TEAM2, enemy_team = TEAM1 })


-------------------------------------------
-- cc computers
-------------------------------------------

cp_base_cc_computer = trigger_ff_script:new({ prefix = "unassigned", enemy_team = Team.kUnassigned })

function cp_base_cc_computer:ontrigger( trigger_entity )

	-- check whether command centers are enabled
	if not ENABLE_CC then return end

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		-- Allow spies to open the enemy doors
		if player:GetTeamId() == self.enemy_team and player:GetClass() == Player.kSpy then

			if player:IsInUse() then
				for i,v in ipairs(doors) do
					-- open each enemy door
					OutputEvent( self.prefix .. v, "Open" )
				end
			else
				-- tell the player they can open the enemy doors
				BroadCastMessageToPlayer(player, "#FF_CZ2_USE_DOORS")
			end

		end
	end
end

cp_team1_cc_computer = cp_base_cc_computer:new({ prefix = team_info[TEAM1].team_name, enemy_team = TEAM2 })
cp_team2_cc_computer = cp_base_cc_computer:new({ prefix = team_info[TEAM2].team_name, enemy_team = TEAM1 })


-------------------------------------------
-- cp flaginfo
-------------------------------------------

function flaginfo( player_entity )

	local player = CastToPlayer( player_entity )

	for i,v in ipairs(command_points) do

		ConsoleToAll( "CP Number: " .. v.cp_number )
		ConsoleToAll( "Team: " .. v.defending_team )
		ConsoleToAll( "Icon: " .. icons[ v.defending_team ].teamicon )
		
		AddHudIcon( player, icons[ v.defending_team ].teamicon , v.cp_number .. "-background-" .. v.defending_team , command_points[v.cp_number].hudposx, command_points[v.cp_number].hudposy, command_points[v.cp_number].hudwidth, command_points[v.cp_number].hudheight, command_points[v.cp_number].hudalign)
		AddHudIcon( player, command_points[v.cp_number].hudstatusicon, v.cp_number .. "-foreground-" .. v.defending_team , command_points[v.cp_number].hudposx, command_points[v.cp_number].hudposy, command_points[v.cp_number].hudwidth, command_points[v.cp_number].hudheight, command_points[v.cp_number].hudalign)

	end

	DrawCCAlarmIcon( TEAM1 )
	DrawCCAlarmIcon( TEAM2 )

end


-------------------------------------------
-- cp teleporters
-------------------------------------------

trigger_teleport = trigger_ff_script:new({})
cp_base_teleporter = trigger_teleport:new({ cp_number = 0, next_teleport_tick = 0 })

function cp_base_teleporter:allowed( allowed_entity ) 

	-- check whether cc-to-cp teleporters are enabled
	if not ENABLE_CC or not ENABLE_CC_TELEPORTERS then return EVENT_DISALLOWED end

	local stime = GetServerTime()

	if self.next_teleport_tick > stime then return end

	if IsPlayer( allowed_entity ) then

		local player = CastToPlayer( allowed_entity )
		-- Allow players on defending team to teleport to cp
		if player:GetTeamId() == command_points[self.cp_number].defending_team then

			if player:IsInUse() then
				-- teleport the player
				local team_name = team_info[player:GetTeamId()].team_name

				if ENTITY_TOUCHING_CC[player:GetId()] ~= nil then
					team_name = team_info[ENTITY_TOUCHING_CC[player:GetId()]].team_name
				end

				OutputEvent( team_name .. "_cp" .. self.cp_number .. "_teleport_enter_sound", "PlaySound" )
				--OutputEvent( team_name .. "_cp" .. self.cp_number .. "_teleport_exit_sound", "PlaySound", "", 0.1 )
				OutputEvent( team_name .. "_cp" .. self.cp_number .. "_teleport_tesla", "DoSpark", "", 0.1 )

				--self.next_teleport_tick = stime + 1.0

				ApplyToPlayer( player, { AT.kStopPrimedGrens, kReloadClips } )

				return EVENT_ALLOWED
			else
				-- tell the player they can teleport
				BroadCastMessageToPlayer(player, "#FF_CZ2_USE_TELEPORT")
			end

		end
	end

	return EVENT_DISALLOWED

end

-- team1 teleporters
cp_team1_teleporter_cp1 = cp_base_teleporter:new({ cp_number = 1 })
cp_team1_teleporter_cp2 = cp_base_teleporter:new({ cp_number = 2 })
cp_team1_teleporter_cp3 = cp_base_teleporter:new({ cp_number = 3 })
cp_team1_teleporter_cp4 = cp_base_teleporter:new({ cp_number = 4 })
cp_team1_teleporter_cp5 = cp_base_teleporter:new({ cp_number = 5 })

-- team2 teleporters
cp_team2_teleporter_cp1 = cp_base_teleporter:new({ cp_number = 1 })
cp_team2_teleporter_cp2 = cp_base_teleporter:new({ cp_number = 2 })
cp_team2_teleporter_cp3 = cp_base_teleporter:new({ cp_number = 3 })
cp_team2_teleporter_cp4 = cp_base_teleporter:new({ cp_number = 4 })
cp_team2_teleporter_cp5 = cp_base_teleporter:new({ cp_number = 5 })


-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

location_cp1 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_ONE", team = NO_TEAM })
location_cp2 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_TWO", team = NO_TEAM })
location_cp3 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_THREE", team = NO_TEAM })
location_cp4 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_FOUR", team = NO_TEAM })
location_cp5 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_FIVE", team = NO_TEAM })

location_cp1_path = location_info:new({ text = "#FF_LOCATION_CP1_PATH", team = TEAM1 })
location_cp2_path = location_info:new({ text = "#FF_LOCATION_CP2_PATH", team = TEAM1 })
location_cp3_path = location_info:new({ text = "#FF_LOCATION_CP3_PATH", team = NO_TEAM })
location_cp4_path = location_info:new({ text = "#FF_LOCATION_CP4_PATH", team = TEAM2 })
location_cp5_path = location_info:new({ text = "#FF_LOCATION_CP5_PATH", team = TEAM2 })

location_catacombs = location_info:new({ text = "#FF_LOCATION_CATACOMBS", team = NO_TEAM })

location_blue_base = location_info:new({ text = "#FF_LOCATION_BASE", team = TEAM1 })
location_blue_cc = location_info:new({ text = "#FF_LOCATION_COMMAND_CENTER", team = TEAM1 })
location_blue_outside_base = location_info:new({ text = "#FF_LOCATION_OUTSIDE_BASE", team = TEAM1 })
location_blue_canal = location_info:new({ text = "#FF_LOCATION_CANAL", team = TEAM1 })
location_blue_catacombs = location_info:new({ text = "#FF_LOCATION_CATACOMBS", team = TEAM1 })

location_red_base = location_info:new({ text = "#FF_LOCATION_BASE", team = TEAM2 })
location_red_cc = location_info:new({ text = "#FF_LOCATION_COMMAND_CENTER", team = TEAM2 })
location_red_outside_base = location_info:new({ text = "#FF_LOCATION_OUTSIDE_BASE", team = TEAM2 })
location_red_canal = location_info:new({ text = "#FF_LOCATION_CANAL", team = TEAM2 })
location_red_catacombs = location_info:new({ text = "#FF_LOCATION_CATACOMBS", team = TEAM2 })


-----------------------------------------------------------------------------
-- backwards compatiblity - use "cp_*" names in your map instead!
-----------------------------------------------------------------------------
base_team_trigger = cp_base_trigger
blue_door_trigger = cp_team1_door_trigger
red_door_trigger = cp_team2_door_trigger

cz2_base_pack = cp_base_pack
cz2_blue_respawn_pack = cp_team1_respawn_pack
cz2_red_respawn_pack = cp_team2_respawn_pack

cz2_cp1_ammo = cp_cp1_ammo
cz2_cp2_ammo = cp_cp2_ammo
cz2_cp3_ammo = cp_cp3_ammo
cz2_cp4_ammo = cp_cp4_ammo
cz2_cp5_ammo = cp_cp5_ammo

cz2_cp1_armor = cp_cp1_armor
cz2_cp2_armor = cp_cp2_armor
cz2_cp3_armor = cp_cp3_armor
cz2_cp4_armor = cp_cp4_armor
cz2_cp5_armor = cp_cp5_armor

cz2_base_grenade_pack = cp_base_grenade_pack
cz2_blue_grenade_pack = cp_team1_grenade_pack
cz2_red_grenade_pack = cp_team2_grenade_pack

base_cp_zone = cp_base_cp_zone
cp1_zone = cp_cp1_cp_zone
cp2_zone = cp_cp2_cp_zone
cp3_zone = cp_cp3_cp_zone
cp4_zone = cp_cp4_cp_zone
cp5_zone = cp_cp5_cp_zone

base_cp_trigger = cp_base_cp_trigger
cp1_trigger = cp_cp1_cp_trigger
cp2_trigger = cp_cp2_cp_trigger
cp3_trigger = cp_cp3_cp_trigger
cp4_trigger = cp_cp4_cp_trigger
cp5_trigger = cp_cp5_cp_trigger

base_cp_flag = cp_base_flag
blue_flag = cp_team1_flag
red_flag = cp_team2_flag

cp_base_flag_dispenser = base_cp_flag_dispenser
blue_flag_dispenser = cp_team1_flag_dispenser
red_flag_dispenser = cp_team2_flag_dispenser

base_command_center = cp_base_command_center
blue_command_center = cp_team1_command_center
red_command_center = cp_team2_command_center

base_cp_cc_computer = cp_base_cc_computer
blue_cc_computer = cp_team1_cc_computer
red_cc_computer = cp_team2_cc_computer

base_cp_teleporter = cp_base_teleporter
blue_teleporter_cp1 = cp_team1_teleporter_cp1
blue_teleporter_cp2 = cp_team1_teleporter_cp2
blue_teleporter_cp3 = cp_team1_teleporter_cp3
blue_teleporter_cp4 = cp_team1_teleporter_cp4
blue_teleporter_cp5 = cp_team1_teleporter_cp5
red_teleporter_cp1 = cp_team2_teleporter_cp1
red_teleporter_cp2 = cp_team2_teleporter_cp2
red_teleporter_cp3 = cp_team2_teleporter_cp3
red_teleporter_cp4 = cp_team2_teleporter_cp4
red_teleporter_cp5 = cp_team2_teleporter_cp5


