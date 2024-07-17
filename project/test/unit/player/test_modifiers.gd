extends GutTest

var TestModifiers := load("res://players/modifiers.gd")
var modifiers: Node


func before_each() -> void:
	modifiers = TestModifiers.new()
	var parent: Node2D = autoqfree(load("res://players/Talon/talon.tscn").instantiate())
	parent.unique_id = UniqueId.new()
	parent.add_child(modifiers)


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


func test_set_current_ingress() -> void:
	var tests: Array[Array] = [
		# ["Test description"_action_has_unique_id, new_value, expected, max_ingress]
		["It can set current ingress", 5, 5, 10],
		["It sets it at a min of 0", -3, 0, 10],
		["It sets it at a max of max_ingress", 15, 10, 10]
	]

	for test in tests:
		_test_set_current_ingress(test)


func test_signals() -> void:
	watch_signals(modifiers)

	gut.p("It emits an ingress_updated signal when ingress changes")
	modifiers.set_current_ingress(5, 10)
	assert_signal_emitted(modifiers, "ingress_updated")

	gut.p("It emits a no_ingress_signal when ingress is set to zero or less")
	modifiers.set_current_ingress(0, 10)
	assert_signal_emitted(modifiers, "no_ingress")


func _test_set_current_ingress(values: Array) -> void:
	var expected: int = values[2]
	modifiers.set_current_ingress(values[1], values[3])
	var actual: int = modifiers.current_ingress
	assert_eq(expected, actual, values[0])
