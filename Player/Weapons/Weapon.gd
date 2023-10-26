extends Spatial

export var weapon_type = "firearm"
export var weapon_can_block = false
export var weapon_animations = ["swing"]
export var weapon_animation_damage = [15,25]
export var weapon_location = Vector3(0,0,0)
export var weapon_rotation = Vector3(0,0,0)
export var weapon_range = Vector3(0,0,-10)
var weapon_sys_path
var set_pos = true

func _ready():
	add_to_group("weapon")
	
	if weapon_type == "bat":
		scale = Vector3(1,1.25,1)
	
#	if !name in Global.inventory:
#		Global.inventory.append("Long Dagger")

func _process(delta):
	if visible == true:
		if set_pos == true:
			transform.origin = weapon_location
			rotation_degrees = weapon_rotation
			
			match weapon_type:
				"throwable_melee":
					a = 0
					$Area.monitoring = false
		else:
			match weapon_type:
				"throwable_melee":
					ld_spin()
			
		if weapon_sys_path != null:
			get_node(weapon_sys_path).weapon_type = weapon_type
			get_node(weapon_sys_path).weapon = self

func update_weapon_sys_path(path):
	weapon_sys_path = path

func is_visible():
	return visible

func hit(multiplier = 1):
	get_node(weapon_sys_path).attack(multiplier)

var temp_dmg = 35
var a = 5
func ld_spin():
	rotation.x = 0
	
	rotate_y(0.5)
	
	if $AnimationPlayer.is_playing():
		var player = get_node(weapon_sys_path).get_parent()
		player.stamina -= 0.75
		get_tree().call_group("Stamina","update_value",player.stamina,player.max_stamina,true)
		temp_dmg = 40
	
	if $Throw.playing == false:
		$Throw.play()
	
	if a < 10:
		$Area.monitoring = true
		a += 1 - get_node(weapon_sys_path).speed
	if a >= 10:
		$Area.monitoring = false
		a -= 10
	


func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		body.hurt(temp_dmg + get_node(weapon_sys_path).strength,true,5,0.1)
