extends Spatial

#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

export var fast_close := true
var cutscene_amt_trigger = 0
export(float) var death_y_level = -2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.canMove = true
	start_dialog("beginning")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if !OS.is_debug_build():
		fast_close = false
	
	if fast_close:
		print("** Fast Close enabled in the 'L_Main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")
	
	set_process_input(fast_close)

func start_dialog(_dialog):
	var dialog = Dialogic.start(_dialog)
	dialog.connect("dialogic_signal", self, "dialog_listener")
	add_child(dialog)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("change_mouse_input"):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Capture mouse if clicked on the game, needed for HTML5
# Called when an InputEvent hasn't been consumed by _input() or any GUI item
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT && event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

var set_stream = false
func _process(delta):
	if cutscene_amt_trigger == 2:
		var place = ($Player.global_transform.origin - $crack.global_transform.origin).normalized()
		$Player.global_transform.origin -= place
		$Player.gravity_enabled = false
		Input.action_press("ui_accept")
		
		if set_stream == false:
			$ambiance_music.stream = load("res://Assets/Music/AreaBG/0/0blackhole.ogg")
			$ambiance_music.play()
			$Player/Head/Camera/AnimationPlayer.play("shake")
			$crack/CSGCylinder/AnimationPlayer.play("play")
			Global.canMove = false
			set_stream = true
		
#		if get_tree().get_nodes_in_group("Enemy").size() <= 0:
#			set_combat(false)
	if get_node("Player").global_transform.origin.y < death_y_level:
		get_node("Player").hurt(999)

onready var CombatMusic = get_node("combat_music")
var combat = false
func set_combat(_bool:bool):
	combat = _bool
	
	if _bool == true:
		if CombatMusic.playing == false:
			CombatMusic.play()
			#Music.stop()
	else:
		if CombatMusic.playing == true:
			#Music.play()
			CombatMusic.stop()


func _on_Area_area_entered(area):
	pass


func _on_Area_body_entered(body):
	AudioServer.set_bus_effect_enabled(1,0,true)
	$ambiance_music.stop()
	
	$Player/CanvasLayer2.visible = true
	
	$switch_to_next_scene.start()


func _on_switch_to_next_scene_timeout():
	start_dialog("leave")
