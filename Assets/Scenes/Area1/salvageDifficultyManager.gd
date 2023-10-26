extends Node


func _ready():
	yield(get_tree(),"idle_frame")
	if Global.died >= 5:
		$AudioStreamPlayer.play()
		get_parent().get_node("Salvage").Health = 500
		get_parent().get_node("Salvage/AnimationPlayer").playback_speed = 0.75
