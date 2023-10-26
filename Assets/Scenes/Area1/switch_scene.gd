extends Area

export var scene = "res://Assets/Scenes/Area1/padva_entrance.tscn"

func _ready():
	pass


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene(scene)
