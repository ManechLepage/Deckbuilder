extends CardAction

var tokens: Array[Token]

func play(card: CardDisplay):
	current_card = card.card
	var selected_tile: Vector2i = await parent.select_open_tile()
	parent.place_building(card.card, selected_tile)
	parent.resolve(card)
	update()

func update():
	tokens = parent.get_neighbouring_tokens(current_card.position)
	for token in tokens:
		if current_card not in token.card_buffs:
			parent.buff_token_damage(token, token.attack.damage.value)
			token.card_buffs.append(current_card)
	
	var debuff = parent.get_tokens_to_debuff(tokens, current_card)
	for token in debuff:
		parent.buff_token_damage(token, -(token.attack.damage.value / 2))
