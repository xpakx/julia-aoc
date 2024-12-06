filename = "data/data06.txt"
obstacles = Vector{Vector{Bool}}()
pos = (0, 0)
line_count = 1
open(filename, "r") do file
    for line in eachline(file)
		    chars = collect(line)
		    row = map(c -> c == '#', chars)
		    push!(obstacles, row)
		    have_guard = '^' in chars
		    if have_guard
			    column = findfirst(x -> x == '^', chars)
			    global pos = (line_count, column)
		    end
		    global line_count += 1
    end
end

dir = (-1, 0)

function is_within_bounds(pos, obstacles)
    row, col = pos
    return 1 <= row <= size(obstacles, 1) && 1 <= col <= size(obstacles[1], 1)
end

function rotate(dir)
    dx, dy = dir
    return (dy, -dx)
end

steps = 0
visited = Set([(pos[1], pos[2])])
while is_within_bounds(pos, obstacles)
    step = (pos[1] + dir[1], pos[2] + dir[2])
    if is_within_bounds(step, obstacles) && obstacles[step[1]][step[2]]
        # println("Position $step is an obstacle. Rotating...")
	global dir = rotate(dir)
	continue
    end
    # println("Making step to $step...")
    global pos = step
    if !(pos in visited)
	    push!(visited, (pos[1], pos[2]))
	    global steps += 1
    end
end
println(steps)
