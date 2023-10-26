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
			
