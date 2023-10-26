extends Spatial

export var Health = 300
export var XP = 150
export var dinero = 100
export var anim_speed_times = []
var current_attack = 1
onready var anim = get_node("AnimationPlayer")
onready var timer = get_node("switch_attack")
onready var UI = get_node("CanvasLayer")
onready var bossUI = get_node("CanvasLayer/Control/TextureProgress")
var fight_started = false
var can_be_attacked = false
var fight_ended = false
var gave_xp = false
var attack_anims = ["twhomp_r","twhomp_l"]

func _ready():
	get_parent().get_node("Walkway").global_transform.origin = Vector3(0,-100,0)
	UI.visible = false
	bossUI.max_value = Health

func _process(delta):
	$shadow.set_as_toplevel(true)
	$shadow.global_transform.origin.x = global_transform.origin.x
	$shadow.global_transform.origin.z = global_transform.origin.z
	
	$Model/realeyes.look_at(get_parent().get_node("Player").global_transform.origin,Vector3.UP)
	
	$Model/eyes.rotation.y = $Model/realeyes.rotation.y - 300
	bossUI.value = Health
	
	if Health <= 0:
		fight_ended = true
	
	if fight_ended:
		$switch_attack.stop()
		current_attack = null
		get_tree().call_group("gun_l","stop_anim")
		get_tree().call_group("gun","stop_anim")
		get_tree().call_group("gun_r","stop_anim")
		get_tree().call_group("gun_l","set_visible",false)
		get_tree().call_group("gun_r","set_visible",false)
		get_tree().call_group("gun","set_visible",false)
		UI.visible = false
		if !gave_xp:
			Global.add_boss_2_list(name)
			get_parent().start_dialog("salvage_defeat")
			Global.enemy_dead(dinero,XP)
			gave_xp = true
		
		fight_ended = true
	
	if fight_started and timer.time_left <= 0 and !anim.is_playing() and !fight_ended:
		attack()

func play_anim(_name):
	anim.play(_name)

func begin_fignt():
	fight_started = true
	UI.visible = true
	add_to_group("Enemy")

func attack():
	#print("a")
	if fight_started and !fight_ended:
		if current_attack == null:
			current_attack = 1
		else:
			match current_attack:
				1:
					get_tree().call_group("gun_l","stop_anim")
					get_tree().call_group("gun","stop_anim")
					get_tree().call_group("gun_r","stop_anim")
					can_be_attacked = true
					play_anim("twhomp_r")
					get_tree().call_group("gun_l","set_visible",false)
					get_tree().call_group("gun_r","set_visible",false)
					get_tree().call_group("gun","set_visible",false)
				2:
					can_be_attacked = true
					play_anim("twhomp_l")
					get_tree().call_group("gun_l","stop_anim")
					get_tree().call_group("gun","stop_anim")
					get_tree().call_group("gun_r","stop_anim")
					get_tree().call_group("gun_l","set_visible",false)
					get_tree().call_group("gun_r","set_visible",false)
					get_tree().call_group("gun","set_visible",false)
				3:
					get_tree().call_group("gun_r","set_visible",true)
					get_tree().call_group("gun_l","set_visible",false)
					get_tree().call_group("gun_l","stop_anim")
					get_tree().call_group("gun_r","play_sound")
					$play_bullet_anim.start(1)
				4:
					get_tree().call_group("gun_l","set_visible",true)
					get_tree().call_group("gun_r","set_visible",false)
					get_tree().call_group("gun_r","stop_anim")
					get_tree().call_group("gun_l","play_sound")
					$play_bullet_anim.start(1)
			

var scene = preload("res://Assets/misc/dmg_label.tscn")
func hurt(_dmg:float,_stun:bool,_stun_time:float):
	Health -= _dmg
	
	$Hurt.pitch_scale = rand_range(1,1.2)
	$Hurt.playing = false
	$Hurt.playing = true
	$stop_hurt_sou.start()
	var dmglabel = scene.instance()
	add_child(dmglabel)
	dmglabel.transform.origin = transform.origin
	dmglabel.dmg = _dmg
	remove_child(dmglabel)
	get_parent().add_child(dmglabel)

var prevattack = 0
func _on_switch_attack_timeout():
	if fight_started and !fight_ended:
		print("aa")
		if current_attack == null:
			current_attack = 1
			attack()
		
		if current_attack >= 4:
				current_attack = 0
				attack()
		if current_attack < 4:
				current_attack += 1
				attack()

func _on_AnimationPlayer_animation_finished(anim_name):
	if str(anim_name) in attack_anims:
		timer.start(3)
		print("aaa")


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt(50)
		$Area.monitoring = false

func _on_stop_hurt_sou_timeout():
	$Hurt.stop()

func _on_play_bullet_anim_timeout():
	if current_attack == 3:
		get_tree().call_group("gun_r","play_anim")
	elif current_attack == 4:
		get_tree().call_group("gun_l","play_anim")
