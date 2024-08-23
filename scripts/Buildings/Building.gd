class_name Building
extends Card

@export var health: int
@export var building_sprite: Vector2i
@export var ability_usage_per_turn: int

var position: Vector2i
var current_ability_usage = 0

func can_use_ability():
	if ability_usage_per_turn == -1:
		current_ability_usage += 1
		return true
	elif ability_usage_per_turn == 0:
		return false
	elif current_ability_usage < ability_usage_per_turn:
		current_ability_usage += 1
		return true
	else:
		return false
