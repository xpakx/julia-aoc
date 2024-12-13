filename = "data/data13.txt"
file_content = strip(read(filename, String))
content = map(x -> String(x), split(file_content, "\n\n"))

const Game = NTuple{3, Tuple{Int, Int}}
function parse_game(text::String)::Game
	nums = parse.(Int, [match.match for match in eachmatch(r"\d+", text)])
		return ((nums[1], nums[2]), (nums[3], nums[4]), (nums[5], nums[6]))
end

games = map(parse_game, content)
println(games)

