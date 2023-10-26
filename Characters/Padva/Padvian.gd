extends Spatial


func _ready():
	var mat = $Model/HumanoidBase_NotOverlapping.get_active_material(0)
	randomize()
	var rand = str(round(rand_range(1,4)))
	
	mat.albedo_texture = load("res://Assets/Models/MinorCharacters/Padvians/player"+rand+".png")
	
	$Model/AnimationPlayer.play("New Anim (5)")
