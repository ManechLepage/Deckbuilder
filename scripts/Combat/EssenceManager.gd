class_name EssenceManager
extends Node

var essence: int
var max: int
@onready var energy_bar = %EnergyBar

func add_essence(value: int):
	essence += value
	if essence > max:
		max = essence
	update()

func replenish():
	max = 3
	essence = 3
	update()

func can_play(value: int):
	if value > essence:
		return false
	return true

func update():
	energy_bar.set_value(essence, max)

func _unhandled_input(event):
	if Input.is_action_just_pressed("Test2"):
		add_essence(1)
