extends Button

@onready var combat_manager = %CombatManager
@onready var selection_manager = %SelectionManager
@onready var roll_manager = %RollManager


func _on_pressed():
	if text == "Start":
		combat_manager.placing_tokens.emit()
		combat_manager.place()
	elif text == "Roll":
		roll_manager.roll()
	elif text == "Finish Turn":
		combat_manager.finish_player_turn()
		visible = false

func disable():
	visible = false

func roll():
	visible = true
	text = "Roll"

func _on_combat_manager_start_player_turn():
	visible = true
	text = "Finish Turn"
