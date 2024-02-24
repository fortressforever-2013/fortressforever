---------------------------------------------
-- FF_Training
---------------------------------------------

IncludeScript("base_ctf")

JUMP_TECHNIQUES = 1
MOVEMENT = 2
ALL_TOGETHER = 3

-- stage types
VERTICAL_JUMP = 1
HORIZONTAL_JUMP = 2
MISC_JUMP = 3
MOVEMENT_STAGE = 4
MOVEMENT_STAGE_START = 5
MOVEMENT_STAGE_OTHER = 6
ALL_TOGETHER_STAGE = 7

TIME_FOR_GOLD = 15
TIME_FOR_SILVER = 20
TIME_FOR_BRONZE = 25

stage_info = {

	[JUMP_TECHNIQUES] = {
		technique_name = "Jump Techniques",
		stages = {
			[1] = {
				stage_type = VERTICAL_JUMP,
				stage_name = "Drop Concussion Jump",
				stage_specific = "Vertical",
				stage_checklist = "Vertical Drop Conc Jump",
				stage_code = "v_conc",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key_text = "Prime concussion gren:",
				stage_key = "%+gren2% or %toggletwo%",
				stage_limits = {
					force_hhconc = false,
					force_dropconc = true,
					force_waterconc = true,
					force_1pipe = false,
					force_2pipe = false
				}
			},
			[2] = {
				stage_type = HORIZONTAL_JUMP,
				stage_name = "Drop Concussion Jump",
				stage_specific = "Application",
				stage_checklist = "Drop Conc Jump Application",
				stage_code = "a_conc",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key_text = "Prime concussion gren:",
				stage_key = "%+gren2% or %toggletwo%",
				stage_limits = {
					force_hhconc = false,
					force_dropconc = true,
					force_waterconc = false,
					force_1pipe = false,
					force_2pipe = false
				}
			},
			[3] = {
				stage_type = MISC_JUMP,
				stage_name = "Concussion Jump",
				stage_specific = "Water",
				stage_checklist = "Water Conc Jump",
				stage_code = "m_waterconc",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key_text = "Prime concussion gren:",
				stage_key = "%+gren2% or %toggletwo%",
				stage_limits = {
					force_hhconc = false,
					force_dropconc = false,
					force_waterconc = true,
					force_1pipe = false,
					force_2pipe = false
				}
			},
			[4] = {
				stage_type = VERTICAL_JUMP,
				stage_name = "Hand-Held Concussion Jump",
				stage_specific = "Vertical",
				stage_checklist = "Vertical HH Conc Jump",
				stage_code = "v_hhconc",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key_text = "Prime concussion gren:",
				stage_key = "%+gren2% or %toggletwo%",
				stage_limits = {
					force_hhconc = true,
					force_dropconc = false,
					force_waterconc = false,
					force_1pipe = false,
					force_2pipe = false
				}
			},
			[5] = {
				stage_type = HORIZONTAL_JUMP,
				stage_name = "Hand-Held Concussion Jump",
				stage_specific = "Application",
				stage_checklist = "HH Conc Jump Application",
				stage_code = "a_hhconc",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key_text = "Prime concussion gren:",
				stage_key = "%+gren2% or %toggletwo%",
				stage_limits = {
					force_hhconc = true,
					force_dropconc = false,
					force_waterconc = false,
					force_1pipe = false,
					force_2pipe = false
				}
			},
			[6] = {
				stage_type = VERTICAL_JUMP,
				stage_name = "Rocket Jump",
				stage_specific = "Vertical",
				stage_checklist = "Vertical Rocket Jump",
				stage_code = "v_rj",
				stage_complete = false,
				stage_class = Player.kSoldier,
				stage_key_text = "Shoot rocket:",
				stage_key = "%+attack%",
				stage_limits = {
					force_hhconc = false,
					force_dropconc = false,
					force_waterconc = false,
					force_1pipe = false,
					force_2pipe = false
				}
			},
			[7] = {
				stage_type = HORIZONTAL_JUMP,
				stage_name = "Rocket Jump",
				stage_specific = "Application",
				stage_checklist = "Rocket Jump Application",
				stage_code = "a_rj",
				stage_complete = false,
				stage_class = Player.kSoldier,
				stage_key_text = "Shoot rocket:",
				stage_key = "%+attack%",
				stage_limits = {
					force_hhconc = false,
					force_dropconc = false,
					force_waterconc = false,
					force_1pipe = false,
					force_2pipe = false
				}
			},
			[8] = {
				stage_type = VERTICAL_JUMP,
				stage_name = "Pipe Jump",
				stage_specific = "Vertical",
				stage_checklist = "Vertical Pipe Jump",
				stage_code = "v_pipe",
				stage_complete = false,
				stage_class = Player.kDemoman,
				stage_key_text = "Det pipes:",
				stage_key = "%+attack2%",
				stage_limits = {
					force_hhconc = false,
					force_dropconc = false,
					force_waterconc = false,
					force_1pipe = false,
					force_2pipe = true
				}
			},
			[9] = {
				stage_type = HORIZONTAL_JUMP,
				stage_name = "Pipe Jump",
				stage_specific = "Application",
				stage_checklist = "Pipe Jump Application",
				stage_code = "a_pipe",
				stage_complete = false,
				stage_class = Player.kDemoman,
				stage_key_text = "Det pipes:",
				stage_key = "%+attack2%",
				stage_limits = {
					force_hhconc = false,
					force_dropconc = false,
					force_waterconc = false,
					force_1pipe = true,
					force_2pipe = false
				}
			},
			[10] = {
				stage_type = HORIZONTAL_JUMP,
				stage_name = "Jetpack",
				stage_specific = "Application",
				stage_checklist = "Jetpack",
				stage_code = "a_ft",
				stage_complete = false,
				stage_class = Player.kPyro,
				stage_key_text = "Use jetpack:",
				stage_key = "%+attack2%",
				stage_limits = {
					force_hhconc = false,
					force_dropconc = false,
					force_waterconc = false,
					force_1pipe = false,
					force_2pipe = false
				}
			}
		}
	},

	[MOVEMENT] = {
		technique_name = "Movement Techniques",
		stages = {
			[1] = {
				stage_type = MOVEMENT_STAGE,
				stage_name = "Double Jump",
				stage_specific = "Basics",
				stage_checklist = "Double Jump",
				stage_code = "move_doublejump",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key_text = "Jump:",
				stage_key = "%+jump%"
			},
			[2] = {
				stage_type = MOVEMENT_STAGE_START,
				stage_name = "Air Control",
				stage_specific = "Basics",
				stage_checklist = "Air Control Basics",
				stage_code = "move_aircontrol",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key_text = "Strafe: %+moveleft% and %+moveright%",
				stage_key = "Reset stage: %+use%"
			},
			[3] = {
				stage_type = MOVEMENT_STAGE,
				stage_name = "Air Control",
				stage_specific = "Jump",
				stage_checklist = "Air Control Jump",
				stage_code = "move_aircontrolpush",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key = ""
			},
			[4] = {
				stage_type = MOVEMENT_STAGE_START,
				stage_name = "Air Control",
				stage_specific = "Gaining Speed",
				stage_checklist = "Gaining Speed with Strafe",
				stage_code = "move_aircontrolspeed",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key = ""
			},
			[5] = {
				stage_type = MOVEMENT_STAGE_START,
				stage_name = "Air Control",
				stage_specific = "Bunnyhop Primer",
				stage_checklist = "Bunnyhop Air Control",
				stage_code = "move_aircontrolbhop",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key = ""
			},
			[6] = {
				stage_type = MOVEMENT_STAGE_MULTIPLE,
				stage_name = "Bunnyhop",
				stage_specific = "Stepping Stones",
				stage_checklist = "Bunnyhop",
				stage_num_steps = 3,
				stage_code = "move_bhop",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key = ""
			},
			[7] = {
				stage_type = MOVEMENT_STAGE_START,
				stage_name = "Rampslide",
				stage_specific = "",
				stage_checklist = "Rampslide",
				stage_code = "move_rampslide",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key = ""
			},
			[8] = {
				stage_type = MOVEMENT_STAGE_START,
				stage_name = "Trimp",
				stage_specific = "",
				stage_checklist = "Trimp",
				stage_code = "move_trimp",
				stage_complete = false,
				stage_class = Player.kScout,
				stage_key_text = "Jump:",
				stage_key = "%+jump%"
			}
		}
	},
	
	[ALL_TOGETHER] = {
		technique_name = "Putting it All Together",
		stages = {
			[1] = {
				stage_type = ALL_TOGETHER_STAGE,
				stage_name = "Scout",
				stage_specific = "Speed Run",
				stage_checklist = "Scout Speed Run",
				stage_code = "all_scout",
				stage_complete = false,
				stage_medal = 0,
				stage_class = Player.kScout,
				stage_key_text = "Reset:",
				stage_key = "%+use%"
			}
		}
	}
}


VERTICAL_JUMP_TOUCHED = 0
VERTICAL_JUMP_BROADCASTED = 0
VERTICAL_JUMP_MESSAGE = "What?"

NUM_JUMP_QUEUES_NEEDED = 10

GIVE_GREN2 = false
GIVE_PIPES = false
GIVE_RPG = false

TIMEOUT_REPLAY_TIME = 45

current_technique = JUMP_TECHNIQUES
current_stage = 1
failed_attempts = 0
best_run = nil
show_timer = false


-- startup
function startup()
	SetGameDescription( "Training" )

	SetTeamName( Team.kBlue, "Trainee" )
	
	SetPlayerLimit( Team.kBlue, 1 )
	SetPlayerLimit( Team.kRed, -1 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kCivilian, 0 )
	
	setup()
	
end

function setup()
	
	for i,v in ipairs(stage_info) do
		for i2,v2 in ipairs(v.stages) do
			_G[v2.stage_code.."_tele"] = base_tele:new({ technique_id = i, stage_number = i2 })
			_G[v2.stage_code.."_replay_btn"] = base_replay_btn:new({ technique_id = i, stage_number = i2 })
			if v2.stage_type == VERTICAL_JUMP then
				_G[v2.stage_code] = v_jump:new({ technique_id = i, stage_number = i2 })
			elseif v2.stage_type == HORIZONTAL_JUMP then
				_G[v2.stage_code] = a_jump:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code.."_finish"] = a_finish:new({ technique_id = i, stage_number = i2 })
			elseif v2.stage_type == MISC_JUMP then
				_G[v2.stage_code.."_start"] = m_jump_start:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code] = m_jump:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code.."_finish"] = a_finish:new({ technique_id = i, stage_number = i2 })
			elseif v2.stage_type == MOVEMENT_STAGE then
				_G[v2.stage_code] = move_room:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code.."_init"] = move_init:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code.."_finish"] = a_finish:new({ technique_id = i, stage_number = i2 })
			elseif v2.stage_type == MOVEMENT_STAGE_START then
				_G[v2.stage_code] = move_area:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code.."_start"] = move_start:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code.."_init"] = move_init:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code.."_finish"] = a_finish:new({ technique_id = i, stage_number = i2 })
			elseif v2.stage_type == MOVEMENT_STAGE_MULTIPLE then
			    for i3=1,v2.stage_num_steps do
					_G[v2.stage_code..""..i3.."_replay_btn"] = base_replay_btn:new({ technique_id = i, stage_number = i2, step = i3 })
					_G[v2.stage_code..""..i3.."_tele"] = base_tele:new({ technique_id = i, stage_number = i2, step = i3 })
					_G[v2.stage_code..""..i3] = move_bhop_area:new({ technique_id = i, stage_number = i2, step = i3 })
					_G[v2.stage_code..""..i3.."_start"] = move_bhop_start:new({ technique_id = i, stage_number = i2, step = i3 })
					_G[v2.stage_code..""..i3.."_init"] = move_bhop_init:new({ technique_id = i, stage_number = i2, step = i3 })
					_G[v2.stage_code..""..i3.."_finish"] = move_bhop_finish:new({ technique_id = i, stage_number = i2, step = i3 })
				end
			elseif v2.stage_type == ALL_TOGETHER_STAGE then
				_G[v2.stage_code] = all_together_room:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code.."_init"] = all_together_init:new({ technique_id = i, stage_number = i2 })
				_G[v2.stage_code.."_start"] = all_together_start:new({ technique_id = i, stage_number = i2 })
			else
				--ChatToAll( "[SCRIPT] ERROR: no stage type defined for "..v2.stage_checklist )
			end
		end
	end
	
end

-- precache sounds
function precache()
	for i,v in ipairs(stage_info) do
		for i2,v2 in ipairs(v.stages) do
			PrecacheSound("training."..v2.stage_code.."_start")
			PrecacheSound("training."..v2.stage_code.."01")
			PrecacheSound("training."..v2.stage_code.."02")
			PrecacheSound("training."..v2.stage_code.."03")
			PrecacheSound("training."..v2.stage_code.."04")
			PrecacheSound("training."..v2.stage_code.."_timeout")
			if v2.stage_num_steps ~= nil then
				for i3=1,v2.stage_num_steps do
					PrecacheSound("training."..v2.stage_code..i3.."_start")
				end
			end
			if v2.stage_medal ~= nil then
				PrecacheSound("training."..v2.stage_code.."_bronze")
				PrecacheSound("training."..v2.stage_code.."_silver")
				PrecacheSound("training."..v2.stage_code.."_gold")
			end
		end
	end
	
	PrecacheSound("training.stage_complete")
	PrecacheSound("training.all_complete")
	PrecacheSound("training.intro")

	PrecacheSound("misc.bizwarn")
	PrecacheSound("misc.bloop")
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.dadeda")
	PrecacheSound("misc.deeoo")
	PrecacheSound("misc.doop")
	PrecacheSound("misc.woop")
	PrecacheSound("otherteam.flagstolen")
end

function set_ammo( player_entity, ammo_type, amount )
	if IsPlayer( player_entity ) then 
		local player = CastToPlayer( player_entity ) 
		player:RemoveAmmo( ammo_type, 300 )
		player:AddAmmo( ammo_type, amount )
	end
end

function reset_stock( player )
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:RemoveAmmo( Ammo.kNails, 400 )
	player:RemoveAmmo( Ammo.kShells, 400 )
	player:RemoveAmmo( Ammo.kRockets, 400 )
	player:RemoveAmmo( Ammo.kCells, 400 )
	
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
end

function removeprimed( player_entity )
	if IsPlayer( player_entity ) then 
		local player = CastToPlayer( player_entity ) 
		
		ApplyToPlayer( player, {AT.kStopPrimedGrens} )
		
		BroadCastMessage( "You must drop the grenade!" )
		GIVE_GREN2 = true
	end
end

function add_timeout()
	--ChatToAll( "[script] adding timeout schedule (time: "..TIMEOUT_REPLAY_TIME..")" )
	AddSchedule( "timeout", TIMEOUT_REPLAY_TIME, play_timeout ) 
end

function reset_timeout()
	--ChatToAll( "[script] resetting timeout schedule (time: "..TIMEOUT_REPLAY_TIME..")" )
	RemoveSchedule( "timeout" )
	AddSchedule( "timeout", TIMEOUT_REPLAY_TIME, play_timeout ) 
end

function remove_timeout()
	--ChatToAll( "[script] removing timeout schedule" )
	RemoveSchedule( "timeout" )
end

function play_timeout()
	--ChatToAll( "[script] playing timeout sound" )
	BroadCastSound( "training."..stage_info[current_technique].stages[current_stage].stage_code.."_timeout" )
	reset_timeout()
end

function increment_failed( player, inc )
	failed_attempts = failed_attempts + inc
	--ChatToAll( "[script] failed attempts: "..failed_attempts )
	
	if failed_attempts >= 3 then
		--ChatToAll( "[script] broadcasting failed sound" )
		BroadCastSound( "training."..stage_info[current_technique].stages[current_stage].stage_code.."02" )
		reset_failed()
	end
end

function reset_failed()
	failed_attempts = 0
	--ChatToAll( "[script] reset failed attempts: "..failed_attempts )
end

function complete_stage( player )
	--ChatToAll( "[script] technique #"..current_technique.." stage #"..current_stage.." complete" )
	stage_info[current_technique].stages[current_stage].stage_complete = true
	
	show_complete( player, stage_info[current_technique].stages[current_stage].stage_checklist )
	
	if current_stage + 1 <= # stage_info[current_technique].stages then
		current_stage = current_stage + 1
	else
		current_technique = current_technique + 1
		current_stage = 1
	end
	
	flaginfo( player )
	
	reset_failed()
	
	hide_current( player )
	AddSchedule( "hide_complete", 4, hide_complete, player )
	AddSchedule( "show_current", 4, show_current, player )
	
	hide_key( player )
	hide_progressbar( player )
end

function award_medal( player, medal )
	local medal_name = ""
	local sound_delay = 0
	if medal == 1 then medal_name = "Gold"; sound_delay = 6
	elseif medal == 2 then medal_name = "Silver"; sound_delay = 5
	elseif medal == 3 then medal_name = "Bronze"; sound_delay = 4 end
	BroadCastSound( "training."..stage_info[current_technique].stages[current_stage].stage_code.."_"..string.lower(medal_name) )
	
	hide_medal( player )
	show_medal_won( player, medal )
	AddSchedule( "hide_medal_won", 4, hide_medal_won, player )
	AddSchedule( "show_medal", 4, show_medal, player, medal )
	AddSchedule( "play_all_complete", sound_delay, play_all_complete, player )
	
	stage_info[current_technique].stages[current_stage].stage_complete = true
	stage_info[current_technique].stages[current_stage].stage_medal = medal
end

function show_medal( player, medal )
	hide_medal(player)
	if medal == 1 then
		AddHudIcon( player, "ff_training_medal_gold.vtf", "Medal", 16, 64, 64, 64, 0 )
	elseif medal == 2 then
		AddHudIcon( player, "ff_training_medal_silver.vtf", "Medal", 16, 64, 64, 64, 0 )
	elseif medal == 3 then
		AddHudIcon( player, "ff_training_medal_bronze.vtf", "Medal", 16, 64, 64, 64, 0 )
	end
end

function hide_medal( player )
	RemoveHudItem( player, "Medal" )
end

function show_medal_won( player, medal )
	local medal_name = ""
	if medal == 1 then medal_name = "Gold"
	elseif medal == 2 then medal_name = "Silver"
	elseif medal == 3 then medal_name = "Bronze" end
	hide_medal_won(player)
	AddHudIcon( player, "hud_statusbar_256.vtf", "Medal_won_BG", -128, 180, 256, 16, 3 )
	AddHudIcon( player, "ff_training_medal_"..string.lower(medal_name)..".vtf", "Medal_won", -112, 170, 32, 32, 3 )
	AddHudText( player, "Medal_won_text", "You won the "..medal_name.." medal!", 0, 184, 4 )
end

function hide_medal_won( player )
	RemoveHudItem( player, "Medal_won" )
	RemoveHudItem( player, "Medal_won_text" )
	RemoveHudItem( player, "Medal_won_BG" )
end

function play_all_complete( player )
	BroadCastSound( "training.all_complete" )
end

function show_complete( player, technique )
	RemoveHudItem( player, "Completed_BG" )
	RemoveHudItem( player, "Completed_check" )
	RemoveHudItem( player, "Completed_text" )
	AddHudIcon( player, "hud_statusbar_256.vtf", "Completed_BG", -128, 180, 256, 16, 3 )
	AddHudIcon( player, "hud_checkmark.vtf", "Completed_check", -112, 170, 32, 32, 3 )
	AddHudText( player, "Completed_text", technique, 0, 184, 4 )
end

function hide_complete( player )
	RemoveHudItem( player, "Completed_BG" )
	RemoveHudItem( player, "Completed_check" )
	RemoveHudItem( player, "Completed_text" )
end

function show_current( player )
	RemoveHudItem( player, "Current_BG" )
	RemoveHudItem( player, "Current_BG2" )
	RemoveHudItem( player, "Current_arrow" )
	RemoveHudItem( player, "Current_arrow_l" )
	RemoveHudItem( player, "Current_text" )
	RemoveHudItem( player, "Current_text2" )
	AddHudIcon( player, "hud_statusbar_256.vtf", "Current_BG", -64, 40, 128, 16, 3 )
	AddHudIcon( player, "hud_statusbar_256.vtf", "Current_BG2", -64, 58, 128, 16, 3 )
	AddHudIcon( player, "hud_current_arrow.vtf", "Current_arrow", -90, 32, 32, 32, 3 )
	AddHudIcon( player, "hud_current_arrow_l.vtf", "Current_arrow_l", 58, 32, 32, 32, 3 )
	if current_technique == ALL_TOGETHER then
		if show_timer then
			AddHudTimer( player, "Current_text", "speedrun_timer", 0, 42, 4 )
		else
			AddHudText( player, "Current_text", "Timer not started", 0, 44, 4 )
		end
		if best_run ~= nil then
			AddHudTextToAll( "Current_text2", string.format("Best Time: %.3f seconds", best_run), 0, 62, 4 )
		else
			AddHudTextToAll( "Current_text2", "No best time yet", 0, 62, 4 )
		end
	else
		AddHudText( player, "Current_text", stage_info[current_technique].stages[current_stage].stage_name, 0, 44, 4 )
		AddHudText( player, "Current_text2", stage_info[current_technique].stages[current_stage].stage_specific, 0, 62, 4 )
	end
	
end

function hide_current( player )
	RemoveHudItem( player, "Current_BG" )
	RemoveHudItem( player, "Current_BG2" )
	RemoveHudItem( player, "Current_arrow" )
	RemoveHudItem( player, "Current_arrow_l" )
	RemoveHudItem( player, "Current_text" )
	RemoveHudItem( player, "Current_text2" )
end

function show_key( player )
	if stage_info[current_technique].stages[current_stage].stage_key ~= "" then
		RemoveHudItem( player, "Key_BG" )
		RemoveHudItem( player, "Key_text" )
		RemoveHudItem( player, "Key_text2" )
		AddHudIcon( player, "hud_statusbar_256_128.vtf", "Key_BG", -64, 80, 128, 32, 3 )
		AddHudText( player, "Key_text", stage_info[current_technique].stages[current_stage].stage_key_text, 0, 88, 4 )
		AddHudText( player, "Key_text2", stage_info[current_technique].stages[current_stage].stage_key, 0, 96, 4 )
	end
	
end

function hide_key( player )
	RemoveHudItem( player, "Key_BG" )
	RemoveHudItem( player, "Key_text" )
	RemoveHudItem( player, "Key_text2" )
end

function show_progressbar( player )
	if stage_info[current_technique].stages[current_stage].stage_code == "move_aircontrolspeed" then
		hide_progressbar( player )
		local bar_width = 1
		AddHudIcon( player, "hud_statusbar_256.vtf", "Progress_BG", -64, 80, 128, 16, 3 )
		AddHudIcon( player, "hud_statusbar_blue.vtf", "Progress_bar", -62, 80, bar_width, 16, 3 )
	end
end

function update_progressbar( player, percent )
	RemoveHudItem( player, "Progress_bar" )
	RemoveHudItem( player, "Progress_text" )
	local max_width = 124
	local bar_width = percent * max_width
	AddHudIcon( player, "hud_statusbar_blue_active.vtf", "Progress_bar", -62, 80, bar_width, 16, 3 )
	AddHudText( player, "Progress_text", tostring(math.floor(percent * 100 + 0.5)).."% of target speed", 0, 84, 4 )
end

function hide_progressbar( player )
	RemoveHudItem( player, "Progress_BG" )
	RemoveHudItem( player, "Progress_bar" )
	RemoveHudItem( player, "Progress_text" )
end

-------------------------------------
-- Teleports
-------------------------------------
base_tele = trigger_ff_script:new({ technique_id = 0, stage_number = 0, step = 0 })

function base_tele:ontouch( touch_entity )
	if IsPlayer(touch_entity) then
		local player = CastToPlayer( touch_entity )
		player:SetVelocity(Vector(0,0,0))
		
		OutputEvent("steppingstone_*", "Enable")
		
		increment_failed(player, 1)
		reset_timeout()
	end
end

-------------------------------------
-- Teleports
-------------------------------------
base_replay_btn = trigger_ff_script:new({ technique_id = 0, stage_number = 0, step = 0 })

function base_replay_btn:ontrigger( touch_entity )
	if IsPlayer(touch_entity) then
		local player = CastToPlayer( touch_entity )
		if player:IsInUse() then
			BroadCastSound( "training."..stage_info[self.technique_id].stages[self.stage_number].stage_code.."_timeout" )
		end
	end
end

-------------------------------------
-- Vertical Jump Rooms
-------------------------------------
v_jump = trigger_ff_script:new({ technique_id = 0, stage_number = 0 })

function v_jump:ontouch( touch_entity )
	if VERTICAL_JUMP_TOUCHED == 10 then
		BroadCastSound( "training.stage_complete" )
		OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_door", "Open" )
		OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_door_trigger", "Enable" )
		OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_light", "TurnOn" )
		OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_sprite", "ShowSprite" )
		OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_model", "Skin", "6" )
		OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_next", "Enable" )
		
		remove_timeout()
	end
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		--ChatToAll( "[script] technique: "..self.technique_id.." stage num: "..self.stage_number )
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if (VERTICAL_JUMP_TOUCHED > 0) then
					------------------
					----ChatToAll( "[training] "..VERTICAL_JUMP_TOUCHED.." marker touched")
					------------------
				-- first touch
				else
					if self.stage_number > 1 then
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_next", "Disable" )
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_finish_door", "Close" )
					else
						OutputEvent( "start_door", "Close" )
					end
					BroadCastSound( "training."..stage_info[self.technique_id].stages[self.stage_number].stage_code.."01" )
					add_timeout()
				end
				if stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kScout then
					GIVE_GREN2 = true
				end
				if p:GetClass() ~= stage_info[self.technique_id].stages[self.stage_number].stage_class then
				
					show_key( p )
					
					------------------
					if stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kScout then
						ApplyToPlayer( p, {AT.kChangeClassScout} )
						p:RemoveAllWeapons()
						reset_stock( p )
						--ChatToAll( "[training] give the concs!" )
						set_ammo( p, Ammo.kGren2, 1 )
						--DisplayMessage( p, "Use {gren2} or {toggletwo} to throw a concussion grenade" )
					elseif stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kSoldier then
						ApplyToPlayer( p, {AT.kChangeClassSoldier} )
						p:RemoveAllWeapons()
						reset_stock( p )
						p:GiveWeapon( "ff_weapon_rpg", true )
						p:SetAmmoInClip(1)
						GIVE_GREN2 = false
					elseif stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kDemoman then
						ApplyToPlayer( p, {AT.kChangeClassDemoman} )
						p:RemoveAllWeapons()
						reset_stock( p )
						p:GiveWeapon( "ff_weapon_pipelauncher", true )
						if stage_info[self.technique_id].stages[self.stage_number].stage_code == "v_pipe" then
							p:SetAmmoInClip(2)
						else
							p:SetAmmoInClip(1)
						end
						GIVE_GREN2 = false
						GIVE_PIPES = false
					end
					------------------
				end
			end
		end
	end
	
	VERTICAL_JUMP_TOUCHED = 0
	VERTICAL_JUMP_BROADCASTED = 0
	
end

function v_jump:ontrigger( touch_entity )
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if p:IsOnGround() and GIVE_GREN2 then
					------------------
					set_ammo( p, Ammo.kGren2, 1 )
					GIVE_GREN2 = false
					------------------
				end
				if p:IsOnGround() and p:GetClass() == Player.kSoldier then
					------------------
					p:GiveWeapon( "ff_weapon_rpg", true )
					set_ammo( p, Ammo.kRockets, 0 )
					ApplyToPlayer( p, {AT.kReloadClips} )
					p:SetAmmoInClip(1)
					------------------
				end
				if p:IsOnGround() and p:GetClass() == Player.kDemoman and GIVE_PIPES then
					------------------
					p:GiveWeapon( "ff_weapon_pipelauncher", true )
					set_ammo( p, Ammo.kRockets, 0 )
					ApplyToPlayer( p, {AT.kReloadClips} )
					p:SetAmmoInClip(2)
					GIVE_PIPES = false
					------------------
				end
			end
		end
	end
end

function v_jump:onexplode( explode_entity )
	return EVENT_ALLOWED
end

function v_jump:onendtouch() 

end


-------------------------------------
-- Jump Application Rooms
-------------------------------------
a_jump = trigger_ff_script:new({ technique_id = 0, stage_number = 0 })

function a_jump:ontouch( touch_entity ) 
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if self.stage_number > 1 then
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_next", "Disable" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_finish_door", "Close" )
				end
				BroadCastSound( "training."..stage_info[self.technique_id].stages[self.stage_number].stage_code.."01" )
				reset_timeout()
				
				show_current( p )
				
				if p:GetClass() ~= stage_info[self.technique_id].stages[self.stage_number].stage_class then
					
					show_key( p )
					
					------------------
					if stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kScout then
						ApplyToPlayer( p, {AT.kChangeClassScout} )
						p:RemoveAllWeapons()
						reset_stock( p )
						set_ammo( p, Ammo.kGren2, 1 )
					elseif stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kSoldier then
						ApplyToPlayer( p, {AT.kChangeClassSoldier} )
						p:RemoveAllWeapons()
						reset_stock( p )
						p:GiveWeapon( "ff_weapon_rpg", true )
						GIVE_GREN2 = false
					elseif stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kDemoman then
						ApplyToPlayer( p, {AT.kChangeClassDemoman} )
						p:RemoveAllWeapons()
						reset_stock( p )
						p:GiveWeapon( "ff_weapon_pipelauncher", true )
						GIVE_GREN2 = false
					elseif stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kPyro then
						ApplyToPlayer( p, {AT.kChangeClassPyro} )
						p:RemoveAllWeapons()
						reset_stock( p )
						p:GiveWeapon( "ff_weapon_flamethrower", true )
						set_ammo( p, Ammo.kCells, 200 )
						GIVE_GREN2 = false
					end
				end
			end
		end
	end
end

function a_jump:ontrigger( touch_entity ) 
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if p:IsOnGround() and GIVE_GREN2 then
					------------------
					set_ammo( p, Ammo.kGren2, 1 )
					GIVE_GREN2 = false
					------------------
				end
				if p:IsOnGround() and p:GetClass() == Player.kSoldier then
					------------------
					p:GiveWeapon( "ff_weapon_rpg", true )
					set_ammo( p, Ammo.kRockets, 0 )
					ApplyToPlayer( p, {AT.kReloadClips} )
					p:SetAmmoInClip(1)
					------------------
				end
				if p:IsOnGround() and p:GetClass() == Player.kDemoman and GIVE_PIPES then
					------------------
					p:GiveWeapon( "ff_weapon_pipelauncher", true )
					set_ammo( p, Ammo.kRockets, 0 )
					ApplyToPlayer( p, {AT.kReloadClips} )
					p:SetAmmoInClip(1)
					GIVE_PIPES = false
					------------------
				end
				if p:IsOnGround() and p:GetClass() == Player.kPyro then
					------------------
					set_ammo( p, Ammo.kCells, 200 )
					------------------
				end
			end
		end
	end
end

function a_jump:onexplode( explode_entity )
	return EVENT_ALLOWED
end

function a_jump:onendtouch() 

end


-------------------------------------
-- Misc Jump Start
-------------------------------------
m_jump_start = trigger_ff_script:new({ technique_id = 0, stage_number = 0 })

function m_jump_start:ontouch( touch_entity ) 
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if self.stage_number > 1 then
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_next", "Disable" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_finish_door", "Close" )
				end
				BroadCastSound( "training."..stage_info[self.technique_id].stages[self.stage_number].stage_code.."_start" )
				
				reset_timeout()
				
				show_current( p )
				
				if p:GetClass() ~= stage_info[self.technique_id].stages[self.stage_number].stage_class then
					
					show_key( p )
					
					------------------
					if stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kScout then
						ApplyToPlayer( p, {AT.kChangeClassScout} )
						p:RemoveAllWeapons()
						reset_stock( p )
						GIVE_GREN2 = true
					end
				end
			end
		end
	end
end

function m_jump_start:onexplode( explode_entity )
	return EVENT_ALLOWED
end

function m_jump_start:onendtouch() 

end

-------------------------------------
-- Misc Jump Rooms
-------------------------------------
m_jump = trigger_ff_script:new({ technique_id = 0, stage_number = 0 })

function m_jump:ontouch( touch_entity )
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			BroadCastSound( "training."..stage_info[self.technique_id].stages[self.stage_number].stage_code.."01" )
			reset_timeout()
		end
	end
end

function m_jump:ontrigger( touch_entity )
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if (p:IsOnGround() or p:IsUnderWater()) and p:GetClass() == Player.kScout and GIVE_GREN2 then
					------------------
					set_ammo( p, Ammo.kGren2, 1 )
					GIVE_GREN2 = false
					------------------
				end
			end
		end
	end
end

function m_jump:onexplode( explode_entity )
	return EVENT_ALLOWED
end

function m_jump:onendtouch() 

end

-------------------------------------
-- Movement Room
-------------------------------------
move_room = trigger_ff_script:new({ technique_id = 0, stage_number = 0, played_sound = false })

function move_room:ontouch( touch_entity ) 
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if not self.played_sound then
				
					self.played_sound = true
				
					if self.stage_number > 1 then
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_next", "Disable" )
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_finish_door", "Close" )
					elseif self.technique_id > 1 then
						local num_stages_previous_technique = # stage_info[self.technique_id - 1].stages
						OutputEvent( stage_info[self.technique_id - 1].stages[num_stages_previous_technique].stage_code.."_next", "Disable" )
						OutputEvent( stage_info[self.technique_id - 1].stages[num_stages_previous_technique].stage_code.."_finish_door", "Close" )
					end
					BroadCastSound( "training."..stage_info[self.technique_id].stages[self.stage_number].stage_code.."01" )
					
					reset_timeout()
					
					show_current( p )
				end
					
				if p:GetClass() ~= stage_info[self.technique_id].stages[self.stage_number].stage_class then
					
					show_key( p )
					
					------------------
					if stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kScout then
						ApplyToPlayer( p, {AT.kChangeClassScout} )
						p:RemoveAllWeapons()
						reset_stock( p )
					end
				end

			end
		end
	end
end


-------------------------------------
-- Movement Start
-------------------------------------
move_start = trigger_ff_script:new({ technique_id = 0, stage_number = 0, played_sound = false })

function move_start:ontouch( touch_entity ) 
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if not self.played_sound then
				
					self.played_sound = true
				
					if self.stage_number > 1 then
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_next", "Disable" )
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_finish_door", "Close" )
					elseif self.technique_id > 1 then
						local num_stages_previous_technique = # stage_info[self.technique_id - 1].stages
						OutputEvent( stage_info[self.technique_id - 1].stages[num_stages_previous_technique].stage_code.."_next", "Disable" )
						OutputEvent( stage_info[self.technique_id - 1].stages[num_stages_previous_technique].stage_code.."_finish_door", "Close" )
					end
				
					BroadCastSound( "training."..stage_info[self.technique_id].stages[self.stage_number].stage_code.."_start" )
				
					reset_timeout()
					
					show_current( p )
				end
				
				if p:GetClass() ~= stage_info[self.technique_id].stages[self.stage_number].stage_class then
					
					show_key( p )
					show_progressbar( p )
					
					------------------
					if stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kScout then
						ApplyToPlayer( p, {AT.kChangeClassScout} )
						p:RemoveAllWeapons()
						reset_stock( p )
					end
				end
			end
		end
	end
end


-------------------------------------
-- Movement Area
-------------------------------------
move_area = trigger_ff_script:new({ technique_id = 0, stage_number = 0, disabled = false })

function move_area:ontrigger( touch_entity ) 
	if self.disabled then return end
	
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				local l_stage_code = stage_info[self.technique_id].stages[self.stage_number].stage_code
				
				if l_stage_code == "move_aircontrol" or l_stage_code == "move_aircontrolbhop" then
					if p:IsInUse() then
						local neworigin = GetEntityByName( l_stage_code.."_tele_dest" ):GetOrigin()
						neworigin = Vector(neworigin.x,neworigin.y,neworigin.z+36)
						local newangles = GetEntityByName( l_stage_code.."_tele_dest" ):GetAngles()
						local newvelocity = Vector(0,0,0)
						p:Teleport( neworigin, newangles, newvelocity )
						p:SetGravity( 1 )
						p:SpeedMod( 1 )
						increment_failed(p, 1)
						self:adddisable()
						reset_timeout()
					elseif p:IsInForward() then
						BroadCastMessage( "Do not press forward while air controlling" )
					else
						local speed = p:GetSpeed()
						if speed < 50 then
							BroadCastMessage( "You seem to be stuck. Press your USE button to retry" )
						end
					end
				end
				
				if l_stage_code == "move_rampslide" then
				
					local speed = p:GetSpeed()
					
					if speed < 800 then
						local neworigin = GetEntityByName( l_stage_code.."_tele_dest" ):GetOrigin()
						neworigin = Vector(neworigin.x,neworigin.y,neworigin.z+36)
						local newangles = GetEntityByName( l_stage_code.."_tele_dest" ):GetAngles()
						local newvelocity = Vector(0,0,0)
						p:Teleport( neworigin, newangles, newvelocity )
						p:SetGravity( 1 )
						p:SpeedMod( 1 )
						increment_failed(p, 1)
						self:adddisable()
						reset_timeout()
					end
				end
				
				if l_stage_code == "move_trimp" then
				
					local speed = p:GetSpeed()
					
					if speed <= 500 then
						local neworigin = GetEntityByName( l_stage_code.."_tele_dest" ):GetOrigin()
						neworigin = Vector(neworigin.x,neworigin.y,neworigin.z+36)
						local newangles = GetEntityByName( l_stage_code.."_tele_dest" ):GetAngles()
						local newvelocity = Vector(0,0,0)
						p:Teleport( neworigin, newangles, newvelocity )
						p:SetGravity( 1 )
						p:SpeedMod( 1 )
						increment_failed(p, 1)
						self:adddisable()
						reset_timeout()
					end
				end
				
				if l_stage_code == "move_aircontrolspeed" then
					--if p:IsInUse() then
					--	local origin = GetEntityByName( l_stage_code.."_tele_dest" ):GetOrigin()
					--	p:SetOrigin( Vector( origin.x, origin.y, origin.z + 64 ) )
					--	p:SetVelocity( Vector( 0,0,0 ) )
					--	p:SetGravity( 1 )
					--	p:SpeedMod( 1 )
					if p:IsInForward() then
						BroadCastMessage( "Do not press forward while air controlling" )
					else
						local speed = p:GetSpeed()
						update_progressbar( p, speed / 700 )
						if speed > 700 then
							update_progressbar( p, 1.0 )
							BroadCastSound( "misc.doop" )
							remove_timeout()
							OutputEvent("move_aircontrolspeed_showfinishblock", "Enable")
							OutputEvent("move_aircontrolspeed", "Disable")
						end
					end
				end
				
			end
		end
	end
end

function move_area:adddisable()
	self.disabled = true
	AddSchedule(stage_info[self.technique_id].stages[self.stage_number].stage_code .. "-removedisable", 1, self.removedisable, self)
end

function move_area.removedisable(self)
	self.disabled = false
end

-------------------------------------
-- Movement Room
-------------------------------------
move_init = trigger_ff_script:new({ technique_id = 0, stage_number = 0 })

function move_init:ontouch( touch_entity )
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				
				local l_stage_code = stage_info[self.technique_id].stages[self.stage_number].stage_code
				
				if l_stage_code == "move_aircontrol" then
					p:SetVelocity( Vector( 500, 0, 600 ) )
					p:SetGravity( 0.000000001 )
				elseif l_stage_code == "move_aircontrolpush" then
					p:SetVelocity( Vector( -800, 0, 600 ) )
				elseif l_stage_code == "move_aircontrolspeed" then
					p:SetVelocity( Vector( 0, -300, 600 ) )
					p:SetGravity( 0.000000001 )
				elseif l_stage_code == "move_aircontrolbhop" then
					p:SetVelocity( Vector( 0, -400, 600 ) )
					p:SetGravity( 0.000000001 )
				elseif l_stage_code == "move_rampslide" then
					p:SetVelocity( Vector( 2000, 0, 0 ) )
				elseif l_stage_code == "move_trimp" then
					p:SetVelocity( Vector( 1500, 0, 0 ) )
				end
			end
		end
	end
end

-------------------------------------
-- Application finish
-------------------------------------
a_finish = trigger_ff_script:new({ technique_id = 0, stage_number = 0 })

function a_finish:ontouch( touch_entity ) 
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				
				BroadCastSound( "misc.doop" )
				BroadCastSound( "training.stage_complete" )
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_door", "Open" )
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_door_trigger", "Enable" )
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_light", "TurnOn" )
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_sprite", "ShowSprite" )
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_model", "Skin", "6" )
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_next", "Enable" )
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_block", "Enable" )
				
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_tesla", "DoSpark" )
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_beam", "TurnOff" )
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_arrow", "Disable" )
				complete_stage( p )
				p:RemoveAllWeapons()
				p:SetGravity( 1.0 )
				p:SpeedMod( 1.0 )
				
				remove_timeout()
				
			end
		end	
	end
end

-------------------------------------
-- Aircontrolspeed
-------------------------------------

move_aircontrolspeed_hidestartarrows = trigger_ff_script:new({ })

function move_aircontrolspeed_hidestartarrows:ontouch( touch_entity ) 
	if IsPlayer( touch_entity ) then
		local p = CastToPlayer( touch_entity )
		if not p:IsBot() then
			
			OutputEvent("move_aircontrolspeed_starthideblock", "Disable")
			OutputEvent("move_aircontrolspeed_arrow_starthide", "TurnOff")
			OutputEvent("move_aircontrolspeed_arrow_startshow", "TurnOn")
			OutputEvent("move_aircontrolspeed_startblock", "Enable")
			
		end
	end	
end

move_aircontrolspeed_showfinishblock = trigger_ff_script:new({ touched=false })

function move_aircontrolspeed_showfinishblock:ontouch( touch_entity ) 
	if IsPlayer( touch_entity ) then
		local p = CastToPlayer( touch_entity )
		if not p:IsBot() then
			
			if not self.touched then
				OutputEvent("move_aircontrolspeed_finishshowblock", "Enable")
				OutputEvent("move_aircontrolspeed_arrow_finishhide", "TurnOff")
				OutputEvent("move_aircontrolspeed_arrow_finishshow", "TurnOn")
				OutputEvent("move_aircontrolspeed_finishblock", "Disable")
				self.touched = true
			end
			
		end
	end	
end


-------------------------------------
-- Bhop
-------------------------------------

move_bhop_init = trigger_ff_script:new({ technique_id = 0, stage_number = 0, step = 0 })

move_bhop_area = trigger_ff_script:new({ technique_id = 0, stage_number = 0, step = 0 })

move_bhop_start = trigger_ff_script:new({ technique_id = 0, stage_number = 0, step = 0, played_sound = false })

function move_bhop_start:ontouch( touch_entity ) 
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if not self.played_sound then
				
					self.played_sound = true
					
					if self.stage_number > 1 then
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_next", "Disable" )
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_finish_door", "Close" )
					elseif self.technique_id > 1 then
						local num_stages_previous_technique = # stage_info[self.technique_id - 1].stages
						OutputEvent( stage_info[self.technique_id - 1].stages[num_stages_previous_technique].stage_code.."_next", "Disable" )
						OutputEvent( stage_info[self.technique_id - 1].stages[num_stages_previous_technique].stage_code.."_finish_door", "Close" )
					end
					BroadCastSound( "training."..stage_info[self.technique_id].stages[self.stage_number].stage_code..self.step.."_start" )
					
					OutputEvent("steppingstone_*", "Enable")
			
					reset_timeout()
					
					show_current( p )
				end
				
				if p:GetClass() ~= stage_info[self.technique_id].stages[self.stage_number].stage_class then
					------------------
					if stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kScout then
						ApplyToPlayer( p, {AT.kChangeClassScout} )
						p:RemoveAllWeapons()
						reset_stock( p )
					end
				end
				
				if self.step == 1 then
					p:SpeedMod( .5 )
				elseif self.step == 2 then
					p:SpeedMod( .75 )
				else
					p:SpeedMod( 1.0 )
				end
				
			end
		end
	end
end


move_bhop_finish = trigger_ff_script:new({ technique_id = 0, stage_number = 0, step = 0 })

function move_bhop_finish:ontouch( touch_entity ) 
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				
				BroadCastSound( "misc.doop" )
				
				p:RemoveAllWeapons()
				p:SetGravity( 1.0 )
				p:SpeedMod( 1.0 )
				
				reset_timeout()
				OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code..self.step.."_block", "Enable" )
				
				if self.step == stage_info[self.technique_id].stages[self.stage_number].stage_num_steps then
					BroadCastSound( "training.stage_complete" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_door", "Open" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_door_trigger", "Enable" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_light", "TurnOn" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_sprite", "ShowSprite" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_finish_model", "Skin", "6" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_next", "Enable" )
					
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_tesla", "DoSpark" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_beam", "TurnOff" )
					OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_arrow", "Disable" )
					complete_stage( p )
					
					remove_timeout()
				end
				
			end
		end	
	end
end

-------------------------------------
-- freeze
-------------------------------------

function player_freeze( p, bF )
	p:Freeze( bF )
end

-------------------------------------
-- Multipurpose remove
-------------------------------------

remove_all = trigger_ff_script:new({})

function remove_all:allowed( allowed_entity )
	if not stage_info[current_technique].stages[current_stage].stage_complete and current_technique == JUMP_TECHNIQUES then
		if stage_info[current_technique].stages[current_stage].stage_limits.force_hhconc then
			----ChatToAll( "[training] trigger_remove force_hhconc" )
			if IsGrenade( allowed_entity ) then
				GIVE_GREN2 = true
				return EVENT_ALLOWED
			end
		end
		if stage_info[current_technique].stages[current_stage].stage_limits.force_waterconc then
			----ChatToAll( "[training] trigger_remove force_waterconc" )
			if IsGrenade( allowed_entity ) then
				GIVE_GREN2 = true
				BroadCastMessage( "Throw the conc in the water!" )
				--ApplyToPlayer( player, {AT.kStopPrimedGrens} )
				return EVENT_ALLOWED
			end
		end
	end
	return EVENT_DISALLOWED
end

--- TEMPORARY
v_hhconc_remove = remove_all:new({})
a_hhconc_remove = remove_all:new({})
m_waterconc_remove = remove_all:new({})
a_pipe_remove = remove_all:new({})
v_pipe_remove = remove_all:new({})

-------------------------------------
-- Multipurpose catch
-------------------------------------

catch_all = trigger_ff_script:new({})

function catch_all:ontouch( touch_entity )
	if IsPlayer(touch_entity) then return end
end

function catch_all:ontrigger( touch_entity )
	return
end

function catch_all:onexplode( explode_entity )
	if explode_entity:GetClassName() == "ff_projectile_pl" then
		GIVE_PIPES = true
	elseif explode_entity:GetClassName() == "ff_grenade_concussion" then
		GIVE_GREN2 = true
	end
	return EVENT_ALLOWED
end

-------------------------------------
-- speedrun
-------------------------------------
all_together_start = trigger_ff_script:new({ technique_id = 0, stage_number = 0, sound_played = false })

function all_together_start:ontouch( touch_entity )
	if show_timer then return end
	if not stage_info[self.technique_id].stages[self.stage_number].stage_complete then
		if IsPlayer( touch_entity ) then
			local p = CastToPlayer( touch_entity )
			if not p:IsBot() then
				if not self.sound_played then
				
					self.sound_played = true
					
					if self.stage_number > 1 then
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_next", "Disable" )
						OutputEvent( stage_info[self.technique_id].stages[self.stage_number - 1].stage_code.."_finish_door", "Close" )
					elseif self.technique_id > 1 then
						local num_stages_previous_technique = # stage_info[self.technique_id - 1].stages
						OutputEvent( stage_info[self.technique_id - 1].stages[num_stages_previous_technique].stage_code.."_next", "Disable" )
						OutputEvent( stage_info[self.technique_id - 1].stages[num_stages_previous_technique].stage_code.."_finish_door", "Close" )
					end
					BroadCastSound( "training."..stage_info[self.technique_id].stages[self.stage_number].stage_code.."_start" )
					
					reset_timeout()
					
					show_current( p )
				end
				
				if p:GetClass() ~= stage_info[self.technique_id].stages[self.stage_number].stage_class then
					
					show_key( p )
					
					------------------
					if stage_info[self.technique_id].stages[self.stage_number].stage_class == Player.kScout then
						ApplyToPlayer( p, {AT.kChangeClassScout} )
						p:RemoveAllWeapons()
						reset_stock( p )
					end
				end
			end
		end
	end
end

all_together_init = trigger_ff_script:new({ technique_id = 0, stage_number = 0 })

function all_together_init:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		RemoveTimer( "speedrun_timer" )
		AddTimer( "speedrun_timer", 0, 1 )
		show_timer = true
		OutputEvent( stage_info[self.technique_id].stages[self.stage_number].stage_code.."_init", "Disable" )
		
		player:GiveWeapon( "ff_weapon_crowbar", true )
		player:AddAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kGren2, 4 )
		
		show_current( player )
		
		UpdateObjectiveIcon( player, GetEntityByName( "red_flag" ) )
	end
end

all_together_room = trigger_ff_script:new({ technique_id = 0, stage_number = 0 })

function all_together_room:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	end
end

function all_together_room:ontrigger( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if show_timer and player:IsInUse() then
			RemoveTimer( "speedrun_timer" )
			OutputEvent( "all_scout_init", "Enable" )
			
			show_timer = false
			
			player:RemoveAllWeapons()
			player:RemoveAmmo( Ammo.kGren1, 4 )
			player:RemoveAmmo( Ammo.kGren2, 4 )
			
			show_current( player )
			
			local stage_code = stage_info[current_technique].stages[current_stage].stage_code
			TeleportToEntity( player, stage_code.."_tele_dest" )
			player:SetGravity( 1 )
			player:SpeedMod( 1 )
			ApplyToPlayer( player, { AT.kStopPrimedGrens } )
			ApplyToAll({AT.kRemoveProjectiles})
			local flag = CastToInfoScript(GetEntityByName("red_flag"))
			RemoveHudItem( player, flag:GetName() )	
			flag:Return()
			UpdateObjectiveIcon( player, nil )
		end
	end
end

function OutputTime( timername )
	local timerval = GetTimerTime( timername )
	--ChatToAll("["..timername.."] "..timerval.."s")
	BroadCastMessage( string.format("Time: %.3f seconds", timerval), 10, Color.kBlue )
	return timerval
end

function blue_cap:oncapture(player, item)

	local timerval = OutputTime( "speedrun_timer" )
	
	RemoveTimer( "speedrun_timer" )
	OutputEvent( "all_scout_init", "Enable" )
	
	show_timer = false
	
	player:RemoveAllWeapons()
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	
	if timerval > 0 then
		if best_run == nil then
			best_run = timerval
		else
			if timerval < best_run then
				best_run = timerval
			end
		end
	end
	
	local medal_won = nil
	if timerval <= TIME_FOR_GOLD then
		medal_won = 1
	elseif timerval <= TIME_FOR_SILVER then
		medal_won = 2
	elseif timerval <= TIME_FOR_BRONZE then
		medal_won = 3
	else
		-- only play the capture sound if no medal was won
		SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
	end
	
	if medal_won ~= nil then
		if stage_info[current_technique].stages[current_stage].stage_medal == 0 or stage_info[current_technique].stages[current_stage].stage_medal > medal_won then
			award_medal( player, medal_won )
		end
	end
	
	show_current( player )
	
	local stage_code = stage_info[current_technique].stages[current_stage].stage_code
	TeleportToEntity( player, stage_code.."_tele_dest" )
	player:SetGravity( 1 )
	player:SpeedMod( 1 )
	ApplyToPlayer( player, { AT.kStopPrimedGrens } )
	
	-- let the teams know that a capture occured
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
end

function TeleportToEntity( player, entity_name )
	if GetEntityByName( entity_name ) ~= nil then
		local neworigin = GetEntityByName( entity_name ):GetOrigin()
		neworigin = Vector(neworigin.x,neworigin.y,neworigin.z+36+16)
		local newangles = GetEntityByName( entity_name ):GetAngles()
		local newvelocity = Vector(0,0,0)
		player:Teleport( neworigin, newangles, newvelocity )
		return true
	else
		return false
	end
end

-------------------------------------
-- Change class triggers
-------------------------------------
ChangeClass = trigger_ff_script:new({ class=Player.kScout, changeclass=AT.kChangeClassScout })

function ChangeClass:ontouch( touch_entity ) 
	if IsPlayer( touch_entity ) then
		local p = CastToPlayer( touch_entity )
		if not p:IsBot() then
			------------------
			ApplyToPlayer( p, {self.changeclass} )
			p:RemoveAllWeapons()
			reset_stock( p )
			------------------
		end
	end
end

ChangeClass_Scout = ChangeClass:new({ class=Player.kScout, changeclass=AT.kChangeClassScout })
ChangeClass_Medic = ChangeClass:new({ class=Player.kMedic, changeclass=AT.kChangeClassMedic })
ChangeClass_Civilian = ChangeClass:new({ class=Player.kCivilian, changeclass=AT.kChangeClassCivilian })

-------------------------------------
-- OnPrime
-------------------------------------

function player_spawn( player )
	if IsPlayer( player ) then
		BroadCastSound( "training.intro" )
	end
end

function player_onprimegren1( player_id )
	----ChatToAll( "[training] gren1 primed" )
	local player = GetPlayer(player_id)
	if stage_info[current_technique].stages[current_stage].stage_code == "v_frag" then
		AddSchedule("gren2prime3", .85, message, "3")
		AddSchedule("gren2prime2", 1.85, message, "2")
		AddSchedule("gren2prime1", 2.85, message, "1")
		AddSchedule("gren2prime", 3.85, message, "Jump!")
	end
end

function player_onprimegren2( player_id )
	----ChatToAll( "[training] gren2 primed" )
	local player = GetPlayer(player_id)
	
	if stage_info[current_technique].stages[current_stage].stage_type == VERTICAL_JUMP or stage_info[current_technique].stages[current_stage].stage_type == MISC_JUMP then
		increment_failed(player, 1)
		reset_timeout()
	end
	
	if stage_info[current_technique].stages[current_stage].stage_code == "v_conc" then
		AddSchedule("gren2prime3", .5, message, "3")
		AddSchedule("gren2prime2", 1.5, message, "2")
		AddSchedule("gren2prime1", 2.5, message, "1")
		AddSchedule("gren2prime", 3.5, message, "Jump!")
		AddSchedule("gren2primeremove", 3.6, removeprimed, player)
	elseif stage_info[current_technique].stages[current_stage].stage_code == "a_conc" then
		AddSchedule("gren2prime3", .5, message, "3")
		AddSchedule("gren2prime2", 1.5, message, "2")
		AddSchedule("gren2prime1", 2.5, message, "1")
		AddSchedule("gren2prime", 3.5, message, "Jump!")
		AddSchedule("gren2primeremove", 3.6, removeprimed, player)
	elseif stage_info[current_technique].stages[current_stage].stage_code == "v_hhconc" then
		AddSchedule("gren2prime3", .85, message, "3")
		AddSchedule("gren2prime2", 1.85, message, "2")
		AddSchedule("gren2prime1", 2.85, message, "1")
		AddSchedule("gren2prime", 3.85, message, "Jump!")
	elseif stage_info[current_technique].stages[current_stage].stage_code == "a_hhconc" then
		AddSchedule("gren2prime3", .5, message, "3")
		AddSchedule("gren2prime2", 1.5, message, "2")
		AddSchedule("gren2prime1", 2.5, message, "1")
		AddSchedule("gren2prime", 3.5, message, "Jump!")
	end
end

function player_onthrowgren1( player, primed )
	----ChatToAll( "[training] gren1 thrown" )
	return EVENT_ALLOWED
end

function player_onthrowgren2( player, primed )
	----ChatToAll( "[training] gren2 thrown" )
	if stage_info[current_technique].stages[current_stage].stage_code == "v_hhconc" or stage_info[current_technique].stages[current_stage].stage_code == "a_hhconc" then
		BroadCastMessage( "Do not throw the conc when Hand-Held Conc Jumping!" )
		GIVE_GREN2 = true
		RemoveSchedule("gren2prime3")
		RemoveSchedule("gren2prime2")
		RemoveSchedule("gren2prime1")
		RemoveSchedule("gren2prime")
		--ApplyToPlayer( player, {AT.kStopPrimedGrens} )
		return EVENT_DISALLOWED
	end
	
	if stage_info[current_technique].stages[current_stage].stage_code == "v_conc" or stage_info[current_technique].stages[current_stage].stage_code == "a_conc" then
		RemoveSchedule("gren2primeremove")
		return EVENT_ALLOWED
	end
	
	return EVENT_ALLOWED
end

-----------------------------------------------------------------------------
-- On damage
-----------------------------------------------------------------------------
function player_ondamage( player, damageinfo )
	----ChatToAll( "[training] player ondamage" )
	if not damageinfo then
		return
	end

	damageinfo:SetDamage(0)
	
	local weapon = damageinfo:GetInflictor():GetClassName()
  
	if weapon == "ff_projectile_rocket" then
		player:RemoveAllWeapons()
		if stage_info[current_technique].stages[current_stage].stage_type == VERTICAL_JUMP then
			increment_failed(player, 1)
			reset_timeout()
		end
	end
	
	if weapon == "ff_projectile_pl" then
		player:RemoveAllWeapons()
		if stage_info[current_technique].stages[current_stage].stage_type == VERTICAL_JUMP then
			increment_failed(player, .5)
			reset_timeout()
		end
	end
	
end

-------------------------------------
-- Vertical Jump Markers
-------------------------------------
VerticalJumpMarker = trigger_ff_script:new({ message = "Touched", number = 0 })

function VerticalJumpMarker:ontouch( touch_entity ) 
	if VERTICAL_JUMP_BROADCASTED == 0 then
	if IsPlayer( touch_entity ) then
		local p = CastToPlayer( touch_entity )
		if not p:IsBot() then
			if self.number > VERTICAL_JUMP_TOUCHED then
				-------------
				----ChatToAll( "[training] Upped to: " .. self.number )
				--------------
				VERTICAL_JUMP_TOUCHED = self.number
				VERTICAL_JUMP_MESSAGE = self.message
				if self.number == 10 then
					BroadCastSound ( "misc.doop" )
					OutputEvent( stage_info[current_technique].stages[current_stage].stage_code.."_tesla", "DoSpark" )
					OutputEvent( stage_info[current_technique].stages[current_stage].stage_code.."_beam", "TurnOff" )
					OutputEvent( stage_info[current_technique].stages[current_stage].stage_code.."_arrow", "Disable" )
					complete_stage( p )
				end
			else
				BroadCastMessage( VERTICAL_JUMP_MESSAGE )
				VERTICAL_JUMP_BROADCASTED = 1
				reset_timeout()
			end
		end
	end	
	end
end

function VerticalJumpMarker:onendtouch() 

end

-------------------------------------
-- Declare Veritical Jump Markers
-------------------------------------
Jump1			= VerticalJumpMarker:new({ message="Not Quite", number=1 })
Jump2			= VerticalJumpMarker:new({ message="Nice Try", number=2 })
Jump3			= VerticalJumpMarker:new({ message="Keep it up", number=3 })
Jump4			= VerticalJumpMarker:new({ message="Good Effort", number=4 })
Jump5			= VerticalJumpMarker:new({ message="You're Getting It", number=5 })
Jump6			= VerticalJumpMarker:new({ message="Good, but still a ways to go", number=6 })
Jump7			= VerticalJumpMarker:new({ message="Great, but not quite", number=7 })
Jump8			= VerticalJumpMarker:new({ message="Almost There", number=8 })
Jump9			= VerticalJumpMarker:new({ message="So Close...", number=9 })
Jump10			= VerticalJumpMarker:new({ message="Complete!", number=10 })


function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )
	
	current_y = 0
	
	for i,v in ipairs(stage_info) do
		
		heading_complete = true
		for i2,v2 in ipairs(v.stages) do
			if not v2.stage_complete then
				heading_complete = false
				break
			end
		end
		
		RemoveHudItem( player, "Checklist_Header"..i )
		RemoveHudItem( player, "Checklist_Header_text"..i )
		RemoveHudItem( player, "Checklist_Header"..i.."_check" )
		
		AddHudIcon( player, "hud_statusbar_256.vtf", "Checklist_Header"..i, 10, current_y + 10, 136, 16, 1 )
		if heading_complete then
			AddHudText( player, "Checklist_Header_text"..i, v.technique_name, 127, current_y + 14, 5 )
			AddHudIcon( player, "hud_checkmark.vtf", "Checklist_Header"..i.."_check", 124, current_y + 6, 20, 20, 1 )
		else
			AddHudText( player, "Checklist_Header_text"..i, v.technique_name, 140, current_y + 14, 5 )
		end
		
		RemoveHudItem( player, "Checklist_BG"..i )
		
		if i == current_technique then
			if # v.stages > 2 then
				AddHudIcon( player, "hud_statusbar_256_128.vtf", "Checklist_BG"..i, 10, current_y + 28, 136,  10 + # v.stages * 10, 1 )
			else
				AddHudIcon( player, "hud_statusbar_256.vtf", "Checklist_BG"..i, 10, current_y + 28, 136,  10 + # v.stages * 10, 1 )
			end
		end
		for i2,v2 in ipairs(v.stages) do
			RemoveHudItem( player, "Checklist_Item"..i.."-"..i2 )
			RemoveHudItem( player, "Checklist_Item"..i.."-"..i2.."_check" )
			
			if i == current_technique then
				if v2.stage_complete then
					AddHudIcon( player, "hud_checkmark.vtf", "Checklist_Item"..i.."-"..i2.."_check", 132, current_y + 22 + i2 * 10, 10, 10, 1 )
				elseif i2 == current_stage and i == current_technique then
					AddHudIcon( player, "hud_current_arrow.vtf", "Checklist_Item"..i.."-"..i2.."_check", 132, current_y + 23 + i2 * 10, 10, 10, 1 )
				end
				AddHudText( player, "Checklist_Item"..i.."-"..i2, v2.stage_checklist, 130, current_y + 24 + i2 * 10, 5 )
			end
		end
		
		if i == current_technique then
			current_y = current_y + 32 + # v.stages * 10
		else
			current_y = current_y + 20
		end
	
	end
	
	show_current( player )
end


function message( text )
	BroadCastMessage( text )
end

function disable( entity )
	ConsoleToAll( entity.." you are nuts" )
	OutputEvent( entity, "Disable" )
end