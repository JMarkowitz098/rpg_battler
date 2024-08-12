extends Control

@onready var text := $TextBackground/Text
@onready var next_button := $TextBackground/NextButton

var scene_texts: Array[SceneText] = []

var text_index := 0

func _ready() -> void:
	# For Testing
	var text1 := SceneText.new("001", "I am scene text 1")
	var text2 := SceneText.new("002", "I am scene text 2")
	var text3 := SceneText.new("003", "I am scene text 3")
	var test_texts: Array[SceneText] = [text1, text2, text3]
	load_scene_texts(test_texts)


func load_scene_texts(_scene_texts: Array[SceneText]) -> void:
	scene_texts = _scene_texts
	text.text = scene_texts[0].content
	next_button.show()
	next_button.grab_focus()


func _on_next_button_pressed() -> void:
	if not Utils.is_test: Sound.play(Sound.focus)
	text_index += 1
	text.text = scene_texts[text_index].content

	if text_index == scene_texts.size() - 1: next_button.hide()
