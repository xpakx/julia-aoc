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

		print("$file_num * ", i-1, " = ", result, ", ")
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
				print("$file_num * ", j-1, " = ", result, ", ")
				global file_num += 1
			end
			global j -= 1
			continue
		end
		for _ in 1:spaces_to_consume
			global result += (j-1)*file_num
			print("$file_num * ", j-1, " = ", result, ", ")
			global file_num += 1
		end
		files[j] -= spaces_to_consume
		spaces_to_consume = 0
	end

	global i += 1
end

println(files)
println(result)
