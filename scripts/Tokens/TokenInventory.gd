extends Node

@export var tokens: Array[Token]
var combat_tokens: Array[Token]

func _on_placing_tokens():
	combat_tokens.clear()
	for token in tokens:
		combat_tokens.append(token.duplicate(true))

func get_combat_token_at_position(position: Vector2i):
	for token in combat_tokens:
		if position == token.position:
			return token
	return null

func print_combat_token_positions():
	for token in combat_tokens:
		print(token.position)
