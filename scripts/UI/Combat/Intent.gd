extends Control

var enemy: Enemy

@export var icon: PackedScene

@export_group("Icons")

@export_subgroup("Intents")
@export var passive_icon: Texture2D
@export var attack_icon: Texture2D
@export var no_intents_icon: Texture2D

@export_subgroup("Effects")
@export var poison_icon: Texture2D

func update(_enemy: Enemy):
	enemy = _enemy
	
	load_intent()
	load_effects()


func get_intent_texture():
	if enemy.can_enemy_attack and enemy.does_attack:
		return attack_icon
	else:
		if len(enemy.passives) > 0:
			return passive_icon
		else:
			return no_intents_icon

func get_effect_texture(effect: Effects.TYPE):
	if effect == Effects.TYPE.POISON:
		return poison_icon

func load_intent():
	var intent = icon.instantiate()
	get_child(0).add_child(intent)
	
	intent.texture = get_intent_texture()

func load_effects():
	for i in range(len(enemy.effects)):
		var effect = icon.instantiate()
		get_child(0).add_child(effect)
		
		effect.texture = get_effect_texture(enemy.effects[i])
		effect.get_child(0).text = str(enemy.effect_quantity[i])
