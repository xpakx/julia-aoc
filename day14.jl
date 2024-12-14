const Robot = NTuple{2, Tuple{Int, Int}}

function parse_robot(text::String)::Robot
	nums = parse.(Int, [match.match for match in eachmatch(r"-?\d+", text)])
	return ((nums[1], nums[2]), (nums[3], nums[4]))
end

function read_file(filename::String)::Vector{Robot}
	data = Vector{Robot}()
	open(filename, "r") do file
		data = map(x -> parse_robot(String(x)), eachline(file))
	end
	return data
end

function simulate(robot::Robot, steps::Int, width::Int, height::Int)::Tuple{Int, Int}
	(p₁, p₂) = robot[1]
	(v₁, v₂) = robot[2]
	r₁ = mod(p₁ + steps*v₁, width)
	r₂ = mod(p₂ + steps*v₂, height)
	return (r₁, r₂)
end

function reduce_quadrants(positions, width, height)
    (i, j) = ((width-1)/2, (height-1)/2)
    a = sum(x > i && y > j for (x, y) in positions)
    b = sum(x < i && y > j for (x, y) in positions)
    c = sum(x < i && y < j for (x, y) in positions)
    d = sum(x > i && y < j for (x, y) in positions)
    return (a, b, c, d)
end

width = 101
height = 103
filename = "data/data14.txt"
data = read_file(filename)
positions = map(x -> simulate(x, 100, width, height), data)
results  = reduce_quadrants(positions, width, height)
println(reduce(*, results))

function is_symmetric(points::Vector{Tuple{Int, Int}}, xn::Int)::Bool
    point_set = Set(points)
    
    for (x, y) in points
        mirrored = (2 * xn - x, y)
	if !(mirrored in point_set)
            return false
        end
    end
    return true
end

function search(robots::Vector{Robot}, width::Int, height::Int) 
	sec = 0
	while true
		sec += 1
		new_robots = Vector{Robot}()
		points = map(x -> simulate(x, sec, width, height), data)
		for i in 0:width
			if is_symmetric(points, i)
				println(sec)
				break
			end
		end
	end
end
search(data, width, height)
