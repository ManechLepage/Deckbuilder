class_name Movement
extends Resource

@export var relative_directions: Array[Vector2i]
@export var distance: int
@export var relative_positions: Array[Vector2i]
@export var ignore_obstacles: bool

var relative_neighbours = [
	Vector2i(0, 1),
	Vector2i(0, -1),
	Vector2i(1, 0),
	Vector2i(-1, 0)
]

var visited_nodes: Array[Vector2i]
var obstacles: Array[Vector2i]

func calculate_relative_positions(_obstables: Array[Vector2i], position: Vector2i):
	visited_nodes.clear()
	obstacles = _obstables
	find_range(position, distance, 0)
	return visited_nodes

func find_range(position: Vector2i, max_range:int, current_range:int):
	visited_nodes.append(position)
	if current_range < max_range:
		for i in relative_neighbours:
			if position + i not in obstacles or ignore_obstacles:
				find_range(position + i, max_range, current_range + 1)
