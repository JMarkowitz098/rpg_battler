extends GutTest

var TestStats := load("res://players/stats.gd")
var stats: Stats


func before_each() -> void:
	stats = TestStats.new(1, 10, 1, 1, 1)


func test_can_create_stats() -> void:
	assert_not_null(stats)


func test_values() -> void:
	assert_eq(stats.level, 1, "level")
	assert_eq(stats.max_ingress, 10, "max_ingress")
	assert_eq(stats.incursion, 1, "incursion")
	assert_eq(stats.refrain, 1, "refrain")
	assert_eq(stats.agility, 1, "agility")


func test_format_for_save() -> void:
	var expected := {
		"level": 1,
		"max_ingress": 10,
		"incursion": 1,
		"refrain": 1,
		"agility": 1
	}
	var actual := stats.format_for_save()

	assert_eq_deep(expected, actual)