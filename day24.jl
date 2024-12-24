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

function to_signal_dict(data::Vector{Tuple{String,Int}})::Dict{String, Int}
	result = Dict{String, Int}()
	for (key, value) in data
		result[key] = value
	end
	return result
end

function to_gate_dict(data::Vector{Gate})::Dict{String, Gate}
	result = Dict{String, Gate}()
	for gate in data
		result[gate.output] = gate
	end
	return result
end

function solve(gate::Gate, gates::Dict{String, Gate}, signals::Dict{String, Int})::Int
	input1 = 0
	if haskey(signals, gate.input1)
		input1 = signals[gate.input1]
	else
		input1 = solve(gates[gate.input1], gates, signals)
		signals[gate.input1] = input1
	end

	input2 = 0
	if haskey(signals, gate.input2)
		input2 = signals[gate.input2]
	else
		input2 = solve(gates[gate.input2], gates, signals)
		signals[gate.input2] = input2
	end
	if gate.operation == "AND"
		return input1 & input2
	elseif gate.operation == "OR"
		return input1 | input2
	else
		return input1 ⊻ input2
	end
end

function solve1(gates::Vector{Gate}, signals::Vector{Tuple{String, Int}})::Int
	signal_dict = to_signal_dict(signals)
	gate_dict = to_gate_dict(gates)
	result = 0
	for gate in gates
		if startswith(gate.output, 'z')
			bit = solve(gate, gate_dict, signal_dict)
			i = parse(Int, gate.output[2:end])
			if bit == 1
				result = result | (1 << i)
			end
		end
	end
	return result
end

function count_inputs(gates::Vector{Gate})::Dict{String, Int}
	result = Dict{String, Int}()
	for gate in gates
		if haskey(result, gate.input1)
			result[gate.input1] += 1
		else
			result[gate.input1] = 1
		end
		if haskey(result, gate.input2)
			result[gate.input2] += 1
		else
			result[gate.input2] = 1
		end
	end
	return result
end

function solve2(gates::Vector{Gate})::Vector{String}
	inputs = count_inputs(gates)
	err = Set{String}()
	highest_z = 0
	for gate in gates
		if startswith(gate.output, 'z') 
			i = parse(Int, gate.output[2:end])
			if i > highest_z
				highest_z = i
			end
		end
		if startswith(gate.output, 'z') && gate.operation != "XOR"
			push!(err, gate.output)
		end
		if startswith(gate.input1, 'z')
			push!(err, gate.input1)
		end
		if startswith(gate.input2, 'z')
			push!(err, gate.input2)
		end
		if gate.operation == "XOR" && !startswith(gate.output, 'z') && !(
			(startswith(gate.input1, 'x') && startswith(gate.input2, 'y')) || 
			(startswith(gate.input1, 'y') && startswith(gate.input2, 'x')))
			push!(err, gate.output)
		end
		if gate.operation == "XOR" && !startswith(gate.output, 'z') && inputs[gate.output] != 2
			push!(err, gate.output)
		end
		if gate.operation == "AND" && !startswith(gate.output, 'z') && inputs[gate.output] != 1 &&
			!((gate.input1 == "x00" && gate.input2 == "y00") | (gate.input1 == "y00" && gate.input2 == "x00"))
			push!(err, gate.output)
		end

	end
	z = "z" * lpad(highest_z, 2, '0')
	if z in err
		delete!(err, z)
	end
	
	return sort(collect(err))
end

signals, gates = read_file("data/data24.txt")
println(solve1(gates, signals))
println(join(solve2(gates), ','))
