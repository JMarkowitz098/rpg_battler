# Currently victory screen erases save data when there is an error. Need to fix

# extends GutTest

# var TestVictoryScreen := load("res://menus/victory_screen.tscn")
# var screen: Panel


# func before_each() -> void:
# 	var defeated: Array[Player.Id] = [Player.Id.TALON, Player.Id.NASH]
# 	Utils._params = { "defeated": defeated}
# 	screen = add_child_autoqfree(TestVictoryScreen.instantiate())


# func test_can_create_victory_screen() -> void:
# 	assert_not_null(screen)


# func test_can_render_summary() -> void:
# 	assert_eq(screen.summary_data.text, "You defeated Talon and Nash")

