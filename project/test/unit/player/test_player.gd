extends GutTest

var TestPlayer := load("res://players/player.gd")
var player: Player

func before_each() -> void:
	player = TestPlayer.new()
	player.ingress_energy = Label.new()
	player.modifiers = Modifiers.new()
	player.details = MockPlayerDetails.new() # Normally loaded in from Node
	player.load_stats(MockStats.new())
	player.set_unique_id(UniqueId.new())
	player.set_skills(MockIngress.create_array())


func after_each() -> void:
	player.ingress_energy.free()
	player.modifiers.free()
	player.free()

func test_can_create_player() -> void:
	assert_not_null(player, "player")
	assert_not_null(player.stats, "stats")
	assert_not_null(player.details, "details")
	assert_not_null(player.unique_id, "unique_id")
	assert_not_null(player.slot, "slot")
	assert_not_null(player.type, "type")
	assert_not_null(player.learned_skills, "skills")
	assert_not_null(player.modifiers, "modifiers")


func test_talon() -> void:
	var talon: Node2D = load("res://players/Talon/talon.tscn").instantiate()
	add_child_autoqfree(talon)
	_test_player_scene(talon)


func test_nash() -> void:
	var nash: Node2D = load("res://players/Nash/nash.tscn").instantiate()
	add_child_autoqfree(nash)
	_test_player_scene(nash)


func test_esen() -> void:
	var esen: Node2D = load("res://players/Esen/esen.tscn").instantiate()
	add_child_autoqfree(esen)
	_test_player_scene(esen)


func test_get_usable_skills() -> void:
	var skill_1 := MockIngress.create_incursion()
	var skill_2 := MockIngress.create_refrain()
	var skill_3 := MockIngress.create_incursion()
	skill_3.ingress = 4

	var skills := SkillGroup.new()
	skills.add_skill(skill_1)
	skills.add_skill(skill_2)
	skills.add_skill(skill_3)
	var actual: Array[NewIngress]
	var expected: Array[NewIngress]

	player.learned_skills = skills
	player.modifiers.current_ingress = 10

	gut.p("All skills are available when player has high enough ingress")
	expected = [ skill_1, skill_2, skill_3 ]
	actual = player.get_usable_skills()
	assert_eq_deep(actual, expected)

	gut.p("Skills that cost too much are not available")
	player.modifiers.current_ingress = 3
	expected = [ skill_1, skill_2 ]
	actual = player.get_usable_skills()
	assert_eq_deep(actual, expected)

	gut.p("No skills are available when user has 1 ingress")
	player.modifiers.current_ingress = 1
	expected = [  ]
	actual = player.get_usable_skills()
	assert_eq_deep(actual, expected)

	gut.p("Only refrain is available at 2 ingress")
	player.modifiers.current_ingress = 2
	expected = [ skill_2 ]
	actual = player.get_usable_skills()
	assert_eq_deep(actual, expected)
	

func _test_player_scene(member: Node2D) -> void:
	assert_not_null(member.details, "player_details")
	assert_not_null(member.modifiers, "modifiers")
	assert_connected(member.modifiers, member, 'ingress_updated', "_on_modifiers_ingress_updated")
	assert_connected(member.modifiers, member, 'no_ingress', "_on_modifiers_no_ingress")
