
-- base_soldierarena

function startup()

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kRed)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kYellow)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kGreen)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

function player_spawn( player_id )
	-- 400 for overkill. of course the values
	-- get clamped in game code
	local player = GetPlayer(player_id)
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:RemoveAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:RemoveAmmo( Ammo.kCells, 400 )
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )

	-- Players get 1 gren1
	player:AddAmmo( Ammo.kGren1, 1 )
end

function player_ondamage( player, damageinfo )

	if not player_entity then return end
	if not damageinfo then return end

	local attackerPlayer = CastToPlayer(damageinfo:GetAttacker())
	if not attackerPlayer then return end

	local weapon = damageinfo:GetInflictor():GetClassName()
	local player = CastToPlayer(player_entity)

	-- Don't take rocket, gl/pl damage from ourselves
	if ( player:GetId() == attackerPlayer:GetId() ) then
		
		if ( weapon == "ff_projectile_rocket" ) then
			damageinfo:SetDamage(0);
		-- green pipes
		elseif ( weapon == "ff_projectile_pl" ) then
			damageinfo:SetDamage(0);
		-- blue pipes
		elseif ( weapon == "ff_projectile_gl" ) then
			damageinfo:SetDamage(0);
		end
	end
end

function player_killed( player_id )
	-- If you kill someone, give your team a point
	local killer = GetPlayer(killer)
	local victim = GetPlayer(player_id)
	
	if not (victim:GetTeamId() == killer:GetTeamId()) then
		local killersTeam = killer:GetTeam()
		killersTeam:AddScore(1)
	end
end
