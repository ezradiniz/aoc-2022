#!/bin/bash

set -e

template=$(cat <<EOF
local function solve1()
	local input = "./sample.txt"
	local answer = 0
	for line in io.lines(input) do
		print(line)
	end
	print("part 1:", answer)
end

local function solve2()
	local input = "./sample.txt"
	local answer = 0
	for line in io.lines(input) do
		print(line)
	end
	print("part 2:", answer)
end

solve1()
solve2()
EOF
)

day="$1"

directory=$(printf "day_%02d" "$day")

if [ -d "$directory" ]; then
    echo "This $directory already exists!"
    exit 1
fi

mkdir -p "$directory"
echo "$template" > "./$directory/main.lua"
touch "./$directory/sample.txt"
touch "./$directory/input.txt"

echo "Enjoy day $day!"
