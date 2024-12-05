filename = "data/data03.txt"
file_content = read(filename, String)
matches = collect(eachmatch(r"mul\((-?\d+),(-?\d+)\)",file_content))
parsed_matches = [parse(Int, match.captures[1])*parse(Int, match.captures[2]) for match in matches]
println(sum(parsed_matches))

matches = collect(eachmatch(r"(mul\((-?\d+),(-?\d+)\))|(do\(\))|(don\'t\(\))",file_content))
enabled = true
result = 0
for match in matches
	if !isnothing(match.captures[1])  # mul()
		if enabled
			num1 = parse(Int, match.captures[2])
			num2 = parse(Int, match.captures[3])
			global result += num1 * num2
		end
	elseif !isnothing(match.captures[4])  # do()
		global enabled = true
	elseif !isnothing(match.captures[5])  # don't()
		global enabled = false
    end
end
println(result)
