extends TextureButton

@onready var combat_manager = %CombatManager
@onready var selection_manager = %SelectionManager
@onready var roll_manager = %RollManager

enum STATES {START, ROLL, FINISH_TURN}
var state: STATES = STATES.START

@export var start_sprites: Array[Texture2D]
@export var roll_sprites: Array[Texture2D]
@export var finish_turn_sprites: Array[Texture2D]

func _ready() -> void:
	update()

func _on_pressed():
	if state == STATES.START:
		combat_manager.placing_tokens.emit()
		combat_manager.place()
	elif state == STATES.ROLL:
		roll_manager.roll()
	elif state == STATES.FINISH_TURN:
		combat_manager.finish_player_turn()
		visible = false

func disable():
	visible = false

func roll():
	visible = true
	state = STATES.ROLL
	update()

func _on_combat_manager_start_player_turn():
	visible = true
	state = STATES.FINISH_TURN
	update()

func update():
	if state == STATES.START:
		update_textures(start_sprites)
	elif state == STATES.ROLL:
		update_textures(roll_sprites)
	else:
		update_textures(finish_turn_sprites)
	
func update_textures(textures: Array[Texture2D]):
	texture_normal = textures[0]
	texture_hover = textures[1]
	texture_pressed = textures[2]
