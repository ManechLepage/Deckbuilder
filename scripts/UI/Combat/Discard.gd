extends Control

@onready var canvas_layer = %CanvasLayer
@onready var cards = %Cards
const card_menu = preload("res://scenes/UI/card_menu.tscn")

func _on_texture_rect_gui_input(event):
	if Input.is_action_just_pressed("left_click"):
		var menu = card_menu.instantiate()
		canvas_layer.add_child(menu)
		menu.load_menu(cards.discard_pile)
