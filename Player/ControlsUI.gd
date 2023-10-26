extends Button

func _on_Controls_pressed():
	if visible == true:
		$TextureRect.visible = !$TextureRect.visible
