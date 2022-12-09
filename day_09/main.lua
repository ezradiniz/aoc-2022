table.unpack = table.unpack or unpack

local function create_rope(length)
	local rope = {}

	for i = 1, length do
		rope[i] = { 0, 0 }
	end

	return {
		move = function(dir)
			local dx, dy = 0, 0

			if dir == "U" then
				dy = 1
			elseif dir == "D" then
				dy = -1
			elseif dir == "L" then
				dx = -1
			else
				dx = 1
			end

			local x, y = table.unpack(rope[1])

			x = x + dx
			y = y + dy

			local px, py = x, y

			rope[1] = { x, y }

			for i = 2, length do
				x, y = table.unpack(rope[i])

				if math.abs(x - px) == 2 and math.abs(y - py) == 2 then
					x, y = math.floor((x + px) / 2), math.floor((y + py) / 2)
				elseif math.abs(y - py) == 2 then
					x, y = px, math.floor((y + py) / 2)
				elseif math.abs(x - px) == 2 then
					x, y = math.floor((x + px) / 2), py
				end

				rope[i] = { x, y }
				px, py = x, y
			end
		end,
		tail = function()
			return rope[length]
		end,
	}
end

local function solve1()
	local input = "./input.txt"

	local rope = create_rope(2)
	local path = {}

	for line in io.lines(input) do
		local dir, count = line:sub(1, 1), tonumber(line:sub(3, #line))
		for _ = 1, count do
			rope.move(dir)
			local tail = rope.tail()
			local tail_key = tail[1] .. "," .. tail[2]
			path[tail_key] = true
		end
	end

	local answer = 0
	for _ in pairs(path) do
		answer = answer + 1
	end

	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"

	local rope = create_rope(10)
	local path = {}

	for line in io.lines(input) do
		local dir, count = line:sub(1, 1), tonumber(line:sub(3, #line))
		for _ = 1, count do
			rope.move(dir)
			local tail = rope.tail()
			local tail_key = tail[1] .. "," .. tail[2]
			path[tail_key] = true
		end
	end

	local answer = 0
	for _ in pairs(path) do
		answer = answer + 1
	end

	print("part 2:", answer)
end

solve1()
solve2()
