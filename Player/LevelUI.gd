extends Control

onready var player = get_parent().get_parent().get_parent()
onready var levelsys = player.get_node("LevelSys")
onready var overview = get_node("Overview")

onready var speed = get_node("Speed")
onready var strength = get_node("Stength")
onready var intel = get_node("Inteligence")
onready var res = get_node("Resistance")

onready var level = levelsys.level
onready var xp = levelsys.xp
onready var req_xp = levelsys.req_xp
onready var skills = levelsys.skills_accquired
onready var skill_points = levelsys.skill_points

func _ready():
	visible = false
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	

func update_overview():
	level = levelsys.level
	xp = levelsys.xp
	req_xp = levelsys.req_xp
	skills = levelsys.skills_accquired
	skill_points = levelsys.skill_points
	
	speed.text = "Speed: "+str(levelsys.speed)
	strength.text = "Strength: "+str(levelsys.strength)
	
	overview.bbcode_text = """
LEVEL: [color=gray]"""+str(level)+"""[/color]

SKILL POINTS: [color=gray]"""+str(skill_points)+"""[/color]

DINERO: [color=gray]"""+str(Global.Dinero)+"""[/color]

XP:
[color=gray]"""+str(xp)+"/"+str(req_xp)+"""[/color]

PERKS:
[color=gray]"""+str(skills)+"""[/color]
"""

func _input(event):
	if Input.is_action_just_pressed("show_level_ui"):
		visible = !visible
		
		if visible:
			get_tree().call_group("WeaponSys","update_attack_state",false)
			get_parent().get_node("Paused").paused = true
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			get_tree().call_group("WeaponSys","update_attack_state",true)
			get_parent().get_node("Paused").paused = false
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			mouse_filter =Control.MOUSE_FILTER_IGNORE


func _on_Speed_button_up():
	speed.text = "Speed: "+str(levelsys.speed)
	
	if skill_points >= 1:
		levelsys.add_2_speed()
		Global.skill_points -= 1
	update_overview()

func _on_Stength_button_up():
	strength.text = "Strength: "+str(levelsys.strength)
	
	if skill_points >= 1:
		levelsys.add_2_strength()
		Global.skill_points -= 1
	update_overview()
