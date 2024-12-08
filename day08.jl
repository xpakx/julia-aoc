filename = "data/data08.txt"
file_content = read(filename, String)

char_matrix = [collect(line) for line in split(file_content, '\n')]
data = [(char, x, y) for (y, row) in enumerate(char_matrix) for (x, char) in enumerate(row) if char != '.']

grouped = Dict{Char, Vector{Tuple{Int, Int}}}()
for (char, x, y) in data
	if haskey(grouped, char)
		push!(grouped[char], (x, y))
	else
		grouped[char] = [(x, y)]
	end
end

for char in keys(grouped)
    println("Character: $char")
    println("Positions: $(grouped[char])")
end

