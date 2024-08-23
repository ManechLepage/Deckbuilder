class_name CardAction
extends Node

var parent: CardActions
var current_card: Card
var position: Vector2i

@export var card_name: StringName

func _ready():
	parent = get_parent()

func play(card: CardDisplay):
	pass

func can_play():
	return true

func on_death():
	pass

func on_start_of_player_turn():
	pass

func update():
	pass

func ability():
	pass
