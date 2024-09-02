class_name PassiveManager
extends Node

@onready var combat_manager: CombatManager = %CombatManager
@onready var selection_manager: SelectionManager = %SelectionManager
@onready var enemy_manager: EnemyManager = %EnemyManager
@onready var building_manager: BuildingManager = %BuildingManager
@onready var tokens = %Tokens
@onready var tile_map: TileManager = %TileMap

func activate(passive: Passive):
	if passive is RandomHealing:
		random_healing(passive)
	update()

func random_healing(passive: RandomHealing):
	for i in range(passive.times):
		var enemy: Enemy = enemy_manager.enemies.pick_random()
		enemy.heal(passive.value)

func update():
	combat_manager.update_enemies()
	combat_manager.update_buildings()
	combat_manager.update_tokens()
