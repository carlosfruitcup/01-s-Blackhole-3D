extends Spatial


func _on_Area_body_entered(body):
	if body.is_in_group("Player") and get_parent().get_parent().cutscene_amt_trigger < 2:
		
		get_parent().get_parent().cutscene_amt_trigger += 2
		
		queue_free()
	elif body.is_in_group("Player") and get_parent().get_parent().cutscene_amt_trigger < 1:
		get_tree().call_group("world","start_dialog","default")
