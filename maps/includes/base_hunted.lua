
-- base_hunted.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- Basic hunted-style gameplay. Respawns all players when the VIP is killed
-----------------------------------------------------------------------------
POINTS_PER_HUNTED_DEATH = 5
POINTS_PER_HUNTED_DEATH_FOR_ASSASSIN = 5
POINTS_PER_HUNTED_ESCAPE = 10
POINTS_PER_HUNTED_ESCAPE_FOR_HUNTED = 10
POINTS_PER_HUNTED_ESCAPE_FOR_BODYGUARDS = 10
POINTS_PER_HUNTED_ATTACK = 2
HUNTED_ALLIES_TEAM = Team.kRed
HUNTED_ENTITY = nil
LAST_HUNTED_LOCATION = nil
ESCAPE_DOOR_BUTTON_UNLOCKED = true

-- escape_door_top is also defined as a base_escape_door object down below
escape_door = {
	entity_names = { "escape_door_top", "escape_door_bottom" },
	isopen = false,
	openicon = "hud_door_open.vtf",
	closedicon = "hud_door_closed.vtf",
	hudposx = 0,
	hudposy = 32,
	hudwidth = 64,
	hudheight = 32,
	hudalignx = 4,
	hudaligny = 0
}

-- precache sounds
function precache()
	PrecacheSound("ff_hunted.thunder")
	PrecacheSound("ff_hunted.cheer")
	PrecacheSound("ff_hunted.dying_bird")
	PrecacheSound("ff_hunted.dying_bird_full")
	PrecacheSound("ff_hunted.dying_bird_full")
	PrecacheSound("ff_hunted.i_am_the_werewolf")
	PrecacheSound("ff_hunted.i_fight_vampires")
	PrecacheSound("ff_hunted.werewolf_howling")
	PrecacheSound("ff_hunted.werewolf_movies")
	PrecacheSound("ff_hunted.werewolves_howling")

	PrecacheSound("otherteam.flagstolen")
end

function startup()
	SetGameDescription( "Hunted" )

	-- set up team names
	SetTeamName( Team.kBlue, "The Hunted" )
	SetTeamName( Team.kRed, "Bodyguards" )
	SetTeamName( Team.kYellow, "Assassins" )
	SetTeamName( Team.kGreen, "Green Kid Touchers" )

	-- set up team limits
	SetPlayerLimit( Team.kBlue, 1 ) -- There can be only one Highlander!
	SetPlayerLimit( Team.kRed, 0 ) -- Unlimited bodyguards.
	SetPlayerLimit( Team.kYellow, 6 ) -- Only 6 assassins, but can we dynamically change this based on maxplayers and/or the current playercount?
	SetPlayerLimit( Team.kGreen, -1 ) -- Fuck green.

	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

	team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, 1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	RemoveSchedule( "hunted_location_timer" )
	AddScheduleRepeating( "hunted_location_timer" , 1.0, hunted_location_timer )

end

-------------------------------------------
-- hunted flaginfo
-------------------------------------------

function flaginfo( player_entity )

	local player = CastToPlayer( player_entity )

	if escape_door.isopen then
		RemoveHudItem( player, "escape_door_closed" )
		AddHudIcon( player, escape_door.openicon, "escape_door_open", escape_door.hudposx, escape_door.hudposy, escape_door.hudwidth, escape_door.hudheight, escape_door.hudalignx, escape_door.hudaligny )
	else
		RemoveHudItem( player, "escape_door_open" )
		AddHudIcon( player, escape_door.closedicon, "escape_door_closed", escape_door.hudposx, escape_door.hudposy, escape_door.hudwidth, escape_door.hudheight, escape_door.hudalignx, escape_door.hudaligny )
	end

end

function hunted_location_timer()

	if HUNTED_ENTITY ~= nil then

		local player = CastToPlayer( HUNTED_ENTITY )

		if player:GetLocation() ~= LAST_HUNTED_LOCATION then

			LAST_HUNTED_LOCATION = player:GetLocation()
			RemoveHudItem( player, "hunted_location" )
			AddHudTextToTeam( GetTeam(Team.kRed), "hunted_location", "Hunted Location: " .. player:GetLocation(), 4, 44, 0, 1 )
			RemoveHudItemFromTeam( GetTeam(Team.kYellow), "hunted_location" )

		end

	elseif LAST_HUNTED_LOCATION ~= nil then

		LAST_HUNTED_LOCATION = nil
		RemoveHudItemFromAll( "hunted_location" )

	end

end


function respawn_everyone()
	ApplyToAll({ AT.kAllowRespawn, AT.kRespawnPlayers, AT.kRemoveProjectiles, AT.kStopPrimedGrens })

	AddSchedule( "close_escape_doors", 4.0, close_escape_doors )
end

function close_escape_doors()
	for i,v in ipairs(escape_door.entity_names) do
		-- close each enemy escape door
		OutputEvent( v, "Close" )
	end
end

function lock_escape_door_button()
	ESCAPE_DOOR_BUTTON_UNLOCKED = false
end

function unlock_escape_door_button()
	ESCAPE_DOOR_BUTTON_UNLOCKED = true
end

function hunted_escape_notification()
	BroadCastMessage( "The Hunted escaped!" )
	BroadCastSound ( "ff_hunted.cheer" )
end

function player_ondamage( player, damageinfo )

	-- if no damageinfo do nothing
	if not damageinfo then return end

	local attacker = damageinfo:GetAttacker()
	local inflictor = damageinfo:GetInflictor()

	-- hunted has body armor on and only takes damage from certain things
	if player:GetTeamId() == Team.kBlue then

		local weapon = damageinfo:GetInflictor():GetClassName()
		local attacker_is_buildable = false

		if IsSentrygun(attacker) or IsDispenser(attacker) or IsSentrygun(inflictor) or IsDispenser(inflictor) then

			attacker_is_buildable = true

		end

		if attacker_is_buildable ~= true and weapon ~= "ff_weapon_sniperrifle" and weapon ~= "ff_weapon_crowbar" and weapon ~= "ff_projectile_dart" and weapon ~= "ff_weapon_knife" then

			damageinfo:ScaleDamage(0)

		else

			-- BroadCastSound ( "ff_hunted.dying_bird" )

		end

	-- hunted also has quad damage
	else

		if IsPlayer( attacker ) then

			attacker = CastToPlayer( attacker )

			if attacker:GetTeamId() == Team.kBlue and player:GetTeamId() ~= HUNTED_ALLIES_TEAM then

				damageinfo:ScaleDamage(4)
				attacker:AddFortPoints( POINTS_PER_HUNTED_ATTACK * 10, "Hunted Attack" )
				ConsoleToAll( "The Hunted, " .. attacker:GetName() .. ", dealt quad damage to" .. player:GetName() .. "!" )

			end

		end

	end

end

function player_onkill( player )
	-- Don't let blue hunted suicide.
	if player:GetTeamId() == Team.kBlue then
		return false
	end
	return true
end

-- We only care when The Hunted is killed by another player
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

	if player_victim:GetTeamId() == Team.kBlue then
		ConsoleToAll( "The Hunted, " .. player_victim:GetName() .. ", was assassinated!" )
		BroadCastMessage( "The Hunted was assassinated!" )
		-- BroadCastSound ( "ff_hunted.werewolves_howling" )
		BroadCastSound ( "ff_hunted.thunder" )
		local team = GetTeam( Team.kYellow )
		team:AddScore( POINTS_PER_HUNTED_DEATH )
		ApplyToAll( { AT.kDisallowRespawn } )
		AddSchedule("respawn_everyone", 2, respawn_everyone)
	end
end

function player_disconnected( player )
	if player:GetTeamId() == Team.kBlue then
		HUNTED_ENTITY = nil
		UpdateObjectiveIcon( player, HUNTED_ENTITY )
		UpdateTeamObjectiveIcon( GetTeam(Team.kRed), HUNTED_ENTITY )
		RemoveHudItemFromAll("hunted_location")
	end
end


BLOCKTEAMCHANGE = {}

function player_switchteam( player, currentteam, desiredteam )
	local i = player:GetId()
	local stime = GetServerTime()
	
	if desiredteam == Team.kBlue then
		local delaytime = BLOCKTEAMCHANGE[i]
		if delaytime ~= nil and delaytime > stime then
			return false
		end
		
		BLOCKTEAMCHANGE[i] = stime + 10;
	end

	if player:GetTeamId() == Team.kBlue then
		HUNTED_ENTITY = nil
		UpdateObjectiveIcon( player, HUNTED_ENTITY )
		UpdateTeamObjectiveIcon( GetTeam(Team.kRed), HUNTED_ENTITY )
		RemoveHudItemFromAll("hunted_location")
	end

	return true
end

-- Give everyone a full resupply, but strip grenades from assassins
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 100 )
	player:AddAmmo( Ammo.kNails, 300 )
	player:AddAmmo( Ammo.kShells, 300 )
	player:AddAmmo( Ammo.kRockets, 300 )
	player:AddAmmo( Ammo.kCells, 300 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kManCannon, 1 )

	if player:GetTeamId() ~= Team.kYellow then
		player:AddAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kGren2, 4 )
	end

	-- AddHudText( player, "escape_door_text", "ESCAPE DOOR:", 0, 32, 4 )

	if player:GetTeamId() == Team.kRed then
		UpdateObjectiveIcon( player, HUNTED_ENTITY )
		if HUNTED_ENTITY ~= nil then
			local player_hunted = CastToPlayer( HUNTED_ENTITY )
			AddHudText( player, "hunted_location", "Hunted Location: " .. player_hunted:GetLocation(), 4, 44, 0, 1 )
		end
	elseif player:GetTeamId() == Team.kYellow then
		UpdateObjectiveIcon( player, nil )
	else
		HUNTED_ENTITY = player
		UpdateObjectiveIcon( player, GetEntityByName("hunted_escape") )
		UpdateTeamObjectiveIcon( GetTeam(Team.kRed), HUNTED_ENTITY )
	end

--	if player:GetTeamId() == Team.kRed then
--		BroadCastSoundToPlayer(player, "ff_hunted.i_fight_vampires")
--	elseif player:GetTeamId() == Team.kYellow then
--		BroadCastSoundToPlayer(player, "ff_hunted.werewolf_howling")
--	else
--		BroadCastSoundToPlayer(player, "ff_hunted.i_am_the_werewolf")
--	end
end


-- escape portal entrance
hunted_escape = trigger_ff_script:new({
	botgoaltype = Bot.kHuntedEscape,
	team = Team.kBlue
})

-- escape touch
function hunted_escape:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			player:AddFrags( POINTS_PER_HUNTED_ESCAPE_FOR_HUNTED )
			player:AddFortPoints( POINTS_PER_HUNTED_ESCAPE_FOR_HUNTED * 10, "Hunted Escape" )

			ConsoleToAll( "The Hunted, " .. player:GetName() .. ", escaped!" )

			local team = GetTeam( Team.kBlue )
			team:AddScore( POINTS_PER_HUNTED_ESCAPE )
			team = GetTeam( Team.kRed )
			team:AddScore( POINTS_PER_HUNTED_ESCAPE )

			ApplyToAll({ AT.kAllowRespawn, AT.kRespawnPlayers, AT.kRemoveProjectiles, AT.kStopPrimedGrens })
			AddSchedule( "hunted_escape_notification", 0.1, hunted_escape_notification )
			AddSchedule( "close_escape_doors", 4.0, close_escape_doors )

		end
	end

end


base_escape_door = trigger_ff_script:new({})

function base_escape_door:onopen()

	BroadCastMessage("Escape Door Open!")
	BroadCastSound("otherteam.flagstolen")

	escape_door.isopen = true

	RemoveHudItemFromAll( "escape_door_closed" )
	AddHudIconToAll( escape_door.openicon, "escape_door_open", escape_door.hudposx, escape_door.hudposy, escape_door.hudwidth, escape_door.hudheight, escape_door.hudalignx, escape_door.hudaligny )

end

function base_escape_door:onfullyclosed()

	BroadCastMessage("Escape Door Closed!")
	-- BroadCastSound("otherteam.flagstolen")

	escape_door.isopen = false

	RemoveHudItemFromAll( "escape_door_open" )
	AddHudIconToAll( escape_door.closedicon, "escape_door_closed", escape_door.hudposx, escape_door.hudposy, escape_door.hudwidth, escape_door.hudheight, escape_door.hudalignx, escape_door.hudaligny )

end

escape_door_top = base_escape_door


base_escape_door_button = func_button:new({}) 

function base_escape_door_button:allowed( allowed_entity ) 
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if ESCAPE_DOOR_BUTTON_UNLOCKED then
			lock_escape_door_button()
			AddSchedule( "unlock_escape_door_button", 6.66, unlock_escape_door_button )
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- TODO this doesn't work
function base_escape_door_button:onfailuse( use_entity )
	if IsPlayer( use_entity ) then
		local player = CastToPlayer( use_entity )
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDBUTTON" )
	end
end

escape_door_button_left = base_escape_door_button
escape_door_button_right = base_escape_door_button
escape_door_button_inside = base_escape_door_button

