extends CardAction

func play(card: CardDisplay):
	current_card = card.card
	var selected_tile: Vector2i = parent.get_random_open_space()
	parent.place_building(card.card, selected_tile)
	parent.resolve(card)

func ability():
	var token: Token = await parent.select_any_token()
	var tiles = parent.get_neighbouring_tiles(current_card.position)
	var tile = await parent.make_tiles_selectable(tiles)
	parent.teleport_token(token, tile)
