extends Label

@onready var combat_manager = %CombatManager

func update_label():
	if combat_manager.current_combat_phase == combat_manager.CombatPhase.RollPlacements:
		text = "Rolling..."
	elif combat_manager.current_combat_phase == combat_manager.CombatPhase.PlayerTurn:
		text = "Player's turn"
	else:
		text = "Enemy's turn"
