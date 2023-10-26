extends Spatial

export var isVisible = 0

func _ready():
	set_visible(isVisible)

func _on_Area_body_entered(body):
	if body.is_in_group("Player") and visible == true:
		get_parent().start_dialog("save")

func set_visible(_bool = false):
	_bool = int(_bool)
	
	visible = _bool
	
	
