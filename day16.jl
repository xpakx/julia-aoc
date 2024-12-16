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

filename = "data/data16.txt"
board = get_map(filename)
reindeer = [(i, j) for (i, row) in enumerate(board) for (j, val) in enumerate(row) if val == Start][1]
set!(board, reindeer, Empty)
println(board)
