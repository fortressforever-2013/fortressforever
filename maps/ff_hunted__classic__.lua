
-- ff_hunted__classic__.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("ff_hunted")

-----------------------------------------------------------------------------
-- Basic hunted-style gameplay. Respawns all players when the VIP is killed
-----------------------------------------------------------------------------
POINTS_PER_HUNTED_DEATH = 25
POINTS_PER_HUNTED_ESCAPE = 50

function startup()
	SetGameDescription("Hunted Classic")

	-- set up team names
	SetTeamName( Team.kBlue, "The Hunted" )
	SetTeamName( Team.kRed, "Bodyguards" )
	SetTeamName( Team.kYellow, "Assassins" )
	SetTeamName( Team.kGreen, "Green Kid Touchers" )

	-- set up team limits
	SetPlayerLimit( Team.kBlue, 1 ) -- There can be only one Highlander!
	SetPlayerLimit( Team.kRed, 0 ) -- Unlimited bodyguards.
	SetPlayerLimit( Team.kYellow, 5 ) -- Only 5 assassins, but can we dynamically change this based on maxplayers and/or the current playercount?
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
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	RemoveSchedule( "hunted_location_timer" )
	AddScheduleRepeating( "hunted_location_timer" , 1.0, hunted_location_timer )

end
