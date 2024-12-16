using DataStructures

@enum Dir Left Right Up Down
@enum Field Empty Wall End Start
const Map = Vector{Vector{Field}}

function collect_symbol(char::Char)::Field
	if char == 'S' return Start elseif char == '#' return Wall elseif char == 'E' return End else return Empty end
end

function get_map(filename::String)::Map
	file_content = read(filename, String)
	data = split(strip(file_content), "\n")
	return map(x -> map(collect_symbol, collect(x)), data)
end

function dir_to_coord(dir::Dir)::Tuple{Int, Int}
	if dir == Up return (-1, 0) elseif dir == Right return (0, 1) elseif dir == Left return (0, -1) elseif dir == Down return (1, 0) end
end

function get(board::Map, pos::Tuple{Int, Int})::Field
	return board[pos[1]][pos[2]]
end

function set!(board::Map, pos::Tuple{Int, Int}, value::Field)
	board[pos[1]][pos[2]] = value
end


const Pair = Tuple{Tuple{Int,Int},Tuple{Int,Int}}

function dijkstra(board::Map, start::Tuple{Int, Int})::Int
	Q = PriorityQueue{Pair, Int}()
	d = Dict{Pair, Int64}()
	pre = Dict{Pair, Pair}()

	dirs = [(0, 1), (0, -1), (1, 0), (-1, 0)]

	enqueue!(Q, (start, (0, -1)) => 0)
	d[(start, (0, -1))] = 0

	while !isempty(Q)
		node, dir = dequeue!(Q)
		neighbors = map(x -> x .+ node, dirs)
		for n in neighbors
			if get(board, n) == Wall
				continue
			elseif get(board, n) == End
				return d[(node, dir)] + 1
			end
			d1 = d2 = typemax(Int)
			dir2 = node .- n
			if haskey(d, (node,dir)) 
				d1 = d[(node, dir)]
			end
			if haskey(d, (n,dir2)) 
				d2 = d[(n, dir2)]
			end
			dist = 1
			if dir2 != dir
				dist += 1000
			end
			if dir2 .* (-1, -1) == dir
				dist += 1000
			end
			if d2 > d1 + dist
				if haskey(Q, (n, dir2))
					Q[(n, dir2)] = d1 + dist
				else
					enqueue!(Q, (n, dir2) => d1 + dist)
				end
				d[(n, dir2)] = d1 + dist
				pre[(n, dir2)] = (node, dir)
			end
		end
	end
end

filename = "data/data16.txt"
board = get_map(filename)
reindeer = [(i, j) for (i, row) in enumerate(board) for (j, val) in enumerate(row) if val == Start][1]
set!(board, reindeer, Empty)
println(dijkstra(board, reindeer))
