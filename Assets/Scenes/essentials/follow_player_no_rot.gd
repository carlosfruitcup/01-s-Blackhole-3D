extends CSGMesh


func _ready():
	set_as_toplevel(true)

func _process(delta):
	global_transform.origin.x = get_parent().global_transform.origin.x
	global_transform.origin.z = get_parent().global_transform.origin.z
