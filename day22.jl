function get_seeds(filename::String)::Vector{Int}
	file_content = read(filename, String)
	data = split(strip(file_content), "\n")
	return map(x -> parse(Int, String(x)), data)
end

function nextnum(num::Int)::Int
	a = prune(mix(num, num*64))
	b = prune(mix(a, a ÷ 32))
	return prune(mix(b, b * 2048))
end

mix(secret::Int, num::Int)::Int = secret ⊻ num
prune(num::Int)::Int = mod(num, 16777216)

function sim(num::Int, n::Int)::Int
	for _ in 1:n
		num = nextnum(num)
	end
	return num
end

filename = "data/data22.txt"
seeds = get_seeds(filename)
println(seeds)

result = map(a -> sim(a, 2000), seeds)
println(result)
println(sum(result))
