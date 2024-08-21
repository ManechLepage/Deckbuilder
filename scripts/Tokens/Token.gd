class_name Token
extends Resource

@export var id: int
@export var name: StringName
@export var sprite: Vector2i
@export var health: int
@export var movement: Movement
@export var attack: Attack

var has_moved: bool
var position: Vector2i
var attacks_this_turn: int

var card_buffs: Array[Card]
