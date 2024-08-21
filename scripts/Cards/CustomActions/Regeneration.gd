extends CardAction

func play(card: CardDisplay):
	for i in range(5):
		parent.heal_token(parent.get_random_token(), 1)
	parent.resolve(card)
