extends GutTest

var TestPlayerGroup := load("res://players/player_group.tscn")
var player_group: Node2D


func before_each() -> void:
	player_group = TestPlayerGroup.instantiate()
	add_child_autofree(player_group)


func test_can_create_new_group() -> void:
	assert_not_null(player_group)


# func test_load_members_from_save_data() -> void:
#   player_group.load_members_from_save_data()
