
-- attrition.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_respawnturret");
IncludeScript("base_teamplay");

function startup()
	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, -1 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, -1 )
end

function precache()
	--PrecacheSound( "Backpack.Touch" )

	-- Start our scoring scheduling ticking away
	AddScheduleRepeating( "DoScoring", 1, DoScoring, 0 )
end

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
end

-- We use time to count up. Once we get to 20 we give a team a point.
-- Team is for the team controlling the center atm
CONTROL_TIME = 0
CONTROL_TEAM = Team.kUnassigned
CONTROL_TIME_MAX = 3

-- Collection of who is touching the "center"
local c = Collection()



-- This is the goal name for the trigger_ff_script in the
-- middle of the map that you are trying to hold
center = trigger_ff_script:new({})

function center:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )

		-- Get the actual trigger_ff_script
		local trigger = CastToTriggerScript( entity )
		
		-- Add this player to the collection
		c:AddItem( player )

		-- Reset time if everyone's not on the same team
		if AllTheSame( player:GetTeamId() ) then
			ConsoleToAll( "All dudes the same" )
			CONTROL_TEAM = player:GetTeamId()
		else
			ConsoleToAll( "Resetting time!" )
			CONTROL_TIME = 0
			CONTROL_TEAM = Team.kUnassigned
		end
	end
end

function center:onendtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )

		-- See if all of the same team is in the middle
		if AllTheSame( player:GetTeamId() ) then
			CONTROL_TEAM = player:GetTeamId()
		else
			CONTROL_TEAM = Team.kUnassigned
			CONTROL_TIME = 0
		end

		-- Remove player from collection
		c:RemoveItem( player )		

		-- Now that the player is removed, re-check
		-- everything. This might have been a case of
		-- the guy who just left making AllTheSame false.
		if c:Count() > 0 then
			local temp = CastToPlayer( c:Element( 0 ) )
			if AllTheSame( temp:GetTeamId() ) then
				CONTROL_TEAM = temp:GetTeamId()
			else
				CONTROL_TEAM = Team.kUnassigned
				CONTROL_TIME = 0
			end
		else
			CONTROL_TEAM = Team.kUnassigned
			CONTROL_TIME = 0
		end
	end
end

-- This is fired when everyone has stopped touching "center"
-- and it goes to its inactive state
function center:oninactive()
	-- Clear out the items in the collection
	c:RemoveAllItems()

	-- Reset some stuff
	CONTROL_TEAM = Team.kUnassigned
	CONTROL_TIME = 0
end


-- Utility function - checks to see if everyone
-- in the collection is on the same team
function AllTheSame( team )
	for temp in c.items do
		local player = CastToPlayer( temp )
		
		if player:GetTeamId() ~= team then
			return false
		end
	end

	return true
end




-- Scoring function - runs every second to count up the
-- time (if appropriate). Once time reaches 20 we give
-- the team holding the center 20 points
function DoScoring( hi )
	-- ConsoleToAll( "Do Scoring: " .. CONTROL_TIME .. " Team: " .. CONTROL_TEAM )

	if c:Count() == 0 then
		CONTROL_TEAM = Team.kUnassigned
		CONTROL_TIME = 0
		return
	end

	if CONTROL_TEAM == Team.kUnassigned then
		CONTROL_TEAM = Team.kUnassigned
		CONTROL_TIME = 0
		return
	end

	if AllTheSame( CONTROL_TEAM ) then
		CONTROL_TIME = CONTROL_TIME + 1
	else
		CONTROL_TIME = 0
		CONTROL_TEAM = Team.kUnassigned
	end

	if CONTROL_TIME == CONTROL_TIME_MAX then
		local team = GetTeam( CONTROL_TEAM )
		team:AddScore( 20 )
		CONTROL_TEAM = Team.kUnassigned
		CONTROL_TIME = 0

		-- If guys are still standing in there, capture their team
		-- since we just reset everything
		if c:Count() > 0 then
			local temp = CastToPlayer( c:Element( 0 ) )
			if AllTheSame( temp:GetTeamId() ) then
				CONTROL_TEAM = temp:GetTeamId()
			end
		end
	end
end
