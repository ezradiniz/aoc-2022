local function calc_score(opp, you)
	local score_table = {}

	score_table["A"] = {}
	score_table["A"]["X"] = 1 + 3
	score_table["A"]["Z"] = 3 + 0
	score_table["A"]["Y"] = 2 + 6

	score_table["B"] = {}
	score_table["B"]["X"] = 1 + 0
	score_table["B"]["Z"] = 3 + 6
	score_table["B"]["Y"] = 2 + 3

	score_table["C"] = {}
	score_table["C"]["X"] = 1 + 6
	score_table["C"]["Z"] = 3 + 3
	score_table["C"]["Y"] = 2 + 0

	return score_table[opp][you]
end

local function solve1()
	local input = "./input.txt"

	local score = 0
	for line in io.lines(input) do
		local opp = line:sub(1, 1)
		local you = line:sub(3, 3)
		score = score + calc_score(opp, you)
	end

	print("part 1:", score)
end

local function solve2()
	local input = "./input.txt"

	local follow_strategy = function(opp, you)
		local strategy = {}

		strategy["A"] = {}
		strategy["A"]["X"] = "Z"
		strategy["A"]["Z"] = "Y"
		strategy["A"]["Y"] = "X"

		strategy["B"] = {}
		strategy["B"]["X"] = "X"
		strategy["B"]["Z"] = "Z"
		strategy["B"]["Y"] = "Y"

		strategy["C"] = {}
		strategy["C"]["X"] = "Y"
		strategy["C"]["Z"] = "X"
		strategy["C"]["Y"] = "Z"

		return strategy[opp][you]
	end

	local score = 0
	for line in io.lines(input) do
		local opp = line:sub(1, 1)
		local you = line:sub(3, 3)
		score = score + calc_score(opp, follow_strategy(opp, you))
	end

	print("part 2:", score)
end

solve1()
solve2()
