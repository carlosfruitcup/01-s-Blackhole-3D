tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("BoneGizmo", "Spatial", preload("res://addons/BoneGizmo-patch-1/bone_gizmo_node.gd"), 
	preload("res://addons/BoneGizmo-patch-1/bone_gizmo.png"))

func _exit_tree():
	remove_custom_type("BoneGizmo")
