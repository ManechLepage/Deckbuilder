extends Node

@onready var tile_map = %TileMap
@onready var healths = %Healths
@onready var cards = %Cards

var buildings: Array[Building]

func create_building(card: Building, position: Vector2i):
	buildings.append(card.duplicate(true))
	tile_map.place_building(card, position)

func remove_building(building: Building):
	cards.get_card_action(building).on_death()
	tile_map.erase_cell(1, building.position)
	healths.destroy_building_health(building)
	buildings.erase(building)

func start_player_turn():
	for building in buildings:
		cards.get_card_action(building).on_start_of_player_turn()
