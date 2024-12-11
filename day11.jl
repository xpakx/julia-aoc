filename = "data/data11.txt"
file_content = strip(read(filename, String))
stones_str = split(file_content, " ")
stones = map(x -> parse(Int, x), stones_str)

println(stones)

function number_of_digits(number::Int)::Int
	return floor(Int, log10(number) + 1)
end

function remove_ending(num::Int, digits::Int)::Int
	return floor(Int, num ÷ digits)
end

function remove_beginning(num::Int, digits::Int)::Int
	return num % digits
end

function transform(stone::Int)::Vector{Int}
	if stone == 0
		return [1]
	end

	digits = number_of_digits(stone)
	if digits % 2 == 0
		mask = 10^(digits ÷ 2)
		first = remove_ending(stone, mask)
		second = remove_beginning(stone, mask)
		return [first, second]
	end
	return [stone*2024]
end

function transform(stones::Vector{Int})::Vector{Int}
	result = Int[]
	for stone in stones
		append!(result, transform(stone))
	end
	return result
end

function blinks(stones::Vector{Int}, blink_num::Int)::Int
	for _ in 1:blink_num
		stones = transform(stones)
	end
	return length(stones)
end


function transform(stones::Dict{Int, Int})::Dict{Int, Int}
	new_stones = Dict{Int, Int}()
	for (stone, stone_count) in stones
		new_stone = transform(stone)
		for s in new_stone
			if haskey(new_stones, s)
				new_stones[s] += stone_count
			else
				new_stones[s] = stone_count
			end
		end
	end
	return new_stones
end

function blink_reduce(stones::Vector{Int}, blink_num::Int)::Int
	stone_count = Dict{Int, Int}() # stone -> count
	for stone in stones
		if haskey(stone_count, stone)
			stone_count[stone] += 1
		else
			stone_count[stone] = 1
		end
	end
	for _ in 1:blink_num
		stone_count = transform(stone_count)
	end
	return sum(values(stone_count))
end


println(blinks(stones, 25))
println(blink_reduce(stones, 75))
