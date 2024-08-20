extends GutTest

var TestCutscene := load("res://cutscene/cutscene.tscn")
var cutscene: Control
var text1: SceneText
var text2: SceneText
var text3: SceneText
var scene_texts: Array[SceneText]


func before_each() -> void:
	Utils.is_test = true
	cutscene = TestCutscene.instantiate()
	add_child_autoqfree(cutscene)
	text1 = SceneText.new("001", "I am scene text 1", "talon")
	text2 = SceneText.new("002", "I am scene text 2", "nash")
	text3 = SceneText.new("003", "I am scene text 3", "talon")
	scene_texts = [text1, text2, text3]


func test_can_create_victory_screen() -> void:
	assert_not_null(cutscene)


func test_can_load_scene_text() -> void:
	cutscene.load_scene_texts(scene_texts)
	assert_eq_deep(scene_texts, cutscene.scene_texts)


func test_sets_first_item_as_text() -> void:
	cutscene.load_scene_texts(scene_texts)
	assert_eq(cutscene.text_index, 0)
	assert_eq(cutscene.text.text, scene_texts[0].content)
	assert_true(cutscene.next_button.has_focus())
	assert_eq(cutscene.left_portrait.texture, Utils.get_player_portrait(PlayerId.Id.TALON))


func test_can_advance_text() -> void:
	cutscene.load_scene_texts(scene_texts)
	cutscene.next_button.pressed.emit()
	assert_eq(cutscene.text_index, 1)
	assert_eq(cutscene.text.text, scene_texts[1].content)
	assert_eq(cutscene.left_portrait.portrait.texture, Utils.get_player_portrait(PlayerId.Id.NASH))

# Causing it to change scenes fails because battle scene
# func test_scene_changes_at_end_of_text() -> void:
# 	cutscene.load_scene_texts(scene_texts)

# 	cutscene.next_button.pressed.emit()
# 	cutscene.next_button.pressed.emit()
	# cutscene.next_button.pressed.emit() 

	# assert_false(cutscene.next_button.visible)