tool
extends Spatial

var run = false
var ran_once = false
var print_once = false

#All paths are must be relative to the node (BoneGizmo)
export(NodePath) var skeleton_path
export(String) var edit_bone = ""
export(String) var animation_path = "../AnimationPlayer"

var skeleton
var bone_index
var amount = 0
var bones = []

func _process(delta):
	#print('a')
	if run:
		skeleton = get_node(skeleton_path)
		
		if not edit_bone == "" and not skeleton_path == "":
			bone_index = skeleton.find_bone(edit_bone)
			skeleton.set_bone_pose(bone_index,transform)
			
		if ran_once == false:
			amount = skeleton.get_bone_count() - 1
			print(amount)
			ran_once = true
		
		
		if amount > 0:
			bones.append(skeleton.get_bone_name(amount))
			amount -= 1
		
		if amount <= 0 and !print_once:
			print(bones)
			print_once = true
	else:
		ran_once = false
		print_once = false
		bones = []



func create_tracks():
	var skeleton_node = get_node(skeleton_path)
	var animation_node = get_node(animation_path)
	var animation = animation_node.get_animation(animation_node.assigned_animation)
	print(animation_node.current_animation)
	for i in range(skeleton_node.get_bone_count()):
		animation.add_track(Animation.TYPE_TRANSFORM,i)
		animation.track_set_path(i,"Skeleton"+ ":" + skeleton_node.get_bone_name(i))


func insert_key(): #This will override all the bone poses in the track with the current ones
	var skeleton_node = get_node(skeleton_path)
	var animation_node = get_node(animation_path)
	var animation = animation_node.get_animation(animation_node.assigned_animation)
	for i in range(skeleton_node.get_bone_count()):
		var bone_tr = skeleton_node.get_bone_pose(i)
		var rot = Quat(bone_tr.basis.orthonormalized())
		animation.transform_track_insert_key(i,animation_node.current_animation_position,bone_tr.origin,rot,bone_tr.basis.get_scale())
