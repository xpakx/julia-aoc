
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
	end
	return result
end


data = get_connections("data/data23.txt")
println(data)
dict = to_dict(data)
println(dict)
