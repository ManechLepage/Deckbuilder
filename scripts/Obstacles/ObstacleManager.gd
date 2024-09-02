class_name ObstacleManager
extends Node

@export var test_obstacles: Array[Obstacle]

var obstacles: Array[Obstacle]

func _on_combat_manager_placing_tokens() -> void:
	for obstacle in test_obstacles:
		obstacles.append(obstacle.duplicate(true))
