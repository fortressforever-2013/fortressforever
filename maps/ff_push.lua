-- ff_push.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_push");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

local orig_startup = startup

function startup()
	-- set up team names.  Localisation? 
	SetTeamName( Team.kBlue, "Ball Locks" )
	SetTeamName( Team.kRed, "Rocket Expediting" )

	orig_startup()
end

-----------------------------------------------------------------------------
-- triggers for doors
-----------------------------------------------------------------------------
red_respawn_triggerA = respawndoor:new({ team = Team.kRed })
red_respawn_triggerB = respawndoor:new({ team = Team.kRed })

blue_respawn_triggerA = respawndoor:new({ team = Team.kBlue })
blue_respawn_triggerB = respawndoor:new({ team = Team.kBlue })


-----------------------------------------------------------------------------
-- unique push locations
-----------------------------------------------------------------------------
location_blue_corridor = location_info:new({ text = "Corridor", team = Team.kBlue })
location_red_corridor = location_info:new({ text = "Corridor", team = Team.kRed })

location_blue_lasers = location_info:new({ text = "Lasers", team = Team.kBlue })
location_red_lasers = location_info:new({ text = "Lasers", team = Team.kRed })

location_blue_side_warehouse = location_info:new({ text = "Side Warehouse", team = Team.kBlue })
location_red_side_warehouse = location_info:new({ text = "Side Warehouse", team = Team.kRed })

location_blue_loading_bay = location_info:new({ text = "Loading Bay", team = Team.kBlue })
location_red_loading_bay = location_info:new({ text = "Loading Bay", team = Team.kRed })

location_middle_warehouse = location_info:new({ text = "Middle Warehouse", team = Team.kUnassigned })

