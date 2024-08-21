extends CardAction

func play(card: CardDisplay):
	var selected_tile: Vector2i = parent.get_random_open_space()
	parent.place_building(card.card, selected_tile)
	parent.resolve(card)

func on_start_of_player_turn():
	parent.add_essence(1)
