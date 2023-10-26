extends KinematicBody

var dir = "left"

func _ready():
	set_as_toplevel(true)

func _process(delta):
	match dir:
		"left":
			global_transform.origin.z += 2
		"right":
			global_transform.origin.z -= 2
		"top":
			global_transform.origin.x += 2


func _on_Timer_timeout():
	queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt(15)
		queue_free()
