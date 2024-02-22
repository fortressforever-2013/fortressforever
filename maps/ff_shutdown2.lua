-- ff_shutdown2.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_shutdown");

SECURITY_LENGTH = 60

-----------------------------------------------------------------------------
-- security
-----------------------------------------------------------------------------
red_aardvarksec = red_security_trigger:new()
blue_aardvarksec = blue_security_trigger:new()

local security_off_base = security_off
function security_off( team )
	security_off_base( team )

	OpenDoor(team.."_aardvarkdoorhack")

	AddSchedule("secup10"..team, SECURITY_LENGTH - 10, function()
		BroadCastMessage("#FF_"..team:upper().."_SEC_10")
	end)
end

local security_on_base = security_on
function security_on( team )
	security_on_base( team )

	CloseDoor(team.."_aardvarkdoorhack")
end

-----------------------------------------------------------------------------
-- respawn shields
-----------------------------------------------------------------------------
blue_slayer = not_red_trigger:new()
red_slayer = not_blue_trigger:new()
