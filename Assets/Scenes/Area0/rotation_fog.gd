extends CSGSphere

func _process(delta):
	rotate_y(0.002)
	set_as_toplevel(true)
	
	global_transform.origin = get_parent().global_transform.origin
