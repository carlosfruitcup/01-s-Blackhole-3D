extends Area


func _process(delta):
	if Global.toby_spoken_to == true:
		get_parent().get_node("Toby").queue_free()
		queue_free()



func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		get_parent().start_dialog("toby_speak")
		
		body.global_transform.origin = Vector3(-28.656,2.042,5.741)
		body.look_at(get_parent().get_node("Toby").global_transform.origin,Vector3.UP)
		queue_free()
