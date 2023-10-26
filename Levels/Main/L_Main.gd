extends Spatial

#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

export var combat_music := true
export var begins_with_dialogue = false
export var is_supposed_to_have_ld = false
export var dialogue_begin_with = "default"
export(float) var death_y_level = -2.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.room = get_tree().current_scene.name
	Global.canMove = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	add_to_group("world")
	
	Global.save_vals()
	
	if Global.room != get_tree().current_scene.name:
		Global.room = get_tree().current_scene.name
		Global.died = 0
	
	if is_supposed_to_have_ld:
		if !"Long Dagger" in Global.inventory:
			Global.inventory.append("Long Dagger")
	
	if begins_with_dialogue:
		start_dialog(dialogue_begin_with)
	
	#AudioServer.set_bus_mute(0,true)
	

func start_dialog(_dialog):
	var dialog = Dialogic.start(_dialog)
	dialog.connect("dialogic_signal", self, "dialog_listener")
	add_child(dialog)

# Capture mouse if clicked on the game, needed for HTML5
# Called when an InputEvent hasn't been consumed by _input() or any GUI item
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT && event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if get_tree().get_nodes_in_group("Enemy").size() <= 0:
		set_combat(false)
	
	if get_node("Player").global_transform.origin.y < death_y_level:
		get_node("Player").hurt(999)

onready var CombatMusic = get_node("combat_music")
onready var Music = get_node("ambiance_music")
var combat = false
func set_combat(_bool:bool):
	combat = _bool
	
	if _bool == true:
		if CombatMusic.playing == false:
			CombatMusic.play()
			
			Music.stop()
	else:
		if CombatMusic.playing == true:
			Music.play()
			CombatMusic.stop()
