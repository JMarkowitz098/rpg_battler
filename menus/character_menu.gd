extends ColorRect



func _on_character_one_button_pressed():
	get_tree().change_scene_to_file("res://menus/character_creation_menu.tscn")
