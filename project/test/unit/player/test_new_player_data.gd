extends GutTest

var TestNewPlayerData := load("res://players/new_player_data.gd")
var data: NewPlayerData


func before_each() -> void:
	var init := {
		"player_id": Player.Id.NONE,
		"player_details": MockPlayerDetails.new(),
		"stats": MockStats.new(),
		"unique_id": UniqueId.new(),
		"skills": MockIngress.create_array(),
		"type": Player.Type.PLAYER
	}
	data = TestNewPlayerData.new(init)


func test_can_create_new_player_data() -> void:
	assert_not_null(data)
