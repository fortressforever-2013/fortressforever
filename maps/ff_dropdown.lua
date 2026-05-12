-- ff_dropdown.lua
-- Author: Sh4x

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
-- map handlers
-----------------------------------------------------------------------------
function startup()
	SetGameDescription("Capture the Flag")
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)

	--If the generator is detted during prematch, this will reset the lights in the gen room.
	OutputEvent("blue_gen_lightspots", "turnon")
	OutputEvent("blue_gen_blueflickerlights", "turnoff")
	OutputEvent("blue_generator_hum", "playsound")
	OutputEvent("blue_gen_lightambient", "turnon")
	OutputEvent("blue_gen_fire_light01", "turnoff")
	OutputEvent("blue_gen_bluelights", "turnon")

	OutputEvent("red_gen_lightspots", "turnon")
	OutputEvent("red_gen_redflickerlights", "turnoff")
	OutputEvent("red_generator_hum", "playsound")
	OutputEvent("red_gen_lightambient", "turnon")
	OutputEvent("red_gen_fire_light01", "turnoff")
	OutputEvent("red_gen_redlights", "turnon")

end

-----------------------------------------------------------------------------
-- globals (lawl... unless it starts with "local" its already a global!)
-----------------------------------------------------------------------------

BLUEFIRE_TIMER_START = 60
REDFIRE_TIMER_START = 60


-----------------------------------------------------------------------------
-- backpacks  smallpack1=bottomfloor  smallpack2=middlefloor  smallpack3=upperfloor
-----------------------------------------------------------------------------
redsmallpack1 = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 1,
	gren2 = 1,
      cells = 200,
	armor = 100,
	health = 100,
      respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function redsmallpack1:dropatspawn() return false end

redsmallpack2 = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 1,
	gren2 = 1,
      cells = 200,
	armor = 100,
	health = 100,
      respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function redsmallpack2:dropatspawn() return false end

redsmallpack3 = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 1,
	gren2 = 1,
      cells = 200,
	armor = 100,
	health = 100,
      respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function redsmallpack3:dropatspawn() return false end




bluesmallpack1 = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 1,
	gren2 = 1,
      cells = 200,
	armor = 100,
	health = 100,
      respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function bluesmallpack1:dropatspawn() return false end

bluesmallpack2 = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 1,
	gren2 = 1,
      cells = 200,
	armor = 100,
	health = 100,
      respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function bluesmallpack2:dropatspawn() return false end

bluesmallpack3 = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 1,
	gren2 = 1,
      cells = 200,
	armor = 100,
	health = 100,
      respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function bluesmallpack3:dropatspawn() return false end

-----------------------------------------------------------------------------
-- unique dropdown locations
-----------------------------------------------------------------------------

location_blue_generator = location_info:new({ text = "Generator Room", team = Team.kBlue })
location_blue_tophole = location_info:new({ text = "Top Hole", team = Team.kBlue })

location_red_generator = location_info:new({ text = "Generator Room", team = Team.kRed })
location_red_tophole = location_info:new({ text = "Top Hole", team = Team.kRed })

-----------------------------------------------------------------------------
-- Grates
-----------------------------------------------------------------------------


red_grate_trigger = trigger_ff_script:new({ })

function red_grate_trigger:onexplode( trigger_entity  ) 
	if IsDetpack( trigger_entity ) then 
		OutputEvent( "red_grate", "Break" )
		OutputEvent( "red_grate_wall", "Kill" )
            BroadCastMessage("#FF_RED_GRATEBLOWN")
	end 
	return EVENT_ALLOWED
end
function red_grate_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end



blue_grate_trigger = trigger_ff_script:new({ })

function blue_grate_trigger:onexplode( trigger_entity  ) 
	if IsDetpack( trigger_entity ) then 
		OutputEvent( "blue_grate", "Break" )
		OutputEvent( "blue_grate_wall", "Kill" )
        	BroadCastMessage("#FF_BLUE_GRATEBLOWN")
	end 
	return EVENT_ALLOWED
end
function blue_grate_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end


-----------------------------------------------------------------------------
-- Generators Destroy
-----------------------------------------------------------------------------

red_gen_trigger = trigger_ff_script:new({ })
redfire = 0

function red_gen_trigger:onexplode( trigger_entity  ) 
	if IsDetpack( trigger_entity ) then 
		if redgenup == 1 then
            OutputEvent( "red_doorhack", "Close" )
            BroadCastMessage("#FF_RED_GENBLOWN")

      redfire_start_schedule()
      redfire = 1

            redgenup = 0
            end
	end 
	return EVENT_ALLOWED
end
function red_gen_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end



blue_gen_trigger = trigger_ff_script:new({ })
bluefire = 0

function blue_gen_trigger:onexplode( trigger_entity  ) 
	if IsDetpack( trigger_entity ) then 
            if bluegenup == 1 then
		OutputEvent( "blue_doorhack", "Close" )
            BroadCastMessage("#FF_BLUE_GENBLOWN")

      bluefire_start_schedule()
      bluefire = 1

            bluegenup = 0
            end
	end 
	return EVENT_ALLOWED
end
function blue_gen_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end

-----------------------------------------------------------------------------
-- Generators Repair
-----------------------------------------------------------------------------

red_gen_repair_trigger = func_button:new({})
red_gen_repair_trigger_script = trigger_ff_script:new()
redspannerclang = 0
redgenup = 1
redclangcntr = 0

function red_gen_repair_trigger_script:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
			if player:GetActiveWeaponName() == "ff_weapon_spanner" then
				redspannerclang = 1
				if redfire == 1 then
					DisplayMessage( player, "#HINT_BURNINGGENERATOR" )
				end
			end
	end
end

function red_gen_repair_trigger_script:onendtouch()
	redspannerclang = 0
end

function red_gen_repair_trigger:ondamage()
	if redspannerclang == 1 then
		 if redgenup == 0 then
             	if redfire == 0 then
      	 	OutputEvent( "redspannerhit", "PlaySound" )
             	redclangcntr = redclangcntr + 1
                     if redclangcntr > 4 then
                     redclangcntr = 0             
                     BroadCastMessage("#FF_RED_GEN_OK")
                     OpenDoor("red_doorhack")
		         redspannerclang = 0
                     redgenup = 1
                     end
			end
		 end
      end
	return EVENT_DISALLOWED
end



blue_gen_repair_trigger = func_button:new({})
blue_gen_repair_trigger_script = trigger_ff_script:new()
bluespannerclang = 0
bluegenup = 1
blueclangcntr = 0


function blue_gen_repair_trigger_script:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
			if player:GetActiveWeaponName() == "ff_weapon_spanner" then
				bluespannerclang = 1
				if bluefire == 1 then
					DisplayMessage( player, "#HINT_BURNINGGENERATOR" )
				end
			end
	end
end

function blue_gen_repair_trigger_script:onendtouch()
	bluespannerclang = 0
end

function blue_gen_repair_trigger:ondamage()
	if bluespannerclang == 1 then
		 if bluegenup == 0 then
             	if bluefire == 0 then
             	OutputEvent( "bluespannerhit", "PlaySound" )
             	blueclangcntr = blueclangcntr + 1
                     if blueclangcntr > 4 then
                     blueclangcntr = 0             
                     BroadCastMessage("#FF_BLUE_GEN_OK")
                     OpenDoor("blue_doorhack")
		         bluespannerclang = 0
                     bluegenup = 1
                     end
			end
             end
      end
	return EVENT_DISALLOWED
end


-----------------------------------------------------------------------------
-- Walls
-----------------------------------------------------------------------------
-- used to check if walls already broken
red_wall = true
blue_wall = true


red_wall_trigger = trigger_ff_script:new({ })

function red_wall_trigger:onexplode( trigger_entity  ) 
	if red_wall then
		if IsDetpack( trigger_entity ) then 
			OutputEvent( "red_wall", "Break" )
			BroadCastMessage("#FF_RED_GENWALL")
			red_wall = false
		end
	end
	return EVENT_ALLOWED
end
function red_wall_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end



blue_wall_trigger = trigger_ff_script:new({ })

function blue_wall_trigger:onexplode( trigger_entity  ) 
	if blue_wall then
		if IsDetpack( trigger_entity ) then 
			OutputEvent( "blue_wall", "Break" )
		        BroadCastMessage("#FF_BLUE_GENWALL")
			blue_wall = false
		end
	end
	return EVENT_ALLOWED
end
function blue_wall_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end


-----------------------------------------------------------------------------
-- No builds: area where you can't build a jump pad
-----------------------------------------------------------------------------

nobuild = trigger_ff_script:new({})

function nobuild:onbuild( build_entity )
	local player = CastToPlayer( build_entity )
	if player:GetClass() == Player.kScout then
		DisplayMessage( player, "#HINT_NOJUMPPAD" )
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

no_build = nobuild


-----------------------------------------------------------------------------
-- Reset stuff
-----------------------------------------------------------------------------

function RedDoFireResetLogic()
--	ConsoleToAll( "RedDoFireResetLogic" )	

	-- stop fire timer schedule if its still going [no need for this now]
	--DeleteSchedule( "red_fire_timer_schedule" )

	-- Fire is off
	redfire = 0
end


function BlueDoFireResetLogic()
--	ConsoleToAll( "BlueDoFireResetLogic" )	

	-- stop fire timer schedule if its still going [no need for this now]
	--DeleteSchedule( "blue_fire_timer_schedule" )

	-- Fire is off
	bluefire = 0
end


-----------------------------------------------------------------------------
-- Generator delay before repair - schedules
-----------------------------------------------------------------------------

function redfire_start_schedule()	

--	ConsoleToAll( "starting fire timer schedule" )
	AddSchedule( "red_fire_timer_schedule", REDFIRE_TIMER_START, RedDoFireResetLogic )
end


function bluefire_start_schedule()	

--	ConsoleToAll( "starting fire timer schedule" )
	AddSchedule( "blue_fire_timer_schedule", BLUEFIRE_TIMER_START, BlueDoFireResetLogic )
end

-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
SECURITY_LENGTH = 35
red_aardvarksec = red_security_trigger:new()
blue_aardvarksec = blue_security_trigger:new()

-- utility function for getting the name of the opposite team, 
-- where team is a string, like "red"
local function get_opposite_team(team)
	if team == "red" then return "blue" else return "red" end
end

local security_off_base = security_off
function security_off( team )
	security_off_base( team )

	OpenDoor(team.."_aardvarkdoorhack")
	local opposite_team = get_opposite_team(team)
	OutputEvent("sec_"..opposite_team.."_slayer", "Disable")

	AddSchedule("secup10"..team, SECURITY_LENGTH - 10, function()
		BroadCastMessage("#FF_"..team:upper().."_SEC_10")
	end)
end