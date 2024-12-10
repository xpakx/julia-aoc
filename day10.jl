filename = "data/data10.txt"
file_content = read(filename, String)
lines = split(file_content, '\n')
terrain = [[parse(Int, char) for char in line] for line in lines]

println(terrain)
