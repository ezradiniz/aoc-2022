local function read_pairs(input, callback)
    local make_pair = function(p)
        local sep = string.find(p, "-")
        return { tonumber(p:sub(1, sep - 1)), tonumber(p:sub(sep + 1, #p)) }
    end

    for line in io.lines(input) do
        local sep = string.find(line, ",")
        local pair1 = make_pair(line:sub(1, sep - 1))
        local pair2 = make_pair(line:sub(sep + 1, #line))
        callback(pair1, pair2)
    end
end

local function solve1()
    local input = "./input.txt"

    local contains = function(p1, p2)
        return p1[1] <= p2[1] and p1[2] >= p2[2]
    end

    local count = 0
    read_pairs(input, function(pair1, pair2)
        if contains(pair1, pair2) or contains(pair2, pair1) then
            count = count + 1
        end
    end)

    print("part 1:", count)
end

local function solve2()
    local input = "./input.txt"

    local overlap = function(p1, p2)
        return p1[1] <= p2[1] and p2[1] <= p1[2]
    end

    local count = 0
    read_pairs(input, function(pair1, pair2)
        if overlap(pair1, pair2) or overlap(pair2, pair1) then
            count = count + 1
        end
    end)

    print("part 2:", count)
end

solve1()
solve2()
