using IterTools

function get_data(filename::String)
	file_content = read(filename, String)
	data = split(strip(file_content), "\n\n")
	keys = []
	locks = []
	for entry in data
		lines = split(entry, '\n')
		pins = nothing
		key = false
		for line in lines
			chars = collect(line)
			num = map(x -> x == '#' ? 1 : 0, chars)
			if isnothing(pins)
				key =  sum(num) == 0
				pins = num
			else
				pins = pins .+ num
			end
		end
		push!(key ? keys : locks, pins)
	end
	return (keys, locks)
end

function find_matches(keys, locks)::Int
	result = 0
	for (key, lock) in product(keys, locks)
		test = key .+ lock
		i = findfirst(x -> x > 7, test)
		if isnothing(i)
			result += 1
		end
	end
	return result
end


keys, locks = get_data("data/data25.txt")
println(find_matches(keys, locks))
