filename = "data/data06.txt"
obstacles = Vector{Vector{Bool}}()
open(filename, "r") do file
    for line in eachline(file)
		    chars = collect(line)
		    row = map(c -> c != '.', chars)
		    push!(obstacles, row)
    end
end

println(obstacles)
