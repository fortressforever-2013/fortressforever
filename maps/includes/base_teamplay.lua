
-- base_teamplay.lua

-----------------------------------------------------------------------------
-- base_teamplay handles stuff for "normal" maps so this stuff doesn't need
-- to be replicated all over the place (like standard teamspawns,
-- doors, bags, and such)
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------
if POINTS_PER_CAPTURE == nil then POINTS_PER_CAPTURE = 10; end
if FORTPOINTS_PER_CAPTURE == nil then FORTPOINTS_PER_CAPTURE = 1000; end
if FORTPOINTS_PER_INITIALTOUCH == nil then FORTPOINTS_PER_INITIALTOUCH = 100; end
if FLAG_RETURN_TIME == nil then FLAG_RETURN_TIME = 60; end 
if FLAG_THROW_SPEED == nil then FLAG_THROW_SPEED = 330; end

redallowedmethod = function(self,player) return player:GetTeamId() == Team.kRed end
blueallowedmethod = function(self,player) return player:GetTeamId() == Team.kBlue end
yellowallowedmethod = function(self,player) return player:GetTeamId() == Team.kYellow end
greenallowedmethod = function(self,player) return player:GetTeamId() == Team.kGreen end

-- things for flags
teamskins = {}
teamskins[Team.kBlue] 	= 0
teamskins[Team.kRed] 	= 1
teamskins[Team.kYellow] = 2
teamskins[Team.kGreen] 	= 3

team_hudicons = {}
team_hudicons[Team.kBlue] 	= "hud_flag_blue_new.vtf"
team_hudicons[Team.kRed] 	= "hud_flag_red_new.vtf"
team_hudicons[Team.kGreen] 	= "hud_flag_green_new.vtf"
team_hudicons[Team.kYellow] = "hud_flag_yellow_new.vtf"

-----------------------------------------------------------------------------
-- Player spawn: give full health, armor, and ammo
-----------------------------------------------------------------------------
function player_spawn( player_entity ) 
   local player = CastToPlayer( player_entity ) 

   player:AddHealth( 400 ) 
   player:AddArmor( 400 ) 

   player:AddAmmo( Ammo.kNails, 400 ) 
   player:AddAmmo( Ammo.kShells, 400 ) 
   player:AddAmmo( Ammo.kRockets, 400 ) 
   player:AddAmmo( Ammo.kCells, 400 ) 
end

-----------------------------------------------------------------------------
-- No builds: area where you can't build
-----------------------------------------------------------------------------
nobuild = trigger_ff_script:new({})

function nobuild:onbuild( build_entity )	
	return EVENT_DISALLOWED 
end

no_build = nobuild

-----------------------------------------------------------------------------
-- No grens: area where grens won't explode
-----------------------------------------------------------------------------
nogrens = trigger_ff_script:new({})

function nogrens:onexplode( explode_entity )
	if IsGrenade( explode_entity ) then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

no_grens = nogrens

-----------------------------------------------------------------------------
-- No Fucking Annoyances
-----------------------------------------------------------------------------
noannoyances = trigger_ff_script:new({})

function noannoyances:onbuild( build_entity )
	return EVENT_DISALLOWED 
end

function noannoyances:onexplode( explode_entity )
	if IsGrenade( explode_entity ) then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

function noannoyances:oninfect( infect_entity )
	return EVENT_DISALLOWED 
end

no_annoyances = noannoyances
spawn_protection = noannoyances

-----------------------------------------------------------------------------
-- Useful trigger definitions
-----------------------------------------------------------------------------

-- team only triggers
team_only_trigger = trigger_ff_script:new({ team = Team.kUnassigned, allow = true })
function team_only_trigger:allowed( allowed_entity ) if allowed_entity and IsPlayer(allowed_entity) and CastToPlayer(allowed_entity):GetTeamId() == self.team then return self.allow else return not self.allow end end

-- triggers that allow any team except the given team
not_team_only_trigger = team_only_trigger:new({allow = false})

-- allow only if on the team
red_trigger = team_only_trigger:new({ team = Team.kRed })
blue_trigger = team_only_trigger:new({ team = Team.kBlue })
yellow_trigger = team_only_trigger:new({ team = Team.kYellow })
green_trigger = team_only_trigger:new({ team = Team.kGreen })

-- allow only if not on the team
not_red_trigger = not_team_only_trigger:new({ team = Team.kRed })
not_blue_trigger = not_team_only_trigger:new({ team = Team.kBlue })
not_yellow_trigger = not_team_only_trigger:new({ team = Team.kYellow })
not_green_trigger = not_team_only_trigger:new({ team = Team.kGreen })

-----------------------------------------------------------------------------
-- Trigger_ff_clips
-----------------------------------------------------------------------------

-- these block all players except the team the clip "belongs to" (clip_red blocks all players not on the red team)
clip_blue = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamYellow, ClipFlags.kClipTeamGreen, ClipFlags.kClipAllNonPlayers} })
clip_red = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamBlue, ClipFlags.kClipTeamYellow, ClipFlags.kClipTeamGreen, ClipFlags.kClipAllNonPlayers} })
clip_yellow = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamBlue, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamGreen, ClipFlags.kClipAllNonPlayers} })
clip_green = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamBlue, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamYellow, ClipFlags.kClipAllNonPlayers} })

-- each of these block specific things
block_buildables = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipAllBuildables, ClipFlags.kClipAllBuildableWeapons} })
block_buildablepathing = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipAllBuildables} })
block_buildableweapons = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipAllBuildableWeapons} })
block_spawnturrets = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipAllSpawnTurrets} })
block_nonplayers = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipAllNonPlayers} })
block_players = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipAllPlayers} })
block_backpacks = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipAllBackpacks} })
block_flags = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipAllInfoScripts} })

-----------------------------------------------------------------------------
-- Generic Backpack
-----------------------------------------------------------------------------
genericbackpack = info_ff_script:new({
	health = 0,
	armor = 0,
	grenades = 0,
	shells = 0,
	nails = 0,
	rockets = 0,
	cells = 0,
	detpacks = 0,
	mancannons = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function genericbackpack:dropatspawn() return false end

function genericbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function genericbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
	
		-- give player some health and armor
		if self.health ~= nil and self.health ~= 0 then dispensed = dispensed + player:AddHealth( self.health ) end
		if self.armor ~= nil and self.armor ~= 0 then dispensed = dispensed + player:AddArmor( self.armor ) end
	
		-- give player ammo
		if self.nails ~= nil and self.nails ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kNails, self.nails) end
		if self.shells ~= nil and self.shells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kShells, self.shells) end
		if self.rockets ~= nil and self.rockets ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets) end
		if self.cells ~= nil and self.cells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kCells, self.cells) end
		if self.detpacks ~= nil and self.detpacks ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kDetpack, self.detpacks) end
		if self.mancannons ~= nil and self.mancannons ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kManCannon, self.mancannons) end
		if self.gren1 ~= nil and self.gren1 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren1) end
		if self.gren2 ~= nil and self.gren2 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren2) end
	
		-- if the player took ammo, then have the backpack respawn with a delay
		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity);
			if backpack then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

function genericbackpack:materialize( )
	entity:EmitSound(self.materializesound)
end

-----------------------------------------------------------------------------
-- Health Kit (backpack-based)
-----------------------------------------------------------------------------
healthkit = genericbackpack:new({
	health = 25,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	respawntime = 20,
	touchsound = "HealthKit.Touch",
	botgoaltype = Bot.kBackPack_Health
})

function healthkit:dropatspawn() return true end

-----------------------------------------------------------------------------
-- Armor Kit (backpack-based)
-----------------------------------------------------------------------------
armorkit = genericbackpack:new({
	armor = 200,
	cells = 150,					-- mirv: armour in 2fort/rock2/etc gives 150 cells too
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",
	botgoaltype = Bot.kBackPack_Armor
})

function armorkit:dropatspawn() return true end

-----------------------------------------------------------------------------
-- Ammo Kit (backpack-based)
-----------------------------------------------------------------------------
ammobackpack = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function ammobackpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- bigpack -- has a bit of everything (excluding grens) (backpack-based)
-----------------------------------------------------------------------------
bigpack = genericbackpack:new({
	health = 150,
	armor = 200,
	grenades = 50,
	nails = 150,
	shells = 200,
	rockets = 100,
	cells = 200,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function bigpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Grenade Backpack
-----------------------------------------------------------------------------
grenadebackpack = genericbackpack:new({
	mancannons = 1,
	gren1 = 2,
	gren2 = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 30,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})

function grenadebackpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Door Triggers
-----------------------------------------------------------------------------
respawndoor = trigger_ff_script:new({ team = Team.kUnassigned, allowdisguised=false })

function respawndoor:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		
		local player = CastToPlayer( allowed_entity )
		
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
		
		if self.allowdisguised then
			if player:IsDisguised() and player:GetDisguisedTeam() == self.team then
				return EVENT_ALLOWED
			end
		end
	end
	return EVENT_DISALLOWED
end

function respawndoor:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDDOOR" )
	end
end

bluerespawndoor = respawndoor:new({ team = Team.kBlue })
redrespawndoor = respawndoor:new({ team = Team.kRed })
greenrespawndoor = respawndoor:new({ team = Team.kGreen })
yellowrespawndoor = respawndoor:new({ team = Team.kYellow })

-----------------------------------------------------------------------------
-- Elevator Triggers
-----------------------------------------------------------------------------

elevator_trigger = respawndoor:new( {} )

function elevator_trigger:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDELEVATOR" )
	end
end

blue_elevator_trigger 	= elevator_trigger:new({ team = Team.kBlue })
red_elevator_trigger 	= elevator_trigger:new({ team = Team.kRed })
green_elevator_trigger 	= elevator_trigger:new({ team = Team.kGreen })
yellow_elevator_trigger	= elevator_trigger:new({ team = Team.kYellow })

-----------------------------------------------------------------------------
-- Spawn functions
-----------------------------------------------------------------------------
redspawn = { validspawn = redallowedmethod }
bluespawn = { validspawn = blueallowedmethod }
greenspawn = { validspawn = greenallowedmethod }
yellowspawn = { validspawn = yellowallowedmethod }

-- aliases for people that like underscores
red_spawn = redspawn; blue_spawn = bluespawn;
green_spawn = greenspawn; yellow_spawn = yellowspawn
blue_respawndoor = bluerespawndoor; red_respawndoor = redrespawndoor;
green_respawndoor = greenrespawndoor; yellow_respawndoor = yellowrespawndoor

-----------------------------------------------------------------------------
-- Capture Points
-----------------------------------------------------------------------------
basecap = trigger_ff_script:new({
	health = 100,
	armor = 300,
	grenades = 200,
	shells = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	mancannons = 1,
	gren1 = 4,
	gren2 = 4,
	item = "",
	team = 0,
	jetpackfuelpct = 100,
	-- teampoints and fortpoints are defined as functions here for backwards compatibility (to always get the current value of the global variable)
	-- when defining capture points that inherit from basecap, teampoints and fortpoints can be set to numbers instead
	teampoints = function(cap, team) return POINTS_PER_CAPTURE end, 
	fortpoints = function(cap, player) return FORTPOINTS_PER_CAPTURE end, 
	botgoaltype = Bot.kFlagCap,
})

bluerspawn = info_ff_script:new()

function basecap:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then
		-- get the player and his team
		local player = CastToPlayer( allowed_entity )
		local team = player:GetTeam()
	
		-- check if the player is on our team
		if team:GetTeamId() ~= self.team then
			return false
		end
	
		-- check if the player has the flag
		for i,v in ipairs(self.item) do
			local flag = GetInfoScriptByName(v)
			
			-- Make sure flag isn't nil
			if flag then
				if player:HasItem(flag:GetName()) then
					return true
				end
			end
		end
	end
	
	return false
end

function basecap:ontrigger ( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		-- player should capture now
		for i,v in ipairs( self.item ) do
			
			-- find the flag and cast it to an info_ff_script
			local flag = GetInfoScriptByName(v)

			-- Make sure flag isn't nil
			if flag then
			
				-- check if the player is carrying the flag
				if player:HasItem(flag:GetName()) then
					_G[flag:GetName()].status = 0

					-- reward player for capture
					local fortpoints = (type(self.fortpoints) == "function" and self.fortpoints(self, player) or self.fortpoints)
					player:AddFortPoints(fortpoints, "#FF_FORTPOINTS_CAPTUREFLAG")
					
					-- reward player's team for capture
					local team = player:GetTeam()
					local teampoints = (type(self.teampoints) == "function" and self.teampoints(self, team) or self.teampoints)
					team:AddScore(teampoints)

          			LogLuaEvent(player:GetId(), 0, "flag_capture","flag_name",flag:GetName())
					-- show on the deathnotice board
					ObjectiveNotice( player, "captured the flag" )

					-- clear the objective icon
					UpdateObjectiveIcon( player, nil )

					-- Remove any hud icons
					RemoveHudItem( player, flag:GetName() )

					-- return the flag
					flag:Return()
					
					--Cappin cures what ails ya
					player:RemoveEffect(EF.kOnfire)
					player:RemoveEffect(EF.kConc)
					player:RemoveEffect(EF.kGas)
					player:RemoveEffect(EF.kInfect)
					player:RemoveEffect(EF.kRadiotag)
					player:RemoveEffect(EF.kTranq)
					player:RemoveEffect(EF.kLegshot)
					player:RemoveEffect(EF.kRadiotag)

					-- give player some health and armor
					if self.health ~= nil and self.health ~= 0 then player:AddHealth(self.health) end
					if self.armor ~= nil and self.armor ~= 0 then player:AddArmor(self.armor) end
	
					-- give the player some ammo
					if self.nails ~= nil and self.nails ~= 0 then player:AddAmmo(Ammo.kNails, self.nails) end
					if self.shells ~= nil and self.shells ~= 0 then player:AddAmmo(Ammo.kShells, self.shells) end
					if self.rockets ~= nil and self.rockets ~= 0 then player:AddAmmo(Ammo.kRockets, self.rockets) end
					if self.cells ~= nil and self.cells ~= 0 then player:AddAmmo(Ammo.kCells, self.cells) end
					if self.detpacks ~= nil and self.detpacks ~= 0 then player:AddAmmo(Ammo.kDetpack, self.detpacks) end
					if self.mancannons ~= nil and self.mancannons ~= 0 then player:AddAmmo(Ammo.kManCannon, self.mancannons) end
					if self.gren1 ~= nil and self.gren1 ~= 0 then player:AddAmmo(Ammo.kGren1, self.gren1) end
					if self.gren2 ~= nil and self.gren2 ~= 0 then player:AddAmmo(Ammo.kGren2, self.gren2) end
	
					-- restock player specials
					if self.jetpackfuelpct ~= nil then player:SetJetpackFuelPercent(self.jetpackfuelpct) end 
					
					self:oncapture( player, v )
				end
			end
		end
	end
end

function basecap:oncapture(player, item)
	-- let the teams know that a capture occured
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
	SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
	SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP", Color.kGreen, Color.kGreen, Color.kRed)
end

-----------------------------------------------------------------------------
-- Flag
-- status: 0 = home, 1 = carried, 2 = dropped
-----------------------------------------------------------------------------
baseflag = info_ff_script:new({
	name = "base flag",
	team = 0,
	model = "models/flag/flag.mdl",
	tosssound = "Flag.Toss",
	modelskin = 1,
	dropnotouchtime = 2,
	capnotouchtime = 2,
	botgoaltype = Bot.kFlag,
	status = 0,
	hudicon = "",
	hudx = 5,
	hudy = 114,
	hudalign = 1,
	hudstatusiconalign = 2,
	hudstatusicon = "",
	hudstatusiconx = 0,
	hudstatusicony = 0,
	hudstatusiconw = 50,
	hudstatusiconh = 50,
	allowdrop = true,
	droppedlocation = "",
	carriedby = "",
	flagtoss = false,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function baseflag:precache()
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

function baseflag:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
	local flag = CastToInfoScript( entity )
	LogLuaEvent(0, 0, "flag_spawn","flag_name",flag:GetName())
	self.status = 0
	self:refreshStatusIcons(flag:GetName())
	flag:StartTrail(self.team)
end

function baseflag:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule(self.name .. "-" .. player_id, duration, self.removenotouch, self, player_id)
end

function baseflag.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

function baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	if player:GetTeamId() ~= self.team then
		-- let the teams know that the flag was picked up
		SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
		RandomFlagTouchSpeak( player )
		SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP", Color.kGreen, Color.kGreen, Color.kRed)
		
		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
		
		-- show on the deathnotice board
		--ObjectiveNotice( player, "grabbed the flag" )
		-- log action in stats
		LogLuaEvent(player:GetId(), 0, "flag_touch", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" .. player:GetHealth());	
		
		local team = nil
		-- get team as a lowercase string
		if player:GetTeamId() == Team.kBlue then team = "blue" end
		if player:GetTeamId() == Team.kRed then team = "red" end
		if player:GetTeamId() == Team.kGreen then team = "green" end  
		if player:GetTeamId() == Team.kYellow then team = "yellow" end
		
		-- objective icon pointing to the cap
		UpdateObjectiveIcon( player, GetEntityByName( team.."_cap" ) )

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
		self.carriedby = player:GetName()
		self:refreshStatusIcons(flag:GetName())

	end
end

function baseflag:onownerdie( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, 0.0)
	
	-- remove flag icon from hud
	local player = CastToPlayer( owner_entity )
	RemoveHudItem( player, flag:GetName() )

	self.status = 2
	self.carriedby = ""
	self.droppedlocation = player:GetLocation()
	self:refreshStatusIcons(flag:GetName())
	
	-- clear the objective icon
	UpdateObjectiveIcon( player, nil )

end

function baseflag:ownercloak( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, 0.0)
	
	-- remove flag icon from hud
	local player = CastToPlayer( owner_entity )
	RemoveHudItem( player, flag:GetName() )

	self.status = 2
	self.carriedby = ""
	self.droppedlocation = player:GetLocation()
	self:refreshStatusIcons(flag:GetName())
	
	-- clear the objective icon
	UpdateObjectiveIcon( player, nil )
end

function baseflag:dropitemcmd( owner_entity )
	if allowdrop == false then return end

	--Used by logging
	self.flagtoss = true

	-- throw the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, FLAG_THROW_SPEED)
	
	-- remove flag icon from hud
	local player = CastToPlayer( owner_entity )
	RemoveHudItem( player, flag:GetName() )

	self.status = 2
	self.carriedby = ""
	self.droppedlocation = player:GetLocation()
	self:refreshStatusIcons(flag:GetName())
	
	-- clear the objective icon
	UpdateObjectiveIcon( player, nil )
end	

function baseflag:ondrop( owner_entity )
	local player = CastToPlayer( owner_entity )
	-- let the teams know that the flag was dropped
	SmartSound(player, "yourteam.drop", "yourteam.drop", "otherteam.drop")
	SmartMessage(player, "#FF_YOUDROP", "#FF_TEAMDROP", "#FF_OTHERTEAMDROP", Color.kYellow, Color.kYellow, Color.kYellow)

	local flag = CastToInfoScript(entity)
	--Log a toss if drop was intentional. Otherwise, drop
	if self.flagtoss == true then
		LogLuaEvent(player:GetId(), 0, "flag_thrown","flag_name",flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" ..player:GetHealth());

		self.flagtoss = false
	else
		LogLuaEvent(player:GetId(), 0, "flag_dropped", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ));

	end

	flag:EmitSound(self.tosssound)
end

function baseflag:onloseitem( owner_entity )
	local flag = CastToInfoScript( entity )
	-- let the player that lost the flag put on a disguise
	local player = CastToPlayer( owner_entity )
	player:SetDisguisable(true)
	-- let player cloak if he can
	player:SetCloakable( true )

	self.status = 0 --For some reason, the flag won't register as home when captured, unless I do this.
	self.carriedby = ""
	self:refreshStatusIcons(flag:GetName())
	self:addnotouch(player:GetId(), self.capnotouchtime)
end

function baseflag:onownerforcerespawn( owner_entity )
	local flag = CastToInfoScript( entity )
	local player = CastToPlayer( owner_entity )
	player:SetDisguisable( true )
	player:SetCloakable( true )
	RemoveHudItem( player, flag:GetName() )	
	flag:Drop(0, FLAG_THROW_SPEED)
	
	self.status = 2
	self.carriedby = ""
	self.droppedlocation = player:GetLocation()
	self:refreshStatusIcons(flag:GetName())
	
	-- clear the objective icon
	UpdateObjectiveIcon( player, nil )
end

function baseflag:onreturn( )
	-- let the teams know that the flag was returned
	local team = GetTeam( self.team )
	SmartTeamMessage(team, "#FF_TEAMRETURN", "#FF_OTHERTEAMRETURN", Color.kYellow, Color.kYellow)
	SmartTeamSound(team, "yourteam.flagreturn", "otherteam.flagreturn")
	SmartTeamSpeak(team, "CTF_FLAGBACK", "CTF_EFLAGBACK")
	local flag = CastToInfoScript( entity )

	LogLuaEvent(0, 0, "flag_returned","flag_name",flag:GetName());

	RemoveHudItemFromAll( flag:GetName() .. "location" )
	self.status = 0
	self.droppedlocation = ""
	self:refreshStatusIcons(flag:GetName())
end

function baseflag:hasanimation() return true end

function baseflag:gettouchsize( mins, maxs )
	mins.x = mins.x * 1.50
	mins.y = mins.y * 1.50
	maxs.x = maxs.x * 1.50
	maxs.y = maxs.y * 1.50
	mins.z = 0
	maxs.z = maxs.z * 0.80
end

function baseflag:getphysicssize( mins, maxs )
	mins.x = mins.x / 2
	mins.y = mins.y / 2
	maxs.x = maxs.x / 2
	maxs.y = maxs.y / 2
	mins.z = 0
	maxs.z = 1
end

function baseflag:getbloatsize()
	return 0
end

--All your flag HUD status needs in a convenient package (sort of)
function baseflag:refreshStatusIcons(flagname)
	RemoveHudItemFromAll( flagname .. "_status" )
	RemoveHudItemFromAll( flagname .. "location" )
	RemoveHudItemFromAll( flagname .. "carrier" )
	RemoveHudItemFromAll( flagname .. "timer" )

	if self.status == 1 then
		AddHudTextToAll( flagname .. "carrier", self.carriedby, self.hudstatusiconx, (self.hudstatusicony + self.hudstatusiconh), self.hudstatusiconalign )
		AddHudIconToAll( self.hudstatusiconcarried, ( flagname .. "_status" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
	elseif self.status == 2 then
		AddHudTextToAll( flagname .. "location", self.droppedlocation, self.hudstatusiconx + 24, (self.hudstatusicony + self.hudstatusiconh), self.hudstatusiconalign )
		AddHudTimerToAll( flagname .. "timer", FLAG_RETURN_TIME, -1, self.hudstatusiconx, (self.hudstatusicony + self.hudstatusiconh), self.hudstatusiconalign )
		AddHudIconToAll( self.hudstatusicondropped, ( flagname .. "_status" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
	else
		AddHudIconToAll( self.hudstatusiconhome, ( flagname .. "_status" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )	
	end
end

-----------------------------------------------------------------------------
--flaginfo, basic version. If you override flaginfo in a map's lua, call this to get default functionality.
-----------------------------------------------------------------------------
function flaginfo_base( player_entity )
	local player = CastToPlayer( player_entity )

	local flag = GetInfoScriptByName("blue_flag")
	if flag then
		local flagname = flag:GetName()
	
		RemoveHudItem( player, flagname .. "_status" )
		RemoveHudItem( player, "blue_flagcarrier" )
		RemoveHudItem( player, "blue_flaglocation" )

		if flag:IsCarried() then
			AddHudText( player, "blue_flagcarrier", blue_flag.carriedby, blue_flag.hudstatusiconx, (blue_flag.hudstatusicony + blue_flag.hudstatusiconh), blue_flag.hudstatusiconalign )
			AddHudIcon( player, blue_flag.hudstatusiconcarried, ( flagname .. "_status" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
		elseif flag:IsDropped() then
			AddHudText( player, "blue_flaglocation", blue_flag.droppedlocation, blue_flag.hudstatusiconx + 24, (blue_flag.hudstatusicony + blue_flag.hudstatusiconh), blue_flag.hudstatusiconalign )
			AddHudIcon( player, blue_flag.hudstatusicondropped, ( flagname .. "_status" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
		else
			AddHudIcon( player, blue_flag.hudstatusiconhome, ( flagname .. "_status" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )	
		end
	end
	local flag = GetInfoScriptByName("red_flag")
	if flag then
		local flagname = flag:GetName()
	
		RemoveHudItem( player, flagname .. "_status" )
		RemoveHudItem( player, "red_flagcarrier" )
		RemoveHudItem( player, "red_flaglocation" )

		if flag:IsCarried() then
			AddHudText( player, "red_flagcarrier", red_flag.carriedby, red_flag.hudstatusiconx, (red_flag.hudstatusicony + red_flag.hudstatusiconh), red_flag.hudstatusiconalign )
			AddHudIcon( player, red_flag.hudstatusiconcarried, ( flagname .. "_status" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
		elseif flag:IsDropped() then
			AddHudText( player, "red_flaglocation", red_flag.droppedlocation, red_flag.hudstatusiconx + 24, (red_flag.hudstatusicony + red_flag.hudstatusiconh), red_flag.hudstatusiconalign )
			AddHudIcon( player, red_flag.hudstatusicondropped, ( flagname .. "_status" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
		else
			AddHudIcon( player, red_flag.hudstatusiconhome, ( flagname .. "_status" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )	
		end
	end
	local flag = GetInfoScriptByName("yellow_flag")
	if flag then
		local flagname = flag:GetName()
	
		RemoveHudItem( player, flagname .. "_status" )
		RemoveHudItem( player, "yellow_flagcarrier" )
		RemoveHudItem( player, "yellow_flaglocation" )

		if flag:IsCarried() then
			AddHudText( player, "yellow_flagcarrier", yellow_flag.carriedby, yellow_flag.hudstatusiconx, (yellow_flag.hudstatusicony + yellow_flag.hudstatusiconh), yellow_flag.hudstatusiconalign )
			AddHudIcon( player, yellow_flag.hudstatusiconcarried, ( flagname .. "_status" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )
		elseif flag:IsDropped() then
			AddHudText( player, "yellow_flaglocation", yellow_flag.droppedlocation, yellow_flag.hudstatusiconx + 24, (yellow_flag.hudstatusicony + yellow_flag.hudstatusiconh), yellow_flag.hudstatusiconalign )
			AddHudIcon( player, yellow_flag.hudstatusicondropped, ( flagname .. "_status" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )
		else
			AddHudIcon( player, yellow_flag.hudstatusiconhome, ( flagname .. "_status" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )	
		end
	end
	local flag = GetInfoScriptByName("green_flag")
	if flag then
		local flagname = flag:GetName()
	
		RemoveHudItem( player, flagname .. "_status" )
		RemoveHudItem( player, "green_flagcarrier" )
		RemoveHudItem( player, "green_flaglocation" )

		if flag:IsCarried() then
			AddHudText( player, "green_flagcarrier", green_flag.carriedby, green_flag.hudstatusiconx, (green_flag.hudstatusicony + green_flag.hudstatusiconh), green_flag.hudstatusiconalign )
			AddHudIcon( player, green_flag.hudstatusiconcarried, ( flagname .. "_status" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )
		elseif flag:IsDropped() then
			AddHudText( player, "green_flaglocation", green_flag.droppedlocation, green_flag.hudstatusiconx + 24, (green_flag.hudstatusicony + green_flag.hudstatusiconh), green_flag.hudstatusiconalign )
			AddHudIcon( player, green_flag.hudstatusicondropped, ( flagname .. "_status" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )
		else
			AddHudIcon( player, green_flag.hudstatusiconhome, ( flagname .. "_status" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )	
		end
	end
end
-----------------------------------------------------------------------------
-- Dettable triggers.  Use this to make triggers that respond to a detpack explosion.
-----------------------------------------------------------------------------

detpack_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function detpack_trigger:onexplode( explosion_entity )
   if IsDetpack( explosion_entity ) then
      local detpack = CastToDetpack( explosion_entity )

      if detpack:GetTeamId() ~= self.team then
         -- Generic 'trigger' output for use with logic_ entities.
         OutputEvent( self.team_name .. "_det_relay", "trigger" )
      end
   end

   return EVENT_ALLOWED
end

red_detpack_trigger = detpack_trigger:new({ team = Team.kRed, team_name = "red" })
blue_detpack_trigger = detpack_trigger:new({ team = Team.kBlue, team_name = "blue" })
green_detpack_trigger = detpack_trigger:new({ team = Team.kGreen, team_name = "green" })
yellow_detpack_trigger = detpack_trigger:new({ team = Team.kYellow, team_name = "yellow" })

-----------------------------------------------------------------------------
-- backpack entity setup
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})

-----------------------------------------------------------------------------
-- plays random flag touched sounds to avoid repetition
-- use instead of: SmartSpeak(player, "CTF_YOUGOTFLAG", "CTF_GOTFLAG", "CTF_LOSTFLAG")
-----------------------------------------------------------------------------
function RandomFlagTouchSpeak( player )
	local rnd = RandomInt(1,4)
	if rnd == 1 then SmartSpeak(player, "CTF_YOUGOTFLAG", "CTF_GOTFLAG", "CTF_LOSTFLAG")
	elseif rnd == 2 then SmartSpeak(player, "CTF_YOUGOTFLAG2", "CTF_GOTFLAG2", "CTF_LOSTFLAG2")
	elseif rnd == 3 then SmartSpeak(player, "CTF_YOUGOTFLAG3", "CTF_GOTFLAG3", "CTF_LOSTFLAG3")
	else SmartSpeak(player, "CTF_YOUGOTFLAG4", "CTF_GOTFLAG4", "CTF_LOSTFLAG4") end
end
