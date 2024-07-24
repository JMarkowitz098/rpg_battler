extends Node
class_name MockCreator

const TALON = preload("res://players/Talon/talon.tscn")
const ACTION_QUEUE_ITEM = preload("res://battle_scene/action_queue/action_queue_item.tscn")
const MAX_INGRESS = 8

var safe_add_child: Callable
var player: Node2D
var enemy: Node2D
var enemy_2: Node2D
var action: Action
var battle_groups: BattleGroups
var item_1: ActionQueueItem
var item_2: ActionQueueItem
var item_3: ActionQueueItem


func initialize(_safe_add_child: Callable) -> void:
	safe_add_child = _safe_add_child
	player = _initialize_member()
	enemy = _initialize_member()
	enemy.type = Player.Type.ENEMY
	enemy_2 = _initialize_member()
	enemy_2.type = Player.Type.ENEMY

	var players: Array[Node2D] = [ player ]
	var enemies: Array[Node2D] = [ enemy, enemy_2 ]
	battle_groups = BattleGroups.new(players, enemies)

	action = Action.new(player)
	

func set_action_skill(skill: Ingress) -> void:
	action.skill = skill


func set_action_target(target: Ingress.Target) -> void:
	match target:
		Ingress.Target.ENEMY, Ingress.Target.ALL_ENEMIES:
			action.target = enemy
		Ingress.Target.SELF:
			action.target = player


func reset_members_ingress() -> void:
	player.modifiers.current_ingress = player.stats.max_ingress
	enemy.modifiers.current_ingress = enemy.stats.max_ingress
	enemy_2.modifiers.current_ingress = enemy_2.stats.max_ingress


func create_action_queue_items() -> void:
	item_1 = _create_and_add_item(player)
	item_2 = _create_and_add_item(enemy)
	item_3 = _create_and_add_item(enemy_2)


func _initialize_member() -> Node2D:
	var member := TALON.instantiate()
	safe_add_child.call(member)
	member.stats = load("res://players/Talon/levels/talon_1_stats.tres")
	member.learned_skills = member.details.learnable_skills
	member.stats.max_ingress = MAX_INGRESS
	member.modifiers.current_ingress = member.stats.max_ingress
	return member


func _create_and_add_item(actor: Node2D) -> ActionQueueItem:
	var item: ActionQueueItem = ACTION_QUEUE_ITEM.instantiate()
	safe_add_child.call(item)
	item.set_empty_action(actor)
	return item