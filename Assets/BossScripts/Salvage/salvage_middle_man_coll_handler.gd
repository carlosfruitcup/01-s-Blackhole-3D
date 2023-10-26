extends KinematicBody

func _ready():
	add_to_group("Enemy")

func hurt(_dmg:float,_stun:bool,_stun_time:float,_def):
	get_parent().hurt(_dmg,_stun,_stun_time)
