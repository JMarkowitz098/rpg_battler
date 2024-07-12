extends GutTest

var TestStats := load("res://players/stats.gd")
var stats: Stats


func before_each() -> void:
	stats = TestStats.new()


func test_can_create_stats() -> void:
	assert_not_null(stats)
