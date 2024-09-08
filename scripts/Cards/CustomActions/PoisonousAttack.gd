extends CardAction

func play(card: CardDisplay):
	var token: Token = await parent.select_any_token()
	parent.extra_damage_type(token, DamageType.TYPE.POISON)
	await parent.selected
	parent.resolve(card)
