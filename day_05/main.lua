table.unpack = table.unpack or unpack

local function Stack()
	local stack = {}
	local count = 0

	return {
		push = function(item)
			count = count + 1
			table.insert(stack, count, item)
		end,
		pop = function()
			count = count - 1
			return table.remove(stack, count + 1)
		end,
		top = function()
			return stack[count]
		end,
		reverse = function(i)
			i = ((i or 0) % count) + 1
			local j = count
			while i < j do
				stack[i], stack[j] = stack[j], stack[i]
				i = i + 1
				j = j - 1
			end
		end,
	}
end

local function parse_moves(line)
	local moves = {}
	for val in string.gmatch(line, "[0-9]+") do
		table.insert(moves, tonumber(val))
	end
	return table.unpack(moves) -- count, from, to
end

local function parse_stacks(stacks, line)
	local count = 0
	for i = 2, #line, 4 do
		local crate = line:sub(i, i)
		if crate >= "1" and crate <= "9" then
			break
		end
		count = count + 1
		if count > #stacks then
			table.insert(stacks, count, Stack())
		end
		if crate ~= " " then
			stacks[count].push(crate)
		end
	end
end

local function solve1()
	local input = "./input.txt"

	local stacks = {}

	for line in io.lines(input) do
		if line:sub(1, 4) == "move" then
			local count, from, to = parse_moves(line)
			local s1, s2 = stacks[from], stacks[to]
			for _ = 1, count do
				s2.push(s1.pop())
			end
		elseif #line == 0 then
			for _, stk in pairs(stacks) do
				stk.reverse()
			end
		else
			parse_stacks(stacks, line)
		end
	end

	local answer = ""
	for _, stk in ipairs(stacks) do
		answer = answer .. stk.top()
	end

	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"
	local stacks = {}

	for line in io.lines(input) do
		if line:sub(1, 4) == "move" then
			local count, from, to = parse_moves(line)
			local s1, s2 = stacks[from], stacks[to]
			s1.reverse(-count)
			for _ = 1, count do
				s2.push(s1.pop())
			end
		elseif #line == 0 then
			for _, stk in pairs(stacks) do
				stk.reverse()
			end
		else
			parse_stacks(stacks, line)
		end
	end

	local answer = ""
	for _, stk in ipairs(stacks) do
		answer = answer .. stk.top()
	end

	print("part 2:", answer)
end

solve1()
solve2()
