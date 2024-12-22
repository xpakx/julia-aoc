function get_seeds(filename::String)::Vector{Int}
	file_content = read(filename, String)
	data = split(strip(file_content), "\n")
	return map(x -> parse(Int, String(x)), data)
end

filename = "data/data22.txt"
seeds = get_seeds(filename)
println(seeds)
