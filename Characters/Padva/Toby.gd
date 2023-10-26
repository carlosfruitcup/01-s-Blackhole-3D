extends Spatial


func play():
	$Model/AnimationPlayer.play("come")

func _on_AnimationPlayer_animation_finished(anim_name):
	$Model/AnimationPlayer.play("RESET")

func theroar():
	get_parent().get_node("Player").global_rotation = Vector3(0,180,0)
	self.queue_free()
