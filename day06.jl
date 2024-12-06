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

start = pos
steps = 0
visited = Set([pos])
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
	    push!(visited, pos)
	    global steps += 1
    end
end
println(steps)

function check_obstacle(g_pos, new_obstacle, g_dir, path, obstacles)
	dir = g_dir
	pos = g_pos
	new_path = Set([(pos, dir)])
	while is_within_bounds(pos, obstacles)
		step = (pos[1] + dir[1], pos[2] + dir[2])
		if is_within_bounds(step, obstacles) && (obstacles[step[1]][step[2]] || step == new_obstacle)
			dir = rotate(dir)
			continue
		end
		pos = step
		if ((pos, dir) in path)
			return true
		end
		if ((pos, dir) in new_path)
			return true
		end
		push!(new_path, (pos, dir))

	end
	return false
end

function can_place_obstacle(pos, obstacles, checked)
	if !is_within_bounds(pos, obstacles)
		return false
	end
	if obstacles[pos[1]][pos[2]]
		return false
	end
	return !(pos in checked)
end

pos = start
dir = (-1, 0)
path = Set([(pos, dir)])
loops = 0
checked = Set([pos])
while is_within_bounds(pos, obstacles)
	step = (pos[1] + dir[1], pos[2] + dir[2])
	if is_within_bounds(step, obstacles) && obstacles[step[1]][step[2]]
		global dir = rotate(dir)
		continue
	end
	if can_place_obstacle(step, obstacles, checked)
		if check_obstacle(pos, step, dir, path, obstacles)
			global loops += 1
		end
	end
	push!(checked, step)
	if !((pos, dir) in path)
		push!(path, (pos, dir))
	end
	global pos = step
end
println(loops)
