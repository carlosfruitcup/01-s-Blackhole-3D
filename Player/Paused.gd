extends ColorRect

var paused = false

func _ready():
	add_to_group("pause")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if paused:
			pause(false)
		else:
			pause(true)
	
	if Global.canMove == false:
		if paused == true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if paused == false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	visible = paused
	get_tree().paused = paused


func pause(_pause:bool,_ui = true):
	paused = _pause
	
	get_node("BTTS").visible = _ui
	get_node("Settings").visible = _ui
	get_node("Controls").visible = _ui
