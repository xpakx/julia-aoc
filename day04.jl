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

result = 0
for i in 2:length(data)-1
	for j in 2:length(data[i])-1
		if data[i][j] != 'A'
			continue
		end
		d11 = data[i-1][j-1]
		d12 = data[i+1][j+1]
		d21 = data[i-1][j+1]
		d22 = data[i+1][j-1]
		if (d11 == 'S' && d12 == 'M') || (d11 == 'M' && d12 == 'S')
			if (d21 == 'S' && d22 == 'M') || (d21 == 'M' && d22 == 'S')
				global result += 1
			end
		end
	end
end
println(result)
