local function create_queue()
	local queue = {}
	local i = 1
	return {
		popleft = function()
			local item = queue[i]
			i = i + 1
			return item
		end,
		append = function(item)
			table.insert(queue, item)
		end,
		is_empty = function()
			return i > #queue
		end,
		size = function()
			return #queue - i + 1
		end,
	}
end

local function calc_dist(map, start, end_i, end_j)
	local steps = 0
	local m, n = #map, #map[1]

	local seen = {}
	for i = 1, m do
		local row = {}
		for j = 1, n do
			row[j] = false
		end
		seen[i] = row
	end

	local queue = create_queue()
	for _, pos in pairs(start) do
		queue.append({ pos[1], pos[2] })
		seen[pos[1]][pos[2]] = true
	end

	local dir = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }

	local get_h = function(i, j, ni, nj)
		local a, b = map[i][j], map[ni][nj]
		if a == "S" then
			a = "a"
		end
		if b == "E" then
			b = "z"
		end
		return string.byte(b) - string.byte(a)
	end

	while not queue.is_empty() do
		local qs = queue.size()
		for _ = 1, qs do
			local pos = queue.popleft()
			if pos[1] == end_i and pos[2] == end_j then
				return steps
			end
			local i, j = pos[1], pos[2]
			for _, dpos in pairs(dir) do
				local ni, nj = i + dpos[1], j + dpos[2]
				if ni >= 1 and ni <= m and nj >= 1 and nj <= n and not seen[ni][nj] and get_h(i, j, ni, nj) <= 1 then
					seen[ni][nj] = true
					queue.append({ ni, nj })
				end
			end
		end
		steps = steps + 1
	end

	return steps
end

local function solve1()
	local input = "./input.txt"

	local map = {}
	local start = {}
	local end_i, end_j = 0, 0

	local i = 1
	for line in io.lines(input) do
		local row = {}
		for j = 1, #line do
			local h = line:sub(j, j)
			if h == "S" then
				table.insert(start, { i, j })
			elseif h == "E" then
				end_i, end_j = i, j
			end
			row[j] = h
		end
		map[i] = row
		i = i + 1
	end

	local answer = calc_dist(map, start, end_i, end_j)
	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"

	local map = {}
	local start = {}
	local end_i, end_j = 0, 0

	local i = 1
	for line in io.lines(input) do
		local row = {}
		for j = 1, #line do
			local h = line:sub(j, j)
			if h == "a" or h == "S" then
				table.insert(start, { i, j })
			elseif h == "E" then
				end_i, end_j = i, j
			end
			row[j] = h
		end
		map[i] = row
		i = i + 1
	end

	local answer = calc_dist(map, start, end_i, end_j)
	print("part 2:", answer)
end

solve1()
solve2()
