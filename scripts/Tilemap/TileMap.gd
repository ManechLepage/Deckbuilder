extends Node2D
@onready var ground: TileMapLayer = $Ground
@onready var cover_1: TileMapLayer = $"Cover 1"
@onready var ground_indicator: TileMapLayer = $GroundIndicator
@onready var cover_1_indicator: TileMapLayer = $Cover1Indicator
@onready var building_manager = %BuildingManager

var selected_token: Vector2i

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
		return true
	return false

func move_token(token: Token, position: Vector2i):
	if token:
		token.has_moved = true
		cover_1.erase_cell(token.position)
		place_token(position, token)

func make_token_selectable(token: Token):
	var position = token.position
	cover_1_indicator.set_cell(position, 0, Vector2i(1, 0))

func clear_cover_selections():
	for cell in cover_1_indicator.get_used_cells():
		cover_1_indicator.erase_cell(cell)

func can_select(position: Vector2i):
	if position in cover_1_indicator.get_used_cells():
		return true
	else:
		return false
