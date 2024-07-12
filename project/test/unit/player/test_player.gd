extends GutTest

var TestPlayer := load("res://players/player.gd")
var player: Player

func before_each() -> void:
	player = TestPlayer.new()

func after_each() -> void:
	player.free()

func test_can_create_player() -> void:
	assert_not_null(player)

func test_get_usable_skills() -> void:
	var skill_1 := MockIngress.create_incursion()
	var skill_2 := MockIngress.create_refrain()
	var skill_3 := MockIngress.create_incursion()
	skill_3.ingress = 4

	var skills: Array[Ingress] = [ skill_1, skill_2, skill_3 ]
	var stats := MockStats.new()
	var actual: Array[Ingress]
	var expected: Array[Ingress]

	player.stats = stats
	player.skills = skills

	gut.p("All skills are available when player has high enough ingress")
	expected = [ skill_1, skill_2, skill_3 ]
	actual = player.get_usable_skills()
	assert_eq_deep(actual, expected)

	gut.p("Skills that cost too much are not available")
	player.stats.current_ingress = 3
	expected = [ skill_1, skill_2 ]
	actual = player.get_usable_skills()
	assert_eq_deep(actual, expected)

	gut.p("No skills are available when user has 1 ingress")
	player.stats.current_ingress = 1
	expected = [  ]
	actual = player.get_usable_skills()
	assert_eq_deep(actual, expected)

	gut.p("Only refrain is available at 2 ingress")
	player.stats.current_ingress = 2
	expected = [ skill_2 ]
	actual = player.get_usable_skills()
	assert_eq_deep(actual, expected)

	stats.free()
	
