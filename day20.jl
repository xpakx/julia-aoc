@enum Field Empty Wall End Start
const Map = Vector{Vector{Field}}
const Pos = Tuple{Int, Int}

function collect_symbol(char::Char)::Field
	if char == 'S' return Start elseif char == '#' return Wall elseif char == 'E' return End else return Empty end
end

function get_map(filename::String)::Map
	file_content = read(filename, String)
	data = split(strip(file_content), "\n")
	return map(x -> map(collect_symbol, collect(x)), data)
end

function get(board::Map, pos::Pos)::Field
	return board[pos[1]][pos[2]]
end

function taxicab_dist(p1::Pos, p2::Pos)::Int
    return abs(p2[1] - p1[1]) + abs(p2[2] - p1[2])
end

function filter_neighbors(pos::Pos, candidates::Vector{Pos}, d::Int)::Vector{Pos}
	return filter(x -> taxicab_dist(pos, x) <= d, candidates)
end

function find_path(board::Map, start::Pos, cheat::Int=2)::Int
	pos = start
	dirs = [(1,0), (-1,0), (0,1), (0,-1)]
	path = Vector{Pos}()
	while get(board, pos) != End
		push!(path, pos)
		neighbors = map(x -> x .+ pos, dirs)
		for n in neighbors
			if !(n in path) && get(board, n) != Wall
				pos = n
				break
			end
		end
	end

	d = Dict{Pos, Int}()
	for (i, pos) in enumerate(reverse(path))
		d[pos] = i
	end

	fin = [(i, j) for (i, row) in enumerate(board) for (j, val) in enumerate(row) if val == End][1]
	d[fin] = 0
	path2 = vcat(path, fin)

	dist = 0
	savings = Dict{Int, Int}()
				
	for node in path
		dist += 1
		neighbors = filter_neighbors(node, path2, cheat)
		for n in neighbors
			cost = d[n] + taxicab_dist(node, n) - 1
			if dist + cost < length(path)
				saving = length(path) - (dist + cost)
				if haskey(savings, saving)
					savings[saving] += 1
				else
					savings[saving] = 1
				end
			end
		end
	end
	result = 0
	for (key, value) in savings
		if key >= 100
			result += value
		end
	end

	return result
end

filename = "data/data20.txt"
board = get_map(filename)
start = [(i, j) for (i, row) in enumerate(board) for (j, val) in enumerate(row) if val == Start][1]
println(find_path(board, start))
println(find_path(board, start, 20))
