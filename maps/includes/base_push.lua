-- base_push.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

BALL_THROW_SPEED = 512;
BALL_RETURN_TIME = 120;

-----------------------------------------------------------------------------
-- Some Global Stuff!
-----------------------------------------------------------------------------
function startup()
	SetGameDescription( "Push" )
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- push maps generally don't have civilians, so override in map LUA file if you want 'em
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kCivilian, -1 ) 
	team:SetClassLimit( Player.kEngineer, -1 )

	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
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
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kManCannon, 1 )

	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
end

-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------
push_backpack = genericbackpack:new({ 
	health = 25,
	armor = 50,
	touchsound = "ArmorKit.Touch",
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	botgoaltype = Bot.kBackPack_Health
})

function push_backpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- base_ball
-----------------------------------------------------------------------------
base_ball = info_ff_script:new({
	name = "base ball",
	team = Team.kUnassigned,
	model = "models/items/ball/ball.mdl",
	modelskin = 0,
	tosssound = "Flag.Toss",
	dropnotouchtime = 2,
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

	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen},
	botgoaltype = Bot.kFlag
})

function base_ball:hasanimation() return true end

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
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	info_ff_script.precache(self)
end

function base_ball:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
end

function base_ball:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule(self.name .. "-" .. player_id, duration, self.removenotouch, self, player_id)	
end

function base_ball.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

function base_ball:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		-- pickup if they can
		if self.notouch[player:GetId()] then return; end
	
		if player:GetTeamId() ~= self.team then
			-- let the teams know that the ball was picked up
			SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
			SmartSpeak(player, "CTF_YOUHAVEBALL", "CTF_TEAMHASBALL", "CTF_ENEMYHASBALL")
			SmartMessage(player, "#FF_YOUHAVEBALL", "#FF_TEAMHASBALL", "#FF_ENEMYHASBALL", Color.kGreen, Color.kGreen, Color.kRed)
			
			-- if the player is a spy, then force him to lose his disguise
			player:SetDisguisable( false )
			-- if the player is a spy, then force him to lose his cloak
			player:SetCloakable( false )
			
			-- note: this seems a bit backwards (Pickup verb fits Player better)
			local ball = CastToInfoScript(entity)
			ball:Pickup(player)
			AddHudIcon( player, self.hudicon, ball:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )


			RemoveHudItemFromAll( "ball-icon-dropped" )
			local team = player:GetTeamId()
			if (team == Team.kBlue) then
				AddHudIconToAll( self.hudstatusiconblue, "ball-icon-blue", self.hudstatusiconbluex, self.hudstatusiconbluey, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconbluealign )
			elseif (team == Team.kRed) then
				AddHudIconToAll( self.hudstatusiconred, "ball-icon-red", self.hudstatusiconredx, self.hudstatusiconredy, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconredalign )
			end

		end
	end
end

function base_ball:onownerdie( owner_entity )
	-- drop the ball
	local ball = CastToInfoScript(entity)
	ball:Drop(BALL_RETURN_TIME, 0.0)
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		RemoveHudItem( player, ball:GetName() )

		local team = player:GetTeamId()
			if (team == Team.kBlue) then
				RemoveHudItemFromAll( "ball-icon-blue" )
			elseif (team == Team.kRed) then
				RemoveHudItemFromAll( "ball-icon-red" )
			end
	end
end
function base_ball:ownerfeign( owner_entity )
	-- drop the ball
	local ball = CastToInfoScript(entity)
	ball:Drop(BALL_RETURN_TIME, 0.0)
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		RemoveHudItem( player, ball:GetName() )
		local team = player:GetTeamId()
			if (team == Team.kBlue) then
				RemoveHudItemFromAll( "ball-icon-blue" )
			elseif (team == Team.kRed) then
				RemoveHudItemFromAll( "ball-icon-red" )
			end
	end
end
function base_ball:dropitemcmd( owner_entity )
	-- throw the ball
	local ball = CastToInfoScript(entity)
	ball:Drop(BALL_RETURN_TIME, BALL_THROW_SPEED)
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		RemoveHudItem( player, ball:GetName() )
		local team = player:GetTeamId()
			if (team == Team.kBlue) then
				RemoveHudItemFromAll( "ball-icon-blue" )
			elseif (team == Team.kRed) then
				RemoveHudItemFromAll( "ball-icon-red" )
			end
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

function base_ball:onreturn( )
	-- let the teams know that the ball was returned
	BroadCastMessage("#FF_BALLRETURN", Color.kYellow)
	BroadCastSound ( "yourteam.flagreturn" )
	SpeakAll( "CTF_BALLRETURN" )
end

-- Define the ball
ball = base_ball:new({})

-----------------------------------------------------------------------------
-- Capture Points
-----------------------------------------------------------------------------
pushcap = trigger_ff_script:new({ 
	health = 100,
	armor = 300,
	grenades = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	mancannons = 1,
	gren1 = 0,
	gren2 = 0,
	item = "",
	team = Team.kUnassigned,
	botgoaltype = Bot.kFlagCap
})

function pushcap:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then
		-- get the player and his team
		local player = CastToPlayer( allowed_entity )
			
		-- check if the player is on our team
		if player:GetTeamId() ~= self.team then
			return EVENT_DISALLOWED
		end

		if player:HasItem( self.item ) then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

function pushcap:ontrigger( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
			
		-- check if the player is carrying the ball
		if player:HasItem( self.item ) then
			
			-- reward player for goal
			player:AddFortPoints(FORTPOINTS_PER_CAPTURE, "#FF_FORTPOINTS_GOAL")

			-- reward player's team for capture
			local team = player:GetTeam()
			team:AddScore(POINTS_PER_CAPTURE)

			local ball = GetInfoScriptByName( "ball" )
			
			-- return the ball
			ball:Return()
				
			-- Remove any hud icons
			RemoveHudItem( player, ball:GetName() )
		local team = player:GetTeamId()
			if (team == Team.kBlue) then
				RemoveHudItemFromAll( "ball-icon-blue" )
			elseif (team == Team.kRed) then
				RemoveHudItemFromAll( "ball-icon-red" )
			end
	
			-- let the teams know that a capture occured
			SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
			SmartSpeak(player, "CTF_YOUSCORE", "CTF_TEAMSCORE", "CTF_THEYSCORE")
			SmartMessage(player, "#FF_YOUSCORE", "#FF_TEAMSCORE", "#FF_ENEMYSCORE", Color.kGreen, Color.kGreen, Color.kRed)

			ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips })
		end
	end
end

-- declare the elements
red_cap = pushcap:new({ team = Team.kRed, item = "ball" })
blue_cap = pushcap:new({ team = Team.kBlue, item = "ball" })

-----------------------------------------------------------------------------
-- Hurts
-----------------------------------------------------------------------------
hurt = trigger_ff_script:new({ team = Team.kUnassigned })
function hurt:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

hurt_blue = hurt:new({ team = Team.kBlue })
hurt_red = hurt:new({ team = Team.kRed })
