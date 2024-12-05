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
