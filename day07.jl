using Base: dataids
filename = "data/data07.txt"
data = Vector{Vector{Int}}()
open(filename, "r") do file
    for line in eachline(file)
		    numbers = split(line, ':', limit=2)
		    condition = parse(Int, String(strip(numbers[1])))
		    numbers = split(strip(numbers[2]), ' ')
		    nums = map(x -> parse(Int, String(x)), numbers)
		    pushfirst!(nums, condition)
		    push!(data, nums)
    end
end

function increment!(vec, base)
    carry = 1
    for i in length(vec):-1:1
        vec[i] += carry
        if vec[i] == base
            vec[i] = 0
            carry = 1
        else
            carry = 0
            break
        end
    end
    return vec
end

result = 0
for elem in data
	condition = elem[1]
	elements =  elem[2:end]
	operations = zeros(length(elements)-1)
	while true
		index = 2
		value = elements[1]
		for op in operations
			if op == 0
				value += elements[index]
			elseif op == 1
				value *= elements[index]
			end
			index += 1
		end
		if value == condition
			global result += condition
			break
		end
		if operations == ones(length(elements)-1)
			break
		end
		increment!(operations, 2)
	end
end
println(result)


result = 0
for elem in data
	condition = elem[1]
	elements =  elem[2:end]
	operations = zeros(length(elements)-1)
	twoes = ones(length(elements)-1).*2
	while true
		index = 2
		value = elements[1]
		for op in operations
			if op == 0
				value += elements[index]
			elseif op == 1
				value *= elements[index]
			elseif op == 2
				order = 10^floor(Int, log10(elements[index]) + 1)
				value = value * order + elements[index]
			end
			index += 1
		end
		if value == condition
			global result += condition
			break
		end
		if operations == twoes
			break
		end
		increment!(operations, 3)
	end
end
println(result)
