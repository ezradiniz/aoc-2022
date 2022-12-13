local function compare(lst1, lst2)
	local m, n = #lst1, #lst2
	local size = math.min(m, n)

	for i = 1, size do
		local cur1 = lst1[i]
		local cur2 = lst2[i]

		if type(cur1) == "number" and type(cur2) == "number" then
			if cur1 < cur2 then
				return -1
			elseif cur1 > cur2 then
				return 1
			end
		elseif type(cur1) == "number" then
			local cmp = compare({ cur1 }, cur2)
			if cmp ~= 0 then
				return cmp
			end
		elseif type(cur2) == "number" then
			local cmp = compare(cur1, { cur2 })
			if cmp ~= 0 then
				return cmp
			end
		else
			local cmp = compare(cur1, cur2)
			if cmp ~= 0 then
				return cmp
			end
		end
	end

	return math.max(-1, math.min(1, m - n))
end

local function parse_list(line)
	local stack = { {} }
	local val = 0
	for i = 1, #line do
		local cur = line:sub(i, i)
		if cur == "]" then
			table.remove(stack)
		elseif cur == "[" then
			local lst = {}
			table.insert(stack[#stack], lst)
			table.insert(stack, lst)
		elseif cur ~= "," then
			val = val * 10 + tonumber(cur)
			if tonumber(line:sub(i + 1, i + 1)) == nil then
				table.insert(stack[#stack], val)
				val = 0
			end
		end
	end
	return stack[1][1]
end

local function solve1()
	local input = "./input.txt"
	local answer = 0

	local ln = 1
	local pair_idx = 0
	local pairs = {}

	for line in io.lines(input) do
		if line ~= "" then
			table.insert(pairs, parse_list(line))
			if ln % 2 == 0 then
				pair_idx = pair_idx + 1
				if compare(pairs[1], pairs[2]) < 0 then
					answer = answer + pair_idx
				end
				pairs = {}
			end
			ln = ln + 1
		end
	end

	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"

	local packets = {}

	local div_packet1 = { { 2 } }
	local div_packet2 = { { 6 } }

	table.insert(packets, div_packet1)
	table.insert(packets, div_packet2)

	for line in io.lines(input) do
		if line ~= "" then
			table.insert(packets, parse_list(line))
		end
	end

	table.sort(packets, function(lst1, lst2)
		return compare(lst1, lst2) < 0
	end)

	local answer = 1
	for i, packet in ipairs(packets) do
		if compare(packet, div_packet1) == 0 or compare(packet, div_packet2) == 0 then
			answer = answer * i
		end
	end

	print("part 2:", answer)
end

solve1()
solve2()
