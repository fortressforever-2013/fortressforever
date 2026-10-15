-- ff_cz2.lua


-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_cp_default")
IncludeScript("base_cp")


-----------------------------------------------------------------------------
-- overrides
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

location_cp1 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_ONE", team = NO_TEAM })
location_cp2 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_TWO", team = NO_TEAM })
location_cp3 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_THREE", team = NO_TEAM })
location_cp4 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_FOUR", team = NO_TEAM })
location_cp5 = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_FIVE", team = NO_TEAM })

location_cp1_path = location_info:new({ text = "#FF_LOCATION_CP1_PATH", team = Team.kBlue })
location_cp5_path = location_info:new({ text = "#FF_LOCATION_CP5_PATH", team = Team.kRed })

location_catacombs = location_info:new({ text = "#FF_LOCATION_CATACOMBS", team = NO_TEAM })

location_blue_base = location_info:new({ text = "#FF_LOCATION_BASE", team = Team.kBlue })
location_blue_cc = location_info:new({ text = "#FF_LOCATION_COMMAND_CENTER", team = Team.kBlue })
location_blue_outside_base = location_info:new({ text = "#FF_LOCATION_OUTSIDE_BASE", team = Team.kBlue })
location_blue_canal = location_info:new({ text = "#FF_LOCATION_CANAL", team = Team.kBlue })
location_blue_catacombs = location_info:new({ text = "#FF_LOCATION_CATACOMBS", team = Team.kBlue })

location_red_base = location_info:new({ text = "#FF_LOCATION_BASE", team = Team.kRed })
location_red_cc = location_info:new({ text = "#FF_LOCATION_COMMAND_CENTER", team = Team.kRed })
location_red_outside_base = location_info:new({ text = "#FF_LOCATION_OUTSIDE_BASE", team = Team.kRed })
location_red_canal = location_info:new({ text = "#FF_LOCATION_CANAL", team = Team.kRed })
location_red_catacombs = location_info:new({ text = "#FF_LOCATION_CATACOMBS", team = Team.kRed })

