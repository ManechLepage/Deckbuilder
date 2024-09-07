extends TextureRect

@onready var selection_manager = %SelectionManager

@export var sprites: Array[Texture2D]

func changed_action_type() -> void:
	if selection_manager.current_selection_type == selection_manager.WaitingSelection.Token:
		texture = sprites[1]
	elif selection_manager.current_selection_type == selection_manager.WaitingSelection.Tile:
		texture = sprites[0]
	else:
		texture = null
