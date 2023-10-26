extends Spatial


func _ready():
	visible = false


func _on_VisibilityNotifier_camera_entered(camera):
	visible = true

func _on_VisibilityNotifier_camera_exited(camera):
	visible = false
