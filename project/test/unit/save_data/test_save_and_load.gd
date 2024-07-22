extends GutTest

var TestSaveAndLoad := load("res://save_data/save_and_load.gd")
var save_and_load: SaveAndLoad


func before_each() -> void:
	save_and_load = autofree(TestSaveAndLoad.new(SaveAndLoad.Path.TEST))

func after_each() -> void:
	gut.file_delete("res://test.tres")

func test_can_create_save_file_data() -> void:
	assert_not_null(save_and_load)

func test_can_save_data() -> void:
	var mock_save_file_data := MockSaveFileData.new()
	save_and_load.save_data(mock_save_file_data)

	assert_file_exists("res://test.tres")
	assert_file_not_empty("res://test.tres")


func test_can_load_data() -> void:
	var mock_save_file_data := MockSaveFileData.new()
	save_and_load.save_data(mock_save_file_data)
	var loaded := save_and_load.load_data()

	assert_eq(loaded.id, "mock_id")
	assert_ne(loaded.save_time, "")
	assert_eq(loaded.round_number, Round.Number.ONE)
	assert_eq([], loaded.players_data) # Mocking the player data causes the resource to not load.


func test_can_load_when_no_data() -> void:
	var loaded := save_and_load.load_data()

	assert_null(loaded)