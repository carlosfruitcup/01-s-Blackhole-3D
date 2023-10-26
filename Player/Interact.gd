extends RayCast

onready var UI = get_parent().get_parent().get_parent().get_node("CanvasLayer/Control/Interact")

func _process(delta):
	if is_colliding():
		if !Global.canMove:
			UI.visible = true
			
			var body = get_collider()
			#print(body.is_in_group("iSign"))
			if body.is_in_group("iSign"):
				UI.text = "E - Read"
				
				if Input.is_action_just_pressed("Interact"):
					body.play_dialog()
			
			if body.is_in_group("iDialogue"):
				UI.text = "E - Interact"
				
				if Input.is_action_just_pressed("Interact"):
					body.play_dialog()
			
			if body.is_in_group("iRoom"):
				UI.text = "E - Enter"
				
				if Input.is_action_just_pressed("Interact"):
					body.move_to(get_parent().get_parent().get_parent())
			
		else:
			UI.visible = false
	else:
		UI.visible = false
