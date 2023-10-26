extends Spatial


func play_anim(_name):
	$Model/AnimationPlayer.play(_name)

func _on_AnimationPlayer_animation_finished(anim_name):
	$Model/AnimationPlayer.play("RESET")
