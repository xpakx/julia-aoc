function load_program(filename::String)
	data = split(read(filename, String), ',')
	return map(x -> parse(Int, String(x)), data)
end

program = load_program("data/data17.txt")
println(program)
