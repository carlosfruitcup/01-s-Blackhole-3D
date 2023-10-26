extends Area




func _on_Area_body_entered(body):
	if get_parent().combat == true || get_tree().get_nodes_in_group("Enemy").size() <= 0:
		queue_free()
	
	if body.is_in_group("Player") and get_parent().combat == false:
		if Global.equipped_item == null:
			get_tree().call_group("world","start_dialog","padva_guards")
			queue_free()
		else:
			get_tree().call_group("world","start_dialog","weapon_pg")
		get_tree().call_group("Enemy","look_at_location",body.global_transform.origin)
