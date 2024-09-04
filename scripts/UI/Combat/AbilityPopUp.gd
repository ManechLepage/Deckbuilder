extends Control

var building: Building

func load(_building: Building):
	building = _building
	position = get_tree().get_first_node_in_group("TileMap").ground.map_to_local(building.position)

func _on_activate_button_pressed() -> void:
	get_tree().get_first_node_in_group("BuildingManager").activate(building)
	queue_free()

func _on_close_button_pressed() -> void:
	queue_free()
