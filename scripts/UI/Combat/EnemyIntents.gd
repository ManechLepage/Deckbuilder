class_name EnemyIntents
extends Control

@onready var enemy_manager: EnemyManager = %EnemyManager
@onready var tile_map: TileManager = %TileMap

@export var offset: Vector2

@export var intent_control: PackedScene

func update_intents():
	for child in get_children():
			child.queue_free()
	
	for enemy: Enemy in enemy_manager.enemies:
		var intent = intent_control.instantiate()
		intent.position = tile_map.cover_1.map_to_local(enemy.position) + offset
		intent.update(enemy)
		
		add_child(intent)
