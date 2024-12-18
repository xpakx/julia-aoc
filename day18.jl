function parse_pair(text::String)::Tuple{Int,Int}
	pair = split(text, ',', limit=2)
	nums = map(x -> parse(Int, String(x)), pair)
	return (nums[1], nums[2])

end

function get_map(filename::String)::Vector{Tuple{Int,Int}}
	file_content = read(filename, String)
	data = split(strip(file_content), "\n")
	return map(x -> parse_pair(String(x)), data)
end

size = 6
bytes_to_simulate = 12
filename = "data/data18.txt"
bytes = get_map(filename)
println(bytes)
