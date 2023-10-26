extends Spatial


func _ready():
	pass


func _on_VisibilityEnabler_camera_entered(camera):
	print("Shown "+str(get_child_count())+" nodes")
	for c in get_children():
		c.visible = true

func _on_VisibilityEnabler_camera_exited(camera):
	print("Hidden "+str(get_child_count())+" nodes")
	for c in get_children():
		c.visible = false
