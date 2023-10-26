extends Node


onready var stamina = get_parent().stamina
onready var max_stamina = get_parent().max_stamina

func _on_Timer_timeout():
	get_parent().stamina = get_parent().stamina + round(rand_range(5,15))
	#print(get_parent().stamina)
	get_tree().call_group("Stamina","update_value",get_parent().stamina ,get_parent().max_stamina,false)
