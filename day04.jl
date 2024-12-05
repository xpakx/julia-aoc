filename = "data/data04.txt"
data = Vector{Vector{Char}}()
open(filename, "r") do file
    for line in eachline(file)
	chars = collect(line)
	push!(data, chars)
    end
end

data_matrix = Matrix{Char}(hcat(data...))

function count_xmas(row)
	str = join(row)
	matches = length(collect(eachmatch(r"XMAS", str)))
	str_rev = join(reverse(row))
	matches_rev = length(collect(eachmatch(r"XMAS", str_rev)))
	return matches + matches_rev
end

function eachdiag(matrix)
    diagonals = Vector{Vector{Char}}()
    # Top-left to bottom-right
    for start in 1:size(matrix, 1)
        diag = []
        i, j = start, 1
        while i <= size(matrix, 1) && j <= size(matrix, 2)
            push!(diag, matrix[i, j])
            i += 1
            j += 1
        end
        push!(diagonals, diag)
    end
    
    for start in 2:size(matrix, 2)
        diag = []
        i, j = 1, start
        while i <= size(matrix, 1) && j <= size(matrix, 2)
            push!(diag, matrix[i, j])
            i += 1
            j += 1
        end
        push!(diagonals, diag)
    end

    # Top-right to bottom-left
    for start in 1:size(matrix, 1)
        diag = []
        i, j = start, size(matrix, 2)
        while i <= size(matrix, 1) && j >= 1
            push!(diag, matrix[i, j])
            i += 1
            j -= 1
        end
        push!(diagonals, diag)
    end
    
    for start in 1:size(matrix, 2)-1
        diag = []
        i, j = 1, start
        while i <= size(matrix, 1) && j >= 1
            push!(diag, matrix[i, j])
            i += 1
            j -= 1
        end
        push!(diagonals, diag)
    end

    return diagonals
end

result = 0
for row in eachrow(data_matrix)
	global result += count_xmas(row)
end
for col in eachcol(data_matrix)
	global result += count_xmas(col)
end
for diag in eachdiag(data_matrix)
	global result += count_xmas(diag)
end
println(result)
