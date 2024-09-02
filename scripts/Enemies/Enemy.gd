class_name Enemy
extends Resource

@export var sprite: Vector2i
@export var health: int

@export var movement: Movement
@export var attack: Attack

@export var agressiveness: float

@export var passives: Array[Passive]

var position: Vector2i

var targets: Array[Array]
var target: Array

var can_enemy_attack: bool
var does_attack: bool

func heal(value: int):
	health += value

func can_attack(target_grid: Array[Vector2i], movement_grid: Array[Vector2i]):
	targets.clear()
	var possible_positions: Array[Vector2i] = movement.calculate_relative_positions(movement_grid, position)
	
	#print("TARGET: ", target_grid)
	for possible_position in possible_positions:
		var possible_targets: Array[Vector2i] = attack.area.calculate_relative_positions(movement_grid, possible_position)
		possible_targets.erase(possible_position)
		#print("POSSIBLE TARGETS(", possible_position , "): ", possible_targets)
		for possible_target in possible_targets:
			if possible_target in target_grid:
				targets.append([possible_target, possible_position])
	
	return len(targets) > 0

func choose_target():
	target = targets.pick_random()

func choose_passive():
	if len(passives) > 0:
		return passives.pick_random()
	return null

func calculate_agresiveness():
	does_attack = randf() > agressiveness

func get_random_movement(movement_grid: Array[Vector2i]):
	var possible_positions: Array[Vector2i] = movement.calculate_relative_positions(movement_grid, position)
	return possible_positions.pick_random()
