-- base_fortball.lua

-- if you want base fortball with the default setup, 
-- include base_fortball_default.lua in your map's lua file 
-- and then include base_fortball.lua

-- precache (sounds)
function precache()
	PrecacheSound("misc.bizwarn")
	PrecacheSound("misc.bloop")
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.dadeda")
	PrecacheSound("misc.deeoo")
	PrecacheSound("misc.doop")
	PrecacheSound("misc.woop")

	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")

	-- Unagi Power!  Unagi!
	PrecacheSound("misc.unagi_spatial")

	-- goalie sounds
	--PrecacheSound( goalie_sound_loop )
	--PrecacheSound( goalie_sound_idle )
	--PrecacheSound( goalie_sound_pain )
	--PrecacheSound( goalie_sound_kill )
end

function startup()
	SetGameDescription( "Fortball" )

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

	local ball = GetEntityByName( "ball" )
	for i,v in pairs(teams) do
		objective_entities[v] = ball
	end

	the_wall_reset()

end

function the_wall_reset()
	OutputEvent( "the_wall", "Enable" )
	OutputEvent( "the_wall_laser_blue", "TurnOn" )
	OutputEvent( "the_wall_laser_red", "TurnOn" )
	AddSchedule("the_wall_disable", THE_WALL_TIMER_DISABLE, the_wall_disable )
	AddSchedule("the_wall_10secwarn", THE_WALL_TIMER_WARN, the_wall_10secwarn )
end

function the_wall_disable()
	OutputEvent( "the_wall", "Disable" )
	OutputEvent( "the_wall_laser_blue", "TurnOff" )
	OutputEvent( "the_wall_laser_red", "TurnOff" )
	BroadCastMessage("#FF_ROUND_STARTED")
	BroadCastSound("otherteam.flagstolen")
end

function the_wall_10secwarn()
	BroadCastMessage("#FF_MAP_10SECWARN")
	AddSchedule("the_wall_9secwarn", 1, the_wall_9secwarn )
end

function the_wall_9secwarn()
	BroadCastMessage("#FF_MAP_9SECWARN")
	AddSchedule("the_wall_8secwarn", 1, the_wall_8secwarn )
end

function the_wall_8secwarn()
	BroadCastMessage("#FF_MAP_8SECWARN")
	AddSchedule("the_wall_7secwarn", 1, the_wall_7secwarn )
end

function the_wall_7secwarn()
	BroadCastMessage("#FF_MAP_7SECWARN")
	AddSchedule("the_wall_6secwarn", 1, the_wall_6secwarn )
end

function the_wall_6secwarn()
	BroadCastMessage("#FF_MAP_6SECWARN")
	AddSchedule("the_wall_5secwarn", 1, the_wall_5secwarn )
end

function the_wall_5secwarn()
	BroadCastMessage("#FF_MAP_5SECWARN")
	SpeakAll( "AD_5SEC" )
	AddSchedule("the_wall_4secwarn", 1, the_wall_4secwarn )
end

function the_wall_4secwarn()
	BroadCastMessage("#FF_MAP_4SECWARN")
	SpeakAll( "AD_4SEC" )
	AddSchedule("the_wall_3secwarn", 1, the_wall_3secwarn )
end

function the_wall_3secwarn()
	BroadCastMessage("#FF_MAP_3SECWARN")
	SpeakAll( "AD_3SEC" )
	AddSchedule("the_wall_2secwarn", 1, the_wall_2secwarn )
end

function the_wall_2secwarn()
	BroadCastMessage("#FF_MAP_2SECWARN")
	SpeakAll( "AD_2SEC" )
	AddSchedule("the_wall_1secwarn", 1, the_wall_1secwarn )
end

function the_wall_1secwarn()
	BroadCastMessage("#FF_MAP_1SECWARN")
	SpeakAll( "AD_1SEC" )
end

function goalie_bounds_notification(player)
	BroadCastSoundToPlayer( player, "misc.buzwarn" )
	BroadCastMessageToPlayer(player, "#FF_WATERPOLO_GOALIE_BOUNDS")
end

function reset_ball_carrier()
	if ball_carrier ~= nil and IsPlayer( ball_carrier ) then
		local player = CastToPlayer(ball_carrier)
		UpdateObjectiveIcon( player, objective_entities[player:GetTeamId()] )
		if not BALL_ALWAYS_ENEMY_OBJECTIVE then
			local enemy_team = team_info[player:GetTeamId()].enemy_team
			objective_entities[enemy_team] = GetEntityByName( "ball" )
			UpdateTeamObjectiveIcon( GetTeam(enemy_team), objective_entities[enemy_team] )
		end
	end
	ball_carrier = nil
end

-- Give everyone a full resupply, but strip grenades
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )

	-- god damn right
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )

	-- goalies run fast
	if player:GetClass() ~= Player.kCivilian then
		player:RemoveEffect( EF.kSpeedlua1 )
	else
		player:AddEffect( EF.kSpeedlua1, -1, 0, GOALIE_SPEED )

		-- stop the goalie loop sound
		--player:StopSound( goalie_sound_loop )

		-- play the goalie loop sound
		--player:EmitSound( goalie_sound_loop )
	end

	-- objective
	UpdateObjectiveIcon( player, objective_entities[player:GetTeamId()] )
end

function player_onkill( player )
	-- stop the goalie loop sound
	--if player:GetClass() == Player.kCivilian then
		--player:StopSound( goalie_sound_loop )
	--end

	return true
end

function player_killed( player )
	-- stop the goalie loop sound
	--if player:GetClass() == Player.kCivilian then
		--player:StopSound( goalie_sound_loop )
	--end
end

function player_switchteam( player, currentteam, desiredteam )

	-- stop the goalie loop sound
	--if player:GetClass() == Player.kCivilian then
		--player:StopSound( goalie_sound_loop )
	--end

	return true

end

function player_disconnected( player )

	if ball_carrier ~= nil then
		if ball_carrier:GetId() == player:GetId() then
			reset_ball_carrier()
		end
	end

	-- stop the goalie loop sound
	--if player:GetClass() == Player.kCivilian then
		--player:StopSound( goalie_sound_loop )
	--end

end

function remove_hud_items(ball, player)

	RemoveHudItem( player, ball:GetName() )

	local team = player:GetTeamId()

	if (team == TEAM1) then
		RemoveHudItemFromAll( "ball-icon-blue" )
	elseif (team == TEAM2) then
		RemoveHudItemFromAll( "ball-icon-red" )
	end

end

function player_ondamage( player, damageinfo )
	-- goalies have "UNAGI POWER, UNAGI!"
	local attacker = damageinfo:GetAttacker()
	if IsPlayer( attacker ) then
		attacker = CastToPlayer( attacker )
		if attacker:GetClass() == Player.kCivilian and attacker:GetTeamId() ~= player:GetTeamId() then
			ConsoleToAll( "Goalie, " .. attacker:GetName() .. ", has UNAGI POWER, UNAGI!" )
			--attacker:EmitSound("misc.unagi_spatial")
			attacker:AddFortPoints( POINTS_PER_GOALIE_ATTACK, "#FF_FORTPOINTS_GOALIE_ATTACK" )
			damageinfo:ScaleDamage(69)
			--attacker:EmitSound( goalie_sound_kill )
		elseif attacker:GetClass() == Player.kSniper and player:GetClass() ~= Player.kCivilian then
			-- snipers do less damage to non-goalies
			damageinfo:ScaleDamage(0.1)
		end
	end

	if player:GetClass() == Player.kCivilian then

		if player:GetTeamId() == player:GetLocationTeam() then

			-- goalies are invincible in their team's locations
			damageinfo:ScaleDamage(0)
			--player:EmitSound( goalie_sound_idle )

		else

			-- goalies take more damage outside their team's locations
			damageinfo:ScaleDamage(3)
			--player:EmitSound( goalie_sound_pain )

		end

	end
end


-----------------------------------------------------------------------------
-- ball information
-- status: 0 = home, 1 = carried, 2 = dropped
-----------------------------------------------------------------------------
base_ball = info_ff_script:new({
	name = "base ball",
	team = Team.kUnassigned,
	model = "models/items/ball/ball.mdl",
	modelskin = 0,
	tosssound = "Flag.toss",
	dropnotouchtime = 0,
	capnotouchtime = 2,
	hudicon = "hud_ball",
	hudx = 5,
	hudy = 210,
	hudwidth = 48,
	hudheight = 48,
	hudalign = 1, 
	hudstatusiconbluex = 60,
	hudstatusiconbluey = 5,
	hudstatusiconredx = 60,
	hudstatusiconredy = 5,
	hudstatusiconblue = "hud_ball.vtf",
	hudstatusiconred = "hud_ball.vtf",
	hudstatusiconw = 15,
	hudstatusiconh = 15,
	hudstatusiconbluealign = 2,
	hudstatusiconredalign = 3,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed},
	botgoaltype = Bot.kFlag,
	status = 0
})

function base_ball:hasanimation() return false end
function base_ball:usephysics() return true end

function base_ball:touch( touch_entity )
	if IsPlayer( touch_entity ) then

		local player = CastToPlayer( touch_entity )
		if self.notouch[player:GetId()] then return end

		local ball = CastToInfoScript( entity )

		if player:GetClass() ~= Player.kCivilian then
			-- if the player is a spy, then force him to lose his disguise
			player:SetDisguisable( false )
			player:SetCloakable( false )

			ConsoleToAll( player:GetName() .. " has the ball!" )
			--SmartSound( player, "misc.bloop", "misc.bloop", "misc.bloop" )
			SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
			SmartSpeak(player, "CTF_YOUHAVEBALL", "CTF_TEAMHASBALL", "CTF_ENEMYHASBALL")
			SmartMessage( player, "#FF_WATERPOLO_YOU_PICKUP", "#FF_WATERPOLO_TEAM_PICKUP", "#FF_WATERPOLO_ENEMY_PICKUP", Color.kGreen, Color.kGreen, Color.kRed )
			ball:Pickup( player )

			AddHudIcon( player, self.hudicon, ball:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
			local team = player:GetTeamId()
			if (team == TEAM1) then
				AddHudIconToAll( self.hudstatusiconblue, "ball-icon-blue", self.hudstatusiconbluex, self.hudstatusiconbluey, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconbluealign )
			elseif (team == TEAM2) then
				AddHudIconToAll( self.hudstatusiconred, "ball-icon-red", self.hudstatusiconredx, self.hudstatusiconredy, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconredalign )
			end

			-- 100 points for initial touch on ball
			if self.status == 0 then player:AddFortPoints(POINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
			self.status = 1

			UpdateObjectiveIcon( player, goal_entities[player:GetTeamId()] )
			ball_carrier = player

			if not BALL_ALWAYS_ENEMY_OBJECTIVE then
				local enemy_team = team_info[player:GetTeamId()].enemy_team
				objective_entities[enemy_team] = nil
				UpdateTeamObjectiveIcon( GetTeam(enemy_team), objective_entities[enemy_team] )
			end

		-- goalies return the ball
		else
			if ball:IsDropped() then
				-- if pressing +use
				if player:IsInUse() then
					ConsoleToAll( "Goalie, " .. player:GetName() .. ", returned the ball!" )
					SmartSound( player, "misc.deeoo", "misc.deeoo", "misc.deeoo" )
					SmartMessage( player, "#FF_WATERPOLO_YOU_RETURN", "#FF_WATERPOLO_TEAM_GOALIE_RETURN", "#FF_WATERPOLO_ENEMY_GOALIE_RETURN" )
					player:AddFortPoints( POINTS_PER_GOALIE_RETURN, "#FF_FORTPOINTS_GOALIE_RETURN" )
					ball:Return()
					self.status = 0
				else
					BroadCastMessageToPlayer(player, "#FF_WATERPOLO_USE_RETURN")
				end
			end
		end
	end
end

function base_ball:onownerdie( owner_entity )
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		-- drop the ball
		ConsoleToAll( player:GetName() .. " died and dropped the ball!" )
		local ball = CastToInfoScript( entity )
		ball:Drop(BALL_RETURN_TIME, 0.0)
		remove_hud_items(ball, player)
		self.status = 2

		reset_ball_carrier()
	end
end

function base_ball:ownercloak( owner_entity )
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		-- drop the ball
		ConsoleToAll( player:GetName() .. " cloaked and dropped the ball!" )
		local ball = CastToInfoScript( entity )
		ball:Drop(BALL_RETURN_TIME, 0.0)
		remove_hud_items(ball, player)
		self.status = 2

		reset_ball_carrier()
	end
end

function base_ball:ownerfeign( owner_entity )
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		-- drop the ball
		ConsoleToAll( player:GetName() .. " feigned and dropped the ball!" )
		local ball = CastToInfoScript( entity )
		ball:Drop(BALL_RETURN_TIME, 0.0)
		remove_hud_items(ball, player)
		self.status = 2

		reset_ball_carrier()
	end
end

function base_ball:dropitemcmd( drop_entity )
	if IsPlayer( drop_entity ) then
		-- throw the ball
		local ball = CastToInfoScript( entity )

		local player = CastToPlayer( drop_entity )
		if not player:IsInUse() then
			ball:Drop(BALL_RETURN_TIME, BALL_THROW_SPEED)
		else
			ball:Drop(BALL_RETURN_TIME, BALL_THROW_SPEED * 0.333)
		end

		ConsoleToAll( player:GetName() .. " passed the ball!" )
		remove_hud_items(ball, player)
		self.status = 2

		reset_ball_carrier()
	
		SmartSound( player, "misc.woop", "misc.woop", "misc.woop" )
	
		-- Make it so the player can't touch the ball for 1 second
		-- (so it can't be thrown and not stick to the player)
		self:addnotouch(player:GetId(), 1)
	end
end

function base_ball:ondrop( owner_entity )
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		-- let the teams know that the flag was dropped
		SmartSound(player, "yourteam.drop", "yourteam.drop", "otherteam.drop")
		SmartMessage(player, "#FF_YOUBALLDROP", "#FF_TEAMBALLDROP", "#FF_ENEMYBALLDROP", Color.kYellow, Color.kYellow, Color.kYellow)
	end
	
	local ball = CastToInfoScript(entity)
	ball:EmitSound(self.tosssound)
end

function base_ball:onloseitem( owner_entity )
	if IsPlayer( owner_entity ) then
		-- let the player that lost the ball put on a disguise
		local player = CastToPlayer( owner_entity )
		player:SetDisguisable(true)
		player:SetCloakable( true )
	
		self:addnotouch(player:GetId(), self.capnotouchtime)
	end
end

function base_ball:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
	self.status = 0
end

function base_ball:addnotouch( player_id, duration )
	self.notouch[player_id] = duration
	AddSchedule(self.name .. "-" .. player_id, duration, self.removenotouch, self, player_id)
end

function base_ball.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

-- For when this object is carried, these offsets are used to place
-- the info_ff_script relative to the players feet
function base_ball:attachoffset()
	-- x = forward/backward
	-- y = left/right
	-- z = up/down
	local offset = Vector( 32, 0, 0 )
	return offset
end

function base_ball:precache()
	PrecacheSound(self.tosssound)
	info_ff_script.precache(self)
end

function base_ball:onreturn()
	ConsoleToAll( "The ball has returned!" )
	SpeakAll ( "CTF_BALLRETURN" )
	BroadCastMessage( "#FF_WATERPOLO_BALL_RETURN", Color.kYellow )
	self.status = 0

	reset_ball_carrier()
end

ball = base_ball:new({
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed},
	botgoaltype = Bot.kFlag
})




-- generic goal
base_goal = trigger_ff_script:new({
	health = 100,
	armor = 300,
	grenades = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	detpacks = 0,
	mancannons = 0,
	gren1 = 0,
	gren2 = 0,
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap
})

function base_goal:spawn()
	if self.team ~= Team.kUnassigned then
		goal_entities[self.team] = entity
	end
end

function base_goal:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then		
		-- player has to be carrying the item
		local player = CastToPlayer( allowed_entity )
		return player:HasItem( self.item )
	end

	return EVENT_DISALLOWED
end

function base_goal:ontrigger ( trigger_entity )
	if IsPlayer( trigger_entity ) then

		-- player should capture now
		local player = CastToPlayer( trigger_entity )
		if player:HasItem( self.item ) then
			local team = GetTeam( self.team )
			team:AddScore( POINTS_PER_CAPTURE )
			ConsoleToAll( team:GetName() .. " team scores!" )

			local ball = GetInfoScriptByName( self.item )
			ball:Return()

			remove_hud_items(ball, player)

			if player:GetTeamId() == self.team then
				ConsoleToAll( player:GetName() .. " scored a goal!" )
				-- show on the deathnotice board
				ObjectiveNotice( player, "scored a goal" )
				SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
				SmartSpeak(player, "CTF_YOUSCORE", "CTF_TEAMSCORE", "CTF_THEYSCORE")
				SmartMessage( player, "#FF_WATERPOLO_YOU_GOAL", "#FF_WATERPOLO_TEAM_GOAL", "#FF_WATERPOLO_ENEMY_GOAL", Color.kGreen, Color.kGreen, Color.kRed)
				player:AddFortPoints( POINTS_PER_CAPTURE * 100, "#FF_FORTPOINTS_GOAL" )
			else
				ConsoleToAll( player:GetName() .. " scored an own goal!\nWait, what?!  Kill him like that Columbian a few years ago!  OWN GOAL!  OWN GOAL!" )
				-- show on the deathnotice board
				ObjectiveNotice( player, "scored an own goal" )
				SmartSound(player, "otherteam.flagcap", "otherteam.flagcap", "yourteam.flagcap")
				SmartSpeak(player, "CTF_THEYSCORE", "CTF_THEYSCORE", "CTF_TEAMSCORE")
				SmartMessage( player, "#FF_WATERPOLO_YOU_OWN_GOAL", "#FF_WATERPOLO_TEAM_OWN_GOAL", "#FF_WATERPOLO_ENEMY_OWN_GOAL", Color.kRed, Color.kRed, Color.kGreen)
				player:AddFortPoints( -POINTS_PER_CAPTURE * 100, "#FF_FORTPOINTS_OWN_GOAL" )
			end

			ApplyToAll({ AT.kRespawnPlayers, AT.kReloadClips })

			the_wall_reset()
		end
	end
end

-- on blue's side of map, but points go to red
blue_goal = base_goal:new({ item = "ball", team = TEAM2 })

-- on red's side of map, but points go to blue
red_goal = base_goal:new({ item = "ball", team = TEAM1 })




-- respawns a goalie
base_goalie_respawner = trigger_ff_script:new({ team = Team.kUnassigned })

function base_goalie_respawner:ontouch( trigger_entity )

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		if player:GetClass() == Player.kCivilian and player:GetTeamId() == self.team then
			-- respawn the goalie
			ApplyToPlayer(player, { AT.kRespawnPlayers })
			AddSchedule("goalie_bounds_notification_" .. player:GetId(), 0.1, goalie_bounds_notification, player )
		end
	end

end

-- goalie respawner
blue_goalie_respawner = base_goalie_respawner:new({ team = TEAM1 })
red_goalie_respawner = base_goalie_respawner:new({ team = TEAM2 })




-- returns the item
base_item_returner = trigger_ff_script:new({ item = "", message = "" })

function base_item_returner:allowed ( allowed_entity )

	if IsPlayer( allowed_entity ) then
		-- player has to be carrying the item or be a goalie
		local player = CastToPlayer( allowed_entity )
		if player:HasItem( self.item ) or player:GetClass() == Player.kCivilian then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED

end

function base_item_returner:ontrigger ( trigger_entity )

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		if player:GetClass() ~= Player.kCivilian then
			-- return the item
			local item = GetInfoScriptByName( self.item )
			item:Return()
			remove_hud_items(item, player)
			ConsoleToAll( player:GetName() .. self.message )
			SpeakAll ( "CTF_BALLRETURN" )
			SmartMessage( player, "#FF_WATERPOLO_YOU_BOUNDS", "#FF_WATERPOLO_TEAM_BOUNDS", "#FF_WATERPOLO_ENEMY_BOUNDS", Color.kYellow, Color.kYellow, Color.kYellow )
		else
			-- respawn the goalie
			ApplyToPlayer(player, { AT.kRespawnPlayers })
			AddSchedule("goalie_bounds_notification_" .. player:GetId(), 0.1, goalie_bounds_notification, player )
		end
	end

end

-- ball stripper
ball_stripper = base_item_returner:new({ item = "ball", message = " took the ball out of bounds!" })

-- spawn ammo packs
waterpolo_pack_spawn_blue = blue_ammobackpack
waterpolo_pack_spawn_red = red_ammobackpack

fortball_pack_spawn_blue = blue_ammobackpack
fortball_pack_spawn_red = red_ammobackpack

-- unique fortball spawns (goalies spawn on top of the goal)
bluespawn = { validspawn = function(self,player) return player:GetTeamId() == TEAM1 and player:GetClass() ~= Player.kCivilian and player:GetClass() ~= Player.kSniper end }
redspawn = { validspawn = function(self,player) return player:GetTeamId() == TEAM2 and player:GetClass() ~= Player.kCivilian and player:GetClass() ~= Player.kSniper end }
bluespawn_goalie = { validspawn = function(self,player) return player:GetTeamId() == TEAM1 and player:GetClass() == Player.kCivilian end }
redspawn_goalie = { validspawn = function(self,player) return player:GetTeamId() == TEAM2 and player:GetClass() == Player.kCivilian end }
bluespawn_sniper = { validspawn = function(self,player) return player:GetTeamId() == TEAM1 and player:GetClass() == Player.kSniper end }
redspawn_sniper = { validspawn = function(self,player) return player:GetTeamId() == TEAM2 and player:GetClass() == Player.kSniper end }


-----------------------------------------------------------------------------
-- unique fortball locations
-----------------------------------------------------------------------------
location_ballsonia = location_info:new({ text = "Ballsonia", team = Team.kUnassigned })
location_midfield = location_info:new({ text = "Midfield", team = Team.kUnassigned })
location_blue_side = location_info:new({ text = "Blue Side", team = TEAM1 })
location_red_side = location_info:new({ text = "Red Side", team = TEAM2 })
location_blue_goal = location_info:new({ text = "Blue Goal", team = TEAM1 })
location_red_goal = location_info:new({ text = "Red Goal", team = TEAM2 })
location_upper_deck = location_info:new({ text = "Upper Deck", team = Team.kUnassigned })
location_blue_upper_deck = location_info:new({ text = "Blue Upper Deck", team = TEAM1 })
location_red_upper_deck = location_info:new({ text = "Red Upper Deck", team = TEAM2 })
location_nose_bleeds = location_info:new({ text = "Nose Bleeds", team = Team.kUnassigned })
location_blue_nose_bleeds = location_info:new({ text = "Blue Nose Bleeds", team = TEAM1 })
location_red_nose_bleeds = location_info:new({ text = "Red Nose Bleeds", team = TEAM2 })
location_rainy_sky = location_info:new({ text = "Rainy Sky", team = Team.kUnassigned })
location_death_hills = location_info:new({ text = "Death Hills", team = Team.kUnassigned })
location_sideroom1 = location_info:new({ text = "Side Room 1", team = Team.kUnassigned })
location_sideroom2 = location_info:new({ text = "Side Room 2", team = Team.kUnassigned })

