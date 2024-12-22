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

const Key = Tuple{Int, Int, Int, Int}
function sim2(num::Int, n::Int, mem::Dict{Key, Int})::Int
	diffs = Int[]
	prev = mod(num, 10)
	found = Set{Key}()
	for _ in 1:n
		num = nextnum(num)
		price = mod(num, 10)
		diff = price - prev
		prev = price
		push!(diffs, diff)
		if length(diffs) > 4
			diffs = diffs[2:end]
		end
		if length(diffs) == 4
			k = Tuple(diffs)
			if !(k in found)
				push!(found, k)
				if haskey(mem, k)
					mem[k] += price
				else
					mem[k] = price
				end
			end
		end
	end
	return num
end

filename = "data/data22.txt"
seeds = get_seeds(filename)

result = map(a -> sim(a, 2000), seeds)
println(sum(result))

mem = Dict{Key,Int}()
result = map(a -> sim2(a, 2000, mem), seeds)
(k, v) = findmax(mem)
println(k, v)
