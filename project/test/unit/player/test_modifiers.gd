extends GutTest

var TestModifiers := load("res://players/modifiers.gd")
var modifiers: Node

func before_each() -> void:
	modifiers = TestModifiers.new()

func after_each() -> void:
	modifiers.free()

func test_can_create_modifiers() -> void:
	assert_not_null(modifiers)

func test_default_values() -> void:
	var keys_and_expected := [
		["has_small_refrain_open", false],
		["is_dodging", false],
		["is_eth_dodging", false],
		["rand_agi", 1],
		["current_ingress", 1],
		["plus_max_ingress", 0],
		["plus_incursion", 0],
		["plus_refrain", 0],
		["plus_agility", 0],
		["current_refrain_element", Element.Type.NONE]
	]

	for key_val: Array in keys_and_expected:
		assert_eq(modifiers[key_val[0]], key_val[1])


	