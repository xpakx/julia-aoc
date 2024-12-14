const Robot = NTuple{2, Tuple{Int, Int}}

function parse_robot(text::String)::Robot
	nums = parse.(Int, [match.match for match in eachmatch(r"-?\d+", text)])
	return ((nums[1], nums[2]), (nums[3], nums[4]))
end

function read_file(filename::String)::Vector{Robot}
	data = Vector{Robot}()
	open(filename, "r") do file
		data = map(x -> parse_robot(String(x)), eachline(file))
	end
	return data
end

filename = "data/data14.txt"
data = read_file(filename)
println(data)
