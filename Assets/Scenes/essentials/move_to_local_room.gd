extends Area

export var isOutside = true
export var play_new_music = false
export(AudioStreamOGGVorbis) var room_audio_path
export(AudioStreamOGGVorbis) var amb_audio_path
export(NodePath) var inside_pos_path
export(NodePath) var outside_pos_path
var outside_pos
var inside_pos


func _ready():
	add_to_group("iRoom")
	outside_pos = get_node(outside_pos_path)
	inside_pos = get_node(inside_pos_path)

func _on_Area_body_entered(body):
	pass

func move_to(body):
	if !isOutside:
		body.global_transform.origin = outside_pos.global_transform.origin
		
		if play_new_music:
			get_tree().call_group("MusicManager","play_track",amb_audio_path.get_path())
	else:
		body.global_transform.origin = inside_pos.global_transform.origin
		
		if play_new_music:
			get_tree().call_group("MusicManager","play_track",room_audio_path.get_path())
