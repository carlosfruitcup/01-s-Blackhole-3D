extends CSGMesh

onready var mat = mesh.material

func _process(delta):
	mat.uv1_offset.x += 0.005
	mat.uv1_offset.z += 0.005
