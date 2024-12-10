filename = "data/data10.txt"
file_content = read(filename, String)
lines = split(file_content, '\n')
pop!(lines)
terrain = [[parse(Int, char) for char in line] for line in lines]

function is_within_bounds(terrain::Vector{Vector{Int}}, start::Tuple{Int, Int})
    row, col = start
    return 1 <= row <= size(terrain, 1) && 1 <= col <= size(terrain[1], 1)
end

function get(terrain::Vector{Vector{Int}}, start::Tuple{Int, Int})
	return terrain[start[1]][start[2]]
end

function check(terrain::Vector{Vector{Int}}, start::Tuple{Int, Int}, mem::Set{Tuple{Int, Int}}, delta::Tuple{Int, Int}, p2::Bool=false)
	next = start .+ delta
	if is_within_bounds(terrain, next) && get(terrain, start) + 1 == get(terrain, next)
		return find_path(terrain, next, mem, p2)
	end
	return 0
end

function find_path(terrain::Vector{Vector{Int}}, start::Tuple{Int, Int}, mem::Set{Tuple{Int, Int}}, p2::Bool=false)
	if get(terrain, start) == 9 && (p2 || !(start in mem))
		push!(mem, start)
		return 1
	end
	paths = 0
	paths += check(terrain, start, mem, (1, 0), p2)
	paths += check(terrain, start, mem, (-1, 0), p2)
	paths += check(terrain, start, mem, (0, 1), p2)
	paths += check(terrain, start, mem, (0, -1), p2)
	return paths
end

function solve(terrain, starts, p2::Bool=false)
	result = 0
	for position in starts 
		score = find_path(terrain, position, Set{Tuple{Int, Int}}(), p2)
		result += score
	end
	return result
end

starts = [(i, j) for i in eachindex(terrain) for j in eachindex(terrain[i]) if terrain[i][j] == 0]

println(solve(terrain, starts))
println(solve(terrain, starts, true))
