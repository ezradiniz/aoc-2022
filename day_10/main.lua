local function solve1()
	local input = "./sample.txt"
	local answer = 0

	local function is_cycle_valid(cycle)
		return cycle <= 220 and (cycle - 20) % 40 == 0
	end

	local X = 1
	local cycle = 0

	for line in io.lines(input) do
		cycle = cycle + 1

		if is_cycle_valid(cycle) then
			answer = answer + cycle * X
		end

		if line ~= "noop" then
			local value = line:sub(6, #line)

			cycle = cycle + 1

			if is_cycle_valid(cycle) then
				answer = answer + cycle * X
			end

			X = X + value
		end
	end

	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"
	local rows, cols = 6, 40

	local image = {}
	for i = 1, rows do
		local row = {}
		for j = 1, cols do
			row[j] = "."
		end
		image[i] = row
	end

	local function draw(cycle, X)
		local i = math.floor((cycle - 1) / cols)
		local j = (cycle - 1) % cols
		if math.abs(X - j) < 2 then
			image[i + 1][j + 1] = "#"
		end
	end

	local X = 1
	local cycle = 0

	for line in io.lines(input) do
		cycle = cycle + 1

		draw(cycle, X)

		if line ~= "noop" then
			local value = line:sub(6, #line)

			cycle = cycle + 1

			draw(cycle, X)

			X = X + value
		end
	end

	-- answer
	print("part 2:")
	for i = 1, rows do
		local row = ""
		for j = 1, cols do
			row = row .. image[i][j]
		end
		print(row)
	end
end

solve1()
solve2()
