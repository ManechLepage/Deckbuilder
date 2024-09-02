class_name EnemyIntents
extends Control

@onready var enemy_manager: EnemyManager = %EnemyManager
@onready var tile_map: TileManager = %TileMap

@export var offset: Vector2

@export var passive_icon: Texture2D
@export var attack_icon: Texture2D
@export var no_intents_icon: Texture2D

@export var intent_control: PackedScene

func update_intents():
	for child in get_children():
			child.queue_free()
	
	for enemy: Enemy in enemy_manager.enemies:
		var intent = intent_control.instantiate()
		intent.position = tile_map.cover_1.map_to_local(enemy.position) + offset
		intent.get_child(0).texture = get_texture(enemy)
		
		add_child(intent)

func get_texture(enemy: Enemy):
	if enemy.can_enemy_attack and enemy.does_attack:
		return attack_icon
	else:
		if len(enemy.passives) > 0:
			return passive_icon
		else:
			return no_intents_icon
