
-- ff_hunted.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_hunted")

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------

escape_door_top = base_escape_door

yellow_door = yellowrespawndoor
yellow_door_Sewers_1 = yellowrespawndoor
yellow_door_BuildingOneNook_2 = yellowrespawndoor
yellow_door_BuildingOneBreakRoom = yellowrespawndoor
yellow_door_Sewers_2 = yellowrespawndoor
yellow_door_BuildingOneNook_1 = yellowrespawndoor
yellow_door_Warehouse_1 = yellowrespawndoor
yellow_door_RuinsAttic = yellowrespawndoor
yellow_door_ShaftRoom = yellowrespawndoor
yellow_door_RuinsBathroom_1 = yellowrespawndoor
yellow_door_RuinsBathroom_2 = yellowrespawndoor
yellow_door_OrgyTower = yellowrespawndoor
yellow_door_MainRoadBuilding_1 = yellowrespawndoor

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

location_green_hallway = location_info:new({ text = "Green Hallway", team = Team.kGreen })
location_main_tunnel_elevator = location_info:new({ text = "Main Tunnel Elevator", team = Team.kBlue })
location_main_tunnel_section1 = location_info:new({ text = "Main Tunnel Section 1", team = Team.kRed })
location_main_tunnel_section2 = location_info:new({ text = "Main Tunnel Section 2", team = Team.kRed })
location_main_tunnel_section3 = location_info:new({ text = "Main Tunnel Section 3", team = Team.kRed })
location_main_tunnel_sewer_ladder = location_info:new({ text = "Main Tunnel Sewer Ladder", team = Team.kRed })
location_main_tunnel_t = location_info:new({ text = "Main Tunnel T", team = Team.kRed })
location_main_tunnel_turn1 = location_info:new({ text = "Main Tunnel Turn 1", team = Team.kRed })
location_main_tunnel_turn2 = location_info:new({ text = "Main Tunnel Turn 2", team = Team.kRed })

location_beside_robotery = location_info:new({ text = "Beside Robotery", team = NO_TEAM })
location_behind_robotery = location_info:new({ text = "Behind Robotery", team = NO_TEAM })
location_main_ramp = location_info:new({ text = "Main Ramp", team = NO_TEAM })
location_main_ramp_opening = location_info:new({ text = "Main Ramp Opening", team = NO_TEAM })
location_main_ramp_overhang = location_info:new({ text = "Main Ramp Overhang", team = NO_TEAM })
location_main_road = location_info:new({ text = "Main Road", team = NO_TEAM })
location_main_road_hill = location_info:new({ text = "Main Road Hill", team = NO_TEAM })
location_main_road_lookout = location_info:new({ text = "Main Road Lookout", team = NO_TEAM })
location_main_road_stairs = location_info:new({ text = "Main Road Stairs", team = NO_TEAM })
location_mountain_tunnel = location_info:new({ text = "Mountain Tunnel", team = NO_TEAM })
location_robotery = location_info:new({ text = "Robotery", team = NO_TEAM })
location_robotery_crevice = location_info:new({ text = "Robotery Crevice", team = NO_TEAM })
location_robotery_front_roof = location_info:new({ text = "Robotery Front Roof", team = NO_TEAM })
location_robotery_loading_bay = location_info:new({ text = "Robotery Loading Bay", team = NO_TEAM })
location_robotery_side_doors = location_info:new({ text = "Robotery Side Doors", team = NO_TEAM })

location_lower_vent_room = location_info:new({ text = "Lower Vent Room", team = NO_TEAM })
location_upper_vent_room = location_info:new({ text = "Upper Vent Room", team = NO_TEAM })
location_vent = location_info:new({ text = "Vent", team = NO_TEAM })
location_vent_stairwell_room = location_info:new({ text = "Vent-Stairwell Room", team = NO_TEAM })

location_break_room = location_info:new({ text = "Break Room", team = Team.kYellow })
location_break_room_nook = location_info:new({ text = "Break Room Nook", team = Team.kYellow })
location_building_1_alley_lookout = location_info:new({ text = "Building 1 Alley Lookout", team = Team.kYellow })
location_building_1_entrance = location_info:new({ text = "Building 1 Entrance", team = NO_TEAM })
location_building_1_exit = location_info:new({ text = "Building 1 Exit", team = NO_TEAM })
location_building_1_lockers = location_info:new({ text = "Building 1 Lockers", team = NO_TEAM })
location_building_1_lockers_nook = location_info:new({ text = "Building 1 Lockers Nook", team = NO_TEAM })
location_building_1_lookout = location_info:new({ text = "Building 1 Lookout", team = Team.kYellow })
location_building_1_lookout_room = location_info:new({ text = "Building 1 Lookout Room", team = Team.kYellow })
location_building_1_lookout_room_exit = location_info:new({ text = "Building 1 Lookout Room Exit", team = Team.kYellow })
location_building_1_rooftop = location_info:new({ text = "Building 1 Rooftop", team = NO_TEAM })
location_utility_room = location_info:new({ text = "Utility Room", team = Team.kYellow })
location_utility_room_boxes = location_info:new({ text = "Utility Room Boxes", team = NO_TEAM })
location_utility_room_lower_stairs = location_info:new({ text = "Utility Room Lower Stairs", team = Team.kYellow })
location_utility_room_other_boxes = location_info:new({ text = "Utility Room Other Boxes", team = NO_TEAM })
location_utility_room_upper_nook = location_info:new({ text = "Utility Room Upper Nook", team = NO_TEAM })
location_utility_room_upper_stairs = location_info:new({ text = "Utility Room Upper Stairs", team = Team.kYellow })

location_sewers_alley = location_info:new({ text = "Sewer Alley Ladder", team = NO_TEAM })
location_sewers_dead_end = location_info:new({ text = "Sewer Dead End", team = NO_TEAM })
location_sewers_main_road = location_info:new({ text = "Sewer Main Road Ladder", team = NO_TEAM })
location_sewers_main_tunnel = location_info:new({ text = "Sewer Main Tunnel Ladder", team = NO_TEAM })
location_sewers_mountain_tunnel = location_info:new({ text = "Sewer Mountain Tunnel Ladder", team = NO_TEAM })
location_sewers_section1 = location_info:new({ text = "Sewer Section 1", team = NO_TEAM })
location_sewers_section2 = location_info:new({ text = "Sewer Section 2", team = NO_TEAM })
location_sewers_section3 = location_info:new({ text = "Sewer Section 3", team = NO_TEAM })
location_sewers_section4 = location_info:new({ text = "Sewer Section 4", team = NO_TEAM })
location_sewers_turn1 = location_info:new({ text = "Sewer Turn 1", team = NO_TEAM })
location_sewers_turn2 = location_info:new({ text = "Sewer Turn 2", team = NO_TEAM })
location_sewers_turn3 = location_info:new({ text = "Sewer Turn 3", team = NO_TEAM })
location_sewers_turn4 = location_info:new({ text = "Sewer Turn 4", team = NO_TEAM })
location_sewers_turn5 = location_info:new({ text = "Sewer Turn 5", team = NO_TEAM })

location_alley = location_info:new({ text = "Alley", team = NO_TEAM })
location_alley_entrance = location_info:new({ text = "Alley Entrance", team = NO_TEAM })
location_alley_lookouts = location_info:new({ text = "Alley Lookouts", team = Team.kYellow })

location_above_t_hallway = location_info:new({ text = "Above T Hallway", team = NO_TEAM })
location_t_hallway = location_info:new({ text = "T Hallway", team = NO_TEAM })
location_t_hallway_exit = location_info:new({ text = "T Hallway Exit", team = NO_TEAM })

location_stairwell_building_floor2 = location_info:new({ text = "Stairwell Building Floor 2", team = NO_TEAM })
location_stairwell_building_floor3 = location_info:new({ text = "Stairwell Building Floor 3", team = NO_TEAM })
location_stairwell_building_floor4 = location_info:new({ text = "Stairwell Building Floor 4", team = Team.kYellow })
location_stairwell_floor1 = location_info:new({ text = "Stairwell Floor 1", team = NO_TEAM })
location_stairwell_floor2 = location_info:new({ text = "Stairwell Floor 2", team = NO_TEAM })
location_stairwell_floor3 = location_info:new({ text = "Stairwell Floor 3", team = Team.kYellow })
location_stairwell_floor4 = location_info:new({ text = "Stairwell Floor 4", team = Team.kYellow })

location_ruins = location_info:new({ text = "Ruins", team = Team.kYellow })
location_ruins_attic = location_info:new({ text = "Ruins Attic", team = Team.kYellow })
location_ruins_attic_door = location_info:new({ text = "Ruins Attic Door", team = Team.kYellow })
location_ruins_bathroom = location_info:new({ text = "Ruins Bathroom", team = Team.kYellow })
location_ruins_crate_room = location_info:new({ text = "Ruins Crate Room", team = NO_TEAM })
location_ruins_crate_room_exit = location_info:new({ text = "Ruins Crate Room Exit", team = NO_TEAM })
location_ruins_dark_side = location_info:new({ text = "Ruins Dark Side", team = NO_TEAM })
location_ruins_exit = location_info:new({ text = "Ruins Exit", team = NO_TEAM })
location_ruins_field_holes = location_info:new({ text = "Ruins Field Holes", team = Team.kYellow })
location_ruins_lower_ladder_room = location_info:new({ text = "Ruins Lower Ladder Room", team = Team.kYellow })
location_ruins_middle_floor = location_info:new({ text = "Ruins Middle Floor", team = Team.kYellow })
location_ruins_storage = location_info:new({ text = "Ruins Storage", team = NO_TEAM })
location_ruins_tower_base = location_info:new({ text = "Ruins Tower Base", team = NO_TEAM })
location_ruins_tower_rooftop = location_info:new({ text = "Ruins Tower Rooftop", team = NO_TEAM })
location_ruins_tower_window = location_info:new({ text = "Ruins Tower Window", team = NO_TEAM })
location_ruins_upper_ladder_room = location_info:new({ text = "Ruins Upper Ladder Room", team = Team.kYellow })

location_warehouse = location_info:new({ text = "Warehouse", team = Team.kYellow })
location_warehouse_alley = location_info:new({ text = "Warehouse Alley", team = NO_TEAM })
location_warehouse_entrance = location_info:new({ text = "Warehouse Entrance", team = NO_TEAM })
location_warehouse_ramp = location_info:new({ text = "Warehouse Ramp", team = NO_TEAM })
location_warehouse_ramp_nook = location_info:new({ text = "Warehouse Ramp Nook", team = NO_TEAM })

location_between_towers = location_info:new({ text = "Between Towers", team = NO_TEAM })
location_billy_dons_property = location_info:new({ text = "Billy Don's Property", team = Team.kYellow })
location_escape_tunnel = location_info:new({ text = "Escape Tunnel", team = Team.kBlue })
location_field = location_info:new({ text = "Field", team = NO_TEAM })
location_field_bridge = location_info:new({ text = "Field Bridge", team = NO_TEAM })
location_fuel_room = location_info:new({ text = "Fuel Room", team = NO_TEAM })
location_fuel_room_rooftop = location_info:new({ text = "Fuel Room Rooftop", team = NO_TEAM })
location_tower1 = location_info:new({ text = "Tower 1", team = Team.kRed })
location_tower2 = location_info:new({ text = "Tower 2", team = Team.kRed })
location_under_the_bridge = location_info:new({ text = "Under Field Bridge", team = NO_TEAM })
