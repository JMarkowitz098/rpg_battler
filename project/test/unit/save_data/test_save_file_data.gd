extends GutTest

var TestSaveFileData := load("res://save_data/save_file_data.gd")
var data: SaveFileData
var players_data: Array[PlayerData] = [ MockPlayerData.new() ]
var save_time := Time.get_datetime_string_from_system()


func before_each() -> void:
	data = autofree(TestSaveFileData.new(
		"0", players_data, save_time, Round.Number.ONE
	))

func test_can_create_save_file_data() -> void:
	assert_not_null(data)


func test_values() -> void:
	assert_eq(data.id, "0", "id")
	assert_eq(data.players_data, players_data, "players_data")
	assert_eq(data.save_time, save_time, "save_time")
	assert_eq(data.round_number, Round.Number.ONE, "round_number")
