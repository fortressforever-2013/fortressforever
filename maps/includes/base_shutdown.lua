
-- base_shutdown.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;
SECURITY_LENGTH = 45;
FORTPOINTS_PER_SECURITY_DISABLE = 50

local base_shutdown_base = {}
base_shutdown_base.startup = startup

function startup()
	if type(base_shutdown_base.startup) == "function" then
		-- call the saved function
		base_shutdown_base.startup()
	end

	-- this will take care of lights, etc when map loads or round gets restarted/prematch ends
	security_on("red")
	security_on("blue")
end

-----------------------------------------------------------------------------
-- Security events
-----------------------------------------------------------------------------

-- called when security gets turned off (team is a string prefix, like "red")
function security_off( team )
	-- turn off security light, brush, hurt, etc
	OutputEvent(team.."_security_light", "TurnOff")
	OutputEvent(team.."_security_brush", "Disable")
	OutputEvent(team.."_security_hurt", "Disable")
	OutputEvent(team.."_laser_hurt", "Disable") -- a possible alias
	
	-- get the clip entities
	local clips = Collection()
	local clipname = team.."_security_clip"
	clips:GetByName({clipname})

	for clip in clips.items do
		clip = CastToTriggerClip(clip)
		if clip and _G[clipname] and _G[clipname].clipflags then
			-- clear flags, but send a dummy flag (for some reason with zero flags it blocks everything)
			clip:SetClipFlags({ClipFlags.kClipTeamBlue})
		end
	end
	
	-- add a timer for the security on HUD
	if team == "red" then	
		AddHudTimerToAll( "red_sec_timer", SECURITY_LENGTH, -1, button_red.iconx, button_red.icony + 15, button_red.iconalign )
	else 
		AddHudTimerToAll( "blue_sec_timer", SECURITY_LENGTH, -1, button_blue.iconx, button_blue.icony + 15, button_blue.iconalign )
	end
end

-- called when security gets turned on (team is a string prefix, like "red")
function security_on( team )
	-- turn on security light, brush, hurt, etc
	OutputEvent(team.."_security_light", "TurnOn")
	OutputEvent(team.."_security_brush", "Enable")
	OutputEvent(team.."_security_hurt", "Enable")
	OutputEvent(team.."_laser_hurt", "Enable") -- a possible alias
	
	-- get the clip entities
	local clips = Collection()
	local clipname = team.."_security_clip"
	clips:GetByName({clipname})

	for clip in clips.items do
		clip = CastToTriggerClip(clip)
		if clip and _G[clipname] and _G[clipname].clipflags then
			-- reset flags to normal
			clip:SetClipFlags(_G[clipname].clipflags)
		end
	end
	
	-- remove security timer
	RemoveHudItemFromAll( team.."_sec_timer" )
end

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------

-- base button stuff (common functionality)
button_common = func_button:new({ team = Team.kUnassigned }) 

function button_common:allowed( allowed_entity ) 
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team and player:IsAlive() then
			player:AddFortPoints( FORTPOINTS_PER_SECURITY_DISABLE, "#FF_FORTPOINTS_DISABLE_SECURITY" )
			ObjectiveNotice( player, "disabled security" )
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

function button_common:onfailuse( use_entity )
	if IsPlayer( use_entity ) then
		local player = CastToPlayer( use_entity )
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDBUTTON" )
	end
end

-----------------------------------------------------------------------------
-- Button inputs (touch, use, damage etc.)
-----------------------------------------------------------------------------

-- red button
button_red = button_common:new({ 
	team = Team.kBlue, 
	sec_up = true, 
	sec_down_icon = "hud_secdown.vtf", 
	sec_up_icon = "hud_secup_red.vtf", 
	iconx = 60,
	icony = 30,
	iconw = 16,
	iconh = 16,
	iconalign = 3
}) 

-----------------------------------------------------------------------------
-- Button responses 
-----------------------------------------------------------------------------
function button_red:onin() 
	if SECURITY_LENGTH == 60 or SECURITY_LENGTH == 30 then
		BroadCastMessage( "#FF_RED_SEC_"..SECURITY_LENGTH )
	else
		BroadCastMessage( "#FF_RED_SECURITY_DEACTIVATED" )
	end
	SpeakAll( "SD_REDDOWN" )

	self.sec_up = false

	RemoveHudItemFromAll( "red-sec-up")
	AddHudIconToAll( self.sec_down_icon, "red-sec-down", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
	LogLuaEvent(0, 0, "security_down", "team", "red")

	security_off("red")
end 

function button_red:onout()
	BroadCastMessage( "#FF_RED_SECURITY_ACTIVATED" )
	SpeakAll( "SD_REDUP" )

	self.sec_up = true

	RemoveHudItemFromAll( "red-sec-down" )
	AddHudIconToAll( self.sec_up_icon, "red-sec-up", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
	LogLuaEvent(0, 0, "security_up", "team", "red")

	security_on("red")
end

-----------------------------------------------------------------------------
-- Button inputs (touch, use, damage etc.)
-----------------------------------------------------------------------------

-- blue button
button_blue = button_common:new({ 
	team = Team.kRed, 
	sec_up = true, 
	sec_down_icon = "hud_secdown.vtf", 
	sec_up_icon = "hud_secup_blue.vtf", 
	iconx = 60,
	icony = 30,
	iconw = 16,
	iconh = 16,
	iconalign = 2
}) 

-----------------------------------------------------------------------------
-- Button responses 
-----------------------------------------------------------------------------
function button_blue:onin() 
	if SECURITY_LENGTH == 60 or SECURITY_LENGTH == 30 or SECURITY_LENGTH == 40 then
		BroadCastMessage( "#FF_BLUE_SEC_"..SECURITY_LENGTH )
	else
		BroadCastMessage( "#FF_BLUE_SECURITY_DEACTIVATED" )
	end
	SpeakAll( "SD_BLUEDOWN" )

	self.sec_up = false

	RemoveHudItemFromAll( "blue-sec-up")
	AddHudIconToAll( self.sec_down_icon, "blue-sec-down", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
	LogLuaEvent(0, 0, "security_down", "team", "blue")

	security_off("blue")
end 

function button_blue:onout()
	BroadCastMessage( "#FF_BLUE_SECURITY_ACTIVATED" )
	SpeakAll( "SD_BLUEUP" )

	self.sec_up = true

	RemoveHudItemFromAll( "blue-sec-down")
	AddHudIconToAll( self.sec_up_icon, "blue-sec-up", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
	LogLuaEvent(0, 0, "security_up", "team", "blue")

	security_on("blue")
end

-----------------------------------------------------------------------------
-- Trigger-based security toggling
-----------------------------------------------------------------------------

base_security_trigger = not_team_only_trigger:new({ button = "" })

function base_security_trigger:ontrigger( player )
	-- only take sec down if its up currently
	local button = _G[self.button]
	if button and button.sec_up then
		local player = CastToPlayer( player )
		player:AddFortPoints( FORTPOINTS_PER_SECURITY_DISABLE, "#FF_FORTPOINTS_DISABLE_SECURITY" )
		ObjectiveNotice( player, "disabled security" )
		self:onsecuritydown( player )
	end
end

function base_security_trigger:onsecuritydown( player )
	-- call the button's onin directly
	local button = _G[self.button]
	button.onin( button )
	AddSchedule( self.button.."_security", SECURITY_LENGTH, function() self:onsecurityup() end )
end
function base_security_trigger:onsecurityup()
	-- call the button's onout directly
	local button = _G[self.button]
	button.onout( button )
end

red_security_trigger = base_security_trigger:new( { team = Team.kRed, button = "button_red" } )
blue_security_trigger = base_security_trigger:new( { team = Team.kBlue, button = "button_blue" } )

-----------------------------------------------------------------------------
-- Hurts
-----------------------------------------------------------------------------

-- backwards compatibility
hurt = team_only_trigger:new({})
-- red lasers hurt blue and vice-versa
red_security_hurt = not_red_trigger:new({})
blue_security_hurt = not_blue_trigger:new({})
-- the trigger_hurts can also be named like this
red_laser_hurt = red_security_hurt
blue_laser_hurt = blue_security_hurt

-----------------------------------------------------------------------------
-- Clips
-----------------------------------------------------------------------------

red_security_clip = clip_red:new()
blue_security_clip = clip_blue:new()

-------------------------
-- flaginfo
-------------------------

--flaginfo runs whenever the player spawns or uses the flaginfo command.
--Right now it just refreshes the HUD items; this ensures that players who just joined the server have the right information
function flaginfo( player_entity )
	flaginfo_base(player_entity) --see base_teamplay.lua

	local player = CastToPlayer( player_entity )
	
	RemoveHudItem( player, "red-sec-down" )
	RemoveHudItem( player, "blue-sec-down" )
	RemoveHudItem( player, "red-sec-up" )
	RemoveHudItem( player, "blue-sec-up" )

	if button_blue.sec_up == true then
		AddHudIcon( player, button_blue.sec_up_icon, "blue-sec-up", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, button_blue.iconalign )
	else
		AddHudIcon( player, button_blue.sec_down_icon, "blue-sec-down", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, button_blue.iconalign )
	end

	if button_red.sec_up == true then
		AddHudIcon( player, button_red.sec_up_icon, "red-sec-up", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, button_red.iconalign )
	else
		AddHudIcon( player, button_red.sec_down_icon, "red-sec-down", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, button_red.iconalign )
	end
end