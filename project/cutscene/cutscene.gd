extends Control

@onready var text := $TextBackground/Text
@onready var next_button := $TextBackground/NextButton
@onready var left_portrait := $LeftPortrait


var scene_texts: Array[SceneText] = []

var text_index := 0

func _ready() -> void:
	# For Testing
	if Utils.is_test:
		var text_loader := CutsceneTextLoader.new()
		var test_texts := text_loader.load_chapter("res://cutscene/scene_text_csvs/test.csv")
		load_scene_texts(test_texts)


func load_scene_texts(_scene_texts: Array[SceneText]) -> void:
	scene_texts = _scene_texts
	_update_assets(text_index)
	next_button.show()
	next_button.grab_focus()


func _on_next_button_pressed() -> void:
	if not Utils.is_test: Sound.play(Sound.focus)
	text_index += 1
	_update_assets(text_index)
	if text_index == scene_texts.size() - 1: next_button.hide()

func _update_assets(index: int) -> void:
	var current_text := scene_texts[index]
	text.text = current_text.content
	left_portrait.texture = Utils.get_player_portrait(current_text.speaker)
