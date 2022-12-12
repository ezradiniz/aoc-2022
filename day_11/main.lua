local function create_monkey()
	local monkey = {
		items = {},
		div = nil,
		operation = nil,
		to_true = nil,
		to_false = nil,
		count = 0,
	}
	return monkey
end

local function create_operation(op, val1)
	return function(val2, transform)
		local v = val1
		if val1 == "old" then
			v = val2
		end
		if op == "*" then
			return transform(v * val2)
		elseif op == "+" then
			return transform(v + val2)
		else
			error("unexpected operation: " .. op)
		end
	end
end

local function parse_monkeys(input)
	local monkeys = {}
	local cur_monkey = nil
	for line in io.lines(input) do
		if line:sub(1, 6) == "Monkey" then
			cur_monkey = create_monkey()
			table.insert(monkeys, cur_monkey)
		elseif line:sub(3, 10) == "Starting" then
			for item in line:gmatch("%d+") do
				table.insert(cur_monkey.items, tonumber(item))
			end
		elseif line:sub(3, 6) == "Test" then
			cur_monkey.div = tonumber(line:sub(22, #line))
		elseif line:sub(3, 11) == "Operation" then
			local op = line:sub(24, 24)
			local val = line:sub(26, #line)
			cur_monkey.operation = create_operation(op, val)
		elseif line:sub(8, 11) == "true" then
			cur_monkey.to_true = tonumber(line:sub(29, #line)) + 1
		elseif line:sub(8, 12) == "false" then
			cur_monkey.to_false = tonumber(line:sub(30, #line)) + 1
		end
	end
	return monkeys
end

local function run(rounds, monkeys, transform_worry)
	for _ = 1, rounds do
		for _, monkey in pairs(monkeys) do
			for i, item in pairs(monkey.items) do
				local worry = monkey.operation(item, transform_worry)
				local next
				if worry % monkey.div == 0 then
					next = monkey.to_true
				else
					next = monkey.to_false
				end
				table.insert(monkeys[next].items, worry)
				monkey.count = monkey.count + 1
				monkey.items[i] = nil
			end
		end
	end
end

local function solve1()
	local input = "./input.txt"

	local monkeys = parse_monkeys(input)

	local function transform_worry(worry)
		return math.floor(worry / 3)
	end

	run(20, monkeys, transform_worry)

	local counter = {}
	for _, monkey in pairs(monkeys) do
		table.insert(counter, monkey.count)
	end

	table.sort(counter)
	local top1, top2 = counter[#counter], counter[#counter - 1]

	print("part 1:", top1 * top2)
end

local function solve2()
	local input = "./input.txt"

	local function gcd(a, b)
		if b == 0 then
			return a
		end
		return gcd(b, a % b)
	end

	local function lcm(...)
		local arg = { ... }
		local ret = 1
		for _, n in ipairs(arg) do
			ret = ret * n / gcd(ret, n)
		end
		return ret
	end

	local monkeys = parse_monkeys(input)
	local mod = 1
	for _, monkey in pairs(monkeys) do
		mod = lcm(mod, monkey.div)
	end

	local function transform_worry(worry)
		return worry % mod
	end

	run(10000, monkeys, transform_worry)

	local counter = {}
	for _, monkey in pairs(monkeys) do
		table.insert(counter, monkey.count)
	end

	table.sort(counter)
	local top1, top2 = counter[#counter], counter[#counter - 1]

	print("part 2:", top1 * top2)
end

solve1()
solve2()
