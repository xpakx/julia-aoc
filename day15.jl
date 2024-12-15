@enum Dir Left Right Up Down
@enum Field Empty Wall Box Player
const Map = Vector{Vector{Field}}

function collect_dirs(char::Char)::Dir
	if char == '^' return Up elseif char == '>' return Right elseif char == '<' return Left elseif char == 'v' return Down end
end

function collect_symbol(char::Char)::Field
	if char == '@' return Player elseif char == '#' return Wall elseif char == 'O' return Box else return Empty end
end

function get_map(str::String)::Map
	data = split(strip(str), "\n")
	return map(x -> map(collect_symbol, collect(x)), data)
end

function read_file(filename::String)::Tuple{Map, Vector{Dir}}
	file_content = read(filename, String)
	data = split(file_content, "\n\n", limit=2)
	chars = collect(data[2])
	dirs = map(collect_dirs, filter(x -> x != '\n',chars))
	map_data = get_map(String(data[1]))
	return (map_data, dirs)
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

function step!(board::Map, dirs::Vector{Dir}, step_num::Int, player::Tuple{Int, Int})
	num = ((step_num-1) % length(dirs)) + 1
	dir = dirs[num]
	dir_coord = dir_to_coord(dir)
	new_pos = player .+ dir_coord
	if get(board, new_pos) == Wall
		return player
	elseif get(board, new_pos) == Empty
		set!(board, player, Empty)
		set!(board, new_pos, Player)
		return new_pos
	elseif get(board, new_pos) == Box
		pos2 = new_pos .+ dir_coord
		while get(board, pos2) == Box
			pos2 = pos2 .+ dir_coord
		end
		if get(board, pos2) == Wall
			return player
		end
		set!(board, player, Empty)
		set!(board, new_pos, Player)
		set!(board, pos2, Box)
		return new_pos
	end
end

function simulate1!(board::Map, dirs::Vector{Dir})
	player = [(i, j) for (i, row) in enumerate(board) for (j, val) in enumerate(row) if val == Player][1]
	for i in eachindex(dirs)
		player = step!(board, dirs, i, player)
	end
end

function calculate_gps(board::Map)
	boxes = [(i, j) for (i, row) in enumerate(board) for (j, val) in enumerate(row) if val == Box]
	values = [(i-1)*100 + j-1 for (i,j) in boxes]
	return sum(values)
end

function get_wide_map(board::Map)::Tuple{Map, Dict{Tuple{Int, Int}, Vector{Tuple{Int, Int}}}}
	boxes = Dict{Tuple{Int, Int}, Vector{Tuple{Int, Int}}}()
	new_board = Vector{Vector{Field}}()
	for (i, row) in enumerate(board)
		new_row = Vector{Field}()
		for (j, val) in enumerate(row)
			if val == Empty || val == Wall
				push!(new_row, val)
				push!(new_row, val)
			elseif val == Box
				push!(new_row, Box)
				push!(new_row, Box)
				positions = [(i,2*j-1), (i,2*j)]
				boxes[(i,2*j)] = positions
				boxes[(i,2*j-1)] = positions
			elseif val == Player
				push!(new_row, Player)
				push!(new_row, Empty)
			end
		end
		push!(new_board, new_row)
	end
	return (new_board, boxes)
end

function get_wall_tree(board, dict, player, dir_coord)::Tuple{Bool, Set{Tuple{Int, Int}}}
	walls = Set{Tuple{Int,Int}}()
	positions = [player]
	while length(positions) > 0 
		pos = pop!(positions)
		new_pos = pos .+ dir_coord
		if get(board, new_pos) == Wall
			return (true, Set{Tuple{Int,Int}}())
		elseif get(board, new_pos) == Box
			box = dict[new_pos]
			push!(walls, box[1])
			push!(walls, box[2])
			if dir_coord[1] === 0
				if box[1] != pos
					push!(positions, box[1])
				else
					push!(positions, box[2])
				end
			else
				push!(positions, box[1])
				push!(positions, box[2])
			end
		end
	end
	return (false, walls)
end

function update_walls!(board, boxes, dict, dir)
	boxes_for_dict = Vector{Vector{Tuple{Int, Int}}}()
	for box in boxes
		set!(board, box, Empty)
		if haskey(dict, box)
			box_data = dict[box]
			pop!(dict, box_data[1])
			pop!(dict, box_data[2])
			new_data = map(x -> x .+ dir, box_data)
			push!(boxes_for_dict, new_data)
		end
	end
	for data in boxes_for_dict
		dict[data[1]] = data
		dict[data[2]] = data
	end
	new_boxes = map(x -> x .+ dir, collect(boxes))
	for box in new_boxes
		set!(board, box, Box)
	end
end


function step2!(board::Map, dirs::Vector{Dir}, dict, step_num::Int, player::Tuple{Int, Int})
	num = ((step_num-1) % length(dirs)) + 1
	dir = dirs[num]
	dir_coord = dir_to_coord(dir)
	new_pos = player .+ dir_coord
	if get(board, new_pos) == Wall
		return player
	elseif get(board, new_pos) == Empty
		set!(board, player, Empty)
		set!(board, new_pos, Player)
		return new_pos
	elseif get(board, new_pos) == Box
		pos2 = new_pos .+ dir_coord
		(has_wall, boxes) = get_wall_tree(board, dict, player, dir_coord)
		if has_wall
			return player
		end
		update_walls!(board, boxes, dict, dir_coord)
		set!(board, player, Empty)
		set!(board, new_pos, Player)
		return new_pos
	end
end

function print_board(board::Map)
	for (i, row) in enumerate(board)
		for (j, val) in enumerate(row)
			if val == Player
				print("@")
			elseif val == Wall
				print("#")
			elseif val == Box
				print("O")
			else 
				print(".")
			end
		end
		println()
	end
end

function simulate2!(board::Map, dirs::Vector{Dir}, dict)
	player = [(i, j) for (i, row) in enumerate(board) for (j, val) in enumerate(row) if val == Player][1]
	for i in eachindex(dirs)
		player = step2!(board, dirs, dict, i, player)
	end
end

function calculate_gps2(dict)
	visited = Set{Tuple{Int,Int}}()
	result = 0
	for (key, value) in dict
		if !(key in visited)
			(i, j) = value[1]
			result += (i-1)*100 + j-1
			push!(visited, value[1])
			push!(visited, value[2])
		end
	end
	return result
end

filename = "data/data15.txt"
(board, dirs) = read_file(filename)
simulate1!(board, dirs)
println(calculate_gps(board))

(board, dirs) = read_file(filename)
(board2, dict) = get_wide_map(board)
simulate2!(board2, dirs, dict)
println(calculate_gps2(dict))
