local function read_lines(filename, callback)
	local file = io.open(filename, "r")
	if not file then
		error("error: could not read the file: " .. filename)
	end
	local index = 1
	for line in file:lines() do
		callback(line, index)
		index = index + 1
	end
	file:close()
end

local function to_priority(item)
	if string.upper(item) == item then
		return string.byte(item) - string.byte("A") + 27
	else
		return string.byte(item) - string.byte("a") + 1
	end
end

local function solve1()
	local input = "./input.txt"

	local calc_priority = function(part1, part2)
		local items1 = {}
		for i = 1, #part1 do
			local item = part1:sub(i, i)
			items1[item] = true
		end

		local items2 = {}
		for i = 1, #part2 do
			local item = part2:sub(i, i)
			items2[item] = true
		end

		local priority = 0
		for item, _ in pairs(items2) do
			if items1[item] ~= nil then
				priority = priority + to_priority(item)
			end
		end

		return priority
	end

	local sum = 0
	read_lines(input, function(items)
		local half = #items / 2
		local part1 = items:sub(1, half)
		local part2 = items:sub(half + 1, #items)
		sum = sum + calc_priority(part1, part2)
	end)

	print("part 1:", sum)
end

local function solve2()
	local input = "./input.txt"

	local group = {}

	local add_badge_to_group = function(item)
		if group[item] ~= nil then
			group[item] = group[item] + 1
		else
			group[item] = 1
		end
	end

	local get_group_priority = function()
		for item, count in pairs(group) do
			if count == 3 then
				return to_priority(item)
			end
		end
		return 0
	end

	local reset_group = function()
		for k, _ in pairs(group) do
			group[k] = nil
		end
	end

	local add_to_group = function(items)
		local seen = {}
		for i = 1, #items do
			local item = items:sub(i, i)
			if seen[item] == nil then
				add_badge_to_group(item)
			end
			seen[item] = true
		end
	end

	local sum = 0
	read_lines(input, function(items, index)
		add_to_group(items)
		if index % 3 == 0 then
			sum = sum + get_group_priority()
			reset_group()
		end
	end)

	print("part 2:", sum)
end

solve1()
solve2()
