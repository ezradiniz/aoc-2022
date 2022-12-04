table.unpack = table.unpack or unpack

local function solve1()
	local input = "./input.txt"
	local current = 0
	local max_calories = 0

	for line in io.lines(input) do
		if #line == 0 then
			max_calories = math.max(max_calories, current)
			current = 0
		else
			current = current + line
		end
	end
	max_calories = math.max(max_calories, current)

	print("part 1:", max_calories)
end

local function solve2()
	local input = "./input.txt"
	local current = 0
	local calories = {}

	for line in io.lines(input) do
		if #line == 0 then
			table.insert(calories, current)
			current = 0
		else
			current = current + line
		end
	end

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
