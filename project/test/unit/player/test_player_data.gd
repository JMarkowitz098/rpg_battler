extends GutTest

var TestPlayerData := load("res://players/player_data.gd")
var data: PlayerData

var player_details := MockPlayerDetails.new()
var stats := MockStats.new()
var unique_id := MockUniqueId.new()
var skills := MockIngress.create_array()


func before_each() -> void:
	data = TestPlayerData.new(player_details, stats, unique_id, skills, Player.Type.PLAYER, 1)


func test_can_create_player_data() -> void:
	assert_not_null(data)


func test_values() -> void:
	assert_eq(data.player_details, player_details, "player_details")
	assert_eq(data.stats, stats, "stats")
	assert_eq(data.unique_id, unique_id, "unique_id")
	assert_eq(data.learned_skills, skills, "skills")
	assert_eq(data.type, Player.Type.PLAYER, "type")


func test_format_for_save() -> void:
	var e_player_details := {
		"player_id": 0,
		"label": "Mock player label",
		"elements": [0, 2],
		"learnable_skills": [[3, 0], [6, 0]]
	}
	var e_stats := {"level": 1, "max_ingress": 10, "incursion": 1, "refrain": 1, "agility": 1}
	var expected := {
		"player_details": e_player_details,
		"stats": e_stats,
		"unique_id": "1234",
		"learned_skills": [[3, 0], [6, 0]],
		"type": 0,
		"slot": 1
	}
	var actual := data.format_for_save()

	assert_eq_deep(expected, actual)
