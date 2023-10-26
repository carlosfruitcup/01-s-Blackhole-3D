extends Spatial

var dmg = 0
onready var label = $Label3D

func _ready():
	global_transform.origin.x += rand_range(-1,1)
	label

func _process(delta):
	global_transform.origin.y -= 0.05
	
	if (get_tree().get_nodes_in_group("dmg_label").size() - 1) >= 15:
		queue_free()
	
	if dmg >= 1:
		label.text = str(dmg)
	
	if dmg <= 0:
		label.text = 'MISS!'


func _on_Timer_timeout():
	queue_free()
