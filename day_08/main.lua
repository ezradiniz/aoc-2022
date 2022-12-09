local function create_stack()
	local stack = {}

	return {
		calc_dist = function(val, pos, default)
			while #stack > 0 and stack[#stack][1] < val do
				table.remove(stack)
			end
			if #stack > 0 then
				return math.abs(pos - stack[#stack][2])
			end
			return default or 0
		end,
		add = function(val, pos)
			table.insert(stack, { val, pos })
		end,
	}
end

local function read_grid(input)
	local grid = {}
	for line in io.lines(input) do
		local row = {}
		for i = 1, #line do
			local cur = tonumber(line:sub(i, i))
			table.insert(row, cur)
		end
		table.insert(grid, row)
	end
	return grid
end

local function solve1()
	local input = "./input.txt"

	local grid = read_grid(input)
	local R, C = #grid, #grid[1]

	local function is_border(i, j)
		return i == 1 or i == R or j == 1 or j == C
	end

	local visible = {}
	for i = 1, R do
		local row = {}
		for j = 1, C do
			row[j] = false
		end
		table.insert(visible, i, row)
	end

	for i = 1, R do
		local left = create_stack()
		local right = create_stack()
		for j = 1, C do
			local k = C - j + 1
			local l = grid[i][j]
			local r = grid[i][k]
			local d1 = left.calc_dist(l, j)
			local d2 = right.calc_dist(r, k)
			visible[i][j] = visible[i][j] or (d1 == 0 or is_border(i, j))
			visible[i][k] = visible[i][k] or (d2 == 0 or is_border(i, j))
			left.add(l, j)
			right.add(r, k)
		end
	end

	for j = 1, C do
		local top = create_stack()
		local bottom = create_stack()
		for i = 1, R do
			local k = R - i + 1
			local t = grid[i][j]
			local b = grid[k][j]
			local d1 = top.calc_dist(t, i)
			local d2 = bottom.calc_dist(b, k)
			visible[i][j] = visible[i][j] or (d1 == 0 or is_border(i, j))
			visible[k][j] = visible[k][j] or (d2 == 0 or is_border(i, j))
			top.add(t, i)
			bottom.add(b, k)
		end
	end

	local answer = 0
	for i = 1, R do
		for j = 1, C do
			if visible[i][j] then
				answer = answer + 1
			end
		end
	end

	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"

	local grid = read_grid(input)
	local R, C = #grid, #grid[1]

	local dist = {}
	for i = 1, R do
		local row = {}
		for j = 1, C do
			row[j] = 1
		end
		table.insert(dist, i, row)
	end

	for i = 1, R do
		local left = create_stack()
		local right = create_stack()
		for j = 1, C do
			local k = C - j + 1
			local l = grid[i][j]
			local r = grid[i][k]
			local d1 = left.calc_dist(l, j, j - 1)
			local d2 = right.calc_dist(r, k, C - k)
			dist[i][j] = dist[i][j] * d1
			dist[i][k] = dist[i][k] * d2
			left.add(l, j)
			right.add(r, k)
		end
	end

	for j = 1, C do
		local top = create_stack()
		local bottom = create_stack()
		for i = 1, R do
			local k = R - i + 1
			local t = grid[i][j]
			local b = grid[k][j]
			local d1 = top.calc_dist(t, i, i - 1)
			local d2 = bottom.calc_dist(b, k, R - k)
			dist[i][j] = dist[i][j] * d1
			dist[k][j] = dist[k][j] * d2
			top.add(t, i)
			bottom.add(b, k)
		end
	end

	local answer = 0
	for i = 1, R do
		for j = 1, C do
			answer = math.max(answer, dist[i][j])
		end
	end

	print("part 2:", answer)
end

solve1()
solve2()
