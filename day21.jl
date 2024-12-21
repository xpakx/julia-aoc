using IterTools
const Panel = Vector{Vector{Char}}
const Pos = Tuple{Int, Int}

function get_codes(filename::String)::Vector{String}
	file_content = read(filename, String)
	return split(strip(file_content), "\n")
end

main_panel = [
   ['7', '8', '9'],
   ['4', '5', '6'],
   ['1', '2', '3'],
   [' ', '0', 'A']
]
nav_panel = [
   [' ', '^', 'A'],
   ['<', 'v', '>'],
]

function calc_distances(panel::Panel)::Dict{Char, Pos}
	dist = Dict{Char, Pos}()
	n = length(panel)
	m = length(panel[1])
	for (i, j) in product(1:n, 1:m)
			dist[panel[i][j]] = (i, j)
	end
	return dist
end

function shortest_sequence(panel::Dict{Char, Pos}, code::String)::String
	curr = 'A'
	result = ""
	for letter in collect(code)
		from = panel[curr]
		to = panel[letter]
		dy = from[1] - to[1]
		dx = from[2] - to[2]
		if dx > 0
			result *= repeat("<", dx)
		end
		if dy < 0
			result *= repeat("v", -dy)
		end
		if dy > 0
			result *= repeat("^", dy)
		end
		if dx < 0
			result *= repeat(">", -dx)
		end
		result *= 'A'
		curr = letter
	end
	return result
end

function calc_sequences(nav::Dict{Char, Pos}, main::Dict{Char, Pos}, code::String)::Int
	res = shortest_sequence(main, code)
	res = shortest_sequence(nav, res)
	res = shortest_sequence(nav, res)
	len = length(res)
	num = parse(Int, code[1:end-1])
	println("$code: $len, $num")
	println(res)
	return len * num
end

filename = "data/data21.txt"
codes = get_codes(filename)
println(codes)
main = calc_distances(main_panel)
nav = calc_distances(nav_panel)
println(nav)

result = map(x -> calc_sequences(nav, main, x), codes)
println(result)
println(sum(result))
