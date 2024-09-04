class_name BuildingManager
extends Node

@onready var tile_map = %TileMap
@onready var healths = %Healths
@onready var cards = %Cards
@onready var canvas_layer: CanvasLayer = %CanvasLayer

@export var ability_pop_up: PackedScene

var buildings: Array[Building]

func create_building(card: Building, position: Vector2i):
	var building: Building = card.duplicate(true)
	buildings.append(building)
	tile_map.place_building(building, position)

func remove_building(building: Building):
	cards.get_card_action(building).on_death()
	tile_map.ground.erase_cell(building.position)
	healths.destroy_building_health(building)
	buildings.erase(building)

func activate_ability(building: Building):
	print("Activate")
	var pop_up = ability_pop_up.instantiate()
	canvas_layer.add_child(pop_up)
	pop_up.load(building)

func activate(building: Building):
	if building.can_use_ability():
		cards.get_card_action(building).ability()

func start_player_turn():
	for building in buildings:
		cards.get_card_action(building).on_start_of_player_turn()
		building.current_ability_usage = 0

func update_building_position(building: Building):
	cards.get_card_action(building).position = building.position
