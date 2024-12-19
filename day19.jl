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

function check2(pattern::Vector{Char}, towels::Vector{Vector{Char}}, cache::Dict{Vector{Char},Int})::Int
	if length(pattern) == 0
		return 1
	end
	if haskey(cache, pattern)
		return cache[pattern]
	end
	count = 0
	for towel in towels
		if check(pattern, towel, 1)
			remaining = pattern[length(towel) + 1:end]
			count += check2(remaining, towels, cache)
		end
	end
	cache[pattern] = count 
	return count
end

function solve2(patterns::Vector{Vector{Char}}, towels::Vector{Vector{Char}})::Int
	result = 0

	for pattern in patterns
		result += check2(pattern, towels, Dict{Vector{Char}, Int}())
	end

	return result
end

(towels, patterns) = read_file("data/data19.txt")
towel_dict = to_towel_dict(towels)
println(solve1(patterns, towel_dict))
println(solve2(patterns, towels))


