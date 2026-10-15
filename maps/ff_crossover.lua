
IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60


-----------------------------------------------------------------------------
-- startup 
-----------------------------------------------------------------------------

function startup()
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 ) 

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )	

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )
end


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

-- red lasers hurt blue and vice-versa

red_laser_hurt = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_red_tunnel= location_info:new({ text = "Tunnels", team = Team.kRed }) 
location_red_lowerrespawn= location_info:new({ text = "Lower Respawn", team = Team.kRed })
location_red_upperrespawn= location_info:new({ text = "Upper Respawn", team = Team.kRed })
location_blue_tunnel= location_info:new({ text = "Tunnels", team = Team.kblue }) 
location_blue_lowerrespawn= location_info:new({ text = "Lower Respawn", team = Team.kBlue })
location_blue_upperrespawn= location_info:new({ text = "Upper Respawn", team = Team.kBlue })