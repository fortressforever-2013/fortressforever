-- backwards compatibility for the Collection class

local Class = require "util.class"
require "util.utils"

local Collection = Class(function(self, entity_or_entities)
	self.entities = totable(entity_or_entities)
	self:SetupItemsKey()
end)

Collection.filters = {
	[CF.kNone] = function(entity) return true end,
	[CF.kPlayers] = function(entity) return IsPlayer(entity) end,
	[CF.kHumanPlayers] = function(entity) return IsPlayer(entity) and not CastToPlayer(entity):IsBot() end,
	[CF.kBotPlayers] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):IsBot() end,
	[CF.kPlayerScout] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kScout end,
	[CF.kPlayerSniper] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kSniper end,
	[CF.kPlayerSoldier] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kSoldier end,
	[CF.kPlayerDemoman] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kDemoman end,
	[CF.kPlayerMedic] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kMedic end,
	[CF.kPlayerHWGuy] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kHwguy end,
	[CF.kPlayerPyro] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kPyro end,
	[CF.kPlayerSpy] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kSpy end,
	[CF.kPlayerEngineer] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kEngineer end,
	[CF.kPlayerCivilian] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kCivilian end,
	[CF.kPlayerScout] = function(entity) return IsPlayer(entity) and CastToPlayer(entity):GetClass() == Player.kScout end,
	[CF.kTeams] = function(entity) return IsEntity(entity) and entity:GetTeamId() >= Team.kSpectator and entity:GetTeamId() <= Team.kGreen end,
	[CF.kTeamSpec] = function(entity) return IsEntity(entity) and entity:GetTeamId() == Team.kSpectator end,
	[CF.kTeamBlue] = function(entity) return IsEntity(entity) and entity:GetTeamId() == Team.kBlue end,
	[CF.kTeamRed] = function(entity) return IsEntity(entity) and entity:GetTeamId() == Team.kRed end,
	[CF.kTeamYellow] = function(entity) return IsEntity(entity) and entity:GetTeamId() == Team.kYellow end,
	[CF.kTeamGreen] = function(entity) return IsEntity(entity) and entity:GetTeamId() == Team.kGreen end,
	[CF.kProjectiles] = function(entity) return IsProjectile(entity) end,
	[CF.kGrenades] = function(entity) return IsGrenade(entity) end,
	[CF.kInfoScipts] = function(entity) return IsInfoScript(entity) end,
	[CF.kInfoScript_Carried] = function(entity) return IsInfoScript(entity) and CastToInfoScript(entity):IsCarried() end,
	[CF.kInfoScript_Dropped] = function(entity) return IsInfoScript(entity) and CastToInfoScript(entity):IsDropped() end,
	[CF.kInfoScript_Returned] = function(entity) return IsInfoScript(entity) and CastToInfoScript(entity):IsReturned() end,
	[CF.kInfoScript_Active] = function(entity) return IsInfoScript(entity) and CastToInfoScript(entity):IsActive() end,
	[CF.kInfoScript_Inactive] = function(entity) return IsInfoScript(entity) and CastToInfoScript(entity):IsInactive() end,
	[CF.kInfoScript_Removed] = function(entity) return IsInfoScript(entity) and CastToInfoScript(entity):IsRemoved() end,
	[CF.kTraceBlockWalls] = function(entity) return true end, -- not applicable for this type of filtering
	[CF.kBuildables] = function(entity) return IsBuildable(entity) end,
	[CF.kDispenser] = function(entity) return IsDispenser(entity) end,
	[CF.kSentrygun] = function(entity) return IsSentrygun(entity) end,
	[CF.kDetpack] = function(entity) return IsDetpack(entity) end,
	[CF.kJumpPad] = function(entity) return IsJumpPad(entity) end,
}

function Collection.PassesFilter(entity, filter)
	if not filter then filter = CF.kNone end
	assert(Collection.filters[filter], "Unknown filter: "..tostring(filter))
	return Collection.filters[filter](entity)
end

function Collection.PassesFilters(entity, filters)
	if not filters then return true end
	filters = totable(filters)
	for _,filter in ipairs(filters) do
		if not Collection.PassesFilter(entity, filter) then
			return false
		end
	end
	return true
end

function Collection:SetupItemsKey()
	-- keep a usable reference to the base metatable
	local real_obj = setmetatable({}, getmetatable(self))
	-- add special handling of the items key
	setmetatable(self, {
		-- the items key returns an iterator
		__index = function(t, k)
			if k == "items" then
				local i = 0
				local n = self:Count()
				return function()
					i = i + 1
					if i <= n then return self.entities[i] end
				end
			end
			return real_obj[k]
		end,
		-- protect the items key from being assigned
		__newindex = function(t, k, v)
			if k == "items" then
				return
			end
			real_obj[k] = v
		end
	})
end

-- lua tables start at index 1
function Collection.ToLuaIndex(collection_index)
	return collection_index+1
end

-- Collection started at index 0
function Collection.ToCollectionIndex(lua_index)
	return lua_index-1
end

function Collection:AddItem(entity_or_entities)
	local entities_to_add = totable(entity_or_entities)

	for i,entity_to_add in ipairs(entities_to_add) do
		table.insert(self.entities, entity_to_add)
	end
end

function Collection:AddFiltered(entity_or_entities, filters)
	local entities_to_add = totable(entity_or_entities)

	for i,entity_to_add in ipairs(entities_to_add) do
		if Collection.PassesFilters(entity_to_add, filters) then
			table.insert(self.entities, entity_to_add)
		end
	end
end

function Collection:RemoveItem(entity_or_entities)
	local entities_to_find = totable(entity_or_entities)

	for i,entity_to_find in ipairs(entities_to_find) do
		local i = self:FindItemIndex(entity_to_find)
		if i then
			table.remove(self.entities, Collection.ToLuaIndex(i))
		end
	end
end

function Collection:RemoveAllItems()
	table.clear(self.entities)
end

function Collection:Count()
	return #self.entities
end

function Collection:NumItems()
	return self:Count()
end

function Collection:IsEmpty()
	return self:Count() == 0
end

function Collection:HasItem(entity_or_entities)
	local entities_to_find = totable(entity_or_entities)

	for i,entity_to_find in ipairs(entities_to_find) do
		if self:FindItemIndex(entity_to_find) then
			return true
		end
	end
	return false
end

-- this is a strange function
function Collection:GetItem(entity_or_entities)
	local entities_to_find = totable(entity_or_entities)

	for i,entity_to_find in ipairs(entities_to_find) do
		local i = self:FindItemIndex(entity_to_find)
		if i then
			return self:Element(i)
		end
	end
end

function Collection:FindItemIndex(entity_to_find)
	for i,entity in ipairs(self.entities) do
		if entity:GetId() == entity_to_find:GetId() then
			return Collection.ToCollectionIndex(i)
		end
	end
	return nil
end

function Collection:Element(i)
	return self.entities[Collection.ToLuaIndex(i)]
end

function Collection:GetByFilter(filters)
	filters = totable(filters)

	-- optimization for players
	local players_only = false
	for _,filter in ipairs(filters) do
		if filter >= CF.kPlayers and filter <= CF.kPlayerScout then
			players_only = true
			break
		end
	end

	if players_only then
		self:AddFiltered(GetPlayers(), filters)
	else
		for ent_id, entity in ipairs(GlobalEntityList) do
			self:AddFiltered(entity, filters)
		end
	end
end

function Collection:GetByName(name_or_names, filters)
	local names_to_find = totable(name_or_names)
	filters = totable(filters)

	for i,name_to_find in ipairs(names_to_find) do
		self:AddFiltered(GetEntitiesByName(name_to_find), filters)
	end
end

function Collection:GetInSphere(entity_or_origin, radius, filters)
	filters = totable(filters)
	local origin = IsEntity(entity_or_origin) and entity_or_origin:GetOrigin() or entity_or_origin
	local ignore_walls = not table.contains(filters, CF.kTraceBlockWalls)
	self:AddFiltered(GetEntitiesInSphere(origin, radius, ignore_walls), filters)
end

return Collection