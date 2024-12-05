filename = "data/data02.txt"
data = Vector{Vector{Int}}()
open(filename, "r") do file
    for line in eachline(file)
	numbers = split(line, ' ')
	nums = Int[]
	for number in numbers
		num = parse(Int, String(number))
		push!(nums, num)
	end
	push!(data, nums)
    end
end

result = 0
for row in data
	step_check = all(abs.(diff(row)) .<= 3) && all(abs.(diff(row)) .>= 1)
	increasing = issorted(row, lt = <)
	decreasing = issorted(row, lt = >)
	if step_check && (increasing || decreasing) 
		global result += 1
	end
end

println(result)

function test(arr)
	steps = diff(arr)
	step_check_row = abs.(steps) .<= 3 .&& abs.(steps) .>= 1
	increasing_row = steps .> 0
	decreasing_row = steps .< 0

	step_check = all(step_check_row)
	increasing = all(increasing_row)
	decreasing  = all(decreasing_row)
	return step_check && (increasing || decreasing) 
end

result = 0
for row in data
	if test(row)
		global result += 1
		continue
	end
	for i in 1:length(row)
		to_test = [row[1:i-1]; row[i+1:end]]
		if test(to_test)
			global result += 1
			break
		end
	end

end
println(result)
