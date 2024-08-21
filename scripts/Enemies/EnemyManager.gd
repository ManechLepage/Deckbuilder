extends Node

@onready var tile_map = %TileMap
@export var testing_enemies: Array[Enemy]
var enemies: Array[Enemy]
@onready var healths = %Healths

func _on_combat_manager_placing_tokens():
	for enemy in testing_enemies:
		enemies.append(enemy.duplicate())

func get_enemy_at_position(position: Vector2i):
	for enemy in enemies:
		if position == enemy.position:
			return enemy
	return null

func remove_enemy(enemy: Enemy):
	tile_map.erase_cell(1, enemy.position)
	healths.destroy_enemy_health(enemy)
	enemies.erase(enemy)
