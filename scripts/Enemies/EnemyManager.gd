class_name EnemyManager
extends Node

@onready var tile_map = %TileMap
@export var testing_enemies: Array[Enemy]
var enemies: Array[Enemy]
@onready var healths = %Healths
@onready var combat_manager: CombatManager = %CombatManager
@onready var passive_manager: PassiveManager = %PassiveManager

var finished = false

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

func manage_enemy_turn():
	finished = false
	enemies.shuffle()
	
	for enemy: Enemy in enemies:
		update_enemy_intent(enemy)
		if enemy.can_enemy_attack:
			enemy.choose_target()
			tile_map.move_enemy(enemy, enemy.target[1])
		else:
			var target = enemy.get_random_movement(tile_map.get_obstacles())
			tile_map.move_enemy(enemy, target)
		
		combat_manager.update_enemies(false)
		await get_tree().create_timer(0.3).timeout
		
		if enemy.can_enemy_attack and enemy.does_attack:
			combat_manager.deal_damage_to_tile(enemy.target[0], enemy.attack.damage)
		else:
			var passive: Passive = enemy.choose_passive()
			if passive:
				passive_manager.activate(passive)
		
		combat_manager.update_tokens()
		combat_manager.update_buildings()
		await get_tree().create_timer(0.3).timeout
	
	finished = true

func update_enemy_intent(enemy: Enemy):
	enemy.can_enemy_attack = enemy.can_attack(tile_map.get_obstacles(false), tile_map.get_obstacles())
