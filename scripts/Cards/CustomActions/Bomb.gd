extends CardAction

func play(card: CardDisplay):
	current_card = card.card
	var selected_tile: Vector2i = await parent.select_open_tile()
	parent.place_building(card.card, selected_tile)
	parent.resolve(card)

func on_death():
	var damage: Damage = Damage.new()
	damage.type = DamageType.Type.Explosion
	damage.value = 5
	parent.explode(1, damage, current_card.position)
