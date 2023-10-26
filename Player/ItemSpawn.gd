extends Position3D

onready var sprite = get_node("sprite")

func _ready():
	sprite.queue_free()

func add_item(scene):
	var s = load(scene)
	var item = s.instance()
	
	add_child(item)
