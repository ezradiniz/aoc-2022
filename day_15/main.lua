local function parse_position(line)
	local sep = string.find(line, ",")
	local s_end = string.find(line, ":", sep)
	local x1 = tonumber(line:sub(13, sep - 1))
	local y1 = tonumber(line:sub(sep + 4, s_end - 1))
	local sep2 = string.find(line, ",", s_end)
	local x2 = tonumber(line:sub(s_end + 25, sep2 - 1))
	local y2 = tonumber(line:sub(sep2 + 4, #line))
	return { x1, y1, x2, y2 }
end

local function calc_dist(p1, p2)
	return math.abs(p1[1] - p2[1]) + math.abs(p1[2] - p2[2])
end

local function solve1()
	local input = "./input.txt"

	local function create_set()
		local map = {}
		return {
			add = function(x, y)
				if map[x] == nil then
					map[x] = {}
				end
				map[x][y] = true
			end,
			has = function(x, y)
				return map[x] ~= nil and map[x][y] ~= nil
			end,
		}
	end

	local sensors = {}
	local beacons = create_set()
	local inf = 1e20
	local min_x, max_x = inf, -inf

	for line in io.lines(input) do
		local pos = parse_position(line)
		local sensor = { pos[1], pos[2] }
		local beacon = { pos[3], pos[4] }
		beacons.add(pos[3], pos[4])
		local dist = calc_dist(sensor, beacon)
		min_x = math.min(min_x, pos[1] - dist)
		max_x = math.max(max_x, pos[1] + dist)
		table.insert(sensors, { sensor, dist })
	end

	local answer = 0
	local y = 2000000
	for x = min_x - 1, max_x + 1 do
		if not beacons.has(x, y) then
			for _, s in pairs(sensors) do
				local s_pos, max_dist = s[1], s[2]
				local dist = calc_dist(s_pos, { x, y })
				if dist <= max_dist then
					answer = answer + 1
					break
				end
			end
		end
	end

	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"

	local sensors = {}
	for line in io.lines(input) do
		local pos = parse_position(line)
		local sensor = { pos[1], pos[2] }
		local beacon = { pos[3], pos[4] }
		table.insert(sensors, { sensor, calc_dist(sensor, beacon) })
	end

	local mi, ma = 0, 4000000
	local dirs = { { -1, -1 }, { -1, 1 }, { 1, 1 }, { 1, -1 } }

	local function is_valid(x, y)
		return x >= mi and x <= ma and y >= mi and y <= ma
	end

	local function find_point()
		for _, item in pairs(sensors) do
			local sensor, dist = item[1], item[2]
			local x, y = sensor[1], sensor[2] + 1
			x = x + dist

			for _, d in ipairs(dirs) do
				for i = 0, dist do
					if is_valid(x, y) then
						local good = true
						for j = 1, #sensors do
							local s, sdist = sensors[j][1], sensors[j][2]
							if calc_dist({ x, y }, s) <= sdist then
								good = false
								break
							end
						end

						if good then
							return { x, y }
						end
					end

					local nx, ny = x + d[1], y + d[2]
					if i ~= dist then
						x = nx
						y = ny
					end
				end
			end
		end
		return { -1, -1 }
	end

	local point = find_point()
	local answer = point[1] * 4000000 + point[2]
	print("part 2:", answer)
end

solve1()
solve2()
