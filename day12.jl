filename = "data/data12.txt"
file_content = strip(read(filename, String))
content = split(file_content, '\n')
chars = map(x -> collect(x), content)

function is_within_bounds(terrain::Vector{Vector{Char}}, start::Tuple{Int, Int})
    row, col = start
    return 1 <= row <= size(terrain, 1) && 1 <= col <= size(terrain[1], 1)
end

function get(terrain::Vector{Vector{Char}}, start::Tuple{Int, Int})::Char
	return terrain[start[1]][start[2]]
end

function check(terrain::Vector{Vector{Char}}, pos::Tuple{Int, Int}, delta::Tuple{Int, Int}, letter::Char)::Bool
	next = pos .+ delta
	return is_within_bounds(terrain, next) && get(terrain, next) == letter
end

function check(terrain::Vector{Vector{Char}}, pos::Tuple{Int, Int})::Bool
	letter = get(terrain, pos)
	return check(terrain, pos, (-1,0), letter)
end

function add(a::Tuple{Int, Int}, b::Tuple{Int, Int})
    (a[1] - b[1], a[2] + b[2])
end

function rotate(dir)
    dx, dy = dir
    return (-dy, dx)
end

function revert(dir)
    dx, dy = dir
    return (-dx, -dy)
end

function to_dir(dir)
	if dir == (1,0)
		return "up"
	elseif dir == (-1,0)
		return "down"
	elseif dir == (0,1)
		return "right"
	else 
		return "left"
	end
end

function trace(start::Tuple{Int, Int}, terrain::Vector{Vector{Char}}, visited::Vector{Vector{Int}}, id::Int)::Int
	letter = get(terrain, start)
	perimeter = 0
	pos = start
	dir = (0, 1)
	side = (1, 0)
	while (pos != start || side != (1, 0)) || perimeter == 0
		visited[pos[1]][pos[2]] = id
		perimeter += 1
		println(pos, " ", to_dir(side), " ", to_dir(dir))

		next = rotate(side)
		test_pos = add(pos, next)
		if !is_within_bounds(terrain, test_pos) || get(terrain, test_pos) != letter
			side = next
			dir = rotate(dir)
			continue
		end
		diag = add(add(pos, dir), side)
		if is_within_bounds(terrain, diag) && get(terrain, diag) == letter
			pos = diag
			dir = revert(rotate(dir))
			side = revert(rotate(side))
			continue
		end
		pos = add(pos, dir)
	end
	return perimeter
end

function scan(terrain::Vector{Vector{Char}})::Int
	visited = Vector{Vector{Int}}()
	visited = [fill(0, length(subvec)) for subvec in terrain]
	perimeters = Vector{Int}()
	letters = Vector{Char}()
	id = 1
	for (i, row) in enumerate(terrain)
		for (j, field) in enumerate(row) 
			if check(terrain, (i,j))
				continue
			end
			if visited[i][j] > 0
				continue
			end
			letter = get(terrain, (i, j))
			perimeter = trace((i,j), terrain, visited, id)
			id += 1
			push!(perimeters, perimeter)
			push!(letters, letter)
		end
	end

	areas = zeros(Int, length(perimeters))
	for (i, row) in enumerate(terrain)
		last = 0
		active = 0
		for (j, field) in enumerate(row) 
			curr = visited[i][j]
			print(curr > 1 ? '.' : '1')
			if curr != 0
				if curr != last
					active = curr
				end
			end
			last = curr

			if active != 0
				areas[active] += 1
			end
		end
		println()
	end

	for i in eachindex(areas)
		println(letters[i], ": ", areas[i], " ", perimeters[i])
	end
	return sum(perimeters .* areas)
end


function flood_fill(start::Tuple{Int, Int}, terrain::Vector{Vector{Char}}, visited::Vector{Vector{Bool}})::Int
	letter = get(terrain, start)
	perimeter = 0
	area = 0
	to_fill = [start]
	visited[start[1]][start[2]] = true
	while length(to_fill) > 0
		pos = pop!(to_fill)
		top = pos .+ (-1, 0)
		down = pos .+ (1, 0)
		right = pos .+ (0, 1)
		left = pos .+ (0, -1)
		println("=>$pos")

		if is_within_bounds(terrain, top) && !visited[top[1]][top[2]] && get(terrain, top) == letter
			push!(to_fill, top)
			visited[top[1]][top[2]] = true
		end
		if is_within_bounds(terrain, down) && !visited[down[1]][down[2]] && get(terrain, down) == letter
			push!(to_fill, down)
			visited[down[1]][down[2]] = true
		end
		if is_within_bounds(terrain, right) && !visited[right[1]][right[2]] && get(terrain, right) == letter
			push!(to_fill, right)
			visited[right[1]][right[2]] = true
		end
		if is_within_bounds(terrain, left) && !visited[left[1]][left[2]] && get(terrain, left) == letter
			push!(to_fill, left)
			visited[left[1]][left[2]] = true
		end

		area += 1
		if !is_within_bounds(terrain, top) || get(terrain, top) != letter
			perimeter += 1
		end
		if !is_within_bounds(terrain, down) || get(terrain, down) != letter
			perimeter += 1
		end
		if !is_within_bounds(terrain, right) || get(terrain, right) != letter
			perimeter += 1
		end
		if !is_within_bounds(terrain, left) || get(terrain, left) != letter
			perimeter += 1
		end
	end
	println(area, " ", perimeter)
	return area * perimeter
end

function scan_fill(terrain::Vector{Vector{Char}})::Int
	visited = Vector{Vector{Bool}}()
	visited = [fill(false, length(subvec)) for subvec in terrain]
	result = 0
	for (i, row) in enumerate(terrain)
		for (j, field) in enumerate(row) 
			if visited[i][j]
				continue
			end
			letter = get(terrain, (i, j))
			result += flood_fill((i,j), terrain, visited)
		end
	end
	return result
end


println(scan_fill(chars))
# print(scan(chars))