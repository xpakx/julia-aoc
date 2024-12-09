filename = "data/data09.txt"
file_content = strip(read(filename, String))
chars = collect(file_content)
nums = map(x -> parse(Int, x), chars)
files = nums[1:2:end]
spaces = nums[2:2:end]

empty_spaces = sum(spaces)

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


files2 = Vector{Tuple{Int, Int}}()
spaces2 = Vector{Tuple{Int, Int}}()

block_num = 0
for (i, count) in enumerate(nums)
	tup = (block_num, count)
	if isodd(i-1)
		push!(spaces2, tup)
	else
		push!(files2, tup)
	end
	global block_num += count
end

result = 0
for (i, file) in enumerate(reverse(files2))
	local file_num = (length(files2) - i)
	file_start = file[1]
	file_len = file[2]

	for (i, space) in enumerate(spaces2)
		space_start = space[1]
		space_len = space[2]
		if space_start > file_start
			break
		end

		if space_len >= file_len
			files2[file_num + 1] = (space_start, file_len)
			if space_len == file_len
				deleteat!(spaces2, i)
			else
				spaces2[i] = (space_start + file_len, space_len - file_len)
			end
			break
		end
	end

	file = files2[file_num + 1]
	for i in file[1]:(file[1] + file[2] - 1)
		global result += file_num * i
	end
end

println(result)
