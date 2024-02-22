
function table.clear(tbl)
	for k in pairs(tbl) do
		tbl[k] = nil
	end
end

function table.contains(tbl, element)
	if tbl == nil then return false end
	for _, value in pairs(tbl) do
		if value == element then
			return true
		end
	end
	return false
end

function table.contains_any(tbl, elements)
	if tbl == nil or elements == nil then return false end
	for _, value in pairs(tbl) do
		for _, element in pairs(elements) do
			if value == element then
				return true
			end
		end
	end
	return false
end

function totable(obj)
	if obj == nil then return {} end
	if type(obj) == "table" then return obj end
	return {obj}
end