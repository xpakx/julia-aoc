filename = "data/data13.txt"
file_content = strip(read(filename, String))
content = map(x -> String(x), split(file_content, "\n\n"))

const Game = NTuple{3, Tuple{Int, Int}}
function parse_game(text::String)::Game
	nums = parse.(Int, [match.match for match in eachmatch(r"\d+", text)])
		return ((nums[1], nums[2]), (nums[3], nums[4]), (nums[5], nums[6]))
end

function solve(game::Game)::Tuple{Int, Int}
	(a₁, a₂) = game[1]
	(b₁, b₂) = game[2]
	(x, y) = game[3]
	det = a₁*b₂ - a₂*b₁
	if det == 0
		return (-1, -1) #TODO?
	end
	n_numerator = x*b₂ - y*b₁
	m_numerator = y*a₁ - x*a₂

	if n_numerator % det != 0 || m_numerator % det !=0
		return (-1, -1)
	end
	return (n_numerator/det, m_numerator/det)
end

cost(solution) = 3*solution[1] + solution[2] 

games = map(parse_game, content)
solutions = map(solve, games)
result = sum(map(cost, filter(x -> x[1] > 0, solutions)))
println(result)

