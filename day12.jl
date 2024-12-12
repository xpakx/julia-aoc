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

function add(a::Tuple{Int, Int}, b::Tuple{Int, Int})
    (a[1] - b[1], a[2] + b[2])
end

function move(pos::Tuple{Int, Int}, terrain::Vector{Vector{Char}}, visited::Vector{Vector{Bool}}, to_fill, letter::Char)
	if is_within_bounds(terrain, pos) && !visited[pos[1]][pos[2]] && get(terrain, pos) == letter
		push!(to_fill, pos)
		visited[pos[1]][pos[2]] = true
	end
end

function check_free(pos::Tuple{Int, Int}, terrain::Vector{Vector{Char}}, letter::Char)
	if !is_within_bounds(terrain, pos) || get(terrain, pos) != letter
		return 1
	end
	return 0
end

function flood_fill(start::Tuple{Int, Int}, terrain::Vector{Vector{Char}}, visited::Vector{Vector{Bool}})::Tuple{Int, Int, Int}
	letter = get(terrain, start)
	perimeter = 0
	area = 0
	to_fill = [start]
	visited[start[1]][start[2]] = true
	dirs = [(1,0), (-1,0), (0,1), (0,-1)]
	corners = 0
	while length(to_fill) > 0
		pos = pop!(to_fill)
		area += 1
		for dir in dirs
			p = pos .+ dir
			move(p, terrain, visited, to_fill, letter)
			perimeter += check_free(p, terrain, letter)
		end
		corners += check_corners(pos, terrain, letter)
	end
	return (area, perimeter, corners)
end

function check_corners(pos::Tuple{Int, Int}, terrain::Vector{Vector{Char}}, letter::Char)
	corners = [(1,1), (-1,1), (1,-1), (-1,-1)]
	result = 0
	for c in corners
		corner = add(pos, c)
		if check_free(corner, terrain, letter) == 1
			pos1 = check_free(add(pos, (c[1], 0)), terrain, letter)
			pos2 = check_free(add(pos, (0, c[2])), terrain, letter)
			if pos1 == pos2
				result += 1
			end
		end
	end
	return result
end

function scan_fill(terrain::Vector{Vector{Char}})::Tuple{Int,Int}
	visited = Vector{Vector{Bool}}()
	visited = [fill(false, length(subvec)) for subvec in terrain]
	result = 0
	result2 = 0
	for (i, row) in enumerate(terrain)
		for j in eachindex(row) 
			if visited[i][j]
				continue
			end
			(area, perimeter, corners) = flood_fill((i,j), terrain, visited)
			result += area * perimeter
			result2 += area * corners
		end
	end
	return (result, result2)
end


println(scan_fill(chars))
# print(scan(chars))
