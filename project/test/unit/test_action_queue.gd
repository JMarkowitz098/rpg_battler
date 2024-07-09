extends GutTest

# Setup
var TestActionQueue := load("res://ui/action_queue.gd")

var ActionScript := load("res://action.gd")
var IngressScript := load("res://skills/ingress.gd")
var ItemScript := load("res://ui/action_queue_item.gd")
var LevelStatsScript := load("res://players/level_stats.gd")
var PlayerDetailsScript := load("res://players/player_details.gd")
var PlayerScript := load("res://players/player.gd")
var StatsScript := load("res://players/stats.gd")

var _queue: ActionQueue = null

func before_each() -> void:
	_queue = ActionQueue.new()

func after_each() -> void:
	_queue.free()

# Tests

func test_can_create_action_queue() -> void:
	assert_not_null(_queue)

func test_fill_enemy_actions() -> void:
	# Setup
		# Cannot use double outside of functions. Throws an error
	var DoubleAction: GDScript = double(ActionScript)
	var DoubleIngress: GDScript = double(IngressScript)
	var DoubleItem: GDScript = double(ItemScript)
	var DoubleLevelStats: GDScript = double(LevelStatsScript)
	var DoublePlayer: GDScript = double(PlayerScript)
	var DoublePlayerDetails: GDScript = double(PlayerDetailsScript)
	var DoubleStats: GDScript = double(StatsScript)

	var players: Array[Node2D] = []
	var enemies: Array[Node2D] = []
	var skills: Array[Ingress] = []

	var action_1: Action = DoubleAction.new()
	var item_1: ActionQueueItem = DoubleItem.new()
	var level_stats_1: LevelStats = DoubleLevelStats.new()
	var player_1: Node2D = DoublePlayer.new()
	var player_details_1: PlayerDetails = DoublePlayerDetails.new()
	var skill_1: Ingress = DoubleIngress.new()
	var skill_2: Ingress = DoubleIngress.new()
	var stats_1: Stats = DoubleStats.new()

	stub(action_1, "set_dodge")
	stub(action_1, "set_enemy_skill")
	stub(stats_1, "set_ingress_energy").to_call_super()

	action_1.actor = player_1
	item_1.action = action_1
	level_stats_1.max_ingress = 10
	level_stats_1.skills = []
	player_1.stats = stats_1
	player_1.stats.level_stats = level_stats_1
	player_details_1.icon_type = Stats.IconType.PLAYER
	stats_1.player_details = player_details_1

	_queue.items = [item_1]

	# Tests
	gut.p("Nothing is set if there are no enemies")
	_queue._fill_enemy_actions(players, enemies)
	assert_not_called(action_1, "set_dodge")
	assert_not_called(action_1, "set_enemy_skill")

	gut.p("Dodge is set on action if the enemy has no usable skills")
	stats_1.current_ingress = 0
	player_details_1.icon_type = Stats.IconType.ENEMY
	_queue._fill_enemy_actions(players, enemies)
	assert_called(action_1, "set_dodge")
	assert_not_called(action_1, "set_enemy_skill")

	gut.p("Sets a skill on action if there are skills to use")
	stats_1.current_ingress = 4
	skill_1.type = Ingress.Type.INCURSION
	skill_1.ingress = 1
	skill_2.type = Ingress.Type.REFRAIN
	skill_2.ingress = 1
	skills = [skill_1, skill_2]
	level_stats_1.skills = skills

	_queue._fill_enemy_actions(players, enemies)
	assert_called(action_1, "set_enemy_skill")

func test_get_usable_skills() -> void:
	var DoubledIngress: GDScript = double(IngressScript)
	var current_ingress := 10

	var skill_1: Ingress = DoubledIngress.new()
	skill_1.ingress = 2
	var skill_2: Ingress = DoubledIngress.new()
	skill_2.ingress = 4
	var skill_3: Ingress = DoubledIngress.new()
	skill_3.ingress = 6

	var skills: Array[Ingress] = [skill_1, skill_2, skill_3]
	var expected: Array[Ingress] = [skill_1, skill_2, skill_3]
	var actual := _queue._get_useable_skills(current_ingress, skills)

	# Asserts
	gut.p("Returns all skills when current ingress is high")
	assert_eq_deep(actual, expected)

	gut.p("Filters out skills that cost too much Ingress")
	current_ingress = 3
	expected = [skill_1]
	actual = _queue._get_useable_skills(current_ingress, skills)
	assert_eq_deep(actual, expected)

	gut.p("Returns empty array when not enough ingress for any skill")
	current_ingress = 1
	expected = []
	actual = _queue._get_useable_skills(current_ingress, skills)
	assert_eq_deep(actual, expected)
