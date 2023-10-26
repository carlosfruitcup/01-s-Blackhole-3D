extends Node

export(NodePath) var boss_path #NOTE MUST BE EXACTLY THE SAME NAME
var boss

func _ready():
	boss = get_node(boss_path)

func _process(delta):
	if is_instance_valid(boss):
		if boss.name in Global.bosses_defeated:
			boss.Health = 0
			boss.fight_started = true
			boss.fight_ended = true
			
			get_parent().get_node("Walkway").global_transform.origin = Vector3(0,0,0)
			
			if !"Long Dagger" in Global.inventory:
				get_parent().get_node("LongDaggerPickup").begins_dialogue = false
				Global.inventory.append("Long Dagger")
				Global.equipped_item = "Long Dagger"
				print("aa")


