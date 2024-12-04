filename = "data/data01.txt"
arr1 = Int[]
arr2 = Int[]
open(filename, "r") do file
    for line in eachline(file)
	numbers = split(line, ' ', limit=2)
	num1 = parse(Int, String(numbers[1]))
	num2 = parse(Int, String(strip(numbers[2])))
	push!(arr1, num1)
	push!(arr2, num2)
    end
end
sort!(arr1)
sort!(arr2)

println(arr1)
println(arr2)

diffs = abs.(arr2 .- arr1)

println(diffs)
println(sum(diffs))
