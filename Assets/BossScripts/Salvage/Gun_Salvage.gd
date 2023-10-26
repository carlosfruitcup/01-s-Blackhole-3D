extends Spatial

onready var anim = $AnimationPlayer
onready var scene = preload("res://Assets/BossScripts/Salvage/sal_Bullet.tscn")
export var loc = "left"

func _ready():
	anim.stop()
	set_visible(false)

func play_anim():
	anim.play("fire")

func stop_anim():
	anim.play("RESET")

func set_visible(_bool):
	visible = _bool

func play_sound():
	$AudioStreamPlayer3D.play()

func create_bullet():
	var b = scene.instance()
	
	add_child(b)
	
	b.global_translation = $Model/Position3D.global_translation
	
	b.dir = loc
	remove_child(b)
	get_parent().add_child(b)
