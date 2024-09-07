extends Control

@onready var texture_rect = $Bar/TextureRect
@onready var label = $Label
@onready var v_box_container = $Bar/VBoxContainer

func set_value(value: int, max: int):
	label.text = str(value) + "/" + str(max)
	
	if value < 4:
		for i in v_box_container.get_children():
			i.visible = false
		for i in range(value):
			v_box_container.get_child(i).visible = true
