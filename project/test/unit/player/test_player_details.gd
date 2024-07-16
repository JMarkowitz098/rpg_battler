extends GutTest

var TestPlayerDetails := load("res://players/player_details.gd")
var details: PlayerDetails

var elements: Array[Element.Type] = [Element.Type.ETH, Element.Type.SHOR]
var skills := MockIngress.create_array()

const LABEL := "Nash"


func before_each() -> void:
	details = TestPlayerDetails.new(Player.Id.NASH, LABEL, elements, skills)


func after_each() -> void:
	details.free()


func test_can_create_player_details() -> void:
	assert_not_null(details)


func test_values() -> void:
	assert_eq(details.player_id, Player.Id.NASH, "player_id")
	assert_eq(details.label, LABEL, "label")
	assert_eq(details.elements, elements, "elements")
	assert_eq(details.learnable_skills, skills, "skills")
