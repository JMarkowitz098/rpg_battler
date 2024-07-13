extends GutTest

var TestGroup := load("res://players/group.tscn")
var group: Group


func before_each() -> void:
	group = TestGroup.instantiate()
	add_child_autofree(group)


func test_can_create_new_group() -> void:
	assert_not_null(group)


func test_can_instantiate_member() -> void:
	var data: Array[NewPlayerData] = [
			NewPlayerData.new({
			"player_id": Player.Id.TALON,
			"player_details": MockPlayerDetails.new(),
			"stats": MockStats.new(),
			"unique_id": UniqueId.new(),
			"skills": MockIngress.create_array(),
			"type": Player.Type.PLAYER
		}),
			NewPlayerData.new({
			"player_id": Player.Id.TALON,
			"player_details": MockPlayerDetails.new(),
			"stats": MockStats.new(),
			"unique_id": UniqueId.new(),
			"skills": MockIngress.create_array(),
			"type": Player.Type.ENEMY
		}),

	]

	group.instantiate_members(data)
	var new_player := group.members[1]

	assert_not_null(new_player.stats, "stats")
	assert_not_null(new_player.details, "player_details")
	assert_eq(new_player.slot, 1, "slot")
	assert_not_null(new_player.unique_id, "unique_id")
	assert_ne(new_player.skills.size(), 0, "skills")
	assert_eq(new_player.type, Player.Type.ENEMY, "type")
	assert_eq(group.slot_two_location.global_position, new_player.global_position, "position")