extends ColorRect

@onready var start_game_button = $CenterContainer/VBoxContainer/StartGameButton

func _ready():
	start_game_button.focus()

func _on_start_game_button_pressed():
	SaveAndLoadPlayer.clear_save_file()
	get_tree().change_scene_to_file("res://menus/character_menu.tscn")

func _on_exit_game_button_pressed():
	get_tree().quit()
