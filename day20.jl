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

filename = "data/data20.txt"
board = get_map(filename)
start = [(i, j) for (i, row) in enumerate(board) for (j, val) in enumerate(row) if val == Start][1]
println(board)
