class_name Movement
extends Resource

var relative_positions: Array[Vector2i]
@export var relative_directions: Array[Vector2i]
@export var distance: int

var relative_neighbours = [
	Vector2i(0, 1),
	Vector2i(0, -1),
	Vector2i(1, 0),
	Vector2i(-1, 0)
]

var visited_nodes: Array[Vector2i]
var grid: Array[Array]

func calculate_relative_positions(_grid: Array[Array], position: Vector2i):
	visited_nodes.clear()
	grid = _grid
	find_range(position, distance, 0)

func find_range(position: Vector2i, max_range:int, current_range:int):
	visited_nodes.append(position)
	if current_range < max_range:
		for i in relative_neighbours:
			if grid[i.x][i.y] == 0:
				find_range(position + i, max_range, current_range + 1)
