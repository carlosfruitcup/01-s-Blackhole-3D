extends Spatial

onready var weapon
onready var raycast = get_parent().get_node("Head/RayCast")
onready var raycast2
var weapon_type :String="firearm"
var weapon_attack_speed :float= 1.0
var weapon_reload_speed :float= 1.0 #Firearms only
var weapon_damage :int=15
var strength = 0
var speed = 0.0
var weapon_anim_num = 0

var can_attack = true

func _ready():
	add_to_group("WeaponSys")

func check_weapons():
	if is_instance_valid(raycast):
		#get_tree().call_group("weapon","update_weapon_sys_path",get_path_to(get_parent().get_node("WeaponSys")))
		var head_children = get_parent().get_node("Head").get_children()

		for w in head_children:
			if w.is_in_group("weapon") && visible == true && weapon == null:
				#realized this requires an inventory.
				#im going to kill myself if this needs massive overhauling
				weapon = w
				raycast.cast_to = weapon.weapon_range
				weapon.weapon_sys_path = get_path()

var attack_anim = "null"
func _input(event):
	if weapon != null:
		#checks if the weapon isnt playing an attack and if the player can currently attack
		if event.is_action_pressed("fire") && weapon.get_node("AnimationPlayer").current_animation != attack_anim && can_attack == true:
			weapon.get_node("AnimationPlayer").playback_speed = weapon_attack_speed
			can_attack = false
			match weapon_type:
				"bat": #yes this is an OFF refrence.
					weapon.scale = Vector3(1,1.25,1)
					var anim = weapon.weapon_animations[round(rand_range(0,weapon.weapon_animations.size()-1))]
					weapon.get_node("AnimationPlayer").play(anim,0,1)
					attack_anim = "fire"
					weapon_anim_num = weapon.weapon_animations.find(anim)
					
					if weapon.weapon_animations.find(anim) > 0:
						get_parent().stamina -= 15
						get_tree().call_group("Stamina","update_value",get_parent().stamina,get_parent().max_stamina,true)
					
				"firearm": 
					#note: for those reading, there was no plan to have firearms in this game
					#this system was ported from another (unannounced) cancelled game which was planned to have guns
					#I think the code is in this messy ass filesystem somewhere, but I recommend not adding firearms to this game.
					weapon.get_node("AnimationPlayer").play("fire")
					attack_anim = "fire"
				"melee":
					weapon.get_node("AnimationPlayer").play(weapon.weapon_animations[round(rand_range(0,weapon.weapon_animations.size()-1))])
					attack_anim = "fire"
				"throwable_melee":
					var anim = weapon.weapon_animations[round(rand_range(0,weapon.weapon_animations.size()-1))]
					weapon.get_node("AnimationPlayer").play(anim)
					attack_anim = "fire"
					weapon_anim_num = weapon.weapon_animations.find(anim)
					
					if weapon.weapon_animations.find(anim) > 0:
						get_parent().stamina -= 15
						get_tree().call_group("Stamina","update_value",get_parent().stamina,get_parent().max_stamina,true)
		
	
		
		if event.is_action_pressed("reload"):
			weapon.get_node("AnimationPlayer").playback_speed = weapon_reload_speed
			match weapon_type:
				"firearm":
					weapon.get_node("AnimationPlayer").play("fire")
		
		if event.is_action_pressed("aim") && can_attack == true:
			if weapon != null:
				match weapon_type:
					"firearm":
						return
					"melee":
						return
					"bat":
						if get_parent().stamina >= 30:
							weapon.scale = Vector3(1,1.25,1)
							
							
							attack(2)
							
							get_parent().stamina -= 30
							get_tree().call_group("Stamina","update_value",get_parent().stamina,get_parent().max_stamina,true)
							
							weapon.get_node("AnimationPlayer").play("swing_",0,1.5)
							attack_anim = "fire"
							
						
					"throwable_melee":
						if get_parent().stamina >= 15:
							raycast2.force_raycast_update()
							print(raycast.get_collision_point())
							if raycast2.is_colliding():
								weapon.set_pos = false
								weapon.global_transform.origin = raycast2.get_collision_point()
								weapon.scale = Vector3(5,5,5)
								weapon.set_as_toplevel(true)
								print(raycast2.get_collider())
								
								get_parent().stamina -= 25
								get_tree().call_group("Stamina","update_value",get_parent().stamina,get_parent().max_stamina,true)
								
								$reset_ld_pos.start(5)
							
							can_attack = false

func attack(multiplier = null):
	if multiplier == null:
		multiplier = 1
	
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var body = raycast.get_collider()
		#
		if body.is_in_group("Enemy"):
			var dmg = weapon.weapon_animation_damage[weapon_anim_num] + strength
			
			body.hurt(dmg * multiplier,false,0,0.2 + (strength/2.7))

func _process(delta):
	check_weapons()
	
	
	
	#print(get_parent().get_node_or_null("Head/RayCast/RayCast2"))
	raycast = get_parent().get_node("Head/RayCast")
	raycast2 = get_parent().get_node("Head/RayCast/RayCast2")
	
	if weapon != null:
		#checks if the current animation is nothing and if the player cant attack, if so the game will reset the values
		if weapon.get_node("AnimationPlayer").current_animation == "" && can_attack == false:
			can_attack = true
			weapon_anim_num = -1

func update_attack_state(state:bool):
	can_attack = state

func _on_reset_ld_pos_timeout():
	if weapon_type == "throwable_melee":
		weapon.set_pos = true
		weapon.scale = Vector3(1,1,1)
		weapon.set_as_toplevel(false)
		
