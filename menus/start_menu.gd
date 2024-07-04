extends ColorRect

@onready var start_game_button := $CenterContainer/VBoxContainer/StartGameButton
@onready var controls_button := $CenterContainer/VBoxContainer/ControlsButton
@onready var help_menu := $CenterContainer/VBoxContainer/HelpMenu

func _ready() -> void:
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	start_game_button.focus(true)
	Music.play(Music.menu_theme)

func _on_start_game_button_pressed() -> void:
	SaveAndLoadPlayer.clear_save_file()
	get_tree().change_scene_to_file("res://menus/character_menu.tscn")
	Sound.play(Sound.confirm)

func _on_exit_game_button_pressed() -> void:
	get_tree().quit()

func _on_controls_button_pressed() -> void:
	Sound.play(Sound.confirm)
	help_menu.show()
	help_menu.close_button.focus(true)
	help_menu.restart_battle_button.hide()
	help_menu.restart_game_button.hide()


func _on_help_menu_hidden() -> void:
	controls_button.focus(true)
