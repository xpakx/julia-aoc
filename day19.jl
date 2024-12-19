function read_file(filename::String)
	file_content = read(filename, String)
	data = split(file_content, "\n\n", limit=2)
	towels = map(x -> collect(x), split(strip(data[1]), ", "))
	patterns = map(x -> collect(x), split(strip(data[2]), '\n'))
	return (towels, patterns)
end

function to_towel_dict(towels::Vector{Vector{Char}})
	towel_dict = Dict{Char, Vector{Vector{Char}}}()
	for towel in towels
		letter = towel[1]
		if haskey(towel_dict, letter)
			push!(towel_dict[letter], towel)
		else
			towel_dict[letter] = [towel]
		end
	end
	return towel_dict
end

function check(word::Vector{Char}, candidate::Vector{Char}, start::Int)::Bool
	if length(word) - start + 1 < length(candidate) 
		return false
	end

	for i in 1:length(candidate)
		j = start + i - 1
		if word[j] != candidate[i]
			return false
		end
	end

	return true
end

function solve1(patterns::Vector{Vector{Char}}, towels::Dict{Char, Vector{Vector{Char}}})::Int
	result = 0

	for pattern in patterns
		indices = [1]
		while length(indices) > 0
			index = pop!(indices)
			if index > length(pattern)
				result += 1
				break
			end
			letter = pattern[index]
			if !haskey(towels, letter)
				continue
			end
			candidates = towels[letter]
			for candidate in candidates
				if check(pattern, candidate, index)
					push!(indices, index + length(candidate))
				end
			end
		end
	end

	return result
end

(towels, patterns) = read_file("data/data19.txt")
towel_dict = to_towel_dict(towels)
println(solve1(patterns, towel_dict))


