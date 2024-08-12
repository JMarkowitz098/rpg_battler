extends GutTest

var TestCutsceneLoader := load("res://cutscene/cutscene_text_loader.gd")
var loader: CutsceneTextLoader


func before_each() -> void:
	loader = TestCutsceneLoader.new()


func test_can_create_cutscene_text_loader() -> void:
	assert_not_null(loader)


func test_can_load_chapter() -> void:
	var text1 := SceneText.new("ch1_1", "Hello world.", "talon")
	var text2 := SceneText.new("ch1_2", "Hello world back.", "nash")
	var text3 := SceneText.new("ch1_3", "Nice to meet you.", "talon")
	var expected: Array[SceneText] = [text1, text2, text3]

	var actual: Array[SceneText] = loader.load_chapter("res://cutscene/scene_text_csvs/test.csv")
	for index in actual.size():
		assert_eq(actual[index].id, expected[index].id)
		assert_eq(actual[index].content, expected[index].content)
		assert_eq(actual[index].speaker, expected[index].speaker)
