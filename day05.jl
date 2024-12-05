filename = "data/data05.txt"
rules = Tuple[]
data = Vector{Vector{Int}}()
rule_mode = true
open(filename, "r") do file
    for line in eachline(file)
	    if line == ""
		    global rule_mode = false
		    continue
	    end
	    if rule_mode
		    numbers = split(line, '|')
		    num1 = parse(Int, String(numbers[1]))
		    num2 = parse(Int, String(numbers[2]))
		    push!(rules, (num1, num2))
	    else
		    numbers = split(line, ',')
		    parsed = [parse(Int, num) for num in numbers]
		    push!(data, parsed)
	    end
    end
end

result = 0
for elem in data
	correct = true
	for rule in rules
		position1 = findfirst(x -> x == rule[1], elem)
		position2 = findfirst(x -> x == rule[2], elem)
		if isnothing(position1) || isnothing(position2)
			continue
		end
		if position1 >= position2 
			correct = false
			break
		end
	end
	if correct
		middle_index = div(length(elem), 2) + 1
		global result += elem[middle_index]
	end
end
println(result)
