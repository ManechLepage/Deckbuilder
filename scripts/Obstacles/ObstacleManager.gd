class_name ObstacleManager
extends Node

@export var test_obstacles: Array[Obstacle]

@onready var roll_manager: RollManager = %RollManager
@onready var tile_map: TileManager = %TileMap

var obstacles: Array[Obstacle]

func _on_combat_manager_placing_tokens() -> void:
	for obstacle in test_obstacles:
		obstacles.append(obstacle.duplicate())

func remove_obstacle(obstacle: Obstacle):
	tile_map.cover_1.erase_cell(obstacle.position)
	obstacles.erase(obstacle)

func get_obstacle_at_position(position: Vector2i):
	for obstacle in obstacles:
		if obstacle.position == position:
			return obstacle
