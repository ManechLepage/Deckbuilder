extends Control

@onready var label = $Label

func set_health(amount: int):
	label.text = str(amount)
