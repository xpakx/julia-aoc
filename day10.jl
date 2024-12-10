filename = "data/data10.txt"
file_content = read(filename, String)
lines = split(file_content, '\n')
pop!(lines)
terrain = [[parse(Int, char) for char in line] for line in lines]

println(terrain)

function is_within_bounds(terrain::Vector{Vector{Int}}, start::Tuple{Int, Int})
    row, col = start
    return 1 <= row <= size(terrain, 1) && 1 <= col <= size(terrain[1], 1)
end

function get(terrain::Vector{Vector{Int}}, start::Tuple{Int, Int})
	return terrain[start[1]][start[2]]
end

function find_path(terrain::Vector{Vector{Int}}, start::Tuple{Int, Int}, mem::Set{Tuple{Int, Int}})
	if get(terrain, start) == 9 && !(start in mem)
		push!(mem, start)
		return 1
	end

	paths = 0
	up = start .+ (1, 0)
	if is_within_bounds(terrain, up) && get(terrain, start) + 1 == get(terrain, up)
		paths += find_path(terrain, up, mem)
	end
	down = start .- (1, 0)
	if is_within_bounds(terrain, down) && get(terrain, start) + 1 == get(terrain, down)
		paths += find_path(terrain, down, mem)
	end
	right = start .+ (0, 1)
	if is_within_bounds(terrain, right) && get(terrain, start) + 1 == get(terrain, right)
		paths += find_path(terrain, right, mem)
	end
	left = start .- (0, 1)
	if is_within_bounds(terrain, left) && get(terrain, start) + 1 == get(terrain, left)
		paths += find_path(terrain, left, mem)
	end
	return paths
end

starts = [(i, j) for i in eachindex(terrain) for j in eachindex(terrain[i]) if terrain[i][j] == 0]

result = 0
for position in starts 
	score = find_path(terrain, position, Set{Tuple{Int, Int}}())
	global result += score
	println("$position,  $score")
end
println(result)
