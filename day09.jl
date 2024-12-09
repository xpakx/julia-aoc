filename = "data/data09.txt"
file_content = strip(read(filename, String))
chars = collect(file_content)
nums = map(x -> parse(Int, x), chars)
files = nums[1:2:end]
spaces = nums[2:2:end]
println(files)
println(spaces)

empty_spaces = sum(spaces)
println(empty_spaces)

file_num = 0
i = 1
j = length(files)
result = 0

while empty_spaces > 0
	for _ in 1:files[i]
		global result += (i-1)*file_num
		global file_num += 1
	end
	
	spaces_to_consume = spaces[i]
	global empty_spaces -= spaces_to_consume

	if i >= j
		break
	end

	while spaces_to_consume > 0
		if files[j] == 0
			global j -= 1
		end
		if files[j] <= spaces_to_consume
			moved = files[j]
			files[j] = 0
			spaces_to_consume -= moved
			for _ in 1:moved
				global result += (j-1)*file_num
				global file_num += 1
			end
			global j -= 1
			continue
		end
		for _ in 1:spaces_to_consume
			global result += (j-1)*file_num
			global file_num += 1
		end
		files[j] -= spaces_to_consume
		spaces_to_consume = 0
	end

	global i += 1
end

println(result)


orig = nums[1:2:end]
files = nums[1:2:end]
spaces = nums[2:2:end]
file_num = 0
i = 1
j = length(files)
result = 0

spacedict = Dict{Int, Vector{Tuple{Int, Int}}}() # space num to list of (block_num, length)
for a in j:-1:2
	files[a]
	for b in eachindex(spaces)
		if files[a] <= spaces[b]
			spaces[b] -= files[a]
			if haskey(spacedict, b)
				push!(spacedict[b], (a-1, files[a]))
			else
				spacedict[b] = [(a-1, files[a])]
			end
			files[a] = 0
			break
		end
	end
end

for i in eachindex(files)
	if files[i] == 0 
		global file_num += orig[i]
	end
	for _ in 1:files[i]
		global result += (i-1)*file_num
		global file_num += 1
		print("$file_num * ", i-1, " = ", result, ", ")
	end

	if haskey(spacedict, i)
		for (block_num, len) in spacedict[i]
			for _ in 1:len
				global result += block_num*file_num
				global file_num += 1
				print("$file_num * ", block_num, " = ", result, ", ")
			end

		end
	end
	if i <= length(spaces)
		global file_num += spaces[i]
	end
end
println()
print(files)
print(result)
