local function create_graph()
	local G = {}
	local I = {}
	local count = 0
	return {
		G = G,
		I = I,
		add = function(u, v)
			if G[u] == nil then
				G[u] = {}
				I[u] = count
				count = count + 1
			end
			table.insert(G[u], v)
		end,
	}
end

local function parse_valve(line)
	return line:sub(7, line:find("h") - 2)
end

local function parse_rate(line)
	return tonumber(line:sub(line:find("=") + 1, line:find(";") - 1))
end

local function parse_tunnels(line)
	local tunnels = {}
	for valve in string.gmatch(line:sub(line:find(" ", line:find("to") + 3), #line), "[A-Z]+") do
		table.insert(tunnels, valve)
	end
	return tunnels
end

local function solve1()
	local input = "./input.txt"
	local graph = create_graph()
	local rates = {}

	for line in io.lines(input) do
		local valve = parse_valve(line)
		local rate = parse_rate(line)
		local tunnels = parse_tunnels(line)
		for _, tvalve in pairs(tunnels) do
			graph.add(valve, tvalve)
		end
		rates[valve] = rate
	end

	local total_rates = 0
	for k, v in pairs(graph.I) do
		if rates[k] > 0 then
			total_rates = total_rates | (1 << v)
		end
	end

	local memo = {}
	local function get_max_pressure(cur, mask, time)
		if time == 1 then
			return 0
		end

		if mask == total_rates then
			return 0
		end

		local key = tostring(cur) .. "," .. tostring(mask) .. "," .. tostring(time)

		if memo[key] ~= nil then
			return memo[key]
		end

		local t = time - 1
		local ret = 0
		if rates[cur] > 0 and (mask & (1 << graph.I[cur])) == 0 then
			ret = math.max(ret, get_max_pressure(cur, mask | (1 << graph.I[cur]), time - 1) + rates[cur] * t)
		end

		for _, nxt_cur in pairs(graph.G[cur]) do
			ret = math.max(ret, get_max_pressure(nxt_cur, mask, time - 1))
		end

		memo[key] = ret
		return ret
	end

	local answer = get_max_pressure("AA", 0, 30)
	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"
	local graph = create_graph()
	local rates = {}

	for line in io.lines(input) do
		local valve = parse_valve(line)
		local rate = parse_rate(line)
		local tunnels = parse_tunnels(line)
		for _, tvalve in pairs(tunnels) do
			graph.add(valve, tvalve)
		end
		rates[valve] = rate
	end

	local total_rates = 0
	for k, v in pairs(graph.I) do
		if rates[k] > 0 then
			total_rates = total_rates | (1 << v)
		end
	end

	-- This is too slow
	local memo = {}
	local function get_max_pressure(cur, mask, time, turn)
		if time == 1 then
			if turn then
				return get_max_pressure("AA", mask, 26, false)
			end
			return 0
		end

		if mask == total_rates then
			return 0
		end

		local key = tostring(cur) .. "," .. tostring(mask) .. "," .. tostring(time) .. "," .. tostring(turn)

		if memo[key] ~= nil then
			return memo[key]
		end

		local t = time - 1
		local ret = 0
		if rates[cur] > 0 and (mask & (1 << graph.I[cur])) == 0 then
			ret = math.max(ret, get_max_pressure(cur, mask | (1 << graph.I[cur]), time - 1, turn) + rates[cur] * t)
		end

		for _, nxt_cur in pairs(graph.G[cur]) do
			ret = math.max(ret, get_max_pressure(nxt_cur, mask, time - 1, turn))
		end

		memo[key] = ret
		return ret
	end

	local answer = get_max_pressure("AA", 0, 26, true)
	print("part 2:", answer)
end

solve1()
solve2()
