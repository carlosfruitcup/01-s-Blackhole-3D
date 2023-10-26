extends KinematicBody

enum {
	IDLE,
	ALERT,
	ANGRY
}

var state = IDLE

var target = null

const TURN_SPEED = 10
var targetPos
var direction


export var inCombat = false
export var Health = 100
export var defHealth = 100
export var defense = 4
export var give_xp_amt = [11,15]
export var give_dinero_amt = [15,20]
export var can_be_stunned = true
export var freeroam = false
export var type = "shooter"
export var shooter_side = "right"
export var can_be_alerted = true
export var can_go_into_cover = true
export var has_3d_anims = false
export var angered_alert = false
var current_attack = 1
onready var NavAgent = get_node("Enemy/NavigationAgent")
onready var raycast = get_node("Enemy/RayCast")
onready var eyes = get_node("Eyes")
onready var Atk_Timer = get_node("Enemy/Attack")
onready var Stop_Timer = get_node("Enemy/StopLooking")
onready var HP = get_node("Viewport/CanvasLayer/Control/HP_bar")
onready var np_move_time = get_node("Enemy/Move_no_plyr")
onready var anim = get_node("Enemy/Model/AnimationPlayer")
var isStunned = false
var canAttack = true



func _ready():
	#NavAgent.connect("velocity_computed", self, "_on_velocity_computed")
	add_to_group("Enemy")
	add_to_group("Angerable")
	
#	if has_3d_anims:
#		anim = get_node("Enemy/Model/AnimationPlayer")
#	else:
#		anim = AnimationPlayer.new()
	
	#HP = get_node("Viewport/CanvasLayer/Control/HP_bar")

var dead = false
var changed_speed = false
var held_speed = 10
var check = 0
func _process(delta):
	
	
	#NavAgent.max_speed = 10
	
	if isStunned == true and changed_speed == false:
		held_speed = NavAgent.max_speed
		NavAgent.max_speed = 0
		changed_speed = true
	elif isStunned == false and changed_speed == true:
		NavAgent.max_speed = held_speed
		held_speed = 0
		changed_speed = false
	
	
	match state:
		IDLE:
			if raycast.is_colliding():
				var body = raycast.get_collider()
				
				if body.is_in_group("Enemy") && body.state == ANGRY:
					target = body.target
					state = ANGRY
			
			if check == 0:
				$Enemy/Sight.monitoring = false
				check += 0.5
			
			if check == 5:
				$Enemy/Sight.monitoring = true
				check = 0
			
			if has_3d_anims:
				if anim.current_animation != "Idle":
					anim.play("Idle",0.2,rand_range(0.75,1))
		
		ALERT:
			if can_be_alerted == true:
				if target != null:
					eyes.look_at(target.global_transform.origin,Vector3.UP)
					rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
				else:
					rotate_y(0.5 * TURN_SPEED)
			else:
				state = IDLE
		ANGRY:
			
			
			
			HP.max_value = defHealth
			HP.value = Health
			
			if target != null:
#				eyes.look_at(target.global_transform.origin,Vector3.UP)
				#raycast.global_rotation.x = eyes.global_rotation.x
				
				if has_3d_anims:
					if anim.current_animation == "Idle":
						anim.stop()
				get_tree().call_group("world", "set_combat", true)
				
				Stop_Timer.stop()
				
				if has_3d_anims:
					if anim.current_animation != "walking" and type != "shooter":
						anim.play("walking")
				
				if type == "mshooter" and !has_3d_anims:
					attack()
				
				if type == "shooter" || type == "mshooter":
					var dist = global_transform.origin.distance_to(target.global_transform.origin)
					
					#note! if type is mshooter, can go into cover will bug the fuck out of the anims
					#better to disable it.
					if can_go_into_cover == true:
						if dist >= 15:
							match shooter_side:
								"right":
									rotation.y = 95
									#anim.play("shoot_cover")
								"left":
									rotation.y = -5
									#anim.play("shoot_cover_l")
						
						if has_3d_anims:
							if anim.current_animation == "":
								#print(global_transform.origin.distance_to(target.global_transform.origin))
								if dist >= 15:
									match shooter_side:
										"right":
											rotation.y = 95
											anim.play("shoot_cover")
										"left":
											rotation.y = -5
											anim.play("shoot_cover_l")
								if dist <= 15:
									anim.play("Shooting")
					else:
						if has_3d_anims:
							anim.play("Shooting")
						
					if target != null: #not sure why i need to write the statement like this, if target == null and else for some reason act like they're flipped
						eyes.look_at(target.global_transform.origin,Vector3.UP)
						rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
						
						#print(eyes.rotation.y)
						
						if can_go_into_cover == true:
							if is_instance_valid(get_node("../RayCast")):
								get_node("../RayCast").look_at(target.global_transform.origin,Vector3.UP)
								
								raycast = get_node("../RayCast")
						
				
						
				
				if raycast.is_colliding():
					
					var body = raycast.get_collider()
					#print(body)
					
					if body.name == "Arrow":
						raycast.add_exception(body)
					
					if body.name == "Player":
						target = body
						
						
				
			else:
				rotate_y(0.01 * TURN_SPEED)
				
				if Stop_Timer.time_left <= 0:
					Stop_Timer.start(5)
				
				if raycast.is_colliding():
					var body = raycast.get_collider()
					
					#print(body)
					if body.name == "Player":
						target = body
					
	
	HP.visible = (state == ANGRY)
	
	if inCombat == true && state != ANGRY:
		state = ANGRY
	
	if Health <= 0:
		if dead == false:
			Global.enemy_dead(give_dinero_amt[round(rand_range(0,1))-1],give_xp_amt[round(rand_range(0,1))-1])
			dead = true
		if has_3d_anims:
			#print("a")
			if anim.current_animation != "dead":
				anim.play("dead",0.1,1.0)
		else: #this probaby isnt the greatest idea as it assumes that all characters that dont have anims are 2D sprites
			#but honestly i kinda dont care, if it works it works.
			if is_instance_valid(get_node_or_null("Enemy/Model/Sprite3D")):
				get_node("Enemy/Model/Sprite3D").modulate.a -= 0.08
				#print("kinda dead")
				
				if get_node("Enemy/Model/Sprite3D").modulate.a <= 0:
					queue_free()

func _physics_process(delta):
	if state != ALERT:
		navigation()

func _on_Sight_body_entered(body):
	if body.name == "Player" && state != ANGRY:
		if can_be_alerted == true:
			if angered_alert == false:
				state = ALERT
			else:
				state = ANGRY
			target = body
	
	if body.is_in_group("Enemy") && body.state == ANGRY:
		target = body.target
		state = ANGRY

var miss = false
func attack():
	var body
	if raycast.is_colliding():
		body = raycast.get_collider()
		
		print(body)
	#print("a")
	if canAttack == true:
		match type:
			"shooter":
				if miss == false:
					print("a")
					if body.is_in_group("Player"):
						if has_3d_anims:
							anim.playback_default_blend_time = 0
						body.hurt(15)
						canAttack = true
						
			"mshooter":
				if miss == false:
					if is_instance_valid(body):
						if body.is_in_group("Player"):
							if has_3d_anims:
								anim.playback_default_blend_time = 0
					var b = Global.scenes[0].instance()
					get_parent().add_child(b)
					
					b.global_transform.origin = global_transform.origin
					b.global_transform.origin.y = global_transform.origin.y + 1
					b.global_transform.origin.z = global_transform.origin.z + 1
					b.look_at(raycast.get_collision_point(), Vector3.UP)
					b.shoot = true
					Atk_Timer.start(rand_range(0.2,0.8))
					canAttack = false
					#print("aaa")
		
		
		


func get_random_pos_in_sphere (radius : float) -> Vector3:
	#should probabl
	var x1 = rand_range (-1, 1)
	var x2 = rand_range (-1, 1)

	while x1*x1 + x2*x2 >= 1:
		x1 = rand_range(-1, 1)
		x2 = rand_range(-1, 1)

	var random_pos_on_unit_sphere = Vector3 (
	2 * x1 * sqrt(1 - x1*x1 - x2*x2),
	2 * x2 * sqrt(1 - x1*x1 - x2*x2),
	1 - 2 * (x1*x1 + x2*x2))

	return random_pos_on_unit_sphere * rand_range (0, radius)


func _on_Sight_body_exited(body):
	if state != ANGRY && body.name == "Player":
		state = IDLE

var played_def_break = false
var scene = preload("res://Assets/misc/dmg_label.tscn")
func hurt(_dmg:float,_stun:bool,_stun_time:float,_def:float):
	
	if defense > 1:
		defense -= _def
	if defense <= 1:
		defense = 1
		
		if !played_def_break:
			$Enemy/DefBreak.play()
			played_def_break = true
	
	if (_dmg / defense) > 0:
		Health -= _dmg / defense
	
	inCombat = true
	
	$Enemy/Damage.playing = false
	$Enemy/Damage.playing = true
	
	var dmglabel = scene.instance()
	add_child(dmglabel)
	dmglabel.transform.origin = transform.origin
	dmglabel.dmg = round(_dmg / defense)
	remove_child(dmglabel)
	get_parent().add_child(dmglabel)
	
	isStunned = _stun
	if _stun == true:
		$StunnedTimer.start(_stun_time)
	
	if state != ANGRY:
		state = ANGRY


func _on_StopLooking_timeout():
	if target == null:
		state = IDLE


func _on_Attack_timeout():
	canAttack = true

var velocity = Vector3()

var is_moving = false
func navigation():
	if NavAgent.is_navigation_finished():
		return
	
	if NavAgent.is_target_reachable() == false && target == null:
		if freeroam == true:
			NavAgent.set_target_location(get_random_pos_in_sphere(60))
	elif NavAgent.is_target_reachable() == false && target != null:
		print("Can't reach player!")
	
	
	if target == null && state == ANGRY:
		NavAgent.set_target_location(transform.origin)
	
#	if target != null or freeroam == true:
#		rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
	
	if type != "shooter":
		if target != null || target == null and freeroam == true:
			targetPos = NavAgent.get_next_location()
			direction = global_transform.origin.direction_to(targetPos)
			
			
			
			velocity = direction * NavAgent.max_speed
			NavAgent.set_velocity(velocity)
			
			move_and_slide(velocity, Vector3.UP)
			
			eyes.look_at(targetPos, Vector3.UP)

func _on_NavigationAgent_velocity_computed(safe_velocity):
	#print("aa")
	
	move_and_slide(safe_velocity, Vector3.UP)


func _on_Move_timeout():
	#print('a')
	if target != null && state == ANGRY:
		NavAgent.set_target_location(target.global_transform.origin)
		#print('a')

func _on_Move_no_plyr_timeout():
	if target == null && state != ALERT || state != ANGRY:
		if freeroam == true:
			var move_to = get_random_pos_in_sphere(60)
			
			NavAgent.set_target_location(move_to)
			
			np_move_time.start(rand_range(3,10))

func _on_Alert_body_entered(body):
	if state == ANGRY:
		if body.is_in_group("Enemy") && body.state != ANGRY:
			body.target = target
			body.state = ANGRY

func _on_StunnedTimer_timeout():
	isStunned = false

func look_at_location(location):
	eyes.look_at(location,Vector3.UP)
	rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
	


func _on_Update_Sights_timeout():
	if $Enemy/Sight.monitorable == true:
		$Enemy/Sight.monitorable = false
		$Enemy/Sight.monitoring = false
	else:
		$Enemy/Sight.monitorable = true
		$Enemy/Sight.monitoring = true
