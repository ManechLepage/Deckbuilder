class_name RollManager
extends Node

@onready var tile_map = %TileMap
@onready var enemy_manager = %EnemyManager
@onready var tokens = %Tokens
@onready var combat_manager = %CombatManager
@onready var phase = %Phase
@onready var building_manager = %BuildingManager
@onready var obstacle_manager: ObstacleManager = %ObstacleManager

var used_tiles: Array[Vector2i]

func roll():
	tile_map.clear_floor()
	used_tiles.clear()
	roll_obstacles()
	roll_tokens()
	roll_enemies()
	roll_buildings()
	tile_map.set_tile_decorations()
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
	obstacle_manager.change_obstacle_sprites()
	for obstacle in obstacle_manager.obstacles:
		if obstacle.fixed:
			tile_map.place_obstacle(obstacle, obstacle.position)
			used_tiles.append(obstacle.position)
	
	for obstacle in obstacle_manager.obstacles:
		if not obstacle.fixed or obstacle.position == Vector2i(-100, -100):
			tile_map.place_obstacle(obstacle, get_random_position())

func get_random_position():
	while true:
		var pos = Vector2i(randi_range(-6, 1), randi_range(-5, 2))
		if pos not in used_tiles:
			if tile_map.has_ground(pos):
				used_tiles.append(pos)
				return pos
	return null
