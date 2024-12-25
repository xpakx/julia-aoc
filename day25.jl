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
			if pins == nothing
				key =  sum(num) == 0
				pins = num
			else
				pins = pins .+ num
			end
		end
		push!(key ? keys : locks, pins)
	end
	println(keys)
	println(locks)
end


get_data("data/data25.txt")
