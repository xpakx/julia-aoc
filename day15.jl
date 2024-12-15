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

filename = "data/data15.txt"
data = read_file(filename)
println(data)
