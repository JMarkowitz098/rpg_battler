extends ColorRect

@onready var start_button = $CenterContainer/VBoxContainer/StartButton

func _ready():
	start_button.grab_focus()

func _on_start_button_pressed():
	SaveAndLoadPlayer.clear_save_file()
	get_tree().change_scene_to_file("res://menus/character_menu.tscn")
