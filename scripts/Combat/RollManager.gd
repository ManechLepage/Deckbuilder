class_name RollManager
extends Node

@onready var tile_map = %TileMap
@onready var enemy_manager = %EnemyManager
@onready var tokens = %Tokens
@onready var combat_manager = %CombatManager
@onready var phase = %Phase
@onready var building_manager = %BuildingManager

var used_tiles: Array[Vector2i]

func roll():
	tile_map.clear_floor()
	used_tiles.clear()
	roll_tokens()
	roll_enemies()
	roll_buildings()
	roll_obstacles()
	combat_manager.player_turn()

func roll_tokens():
	for token in tokens.combat_tokens:
		tile_map.place_token(get_random_position(), token)

func roll_enemies():
	for enemy in enemy_manager.enemies:
		tile_map.place_enemy(get_random_position(), enemy)
		enemy.calculate_agresiveness()

func roll_buildings():
	for building in building_manager.buildings:
		tile_map.place_building(building, get_random_position())

func roll_obstacles():
	pass

func get_random_position():
	while true:
		var pos = Vector2i(randi_range(-6, 1), randi_range(-5, 2))
		if pos not in used_tiles:
			used_tiles.append(pos)
			return pos
	return null
