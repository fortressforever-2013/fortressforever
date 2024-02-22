
-- ff_dm.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
-- IncludeScript("base_soldierarena");
IncludeScript("base_teamplay");

function startup()
	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( Team.kBlue, "Blue Orcas" )
	SetTeamName( Team.kRed, "Red Gazelles" )
end

function precache()
	PrecacheSound( "Backpack.Touch" )
end

--function player_onconc( player_entity, concer_entity )
--	-- player_entity is always a player
--	local player = CastToPlayer( player_entity )
--	local concer = CastToPlayer( concer_entity )
--
--	ConsoleToAll( "Running player_onconc! Player: " .. player:GetName() .. " Concer: " .. concer:GetName() )
--	ConsoleToAll( "conc_duration = " .. conc_duration .. " conc_iconduration = " .. conc_iconduration )
--
--	if player:GetTeamId() == Team.kRed then
--		return EVENT_DISALLOWED
--	end
--
--	conc_duration = -1
--	conc_iconduration = -1
--
--	ConsoleToAll( "conc_duration = " .. conc_duration .. " conc_iconduration = " .. conc_iconduration )
--
--	return EVENT_ALLOWED
--end

--function player_ontranq( player_entity, tranqer_entity )
--	local player = CastToPlayer( player_entity )
--	local tranqer = CastToPlayer( tranqer_entity )
--
--	ConsoleToAll( "Running player_ontranq! Player: " .. player:GetName() .. " Tranqer: " .. tranqer:GetName() )
--	ConsoleToAll( "tranq_duration = " .. tranq_duration .. " tranq_iconduration = " .. tranq_iconduration .. " tranq_speed = " .. tranq_speed )
--
--	if player:GetTeamId() == Team.kRed then
--		return EVENT_DISALLOWED
--	end
--
--	tranq_duration = -1
--	tranq_iconduration = -1
--	tranq_speed = 0.2
--
--	return EVENT_ALLOWED
--end

-- Everyone to spawns with everything
function player_spawn( player_entity )
	-- 400 for overkill. of course the values
	-- get clamped in game code
	--local player = GetPlayer(player_id)
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kManCannon, 1 )
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren2, 4 )
end

function player_onkill( player )
	-- Test, Don't let blue team suicide.
--  	if player:GetTeamId() == Team.kBlue then
--  		return false
--  	end
	return true
end

-- Get team points for killing a player
function player_killed( player_entity, damageinfo )
	-- suicides have no damageinfo
	if damageinfo ~= nil then
		local killer = damageinfo:GetAttacker()
		
		local player = CastToPlayer( player_entity )
		if IsPlayer(killer) then
			killer = CastToPlayer(killer)
			--local victim = GetPlayer(player_id)
			
			if not (player:GetTeamId() == killer:GetTeamId()) then
				local killersTeam = killer:GetTeam()	
				killersTeam:AddScore(1)
			end
		end	
	end
end

-- Just here because
function player_ondamage( player_entity, damageinfo )
end

-- Infinite bag
infini_bag = trigger_ff_script:new({ touchsound = "Backpack.Touch" })

-- Infinite bag :: ontouch
function infini_bag:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		-- 400 for overkill. of course the values
		-- get clamped in game code
		player:AddHealth( 400 )
		player:AddArmor( 400 )

		player:AddAmmo( Ammo.kNails, 400 )
		player:AddAmmo( Ammo.kShells, 400 )
		player:AddAmmo( Ammo.kRockets, 400 )
		player:AddAmmo( Ammo.kCells, 400 )
		player:AddAmmo( Ammo.kDetpack, 1 )
		player:AddAmmo( Ammo.kManCannon, 1 )
		player:AddAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kGren2, 4 )

		-- Play the touch sound
		player:EmitSound( self.touchsound )
	end
end

function infini_bag:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return true
		end
	end

	return false
end

-- Red infinite bag
red_infini_bag = infini_bag:new({ team = Team.kRed })

-- Blue infinite bag
blue_infini_bag = infini_bag:new({ team = Team.kBlue })

-- Spawn doors
spawn_door_trigger = trigger_ff_script:new({ team = Team.kUnassigned, doorname = "" })

function spawn_door_trigger:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			if self.doorname then
				OpenDoor( self.doorname )
			end
		end
	end
end

red_spawn_door1_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door1" })
red_spawn_door2_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door2" })
blue_spawn_door1_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door1" })
blue_spawn_door2_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door2" })
