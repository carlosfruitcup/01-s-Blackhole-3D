extends KinematicBody
class_name MovementController


export var gravity_multiplier := 3.0
export var speed := 10
export var acceleration := 8
export var deceleration := 10
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
export var jump_height := 10
var direction := Vector3()
var input_axis := Vector2()
var velocity := Vector3()
var snap := Vector3()
var up_direction := Vector3.UP
var stop_on_slope := true
onready var floor_max_angle: float = deg2rad(75.0)
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)
var can_jump = true
var jump_count = 0
var gravity_enabled = true

export var max_health = 100
export var health = 100

export var max_stamina = 100
export var stamina = 100

var defense = 1
onready var dmged = get_node("CanvasLayer/Control/dmg/AnimationPlayer")

func _ready():
	get_node("CanvasLayer/Control/TextureRect/AnimationPlayer").play("out")
	add_to_group("Player")
	get_tree().call_group("Stamina","update_value",stamina,max_stamina,true)

var set_death = false
func _process(delta):
	#$CanvasLayer/Control/ViewportContainer/Viewport/Camera.global_transform = $Head/Camera.global_transform
	get_tree().call_group("Health","update_value",health,max_health)
	footsteps_sound()
	
	if health <= 0:
		Global.canMove = true
		for c in get_children():
			if !c.is_in_group("donothide"):
				c.visible = false
		
		if set_death == false:
			Global.died += 1
			Global.reset_values()
			Global.load_game()
			set_death = true
	
	if Input.is_key_pressed(82):
		hurt(9999)
		
	
	#print(speed)
	if stamina > max_stamina:
		#print("a")
		stamina = max_stamina
		get_tree().call_group("Stamina","update_value",stamina,max_stamina,false)
	
	#print(stamina)
	if stamina < 0:
		stamina = 0
		get_tree().call_group("Stamina","update_value",stamina,max_stamina,false)

# Called every physics tick. 'delta' is constant
func _physics_process(delta) -> void:
	input_axis = Input.get_vector("move_back", "move_forward",
			"move_left", "move_right")
	
	
	if !Global.canMove:
		check_movement()
		direction_input()
	else:
		is_moving = false
		velocity = Vector3(0,0,0)
	
#	if is_on_wall() && jump_count == 0:
#		jump_count += 1
#		can_jump = true
#
#	if is_on_wall() && !is_on_floor():
#		stamina -= 0.3
#		get_tree().call_group("Stamina","update_value",stamina,max_stamina)
#
#	if stamina <= 15 && is_on_wall():
#		jump_count = 0
#		can_jump = false
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		jump_count = 0
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		if Input.is_action_pressed("jump") && stamina > 0 and !Global.canMove:
			snap = Vector3.ZERO
			velocity.y = jump_height
			
			stamina -= 15
			get_tree().call_group("Stamina","update_value",stamina,max_stamina,true)

			
			can_jump = false
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		#can_jump = true
		
		snap = Vector3.ZERO
		
		if gravity_enabled == true:
			velocity.y -= gravity * delta
	
	accelerate(delta)
	
	if !Global.canMove:
		velocity = move_and_slide_with_snap(velocity, snap, up_direction, 
				stop_on_slope, 4, floor_max_angle)


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if input_axis.x >= 0.5:
		direction -= aim.z
	if input_axis.x <= -0.5:
		direction += aim.z
	if input_axis.y <= -0.5:
		direction -= aim.x
	if input_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()

onready var fs_1 = get_node("fs_1")
onready var fs_2 = get_node("fs_2")
var current_fs = null
var is_moving = false
func check_movement():
	if is_on_floor():
		if (Input.is_action_pressed("move_back") or
		Input.is_action_pressed("move_forward") or
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right")):
			is_moving = true
		else:
			is_moving = false
	else:
		is_moving = false
				

func footsteps_sound():
	if current_fs != null:
		match speed:
			5:
				current_fs.pitch_scale = 0.45
			10:
				current_fs.pitch_scale = 0.75
	
	if is_moving == true:
		if current_fs == null:
			current_fs = fs_1
			return
		else:
			if current_fs.is_playing() == false:
				current_fs.play()
			if current_fs == fs_1 && fs_1.is_playing() == false:
				current_fs = fs_2
			if current_fs == fs_2 && fs_2.is_playing() == false:
				current_fs = fs_1

func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z

func hurt(dmg,stun = null,stun_time = 0.0):
	if dmg is String:
		dmg = float(dmg)
	
	dmged.play("RESET")
	dmged.play("play")
	
	if (dmg / defense) > 0:
		health -= dmg / defense
	
	if health > 0:
		$Hurt.play()
	#print(health)

func play_level_up():
	$level_up.play()

func heal(_amt = null):
	if _amt == null:
		health = Global.maxHealth
	else:
		float(_amt)
		
		health += _amt
	
	$Heal.play()

func fill(_amt = null):
	if _amt == null:
		stamina = Global.maxStamina
	else:
		float(_amt)
		
		stamina += _amt
	
	$Heal2.play()

func play_out():
	$CanvasLayer/Control/TextureRect/AnimationPlayer.play("out")

func play_in():
	$CanvasLayer/Control/TextureRect/AnimationPlayer.play("play")
