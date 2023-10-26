extends Node


func play_track(track):
	get_parent().get_node("ambiance_music").stream = load(track)
	get_parent().get_node("ambiance_music").play()

func stop_track():
	get_parent().get_node("ambiance_music").stop()
