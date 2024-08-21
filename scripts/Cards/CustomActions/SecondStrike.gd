extends CardAction

func play(card: CardDisplay):
	var token: Token = await parent.select_token_that_already_attacked()
	parent.attack_with_extra_damage(token, 2)
	await parent.selected
	parent.resolve(card)

func can_play():
	return parent.has_token_already_attacked()
