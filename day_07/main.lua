local function build_file_tree(input)
	local make_node = function()
		return { _size = 0 }
	end

	local root = make_node()
	local stack = { root }

	for line in io.lines(input) do
		if line == "$ cd .." then
			local prev = table.remove(stack, #stack)
			stack[#stack]["_size"] = stack[#stack]["_size"] + prev["_size"]
		elseif line:sub(1, 5) == "$ cd " then
			local dir = line:sub(6, #line)
			table.insert(stack, stack[#stack][dir])
		elseif line == "$ ls" then
			-- Do nothing
		elseif line:sub(1, 3) == "dir" then
			local dir = line:sub(5, #line)
			stack[#stack][dir] = make_node()
		else
			local size = tonumber(line:sub(1, line:find(" ") - 1))
			stack[#stack]["_size"] = stack[#stack]["_size"] + size
		end
	end

	return root
end

local function traverse_file_tree(node, callback)
	for key, dir in pairs(node) do
		if key ~= "_size" then
			traverse_file_tree(dir, callback)
		end
	end
	callback(node["_size"])
end

local function solve1()
	local input = "./input.txt"
	local root = build_file_tree(input)

	local max_size = 100000
	local answer = 0

	traverse_file_tree(root, function(size)
		if size <= max_size then
			answer = answer + size
		end
	end)

	print("part 1:", answer)
end

local function solve2()
	local input = "./input.txt"
	local root = build_file_tree(input)

	local total_size = root["_size"]
	local max_size = 70000000
	local need_size = 30000000

	local answer = total_size

	traverse_file_tree(root, function(size)
		if max_size - total_size + size >= need_size then
			answer = math.min(answer, size)
		end
	end)

	print("part 2:", answer)
end

solve1()
solve2()
