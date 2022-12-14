local function create_map()
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

local function traverse_coordinates(c1, c2, callback)
	if c1[2] == c2[2] then
		local lo, hi = math.min(c1[1], c2[1]), math.max(c1[1], c2[1])
		for i = lo, hi do
			callback(i, c2[2])
		end
	end
	if c1[1] == c2[1] then
		local lo, hi = math.min(c1[2], c2[2]), math.max(c1[2], c2[2])
		for i = lo, hi do
			callback(c1[1], i)
		end
	end
end

local function parse_coordinates(line)
	local coor = {}
	for xy in string.gmatch(line, "%d*,%d*") do
		local sep = string.find(xy, ",")
		local x, y = tonumber(xy:sub(1, sep - 1)), tonumber(xy:sub(sep + 1, #xy))
		table.insert(coor, { x, y })
	end
	return coor
end

local function simul_sand(map, max_depth, sand_point, endless)
	local x, y = sand_point[1], sand_point[2]

	if map.has(x, y) then
		return false
	end

	while y <= max_depth do
		if map.has(x, y + 1) then
			if not map.has(x - 1, y + 1) then
				y = y + 1
				x = x - 1
			elseif not map.has(x + 1, y + 1) then
				y = y + 1
				x = x + 1
			else
				map.add(x, y)
				return true
			end
		elseif not endless and y == max_depth then
			map.add(x, y - 1)
			return true
		else
			y = y + 1
		end
	end

	return false
end

local function solve1()
	local input = "./input.txt"

	local map = create_map()
	local max_depth = 0

	for line in io.lines(input) do
		local coordinates = parse_coordinates(line)
		for i = 1, #coordinates - 1 do
			local c1, c2 = coordinates[i], coordinates[i + 1]
			traverse_coordinates(c1, c2, function(x, y)
				map.add(x, y)
				max_depth = math.max(max_depth, y)
			end)
		end
	end

	local answer = 0
	local sand_point = { 500, 0 }
	while simul_sand(map, max_depth, sand_point, true) do
		answer = answer + 1
	end

	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"

	local map = create_map()
	local max_depth = 0

	for line in io.lines(input) do
		local coordinates = parse_coordinates(line)
		for i = 1, #coordinates - 1 do
			local c1, c2 = coordinates[i], coordinates[i + 1]
			traverse_coordinates(c1, c2, function(x, y)
				map.add(x, y)
				max_depth = math.max(max_depth, y)
			end)
		end
	end

	local answer = 0
	local sand_point = { 500, 0 }
	while simul_sand(map, max_depth + 2, sand_point, false) do
		answer = answer + 1
	end

	print("part 2:", answer)
end

solve1()
solve2()
