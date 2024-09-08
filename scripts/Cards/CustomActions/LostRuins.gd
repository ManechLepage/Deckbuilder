extends CardAction

@export var damage: Damage

func play(card: CardDisplay):
	current_card = card.card
	var selected_tile: Vector2i = await parent.select_open_tile()
	parent.place_building(card.card, selected_tile)
	parent.resolve(card)
	update()

func lost_poison_effect(enemy: Enemy) -> void:
	parent.direct_damage(damage, enemy)
