table.unpack = table.unpack or unpack

local function read_lines(filename, callback)
	local file = io.open(filename, "r")
	if not file then
		error("error: could not read the file: " .. filename)
	end
	for line in file:lines() do
		callback(line)
	end
	file:close()
end

local function solve1()
	local input = "./input.txt"
	local current = 0
	local max_calories = 0

	read_lines(input, function(line)
		if #line == 0 then
			max_calories = math.max(max_calories, current)
			current = 0
		else
			current = current + line
		end
	end)
	max_calories = math.max(max_calories, current)

	print("part 1:", max_calories)
end

local function solve2()
	local input = "./input.txt"
	local current = 0
	local calories = {}

	read_lines(input, function(line)
		if #line == 0 then
			table.insert(calories, current)
			current = 0
		else
			current = current + line
		end
	end)

	table.insert(calories, current)
	table.sort(calories, function(left, right)
		return right < left
	end)

	local cal1, cal2, cal3 = table.unpack(calories, 1, 3)
	local total = cal1 + cal2 + cal3

	print("part 2:", total)
end

solve1()
solve2()
