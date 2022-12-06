local function find_start_of_message(message, distinct)
	local seen = {}
	local j = 1
	for i = 1, #message do
		local cur = message:sub(i, i)
		if seen[cur] ~= nil then
			j = math.max(j, seen[cur] + 1)
		end
		local window = i - j + 1
		if window == distinct then
			return i
		end
		seen[cur] = i
	end
end

local function solve1()
	local input = "./input.txt"
	for line in io.lines(input) do
		local answer = find_start_of_message(line, 4)
		print("part 1:", answer)
	end
end

local function solve2()
	local input = "./input.txt"
	for line in io.lines(input) do
		local answer = find_start_of_message(line, 14)
		print("part 2:", answer)
	end
end

solve1()
solve2()
