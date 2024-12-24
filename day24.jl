struct Gate
    input1::String
    operation::String
    input2::String
    output::String
end

function parse_signal(input::String)::Tuple{String, Int}
	m = match(r"(\w+): (\d+)", input)
	return (m.captures[1], parse(Int, m.captures[2]))
end

function parse_gate(input::String)::Gate
	m = match(r"(\w+)\s+(\w+)\s+(\w+)\s+->\s+(\w+)", input)
        return Gate(m.captures[1], m.captures[2], m.captures[3], m.captures[4])
end

function read_file(filename::String)
	file_content = read(filename, String)
	data = split(file_content, "\n\n", limit=2)
	signals = map(x -> parse_signal(String(x)), split(strip(data[1]), '\n'))
	gates = map(x -> parse_gate(String(x)), split(strip(data[2]), '\n'))
	return (signals, gates)
end

signals, gates = read_file("data/data24.txt")
println(signals)
println(gates)
