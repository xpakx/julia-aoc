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
	num = step_num % length(dirs)
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


filename = "data/data15.txt"
data = read_file(filename)
player = [(i, j) for (i, row) in enumerate(data[1]) for (j, val) in enumerate(row) if val == Player][1]
println(data)
println(player)
for i in 1:10
	global player = step!(data[1], data[2], i, player)
	println(player)
end
