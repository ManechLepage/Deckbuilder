class_name CardDisplay
extends Control

@onready var background = $Case/Background
@onready var description_box = $Case/DescriptionBox
@onready var name_label = $Case/DescriptionBox/Name
@onready var description = $Case/DescriptionBox/Description
@onready var energy_cost = $Case/EnergyCost
@onready var health = $Case/Health
@onready var health_label = $Case/Health/HealthLabel

const cover: Texture2D = preload("res://graphics/cards/cover.aseprite")

var card: Card
var focused: bool
var initial_position: Vector2
var can_be_focused: bool = false
var is_being_played: bool = false

signal finished_playing
signal finished_draw
signal finished_discard
signal removed

func _ready():
	scale = Vector2(0.0, 0.0)

func display_card(_card: Card):
	card = _card
	background.texture = card.sprite
	name_label.text = card.name
	description.text = Description.enrich(card.description)
	energy_cost.text = str(card.cost)
	adjust_font_size()
	initial_position = Vector2.ZERO
	removed.connect(get_tree().get_first_node_in_group("SelectionManager").finished_remove)
	
	if card is Building:
		health.visible = true
		health_label.text = str(card.health)

func adjust_font_size(): 
	var goal_size: int = 67
	var font_size: int = 9
	while description.get_rect().size.y > goal_size:
		font_size -= 1
		add_theme_font_size_override(card.name, font_size)

func _on_mouse_entered():
	if can_be_focused:
		get_tree().get_first_node_in_group("SelectionManager").focus_card(self)

func focus():
	focused = true
	var position_tween = get_tree().create_tween()
	var scale_tween = get_tree().create_tween()
	position_tween.tween_property(self, "position", Vector2(position.x, -150), 0.07)
	scale_tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.07)
	z_index = 101

func unfocus():
	var position_tween = get_tree().create_tween()
	var scale_tween = get_tree().create_tween()
	z_index = 100
	if focused:
		position_tween.tween_property(self, "position", Vector2(position.x, 0), 0.07)
	focused = false
	scale_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.07)

func _on_mouse_exited():
	if can_be_focused:
		unfocus()

func play():
	is_being_played = true
	can_be_focused = false
	var position_tween_x = get_tree().create_tween()
	var position_tween_y = get_tree().create_tween()
	var scale_tween = get_tree().create_tween()
	
	reparent(get_tree().get_first_node_in_group("Canvas"))
	
	position_tween_x.tween_property(self, "position:x", 15, 0.12).set_delay(0.3)
	position_tween_y.tween_property(self, "position:y", 180, 0.12).set_delay(0.3)
	scale_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.07)
	await position_tween_x.finished
	is_being_played = false
	finished_playing.emit()

func remove_from_play():
	if is_being_played:
		await finished_playing
	var position_tween_y = get_tree().create_tween()
	var scale_tween = get_tree().create_tween()
	position_tween_y.tween_property(self, "position:y", 420, 0.2).set_delay(1.0).set_trans(Tween.TRANS_BOUNCE)
	scale_tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.2).set_delay(1.0)
	await position_tween_y.finished
	removed.emit()
	queue_free()

func draw():
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.01)
	scale_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.15).timeout
	finished_draw.emit()

func discard():
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.3).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.15).timeout
	finished_discard.emit()
