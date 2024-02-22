
-- base_turret handles some stuff for Respawn Turrets

-- Custom target selection should be handled in your map's .lua
-- file and not this one (so please do not mess with this file)!

----------------------------------------------------------------------------
-- Team assigned Respawn Turrets target players, dispensers, and sentryguns
-- that are not on the Respawn Turrets team as well as players, dispensers,
-- and sentryguns that are not on a team that is allied to the Respawn
-- Turrets team
----------------------------------------------------------------------------
base_respawnturret = baseclass:new({ team = Team.kUnassigned })

-- Note: GetObjectsTeam only works on players, dispensers, and sentryguns so
-- don't use it where an object could be anything except those 3 items

-- Note: IsTeam1AlliedToTeam2 will return true if team1 is allied to team2 or
-- if team1 is the same as team2

function base_respawnturret:validtarget( target_entity ) 
	if self.team == target_entity:GetTeamId() and GetTeam(self.team):IsFFA() then
		return false
	end
	return not AreTeamsAllied(self.team, target_entity:GetTeamId())
end

-- Turrets, by default, have a 2 second delay after they
-- spot a target and before they're deployed (opened)
function base_respawnturret:deploydelay( target_entity ) return 2.0 end

----------------------------------------------------------------------------
-- Generic Respawn Turret assigned to no team.
----------------------------------------------------------------------------
respawnturret = base_respawnturret:new({ team = Team.kUnassigned })

----------------------------------------------------------------------------
-- Team assigned Respawn Turrets
----------------------------------------------------------------------------
respawnturret_blue = base_respawnturret:new({ team = Team.kBlue })
respawnturret_red = base_respawnturret:new({ team = Team.kRed })
respawnturret_yellow = base_respawnturret:new({ team = Team.kYellow })
respawnturret_green = base_respawnturret:new({ team = Team.kGreen })
