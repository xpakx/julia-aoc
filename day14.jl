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

function count_clustered(points::Vector{Tuple{Int, Int}})::Float64
	dirs = [(1,0), (-1,0), (0,1), (0,-1)]
	touching = 0
	for point in points
		for dir in dirs
			if (point .+ dir) in points
				touching += 1
			end
		end
	end
	return touching
end

function print_points(points::Vector{Tuple{Int, Int}})
	sorted_points = sort(points, by = x -> (x[1], x[2]))

	min_x = minimum(x[1] for x in sorted_points)
	max_x = maximum(x[1] for x in sorted_points)
	min_y = minimum(x[2] for x in sorted_points)
	max_y = maximum(x[2] for x in sorted_points)

	point_set = Set(sorted_points)

	for y in reverse(min_y:max_y)
	    for x in min_x:max_x
		if (x, y) in point_set
		    print("*")
		else
		    print(" ")
		end
	    end
	    println() 
	end
end

function search(robots::Vector{Robot}, width::Int, height::Int) 
	sec = 0
	heuristic = 2*length(robots)
	while true
		sec += 1
		points = map(x -> simulate(x, sec, width, height), data)
		curr_heuristic = count_clustered(points)
		if curr_heuristic > heuristic
			print_points(points)
			println(curr_heuristic)
			println(sec)
			break
		end
	end
end
search(data, width, height)
