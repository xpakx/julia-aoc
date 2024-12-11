filename = "data/data11.txt"
file_content = strip(read(filename, String))
stones_str = split(file_content, " ")
stones = map(x -> parse(Int, x), stones_str)

println(stones)
