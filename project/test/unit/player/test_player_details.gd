extends GutTest

var TestPlayerDetails := load("res://players/player_details.gd")
var details: PlayerDetails

var elements: Array[Element.Type] = [Element.Type.ETH, Element.Type.SHOR]
var skills := MockIngress.create_array()

const LABEL := "Nash"


func before_each() -> void:
	details = TestPlayerDetails.new(Player.Id.NASH, LABEL, elements, skills)


func test_can_create_player_details() -> void:
	assert_not_null(details)


func test_values() -> void:
	assert_eq(details.player_id, Player.Id.NASH, "player_id")
	assert_eq(details.label, LABEL, "label")
	assert_eq(details.elements, elements, "elements")
	assert_eq(details.learnable_skills, skills, "skills")


func test_format_for_save() -> void:
	var expected := {
		"player_id": 1,
		"label": LABEL,
		"elements": elements as Array,
		"learnable_skills": [[3, 0], [6, 0]]
	}
	var actual := details.format_for_save()

	assert_eq_deep(expected, actual)
