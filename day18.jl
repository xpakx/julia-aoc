using DataStructures

const Pos = Tuple{Int,Int}

function parse_pair(text::String)::Pos
	pair = split(text, ',', limit=2)
	nums = map(x -> parse(Int, String(x)), pair)
	return (nums[1], nums[2])

end

function get_map(filename::String)::Vector{Pos}
	file_content = read(filename, String)
	data = split(strip(file_content), "\n")
	return map(x -> parse_pair(String(x)), data)
end



function dijkstra(obstacles::Set{Pos}, start::Pos, max_coord::Int)::Int
	Q = PriorityQueue{Pos, Int}()
	d = Dict{Pos, Int64}()
	pre = Dict{Pos, Pos}()
	finish = (max_coord, max_coord)


	dirs = [(0, 1), (0, -1), (1, 0), (-1, 0)]

	enqueue!(Q, start => 0)
	d[start] = 0

	while !isempty(Q)
		node = dequeue!(Q)
		if node == finish
			return d[node]
		end

		neighbors = map(x -> x .+ node, dirs)
		for n in neighbors
			if n[1] < 0 || n[1] > max_coord || n[2] < 0 || n[2] > max_coord
				continue
			end
			if n in obstacles
				continue
			end

			d1 = d2 = typemax(Int)
			dir2 = node .- n
			if haskey(d, node) 
				d1 = d[node]
			end
			if haskey(d, n) 
				d2 = d[n]
			end
			dist = 1
			if d2 >= d1 + dist
				if haskey(Q, n)
					Q[n] = d1 + dist
				else
					enqueue!(Q, n => d1 + dist)
				end
				d[n] = d1 + dist
				pre[n] = node
			end
		end
	end
	return -1
end

function find_blockade(obstacles::Vector{Pos}, start::Pos, max_coord::Int)::Pos
	finish = (max_coord, max_coord)
	left = 1
	right = length(obstacles)
	while left < right
		mid = (left+right)÷2
		obs = Set(obstacles[1:mid])
		if dijkstra(obs, start, max_coord) < 0
			right = mid
		else
			left = mid + 1
		end
	end
	return obstacles[left]
end

size = 70
bytes_to_simulate = 1024
filename = "data/data18.txt"
bytes = get_map(filename)
println(dijkstra(Set(bytes[1:bytes_to_simulate]), (0,0), size))
println(find_blockade(bytes, (0,0), size))
