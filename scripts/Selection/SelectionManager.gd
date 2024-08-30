extends Node

@onready var tile_map = %TileMap
@onready var enemy_manager = %EnemyManager
@onready var tokens = %Tokens
@onready var label = $"../CanvasLayer/Label"
@onready var combat_manager = %CombatManager
@onready var top_button = %TopButton
@onready var hand = $"../CanvasLayer/Hand"
@onready var cards = %Cards
@onready var essence_manager = %EssenceManager
@onready var card_actions = %CardActions
@onready var building_manager = %BuildingManager

var selected_token: Token
var selected_tile: Vector2i
var selectable_tiles: Array[Vector2i]
var focused_card: Control
var selected_card: Card
var played_card: Control

var is_in_hand: bool = false
var can_confirm_action: bool = false

var is_playing_card: bool = false

var is_for_movement: bool = false

enum WaitingSelection {
	None = -1,
	All = 0,
	Token = 1,
	Enemy = 2,
	Tile = 3,
	TokenAndTile = 4,
	Card = 5,
	Building = 6
}

enum TileSelectionType {
	None = -1,
	All = 0,
	Attack = 1,
	Building = 2
}

var current_tile_selection_type: TileSelectionType = TileSelectionType.None
var current_selection_type: WaitingSelection = WaitingSelection.None

#func _process(delta):
	#print(is_in_hand)

func _input(event):
	print(current_selection_type)
	if Input.is_action_just_pressed("left_click"):
		check_for_token()
		check_for_tile()
		check_for_card()
		check_for_building()

func check_for_token():
	if tile_map.can_select_for_movement(tile_map.get_tile_from_mouse_position()):
		var previous_token: Token = selected_token
		selected_token = tokens.get_combat_token_at_position(tile_map.get_tile_from_mouse_position())
		if current_selection_type == WaitingSelection.Token or current_selection_type == WaitingSelection.TokenAndTile or current_selection_type == WaitingSelection.All:
			if tile_map.can_select(tile_map.get_tile_from_mouse_position()):
				card_actions.selected.emit()
		else:
			if not selected_token.has_moved:
				is_for_movement = true
				if previous_token == selected_token:
					is_for_movement = false
					clear_selected_token()
				else:
					selectable_tiles = calculate_selectable_cells(selected_token.movement, tile_map.get_tile_from_mouse_position(), true)
					update_selectable_tiles(selectable_tiles, Vector2i(0, 0))
		tile_map.clear_cover_selections()
		current_selection_type = WaitingSelection.Tile

func check_for_tile():
	if current_selection_type == WaitingSelection.Tile or current_selection_type == WaitingSelection.TokenAndTile or current_selection_type == WaitingSelection.All:
		var tile = tile_map.get_tile_from_mouse_position()
		if  tile in selectable_tiles:
			if is_for_movement:
				is_for_movement = false
				tile_map.move_token(selected_token, tile)
				clear_selected_token()
			else:
				update_selected_tile(selectable_tiles, tile)
				enable_confirmation()
			tile_map.clear_cover_selections()
			current_selection_type = WaitingSelection.None

func check_for_card():
	if focused_card and is_in_hand:
		if essence_manager.can_play(focused_card.card.cost) and cards.get_card_action(focused_card.card).can_play() and not is_playing_card:
			selected_card = focused_card.card
			essence_manager.add_essence(-selected_card.cost)
			cards.visualize_card(focused_card)
			is_playing_card = true

func check_for_building():
	if current_selection_type == WaitingSelection.All or current_selection_type == WaitingSelection.Building:
		var tile = tile_map.get_tile_from_mouse_position()
		for building: Building in building_manager.buildings:
			if building.position == tile:
				building_manager.activate_ability(building)

func token_selectable(selectable_tokens: Array[Token]):
	clear_selections()
	current_selection_type = WaitingSelection.Token
	label.text = "Select a token"
	for token in tokens.combat_tokens:
		if token in selectable_tokens:
			tile_map.make_token_selectable(token)

func attack_token(token: Token):
	show_attacked_tiles(token)
	if token.attack.choose:
		disable_confirmation()
		current_selection_type = WaitingSelection.Tile
	else:
		enable_confirmation()

func update_selected_tile(selectable_tiles: Array[Vector2i], tile: Vector2i):
	selected_tile = tile
	for _tile in selectable_tiles:
		tile_map.place_selectable(_tile, Vector2i(0, 1))
	tile_map.place_selectable(tile, Vector2i(1, 1))

func update_selectable_tiles(_selectable_tiles: Array[Vector2i], sprite: Vector2i):
	selectable_tiles = _selectable_tiles
	tile_map.clear_ground_indicators()
	for tile in selectable_tiles:
		tile_map.place_selectable(tile, sprite)

func clear_selections():
	disable_confirmation()
	current_selection_type = WaitingSelection.All
	selected_token = null
	tile_map.clear_cover_selections()
	tile_map.clear_ground_indicators()

func clear_selected_token():
	selected_token = null
	selectable_tiles.clear()
	tile_map.clear_ground_indicators()

func all_enemies_selectable():
	pass

func show_attacked_tiles(token: Token):
	selectable_tiles = calculate_selectable_cells(token.attack.area, token.position, false)
	update_selectable_tiles(selectable_tiles, Vector2i(0, 1))

func top_button_pressed():
	if current_tile_selection_type == TileSelectionType.Attack:
		attack()
	else:
		card_actions.selected.emit()
		clear_selections()
	combat_manager.update_enemies()
	combat_manager.update_tokens()
	combat_manager.update_buildings()

func attack(token: Token=selected_token):
	combat_manager.attack(token, selected_tile)
	clear_selections()
	card_actions.selected.emit()

func enable_confirmation():
	can_confirm_action = true
	top_button.attack()

func disable_confirmation():
	can_confirm_action = false
	top_button.disable()

func calculate_selectable_cells(token_movement: Movement, position: Vector2i, filter_covers: bool):
	var tiles: Array[Vector2i]
	
	tiles.append_array(token_movement.calculate_relative_positions(tile_map.get_obstacles(), position))
	
	for relative_direction in token_movement.relative_directions:
		tiles.append_array(get_next_in_line(relative_direction, position))
	
	return filter_tiles(tiles, filter_covers)

func get_next_in_line(relative_direction: Vector2i, initial_position: Vector2i):
	var last_position: Vector2i = initial_position
	var hit_entity = false
	var tiles: Array[Vector2i]
	while not hit_entity:
		var new_position: Vector2i = last_position + relative_direction
		tiles.append(new_position)
		if tile_map.get_tile_content(new_position):
			hit_entity = true
		if not tile_map.has_ground(new_position):
			hit_entity = true
		last_position = new_position
	return tiles

func filter_tiles(tiles: Array[Vector2i], filter_cover: bool):
	var filtered_tiles: Array[Vector2i]
	for tile in tiles:
		if tile_map.has_ground(tile):
			if tile_map.get_tile_content(tile) == null or not filter_cover:
				filtered_tiles.append(tile)
	
	return filtered_tiles

func focus_card(card: Control):
	focused_card = card
	for i in hand.get_children():
		i.unfocus()
	focused_card.focus()

func unfocus_card(card: Control):
	if focused_card == card:
		focused_card = null
	card.unfocus()

func resolved(played_card: Control):
	played_card.remove_from_play()
	selected_card = null
	current_selection_type = WaitingSelection.All

func _on_hand_mouse_entered():
	is_in_hand = true

func _on_hand_mouse_exited():
	is_in_hand = false

func finished_remove():
	is_playing_card = false
