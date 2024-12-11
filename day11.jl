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


for blink in 1:25
	global stones = transform(stones)
end

println(length(stones))
