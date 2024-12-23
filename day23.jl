
function get_connections(filename::String)::Vector{Tuple{String,String}}
	file_content = read(filename, String)
	data = split(strip(file_content), "\n")
	splitted =  map(x -> split(String(x),'-',limit=2), data)
	return map(x -> (String(x[1]), String(x[2])), splitted)
end

function to_dict(data::Vector{Tuple{String,String}})::Dict{String, Set{String}}
	result = Dict{String, Set{String}}()
	for (key, value) in data
		if haskey(result, key)
			push!(result[key], value)
		else
			result[key] = Set([value])
		end
		if haskey(result, value)
			push!(result[value], key)
		else
			result[value] = Set([key])
		end
	end
	return result
end

function find_triangles(data::Dict{String, Set{String}})::Int
	result = 0
	for node in keys(data)
		to_add = false
		if startswith(node, 't')
			to_add = true
		end
		neighbors = collect(data[node])
		for (i, a) in enumerate(neighbors[1:end-1])
			for b in neighbors[i+1:end]
				if b in data[a]
					if to_add || startswith(a, 't') || startswith(b, 't')
						result += 1
					end
				end
			end
		end
		
	end
	return result ÷ 3
end


data = get_connections("data/data23.txt")
dict = to_dict(data)
println(find_triangles(dict))
