function read_file(filename::String)
	file_content = read(filename, String)
	data = split(file_content, "\n\n", limit=2)
	towels = map(x -> collect(x), split(strip(data[1]), ", "))
	patterns = map(x -> collect(x), split(strip(data[2]), '\n'))
	return (towels, patterns)
end

(towels, patterns) = read_file("data/data19.txt")

towel_dict = Dict{Char, Vector{Vector{Char}}}()
for towel in towels
	letter = towel[1]
	if haskey(towel_dict, letter)
		push!(towel_dict[letter], towel)
	else
		towel_dict[letter] = [towel]
	end
end

println(towel_dict)
