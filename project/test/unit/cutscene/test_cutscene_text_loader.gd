extends GutTest

var TestCutsceneLoader := load("res://cutscene/cutscene_text_loader.gd")


func test_can_create_cutscene_text_loader() -> void:
	assert_not_null(TestCutsceneLoader)


func test_get_file_path() -> void:
	var expected := "res://cutscene/scene_text_csvs/team_1/chapter_1.csv"
	var actual := CutsceneTextLoader.get_file_path(Team.Id.ONE, Round.Number.ONE)
	assert_eq(actual, expected)

	expected = "res://cutscene/scene_text_csvs/team_2/chapter_2.csv"
	actual = CutsceneTextLoader.get_file_path(Team.Id.TWO, Round.Number.TWO)
	assert_eq(actual, expected)

	expected = "res://cutscene/scene_text_csvs/team_3/chapter_3.csv"
	actual = CutsceneTextLoader.get_file_path(Team.Id.THREE, Round.Number.THREE)
	assert_eq(actual, expected)


func test_can_load_chapter() -> void:
	var text1 := SceneText.new("ch1_1", "Hello world.", "talon")
	var text2 := SceneText.new("ch1_2", "Hello world back.", "nash")
	var text3 := SceneText.new("ch1_3", "Nice to meet you.", "talon")
	var expected: Array[SceneText] = [text1, text2, text3]

	var actual: Array[SceneText] = TestCutsceneLoader.load_chapter("res://cutscene/scene_text_csvs/test.csv")
	for index in actual.size():
		assert_eq(actual[index].id, expected[index].id)
		assert_eq(actual[index].content, expected[index].content)
		assert_eq(actual[index].speaker, expected[index].speaker)
