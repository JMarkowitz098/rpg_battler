extends GutTest

var TestUniqueId := load("res://players/unique_id.gd")
var unique_id: UniqueId


func before_each() -> void:
	unique_id = TestUniqueId.new()


func test_can_create_unique_id() -> void:
	assert_not_null(unique_id)
	assert_ne(unique_id.id, "")

	unique_id = TestUniqueId.new("1111")
	assert_eq(unique_id.id, "1111")
  