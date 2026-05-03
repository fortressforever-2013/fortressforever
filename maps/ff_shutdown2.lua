-- ff_shutdown2.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_shutdown");
PrecacheSound( "HL2Player.TrainUse" )

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

-----------------------------------------------------------------------------
-- OFFENSE AND DEFENSE SPAWNS
-----------------------------------------------------------------------------
red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kSoldier) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kSpy))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSoldier) or (player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kEngineer))) end

redspawn_offense = { validspawn = red_o_only }
redspawn_defense = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kSoldier) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kSpy))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSoldier) or (player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kEngineer))) end

bluespawn_offense = { validspawn = blue_o_only }
bluespawn_defense = { validspawn = blue_d_only }