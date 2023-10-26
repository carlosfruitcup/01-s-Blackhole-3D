extends TextureRect

func _process(delta):
	$Label.text = str(get_parent().get_node("Level").level)
	$Label2.text = str(get_parent().get_node("Level").xp)+"/"+str(get_parent().get_node("Level").req_xp)
	
	$TextureProgress.max_value = get_parent().get_node("Level").req_xp
	$TextureProgress.value = get_parent().get_node("Level").xp
	
	Global.check_levels()
