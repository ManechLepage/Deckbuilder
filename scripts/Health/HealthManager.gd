extends Control

var token_healths: Dictionary
var enemy_healths: Dictionary
var building_healths: Dictionary

@onready var tile_map = %TileMap
@export var health_label: PackedScene

@export var offset: Vector2

func update_token(token: Token):
	var token_health = token_healths.get(token)
	if not token_health:
		var label = health_label.instantiate()
		add_child(label)
		token_healths[token] = label
		token_health = label
	
	token_health.set_health(token.health)
	token_health.position = tile_map.map_to_local(token.position) + offset

func update_enemy(enemy: Enemy):
	var enemy_health = enemy_healths.get(enemy)
	if not enemy_health:
		var label = health_label.instantiate()
		add_child(label)
		enemy_healths[enemy] = label
		enemy_health = label
	
	enemy_health.set_health(enemy.health)
	enemy_health.position = tile_map.map_to_local(enemy.position) + offset

func update_building_health(building: Building):
	var building_health = building_healths.get(building)
	if not building_health:
		var label = health_label.instantiate()
		add_child(label)
		building_healths[building] = label
		building_health = label
	
	building_health.set_health(building.health)
	building_health.position = tile_map.map_to_local(building.position) + offset

func destroy_enemy_health(enemy: Enemy):
	enemy_healths.get(enemy).queue_free()
	enemy_healths.erase(enemy)

func destroy_building_health(building: Building):
	building_healths.get(building).queue_free()
	building_healths.erase(building)
