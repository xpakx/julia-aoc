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

println(data)
