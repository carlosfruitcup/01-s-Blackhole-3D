extends Button


func _ready():
	pass


func _on_Play_mouse_entered():
	$AudioStreamPlayer.play()


func _on_Play_pressed():
	if Global.room == null:
		get_tree().change_scene("res://Assets/Scenes/Area0/beginning_area_room.tscn")
	else:
		match Global.room:
			"beginning":
				get_tree().change_scene("res://Assets/Scenes/Area1/beginning.tscn")
			"padva_city":
				get_tree().change_scene("res://Assets/Scenes/Area1/padva_city.tscn")
