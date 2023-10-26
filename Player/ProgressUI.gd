extends TextureProgress


func update_value(val, max_val):
	#print(name + str(val) + str(max_val))
	value = val
	max_value = max_val
	
	if name == "Stamina":
		get_parent().get_parent().get_parent().get_node("Stamina/Timer").start(5)

func play_anim():
	if is_instance_valid(get_node_or_null("AnimationPlayer")):
		get_node_or_null("AnimationPlayer").play("RESET")
		get_node_or_null("AnimationPlayer").play("play")

func update_label(thing,thing2,thing3,thing4,thing5,thing6 = 0):
	if is_instance_valid(get_node_or_null("Label")):
		get_node_or_null("Label").text = "Level: "+str(thing)+"| XP: "+str(thing2)+"/"+str(thing3)
		
		if thing5 != 0 and thing4 != 0:
			get_node_or_null("Label2").text = "Gained " + str(thing4) +" Dolares!" + "\nGained " + str(thing5) + " XP!"
			
			if thing6 > 0:
				get_node_or_null("Label2").text = "Gained " + str(thing4) +" Dolares!" + "\nGained " + str(thing5) + " XP!" + "\nGained " + str(thing6) + " Skill points!"
			
