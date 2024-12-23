const Graph = Dict{String, Set{String}}

function get_connections(filename::String)::Vector{Tuple{String,String}}
	file_content = read(filename, String)
	data = split(strip(file_content), "\n")
	splitted =  map(x -> split(String(x),'-',limit=2), data)
	return map(x -> (String(x[1]), String(x[2])), splitted)
end

function to_dict(data::Vector{Tuple{String,String}})::Graph
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

function find_triangles(data::Graph)::Int
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

function is_clique(data::Graph, clique::Vector{String})
        for u in clique, v in clique
            if u != v && !(v in data[u])
                return false
            end
        end
        return true
end

function explore(graph::Graph, candidate::Vector{String}, current_clique::Vector{String}, max_clique::Vector{String})
	if length(current_clique) > length(max_clique)
		while length(max_clique) > 0
			pop!(max_clique)
		end
		append!(max_clique, current_clique)
	end

	if length(candidate) + length(current_clique) <= length(max_clique)
		return
	end

	for (i, node) in enumerate(candidate)
		new_clique = copy(current_clique)
		push!(new_clique, node)

		new_candidates = [c for c in candidate[i+1:end] if c in graph[node]]

			explore(graph, new_candidates, new_clique, max_clique)
	end
end

function branch_and_bound(graph::Graph)
	max_clique = String[]
	nodes = collect(keys(graph))
	nodes_sorted = sort(nodes; by=n -> -length(graph[n]))

	explore(graph, nodes_sorted, String[], max_clique)

	return sort(max_clique)
end

data = get_connections("data/data23.txt")
dict = to_dict(data)
println(find_triangles(dict))
println(join(branch_and_bound(dict), ","))
