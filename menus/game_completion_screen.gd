extends Panel

@onready var title := $CenterContainer/VBoxContainer/Title
@onready var message := $CenterContainer/VBoxContainer/Message
@onready var start_over_button := $CenterContainer/VBoxContainer/StartOverButton
@onready var exit_game_button := $CenterContainer/VBoxContainer/ExitGameButton


func _ready() -> void:
	Music.play(Music.menu_theme)
	start_over_button.focus_no_sound()
	var status: Utils.GameOver = Utils.get_param("status")

	if status == Utils.GameOver.VICTORY:
		title.text = "Congratulations"
		message.text = "You beat the game!"
	else:
		title.text = "Game Over"
		message.text = "Better luck next time!"


func _on_start_over_button_pressed() -> void:
	Sound.play(Sound.confirm)
	get_tree().change_scene_to_file("res://menus/start_menu.tscn")


func _on_exit_game_button_pressed() -> void:
	Sound.play(Sound.confirm)
	get_tree().quit()
