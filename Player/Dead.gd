extends ColorRect

var started_time = false

func _process(delta):
	if get_parent().get_parent().get_parent().health <= 0:
		visible = true
	
		
		
		if !started_time:
			$Timer.start()
			Global.died += 1
			started_time = true
	else:
		visible = false	


func _on_Timer_timeout():
	get_parent().get_node("TextureRect/AnimationPlayer").play("play")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "play" and get_parent().get_parent().get_parent().health <= 0:
		get_tree().reload_current_scene()
