extends Control

const card = preload("res://scenes/card.tscn")

@onready var grid_container = $Panel/MarginContainer/ScrollContainer/GridContainer

func load_menu(cards: Array[Card]):
	for i in cards:
		var card_ui: CardDisplay = card.instantiate()
		card_ui.can_be_focused = false
		grid_container.add_child(card_ui)
		card_ui.display_card(i)

func _on_button_pressed():
	queue_free()

func _input(event):
	if Input.is_action_just_pressed("Escape"):
		queue_free()
