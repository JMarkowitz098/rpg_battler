extends Panel
@onready var close_button := $VBoxContainer/ScreensAndMenuButtons/Buttons/CloseButton
@onready var exit_game := $VBoxContainer/ScreensAndMenuButtons/Buttons/ExitGame
@onready var next_button := $VBoxContainer/ScreenButtons/NextButton
@onready var previous_button := $VBoxContainer/ScreenButtons/PreviousButton
@onready var restart_battle_button := $VBoxContainer/ScreensAndMenuButtons/Buttons/RestartBattleButton
@onready var restart_game_button := $VBoxContainer/ScreensAndMenuButtons/Buttons/RestartGameButton
@onready var screen_one := $VBoxContainer/ScreensAndMenuButtons/ScreenOne
@onready var screen_two := $VBoxContainer/ScreensAndMenuButtons/ScreenTwo
@onready var screen_three := $VBoxContainer/ScreensAndMenuButtons/ScreenThree

@onready var screens: Array[VBoxContainer]= [
	screen_one,
	screen_two,
	screen_three
]

var current := 0

func _ready() -> void:
	close_button.focus_no_sound()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_back"):
		Sound.play(Sound.focus)
		hide()

func _on_close_button_pressed() -> void:
	Sound.play(Sound.confirm)
	hide()

func _on_restart_game_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/start_menu.tscn")
	Sound.play(Sound.confirm)

func _on_restart_battle_button_pressed() -> void:
	get_tree().paused = false
	Sound.play(Sound.confirm)
	get_tree().change_scene_to_file("res://battle_scene/battle_scene.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().paused = false
	Sound.play(Sound.confirm)
	get_tree().quit()


func _on_next_button_pressed() -> void:
	if current == 0: previous_button.show()

	Sound.play(Sound.confirm)
	screens[current].hide()
	current += 1
	screens[current].show()
	previous_button.focus()

	if current == screens.size() - 1: next_button.hide()
	

func _on_previous_button_pressed() -> void:
	if current == screens.size() - 1: next_button.show()
		
	Sound.play(Sound.confirm)
	screens[current].hide()
	current -= 1
	screens[current].show()
	next_button.focus()

	if current == 0: previous_button.hide()
		

