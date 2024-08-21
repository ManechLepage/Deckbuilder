class_name CardActions
extends Node

@onready var combat_manager = %CombatManager
@onready var selection_manager = %SelectionManager
@onready var enemy_manager = %EnemyManager
@onready var roll_manager = %RollManager
@onready var essence_manager = %EssenceManager
@onready var tokens = %Tokens
@onready var cards = %Cards
@onready var healths = %Healths
@onready var tile_map = %TileMap
@onready var building_manager = %BuildingManager

signal selected

func resolve(control: CardDisplay):
	selection_manager.resolved(control)

func update():
	combat_manager.update_tokens()
	combat_manager.update_enemies()


func select_any_token():
	combat_manager.current_combat_phase = combat_manager.CombatPhase.Awaiting
	selection_manager.current_tile_selection_type = selection_manager.TileSelectionType.Attack
	selection_manager.token_selectable(tokens.combat_tokens)
	await selected
	return selection_manager.selected_token

func select_token_that_already_attacked():
	
	combat_manager.current_combat_phase = combat_manager.CombatPhase.Awaiting
	selection_manager.current_tile_selection_type = selection_manager.TileSelectionType.Attack
	var possible_tokens: Array[Token]
	for token in tokens.combat_tokens:
		if token.attacks_this_turn > 0:
			possible_tokens.append(token)
	selection_manager.token_selectable(possible_tokens)
	await selected
	return selection_manager.selected_token

func select_open_tile():
	combat_manager.current_combat_phase = combat_manager.CombatPhase.Awaiting
	selection_manager.current_selection_type = selection_manager.WaitingSelection.Tile
	selection_manager.current_tile_selection_type = selection_manager.TileSelectionType.Building
	var tiles: Array[Vector2i]
	for tile in tile_map.get_ground_tiles():
		if tile_map.get_tile_content(tile) == null:
			tiles.append(tile)
	selection_manager.update_selectable_tiles(tiles, Vector2i(0, 1))
	await selected
	return selection_manager.selected_tile


func get_random_open_space():
	var tiles: Array[Vector2i] = tile_map.get_ground_tiles()
	var tile = null
	while tile == null:
		tile = tiles.pick_random()
		if tile_map.get_tile_content(tile):
			tile = null
	return tile

func get_neighbouring_tiles(position: Vector2i):
	var tiles: Array[Vector2i]
	tiles.append(position + Vector2i(0, 1))
	tiles.append(position + Vector2i(0, -1))
	tiles.append(position + Vector2i(1, 0))
	tiles.append(position + Vector2i(-1, 0))
	return tiles

func get_tiles_from_range(range: int, position: Vector2i):
	var tiles: Array[Vector2i]
	if range == 1:
		tiles.append_array([position + Vector2i(0, 1), position + Vector2i(1, 0), position + Vector2i(0, -1), position + Vector2i(-1, 0)])
	return tiles

func get_random_token():
	return tokens.combat_tokens.pick_random()

func get_neighbouring_tokens(position: Vector2i):
	var token_list: Array[Token]
	for token in tokens.combat_tokens:
		if position - token.position in [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]:
			token_list.append(token)
	return token_list

func place_building(building: Building, position: Vector2i):
	building_manager.create_building(building, position)

func make_tiles_selectable(tiles: Array[Vector2i]):
	print("Ability used")
	await selected

func basic_attack(token: Token):
	selection_manager.attack_token(token)

func attack_with_extra_damage(token: Token, amount: int):
	token.attack.damage.value += amount
	basic_attack(token)

func extra_damage_of_same_type(token: Token, amount: int):
	var _token: Token = token.duplicate(true)
	_token.attack.damage.value = amount
	selection_manager.attack(_token)

func explode(range: int, damage: Damage, position: Vector2i):
	var tiles: Array[Vector2i] = get_tiles_from_range(range, position)
	for tile in tiles:
		combat_manager.deal_damage_to_tile(tile, damage)


func teleport_token(token: Token, new_position: Vector2i):
	tile_map.move_token(token, new_position)

func heal_token(token: Token, amount: int):
	token.health += amount
	update()

func buff_token_damage(token: Token, amount: int):
	token.attack.damage.value += amount

func add_essence(value: int):
	essence_manager.add_essence(value)


func reset_token_damage(token: Token, amount: int):
	token.attack.damage.value -= amount

func get_tokens_to_debuff(buffed_tokens: Array[Token], current_card: Card):
	var unbuff_tokens: Array[Token]
	for token in tokens.combat_tokens:
		if token not in buffed_tokens and current_card in token.card_buffs:
			unbuff_tokens.append(token)
			token.card_buffs.erase(current_card)
	return unbuff_tokens


func has_token_already_attacked():
	for token in tokens.combat_tokens:
		if token.attacks_this_turn > 0:
			return true
	return false
