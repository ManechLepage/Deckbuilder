extends Button

signal attacked

@onready var selection_manager = %SelectionManager

func _on_pressed():
	attacked.emit()
	visible = false

func attack():
	visible = true
	text = get_string()

func disable():
	visible = false

func get_string():
	if selection_manager.current_tile_selection_type == selection_manager.TileSelectionType.Attack:
		return "Attack"
	else:
		return "Build"
