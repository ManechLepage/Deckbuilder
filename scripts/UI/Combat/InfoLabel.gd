extends Label

@onready var selection_manager = %SelectionManager

func changed_action_type() -> void:
	if selection_manager.current_selection_type == selection_manager.WaitingSelection.Token:
		text = "Select a token"
	elif selection_manager.current_selection_type == selection_manager.WaitingSelection.Tile:
		text = "Select a tile"
	else:
		text = ""
