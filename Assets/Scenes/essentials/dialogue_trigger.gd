extends Area

export var dialog = "default"


func play_dialog():
	get_tree().call_group("world","start_dialog",dialog)
