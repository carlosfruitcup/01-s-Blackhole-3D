extends RigidBody

var shoot = false

const DAMAGE = 15
const SPEED = 25

onready var timer = get_node("Timer")
onready var sound = get_node("AudioStreamPlayer3D")

func _ready():
	set_as_toplevel(true)
	
func _physics_process(delta):
	if shoot:	
		apply_impulse(global_transform.basis.z, -global_transform.basis.z * SPEED) 
		#apply_impulse(global_transform.basis.y, -Vector3(0,0,0.0001)) 
		#global_transform.origin.x -= rand_range(-0.2,0.2)


func _on_Area_body_entered(body):
	print(body)
	if body.is_in_group("Player"):
		body.hurt(DAMAGE)
		sound.play()
		mode = RigidBody.MODE_STATIC
		visible = false
		timer.start(1)
		
		get_node("Area").set_deferred("monitoring",false)
	elif !body.is_in_group("Enemy") && !body.is_in_group("Player") && !body.name != "Arrow":
		sound.play()
		#mode = RigidBody.MODE_STATIC
		visible = false
		#timer.start(4)
		
		get_node("Area").set_deferred("monitoring",false)
		
	


func _on_Timer_timeout():
	queue_free()

