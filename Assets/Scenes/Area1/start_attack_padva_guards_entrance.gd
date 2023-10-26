extends Area




func _on_Area_body_entered(body):
	if body.is_in_group("Player") and get_parent().combat == false:
		if Global.equipped_item == null:
			get_tree().call_group("Enemy","hurt",0)
			queue_free()


func _on_Area2_body_entered(body):
	if body.is_in_group("Player") and get_parent().combat == false:
		if get_tree().get_nodes_in_group("Enemy").size() >= 1:
			if Global.equipped_item != null:
				get_tree().call_group("Enemy","hurt",0,false,0)
				get_parent().get_node("Padva_Guard").target = body
				get_parent().get_node("Padva_Guard").state = get_parent().get_node("Padva_Guard").ANGRY
				queue_free()
