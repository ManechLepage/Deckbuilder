extends Node

@export var testing_deck: Array[Card]

@onready var deck_count = $"../../CanvasLayer/DrawPile/DeckCount"
@onready var discard_count = $"../../CanvasLayer/Discard/DiscardCount"
@onready var hand_preview = $"../../CanvasLayer/Hand"
@onready var card_actions = %CardActions
@onready var selection_manager = %SelectionManager

const card_scene = preload("res://scenes/card.tscn")
var discard_pile: Array[Card]
var draw_pile: Array[Card]
var hand: Array[Card]

var new_hand_cards: Array[Card]
var new_discarded_cards: Array[Card]

func draw(value: int):
	for i in range(value):
		if len(draw_pile) == 0:
			draw_pile = discard_pile.duplicate()
			discard_pile.clear()
			draw_pile.shuffle()
		
		var card: Card = draw_pile[0]
		draw_pile.remove_at(0)
		hand.append(card)
		new_hand_cards.append(card)
	update_visuals()

func discard(card: Card):
	hand.erase(card)
	discard_pile.append(card)
	new_discarded_cards.append(card)
	update_visuals()

func discard_hand():
	discard_pile.append_array(hand)
	new_discarded_cards.append_array(hand)
	hand.clear()
	update_visuals()

func play_card(card: CardDisplay):
	get_card_action(card.card).play(card)
	for _card in hand:
		if _card == card.card:
			hand.erase(card.card)
			discard_pile.append(card.card)
			new_discarded_cards.append(card.card)
			break
	update_visuals()

func get_card_action(card: Card):
	for action in card_actions.get_children():
			if action.card_name == card.name:
				return action
	return null

func start_combat():
	draw_pile.clear()
	hand.clear()
	discard_pile.clear()
	
	for card: Card in testing_deck:
		draw_pile.append(card.duplicate(true))
	draw_pile.shuffle()
	update_visuals()

func update_visuals():
	deck_count.text = str(len(draw_pile))
	discard_count.text = str(len(discard_pile))
	
	for card in new_hand_cards:
		await create_card(card)
	for card in new_discarded_cards:
		for _card in hand_preview.get_children():
			if _card:
				if card == _card.card:
					_card.discard()
					await _card.finished_discard
					_card.queue_free()
	
	new_discarded_cards.clear()
	new_hand_cards.clear()

func create_card(card: Card):
	var card_ctrl: CardDisplay = card_scene.instantiate()
	hand_preview.add_child(card_ctrl)
	card_ctrl.display_card(card)
	card_ctrl.draw()
	await card_ctrl.finished_draw
	card_ctrl.can_be_focused = true
	
	card_ctrl.mouse_entered.connect(selection_manager._on_hand_mouse_entered)
	card_ctrl.mouse_exited.connect(selection_manager._on_hand_mouse_exited)

func visualize_card(card_ctrl: CardDisplay):
	card_ctrl.play()
	play_card(card_ctrl)
