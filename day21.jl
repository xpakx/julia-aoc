function get_codes(filename::String)::Vector{String}
	file_content = read(filename, String)
	return split(strip(file_content), "\n")
end

filename = "data/data21.txt"
codes = get_codes(filename)
println(codes)
