extends GutTest

var TestPlayerDetails := load("res://players/player_details.gd")
var player_details: Resource


func before_each() -> void:
	player_details = TestPlayerDetails.new()


func test_can_create_modifiers() -> void:
	assert_not_null(player_details)



	