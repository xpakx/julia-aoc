filename = "data/data08.txt"
file_content = read(filename, String)

lines = split(file_content, '\n')
char_matrix = [collect(line) for line in lines]
data = [(char, x, y) for (y, row) in enumerate(char_matrix) for (x, char) in enumerate(row) if char != '.']

dim = length(lines[1])

println("$dim x $dim")
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

function add_antinode!(antinodes, point)
	if point[1] <= 0 || point[1] > dim
		return
	end
	if point[2] <= 0 || point[2] > dim
		return
	end
	if (point in antinodes)
		return
	end
	push!(antinodes, point)
end

antinodes = Set{Tuple{Int, Int}}()
result = 0
for char in keys(grouped)
	positons = grouped[char]
	for i in 1:length(positons)-1
		for j in (i+1):length(positons)
			first = positons[i]
			second = positons[j]
			dx = second[1] - first[1]
			dy = second[2] - first[2]
			point = (first[1] - dx, first[2] - dy)
			point2 = (second[1] + dx, second[2] + dy)
			add_antinode!(antinodes, point)
			add_antinode!(antinodes, point2)
		end
	end
end

println(antinodes)
println(length(antinodes))

for i in 1:dim
	for j in 1:dim
		if (j, i) in antinodes
			print("#")
		else
			found = false
			for (char, y, x) in data
				if (y,x) == (j, i)
					found = true
					print(char)
				end
			end
			if !found
				print(".")
			end
		end
	end
	println()
end
