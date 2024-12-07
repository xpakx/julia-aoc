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

function test()
	result = 0
	for elem in data
		condition = elem[1]
	elements =  elem[2:end]
	stack = [(condition, elements)]
		while length(stack) > 0
			(cond, nums) = pop!(stack)
			if length(nums) == 1
				if cond == nums[1]
					result += condition
					break
				end
			else
				nums_curr = copy(nums)
				last = pop!(nums_curr)

				if cond - last > 0
					push!(stack, (cond - last, nums_curr))
				end

				if iszero(cond % last)
					push!(stack, (cond ÷ last, nums_curr))
				end
			end
		end
	end
	return result
end

println(test())
