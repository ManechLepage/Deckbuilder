class_name CombatManager
extends Node

@onready var tile_map = %TileMap
@onready var tokens = %Tokens
@onready var label = $"../CanvasLayer/Label"
@onready var healths = %Healths
@onready var enemy_manager = %EnemyManager
@onready var selection_manager = %SelectionManager
@onready var roll_manager = %RollManager
@onready var bottom_button = %BottomButton
@onready var phase = %Phase
@onready var essence_manager = %EssenceManager
@onready var cards = %Cards
@onready var building_manager = %BuildingManager

signal placing_tokens
signal start_player_turn

var tokens_left: int
var is_first_turn: bool = true
var current_combat_phase: CombatPhase = CombatPhase.None

enum CombatPhase {
	None = -1,
	RollPlacements = 0,
	PlayerTurn = 1,
	EnemyTurn = 2,
	AfterCombat = 3,
	Awaiting = 4
}

func place():
	current_combat_phase = CombatPhase.RollPlacements
	phase.update_label()
	bottom_button.roll()
	if is_first_turn:
		is_first_turn = false
		cards.start_combat()
		building_manager.buildings.clear()

func _unhandled_input(event):
	if Input.is_action_just_pressed("left_click"):
		if current_combat_phase == CombatPhase.PlayerTurn:
			handle_click_in_player_turn()
		elif current_combat_phase == CombatPhase.EnemyTurn:
			handle_click_in_enemy_turn()
		update_tokens()
		update_enemies()
		update_buildings()

func handle_click_in_placing_tokens():
	if not tile_map.get_tile_content_from_mouse_position():
		if tile_map.has_ground(tile_map.get_tile_from_mouse_position()):
			tile_map.place_token_at_mouse_position(tokens.combat_tokens[tokens_left])
			tokens_left -= 1
			update_placing_label()
			if tokens_left < 0:
				player_turn()

func handle_click_in_player_turn():
	var token: Token = tokens.get_combat_token_at_position(tile_map.get_tile_from_mouse_position())
	if token:
		if not token.has_moved:
			if token == selection_manager.selected_token:
				selection_manager.clear_selected_token()
			else:
				selection_manager.selected_token = token
				selection_manager.selectable_tiles = selection_manager.calculate_selectable_cells(selection_manager.selected_token.movement, tile_map.get_tile_from_mouse_position(), true)
				selection_manager.update_selectable_tiles(selection_manager.selectable_tiles, Vector2i(0, 0))
	else:
		var position = tile_map.get_tile_from_mouse_position()
		if position in selection_manager.selectable_tiles:
			tile_map.move_token(selection_manager.selected_token, position)
		selection_manager.clear_selected_token()

func handle_click_in_enemy_turn():
	place()

func update_tokens():
	for token in tokens.combat_tokens:
		healths.update_token(token)

func reset_tokens():
	for token in tokens.combat_tokens:
		token.has_moved = false
		token.attacks_this_turn = 0

func update_enemies():
	for enemy in enemy_manager.enemies:
		healths.update_enemy(enemy)

func update_buildings():
	for building in building_manager.buildings:
		healths.update_building_health(building)
		cards.get_card_action(building).update()

func player_turn():
	current_combat_phase = CombatPhase.PlayerTurn
	phase.update_label()
	
	update_enemies()
	update_tokens()
	update_buildings()
	reset_tokens()
	
	essence_manager.replenish()
	start_player_turn.emit()
	
	cards.discard_hand()
	cards.draw(5)

func attack(token: Token, target: Vector2i):
	#print("ATTACK: ", token.name, "/", target)
	token.attacks_this_turn += 1
	current_combat_phase = CombatPhase.PlayerTurn
	phase.update_label()
	if token.attack.choose:
		if len(token.attack.area.relative_positions) > 0:
			deal_damage_to_tile(target, token.attack.damage)
		else:
			var direction: Vector2i = target - token.position
			direction = direction.clamp(Vector2i(-1, -1), Vector2i(1, 1))
			if token.attack.damage.piercing:
				for i in range(8):
					deal_damage_to_tile(token.position + (direction * i), token.attack.damage)
			else:
				var tiles: Array[Vector2i] = selection_manager.get_next_in_line(direction, token.position)
				deal_damage_to_tile(tiles[-1], token.attack.damage)
	else:
		for tile in token.attack.area.relative_positions:
			deal_damage_to_tile(token.position + tile, token.attack.damage)

func deal_damage_to_tile(tile: Vector2i, damage: Damage):
	var content = tile_map.get_tile_content(tile)
	if content:
		if content < 0:
			deal_damage_to_enemy(enemy_manager.get_enemy_at_position(tile), damage)
	for building in building_manager.buildings:
		if building.position == tile:
			deal_damage_to_building(building, damage)

func deal_damage_to_enemy(enemy: Enemy, damage: Damage):
	#print("HIT")
	enemy.health -= damage.value
	if enemy.health < 1:
		enemy_manager.remove_enemy(enemy)

func deal_damage_to_building(building: Building, damage: Damage):
	building.health -= damage.value
	if building.health < 1:
		building_manager.remove_building(building)

func update_placing_label():
	label.text = "Placing " + tokens.combat_tokens[tokens_left].name + "..."
	if tokens_left < 0:
		label.text = ""

func finish_player_turn():
	current_combat_phase = CombatPhase.EnemyTurn
	phase.update_label()
