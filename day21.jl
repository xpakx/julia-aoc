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

function optimal_order(dx::Int, dy::Int)::Vector{Char}
	result = []
	if dx > 0
		append!(result, fill('<', dx))
	end
	if dy < 0
		append!(result, fill('v', -dy))
	end
	if dy > 0
		append!(result, fill('^', dy))
	end
	if dx < 0
		append!(result, fill('>', -dx))
	end
	return result
end

function up_first(dx::Int, dy::Int)::Vector{Char}
	ree = fill('^', dy)
	append!(ree, fill(dx>0 ? '<' : '>', abs(dx)))
	return ree
end

function down_first(dx::Int, dy::Int)::Vector{Char}
	result = fill('v', -dy)
	append!(result, fill(dx>0 ? '<' : '>', abs(dx)))
	return result
end

function right_first(dx::Int, dy::Int)::Vector{Char}
	ree = fill('>', -dx)
	append!(ree, fill(dy>0 ? '^' : 'v', abs(dy)))
	return ree
end

function shortest_sequence(panel::Dict{Char, Pos}, code::Vector{Char}, numeric::Bool=true, start::Char='A')::Vector{Char}
	curr = start
	result = []
	empty = panel[' ']
	for letter in code
		from = panel[curr]
		to = panel[letter]
		dy = from[1] - to[1]
		dx = from[2] - to[2]
		if !numeric && to[2] == empty[2] && from[1] == empty[1] && dy > 0
			append!(result, up_first(dx, dy))
		elseif numeric && to[2] == empty[2] && from[1] == empty[1] && dy < 0
			append!(result, down_first(dx, dy))
		elseif to[1] == empty[1] && from[2] == empty[2] && dx < 0
			append!(result, right_first(dx, dy))
		else
			append!(result, optimal_order(dx, dy))
		end
		push!(result, 'A')
		curr = letter
	end
	return result
end

const QuickCode = Dict{Tuple{Char, Char}, Int}
function quick_shortest_sequence(panel::Dict{Char, Pos}, code::QuickCode, numeric::Bool=true)::QuickCode
	result = Dict{Tuple{Char, Char}, Int}()
	for (i, j) in keys(code)
		intermediate = shortest_sequence(panel, [i, j], numeric, i)
		amount = code[(i, j)]
		for a in 1:length(intermediate)-1
			pair = (intermediate[a], intermediate[a+1])
			if haskey(result, pair)
				result[pair] += amount
			else
				result[pair] = amount
			end
		end
	end
	return result
end

function calc_sequences(nav::Dict{Char, Pos}, main::Dict{Char, Pos}, code::Vector{Char}, layers::Int)::Int
	res = shortest_sequence(main, code, false)
	for _ in 1:layers
		res = shortest_sequence(nav, res)
	end
	len = length(res)
	num = parse(Int, join(code)[1:end-1])
	return len * num
end

function quick_calc_sequences(nav::Dict{Char, Pos}, main::Dict{Char, Pos}, code::Vector{Char}, layers::Int)::Int
	code2 = Dict{Tuple{Char, Char}, Int}()
	code2[('A', code[1])] = 1
	for a in 1:length(code)-1
		pair = (code[a], code[a+1])
		if haskey(code2, pair)
			code2[pair] += 1
		else
			code2[pair] = 1
		end
	end
	res = quick_shortest_sequence(main, code2, false)
	for _ in 1:layers
		res = quick_shortest_sequence(nav, res)
	end
	len = sum(values(res))
	num = parse(Int, join(code)[1:end-1])
	return len * num
end

filename = "data/data21.txt"
codes = get_codes(filename)
println(codes)
main = calc_distances(main_panel)
nav = calc_distances(nav_panel)
println(nav)

result = map(x -> calc_sequences(nav, main, collect(x), 2), codes)
println(result)
println(sum(result))

result = map(x -> quick_calc_sequences(nav, main, collect(x), 25), codes)
println(result)
println(sum(result))
