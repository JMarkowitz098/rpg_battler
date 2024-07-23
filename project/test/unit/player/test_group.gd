extends GutTest

var TestGroup := load("res://players/group.tscn")
var group: Group

var data: Array[PlayerData] = [
		PlayerData.new(
			MockPlayerDetails.new(),
			MockStats.new(),
			UniqueId.new("1234"),
			MockIngress.create_array(),
			Player.Type.PLAYER
		),
		PlayerData.new(
			MockPlayerDetails.new(),
			MockStats.new(),
			UniqueId.new("5678"),
			MockIngress.create_array(),
			Player.Type.ENEMY
		),
	]


func before_each() -> void:
	group = TestGroup.instantiate()
	add_child_autofree(group)


func test_can_create_new_group() -> void:
	assert_not_null(group)


func test_can_instantiate_member() -> void:

	group.instantiate_members(data)
	var new_player := group.members[1]

	assert_not_null(new_player.stats, "stats")
	assert_not_null(new_player.details, "player_details")
	assert_eq(new_player.slot, 1, "slot")
	assert_eq(new_player.unique_id.id, "5678")
	assert_ne(new_player.learned_skills.size(), 0, "skills")
	assert_eq(new_player.type, Player.Type.ENEMY, "type")
	assert_eq(group.slot_two_location.global_position, new_player.global_position, "position")


func test_remove_member_by_id() -> void:
	group.instantiate_members(data)
	group.remove_member_by_id("1234")

	assert_eq(group.members.size(), 1)


func test_get_member_by_unique_id() -> void:
	group.instantiate_members(data)
	var expected := group.members[1]
	var actual := group.get_member_by_unique_id("5678")

	assert_eq_deep(expected, actual)