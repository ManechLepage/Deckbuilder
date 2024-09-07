class_name TileManager
extends Node2D

@export_range(0, 1) var frequency: float

@onready var ground: TileMapLayer = $Ground
@onready var cover_1: TileMapLayer = $"Cover 1"
@onready var ground_indicator: TileMapLayer = $GroundIndicator
@onready var cover_1_indicator: TileMapLayer = $Cover1Indicator
@onready var building_manager = %BuildingManager

var selected_token: Vector2i
var restricted_tiles = [Vector2i(4, 0), Vector2i(5, 0)]

var dark_grass = [Vector2i(11, 0), Vector2i(11, 1), Vector2i(11, 2)]
var medium_grass = [Vector2i(9, 0), Vector2i(9, 1), Vector2i(9, 2)]
var light_grass = [Vector2i(10, 0), Vector2i(10, 1), Vector2i(10, 2)]

var grass_noise: FastNoiseLite

func get_tile_from_mouse_position():
	var position = ground.local_to_map(get_global_mouse_position())
	position = Vector2i(position.x - 1, position.y - 1)
	return position

func get_tile_content_from_mouse_position():
	var position = ground.local_to_map(get_global_mouse_position())
	position = Vector2i(position.x - 1, position.y - 1)
	return get_tile_content(position)

func get_ground_tiles():
	var tiles = ground.get_used_cells()
	var updated_tiles: Array[Vector2i]
	for tile in tiles:
		updated_tiles.append(tile - Vector2i(1, 1))
	return updated_tiles

func place_token_at_mouse_position(token: Token):
	var position = ground.local_to_map(get_global_mouse_position())
	position = Vector2i(position.x - 1, position.y - 1)
	place_token(position, token)

func get_tile_content(position: Vector2i):
	var tile_data = cover_1.get_cell_tile_data(position)
	if tile_data:
		return tile_data.get_custom_data("Token")
	else:
		return null

func place_tile(position: Vector2i, type: int):
	var atlas_coord: Vector2i
	var decoration: float = randf()
	var decoration_type: int
	
	if decoration < 0.7:
		decoration_type = 0
	elif decoration < 0.85:
		decoration_type = 1
	else:
		decoration_type = 2
	
	if type == 0:
		atlas_coord = dark_grass[decoration_type]
	elif type == 1:
		atlas_coord = medium_grass[decoration_type]
	else:
		atlas_coord = light_grass[decoration_type]
	
	ground.set_cell(position + Vector2i(1, 1), 3, atlas_coord)

func place_token(position: Vector2i, token: Token):
	token.position = position
	cover_1.set_cell(position, 5, token.sprite)

func place_enemy(position: Vector2i, enemy: Enemy):
	enemy.position = position
	cover_1.set_cell(position, 6, enemy.sprite)

func place_building(building: Building, position: Vector2i):
	building.position = position
	cover_1.set_cell(position, 2, building.building_sprite)
	building_manager.update_building_position(building)

func place_obstacle(obstacle: Obstacle, position: Vector2i):
	obstacle.position = position
	cover_1.set_cell(position, 1, obstacle.sprite)

func clear_floor():
	for tile in cover_1.get_used_cells():
		cover_1.erase_cell(tile)

func clear_ground_indicators():
	for cell in ground_indicator.get_used_cells():
		ground_indicator.erase_cell(cell)

func place_selectable(position: Vector2i, sprite: Vector2i):
	ground_indicator.set_cell(position, 0, sprite)

func has_ground(position: Vector2i):
	position = Vector2i(position.x + 1, position.y + 1)
	if ground.get_cell_tile_data(position):
		if has_water(position):
			return false
		return true
	return false

func has_water(position: Vector2i):
	if ground.get_cell_atlas_coords(position) in restricted_tiles:
		return true
	return false

func move_token(token: Token, position: Vector2i):
	if token:
		token.has_moved = true
		cover_1.erase_cell(token.position)
		place_token(position, token)

func move_enemy(enemy: Enemy, position: Vector2i):
	if enemy:
		cover_1.erase_cell(enemy.position)
		place_enemy(position, enemy)

func make_token_selectable(token: Token):
	var position = token.position
	cover_1_indicator.set_cell(position, 0, Vector2i(1, 0))

func clear_cover_selections():
	for cell in cover_1_indicator.get_used_cells():
		cover_1_indicator.erase_cell(cell)

func can_select_for_movement(position: Vector2i):
	if get_tile_content(position):
		if get_tile_content(position) > -1 and get_tile_content(position) < 1000 :
			return true
	else:
		return false

func can_select(position: Vector2i):
	if position in cover_1_indicator.get_used_cells():
		return true
	else:
		return false

func get_obstacles(enemies=true):
	var obstacles: Array[Vector2i]
	obstacles.append_array(cover_1.get_used_cells())
	
	var water: Array[Vector2i]
	for tile in ground.get_used_cells():
		if has_water(tile):
			water.append(tile)
	
	if enemies:
		obstacles.append_array(water)
		return obstacles
	
	var filtered_obstacles: Array[Vector2i]
	for obstacle in obstacles:
		if get_tile_content(obstacle) > -1:
			filtered_obstacles.append(obstacle)
	filtered_obstacles.append_array(water)
	return filtered_obstacles

func load_noise_tiles():
	grass_noise = FastNoiseLite.new()
	grass_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	grass_noise.frequency = frequency
	grass_noise.seed = randi_range(1, 100_000)
	
	for tile in get_ground_tiles():
		if has_ground(tile):
			var noise_value = grass_noise.get_noise_2d(tile.x, tile.y)
			if noise_value < -0.13:
				place_tile(tile, 0)
			elif noise_value < 0.08:
				place_tile(tile, 1)
			else:
				place_tile(tile, 2)

func _on_combat_start() -> void:
	load_noise_tiles()

func set_tile_decorations():
	for tile in get_ground_tiles():
		if has_ground(tile):
			if not get_tile_content(tile):
				var tile_atlas: Vector2i = ground.get_cell_atlas_coords(tile)
				if tile_atlas in dark_grass:
					place_tile(tile, 0)
				elif tile_atlas in medium_grass:
					place_tile(tile, 1)
				else:
					place_tile(tile, 2)
