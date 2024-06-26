extends Panel

@onready var close_button := $HBoxContainer/VBoxContainer/CloseButton
@onready var restart_game_button := $HBoxContainer/VBoxContainer/RestartGameButton
@onready var restart_battle_button := $HBoxContainer/VBoxContainer/RestartBattleButton

func _on_close_button_pressed() -> void:
	hide()

func _on_restart_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/start_menu.tscn")

func _on_restart_battle_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://battle_scene/battle_scene.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()
