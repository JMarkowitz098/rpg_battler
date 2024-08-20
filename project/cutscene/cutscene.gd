extends Control

@onready var text := $TextBackground/Text
@onready var next_button := $TextBackground/NextButton
@onready var left_portrait := $PortraitBorder

@export_file("*.txt") var text_file: String
var scene_texts: Array[SceneText] = []

var text_index := 0

func _ready() -> void:
	# For Testing
	Music.play(Music.cutscene_theme, 1)
	if Utils.is_test:
		var test_texts := CutsceneTextLoader.load_chapter("res://cutscene/scene_text_files/team_3/chapter_1.txt")
		load_scene_texts(test_texts)
	elif text_file and not Utils._params:
		var test_texts := CutsceneTextLoader.load_chapter(text_file)
		load_scene_texts(test_texts)
	else:
		load_scene_texts(Utils._params.cutscene_texts)


func load_scene_texts(_scene_texts: Array[SceneText]) -> void:
	scene_texts = _scene_texts
	_update_assets(text_index)
	next_button.show()
	next_button.grab_focus()


func _on_next_button_pressed() -> void:
	if not Utils.is_test: Sound.play(Sound.focus)
	if text_index == scene_texts.size() - 1: 
		get_tree().change_scene_to_file("res://battle_scene/battle_scene.tscn")
	else:
		text_index += 1
		_update_assets(text_index)

func _update_assets(index: int) -> void:
	var current_text := scene_texts[index]
	text.text = current_text.content
	left_portrait.portrait.texture = Utils.get_player_portrait(current_text.speaker)
