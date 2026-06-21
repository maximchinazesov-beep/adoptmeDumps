-- https://lua.expert/
local t = {
	river = { "river1", "river2", "river3" },
	ocean = { "ocean1", "ocean2" },
	lake = { "lake1" }
}
local t2 = {}

for v1, v2 in t do
	for v3, v4 in v2 do
		t2[v4] = v1
	end
end

return {
	by_category = t,
	by_kind = t2
}