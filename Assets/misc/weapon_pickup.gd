extends Spatial

export var pickup = "Long Dagger"
export var begins_dialogue = false
export var dialogue = "default"

func _process(delta):
	if pickup in Global.inventory:
		if begins_dialogue:
			get_parent().start_dialog(dialogue)
		queue_free()

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		Global.inventory.append(pickup)
		if Global.equipped_item != null:
			body.get_node("CanvasLayer/Control/Inventory").use(Global.equipped_item)
		body.get_node("CanvasLayer/Control/Inventory").create_physical_item(pickup)
		queue_free()
		
		if begins_dialogue:
			get_parent().start_dialog(dialogue)
