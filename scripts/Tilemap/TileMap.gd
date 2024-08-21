extends TileMap

var selected_token: Vector2i

func get_tile_from_mouse_position():
	var position = local_to_map(get_global_mouse_position())
	position = Vector2i(position.x - 1, position.y - 1)
	return position

func get_tile_content_from_mouse_position():
	var position = local_to_map(get_global_mouse_position())
	position = Vector2i(position.x - 1, position.y - 1)
	return get_tile_content(position)

func get_ground_tiles():
	var tiles = get_used_cells(0)
	var updated_tiles: Array[Vector2i]
	for tile in tiles:
		updated_tiles.append(tile - Vector2i(1, 1))
	return updated_tiles

func place_token_at_mouse_position(token: Token):
	var position = local_to_map(get_global_mouse_position())
	position = Vector2i(position.x - 1, position.y - 1)
	place_token(position, token)

func get_tile_content(position: Vector2i):
	var tile_data = get_cell_tile_data(1, position)
	if tile_data:
		return tile_data.get_custom_data("Token")
	else:
		return null

func place_token(position: Vector2i, token: Token):
	token.position = position
	set_cell(1, position, 5, token.sprite)

func place_enemy(position: Vector2i, enemy: Enemy):
	enemy.position = position
	set_cell(1, position, 6, enemy.sprite)

func place_building(building: Building, position: Vector2i):
	building.position = position
	set_cell(1, position, 2, building.building_sprite)

func clear_floor():
	for tile in get_used_cells(1):
		erase_cell(1, tile)

func clear_ground_indicators():
	for cell in get_used_cells(2):
		erase_cell(2, cell)

func place_selectable(position: Vector2i, sprite: Vector2i):
	set_cell(2, position, 0, sprite)

func has_ground(position: Vector2i):
	position = Vector2i(position.x + 1, position.y + 1)
	if get_cell_tile_data(0, position):
		return true
	return false

func move_token(token: Token, position: Vector2i):
	if token:
		token.has_moved = true
		erase_cell(1, token.position)
		place_token(position, token)

func make_token_selectable(token: Token):
	var position = token.position
	set_cell(3, position, 0, Vector2i(1, 0))

func clear_cover_selections():
	for cell in get_used_cells(3):
		erase_cell(3, cell)

func can_select(position: Vector2i):
	if position in get_used_cells(3):
		return true
	else:
		return false
