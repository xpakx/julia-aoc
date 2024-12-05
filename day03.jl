filename = "data/data03.txt"
file_content = read(filename, String)
matches = collect(eachmatch(r"mul\((-?\d+),(-?\d+)\)",file_content))
parsed_matches = [parse(Int, match.captures[1])*parse(Int, match.captures[2]) for match in matches]
println(sum(parsed_matches))
