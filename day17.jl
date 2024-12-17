A = 17323786
B = 0
C = 0
output = Int[]

function load_program(filename::String)::Vector{Int}
	data = split(read(filename, String), ',')
	return map(x -> parse(Int, String(x)), data)
end

function  combo(val::Int)::Int
	if val <= 3 
		return val
	elseif val == 4
		return A
	elseif val == 5
		return B
	elseif val == 6
		return C
	end
end

function bxl(val::Int, regB::Int)::Int
	return val ⊻ regB
end

function bst(val::Int)::Int
	return mod(combo(val), 8)
end

function jnz(reg::Int, val::Int, inst::Int)::Int
	if reg == 0
		return inst+2
	end
	return val+1
end

function out(val::Int)
	push!(output, bst(val))
end

function dv(val::Int, val2::Int)::Int
	den = 2^combo(val2)
	return floor(val ÷ den)
end

function op(program::Vector{Int}, inst::Int)::Int
	operation = program[inst]
	val = program[inst+1]
	if operation == 0
		global A = dv(A, val)
	elseif operation == 1
		global B = bxl(val, B)
	elseif operation == 2
		global B = bst(val)
	elseif operation == 3
		return jnz(A, val, inst)
	elseif operation == 4
		global B = bxl(B, C)
	elseif operation == 5
		out(val)
	elseif operation == 6
		global B = dv(A, val)
	elseif operation == 7
		global C = dv(A, val)
	end
	return inst + 2
end

function run(program::Vector{Int})
	inst = 1
	while inst <= length(program)
		inst = op(program, inst)
	end
end

program = load_program("data/data17.txt")
println(program)
run(program)
println("$A, $B, $C")
println(output)
