extends Node

var level = 0
var xp = 0
var req_xp = 50
var skill_points = 0

var skills_accquired = []

onready var LevelUI = get_parent().get_node("CanvasLayer/Control/Level")
onready var speedsterUI = get_parent().get_node("CanvasLayer/Control/speedster_ui")
onready var weaponSYS = get_parent().get_node("WeaponSys")
onready var player = get_parent()

export var speed = 0
export var strength = 0
export var intel = 0
export var res = 0

var max_levels = [6,8,5,5]
#func _ready():
#	speed = get_parent().speed

func _process(delta):
	LevelUI.update_overview()
	update_stats()
	update_skill_function()
	
	if skill_points > 0:
		get_parent().get_node("CanvasLayer/Control/Reminder/AnimationPlayer").play("play")

var disabled_pause = false
func update_skill_function():
	match speed:
		20:
			return
				

func update_stats():
	level = Global.Level
	xp = Global.XP
	req_xp = Global.maxXP
	skill_points = Global.skill_points
	
	speed = Global.speed
	strength = Global.strength
	intel = Global.intel
	res = Global.res

func add_skill(skill):
	skills_accquired.append(skill)

func check_skill(skill):
	return(skill in skills_accquired)

func add_2_speed():
	if speed < max_levels[0]:
		player.speed += 1.5
		weaponSYS.speed += 0.2
		Global.speed += 1
		skill_points -= 1
		
		if speed == 4:
			max_levels[1] = 4

func add_2_strength():
	if strength < max_levels[1]:
		weaponSYS.strength += 3
		Global.strength += 1
		Global.skill_points -= 1
		
		if strength == 5:
			max_levels[0] = 3

func add_2_intel():
	if intel < max_levels[2]:
		Global.intel += 1
		Global.skill_points -= 1
