extends CardAction

func play(card: CardDisplay):
	var token: Token = await parent.select_any_token()
	parent.basic_attack(token)
	await parent.selected
	parent.resolve(card)
