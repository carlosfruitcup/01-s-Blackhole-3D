extends Sprite3D

export var speed = 0.001

func _process(delta):
	rotation.z += speed
