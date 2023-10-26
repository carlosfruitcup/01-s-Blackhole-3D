extends Node

var config = ConfigFile.new()
var file = File.new()

var maxHealth = 100
var Health = 100

var maxStamina = 100
var Stamina = 100

var Dinero = 0
var Level = 1
var XP = 0
var maxXP = 150
var skill_points = 0

var canMove = true

var equipped_item = null
var equipped_armor = null
var inventory = []
var debug_items = ["Long Dagger","Purification"]

var room = ""
var died = 0

var tempLevel = 1
var tempXP = 0
var tempMXP = 150
var tempDinero = 0
var tempHealth = 100
var tempStamina = 100
var tempSkillpoints = 0

var speed = 0
var strength = 0
var intel = 0
var res = 0

#var intel_xp_buff = 1

var bosses_defeated = []

var scenes = [preload("res://Characters/CharacterWeapons/Ranged_projectile/Arrow.tscn")]

var toby_spoken_to = false
var alfred_execution = false

func _ready():
	load_game()

func check_levels():
	
	if XP >= maxXP and Level <= 20:
		Level += 1
		Dialogic.set_variable_from_id("1691611384-333",str(Level),"=")
		get_tree().call_group("Player","play_level_up")
		
		skill_points += 1
		maxXP += 150
		XP = 0
		
		get_tree().call_group("Level","play_anim")
		get_tree().call_group("Level","update_value",XP,maxXP)
		enemy_dead(0,0)

func enemy_dead(_dinero,_xp):
	
	XP += _xp + (15 * intel)
	print(XP)
	Dinero += _dinero
	
	check_levels()
	get_tree().call_group("Level","play_anim")
	get_tree().call_group("Level","update_value",XP,maxXP)
	get_tree().call_group("Level","update_label",Level,XP,maxXP,_dinero,_xp,skill_points)

func dialogue_state(_bool = false):
	_bool = bool(_bool)
	
	canMove = _bool
	print(_bool)

func reset_values():
	Level = tempLevel
	XP = tempXP
	maxXP = tempMXP
	Dinero = tempDinero
	maxStamina = tempStamina
	maxHealth = tempHealth
	skill_points = tempSkillpoints

func add_boss_2_list(_name):
	bosses_defeated.append(_name)

func save_vals():
	tempLevel = Level
	tempXP = XP
	tempMXP = maxXP
	tempDinero = Dinero
	tempStamina = maxStamina
	tempHealth = maxHealth
	tempSkillpoints = skill_points

func set(_var, _bool = false):
	_bool = bool(_bool)
	
	match _var:
		"toby_talk":
			toby_spoken_to = _bool

func load_game():
	if !file.file_exists("user://save.cfg"):
			config.save("user://save.cfg")
	else:
			# Load data from a file.
			var err = config.load("user://save.cfg")

			# If the file didn't load, ignore it.
			if err != OK:
				if 1:
					printerr("Generic Error: 1")
				elif 2:
					printerr("Unavaliable")
				else:
					printerr("Something went wrong. " + str(err))
			else:
				# Iterate over all sections.
				if config.has_section("player"):
					for player in config.get_sections():
						var XP_ = config.get_value("player","xp",0)
						var reqXP_ = config.get_value("player","Reqxp",150)
						var level_ = config.get_value("player","level",0)
						var weapon = config.get_value("player","weapon",null)
						var armor = config.get_value("player","armor",null)
						var stamina_ = config.get_value("player","stamina",100)
						var health_ = config.get_value("player","health",100)
						var dinero_ = config.get_value("player","dinero",0)
						var skillpoints_ = config.get_value("player","skillpoints",0)
						var intel_ = config.get_value("player","intel",0)
						var strg = config.get_value("player","strg",0)
						var speedz = config.get_value("player","speed",0)
						var resz = config.get_value("player","resz",0)
						var inv = config.get_value("player","inv",[])
						var rooma = config.get_value("player","room",null)
						
						XP = XP_
						maxXP = reqXP_
						Level = level_
						equipped_item = weapon
						equipped_armor = armor
						maxStamina = stamina_
						maxHealth = health_
						Dinero = dinero_
						skill_points = skillpoints_
						intel = intel_
						strength = strg
						speed = speedz
						res = resz
						inventory = inv
						
						room = rooma
						
						Dialogic.set_variable_from_id("1691611384-333",str(Level),"=")
				
				if config.has_section("events"):
					for events in config.get_sections():
						var tob = config.get_value("events","toby",false)
						var alfexe = config.get_value("events","alfexe",false)
						var boss = config.get_value("events","bosses",[])
						
						bosses_defeated = boss
						alfred_execution = alfexe
						toby_spoken_to = tob
						

func save_game():
	save_vals()
	#PLAYER
	config.set_value("player","xp",XP)
	config.set_value("player","Reqxp",maxXP)
	config.set_value("player","level",Level)
	config.set_value("player","weapon",equipped_item)
	config.set_value("player","armor",equipped_armor)
	config.set_value("player","stamina",maxStamina)
	config.set_value("player","health",maxHealth)
	config.set_value("player","dinero",Dinero)
	config.set_value("player","skillpoints",skill_points)
	config.set_value("player","intel",intel)
	config.set_value("player","strg",strength)
	config.set_value("player","speed",speed)
	config.set_value("player","resz",res)
	config.set_value("player","inv",inventory)
	config.set_value("player","room",room)
	
	#EVENTS
	config.set_value("events","toby",toby_spoken_to)
	config.set_value("events","alfexe",alfred_execution)
	config.set_value("events","bosses",bosses_defeated)
	
	config.save("user://save.cfg")
