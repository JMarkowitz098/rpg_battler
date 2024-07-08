extends GutTest

var TestPlayerSaveData:= load("res://players/player_save_data.gd")
var _data: PlayerSaveData = null

func before_each() -> void:
	var init := {
 		"level": 1,
 		"player_id": Stats.PlayerId.TALON,
 		"slot": 0,
 		"unique_id": "1234"
	}

	_data = TestPlayerSaveData.new(init)

func test_create_object() -> void:
	assert_eq(_data.level, 1, "Created with correct level")
	assert_eq(_data.player_id, Stats.PlayerId.TALON, "Created with correct player_id")
	assert_eq(_data.slot, 0, "Created with correct slot")
	assert_eq(_data.unique_id, "1234", "Created with correct unique_id")