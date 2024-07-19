extends Node
class_name MockCreator

const TALON = preload("res://players/Talon/talon.tscn")

var player: Node2D
var enemy: Node2D
var action: Action
var battle_groups: BattleGroups


func initialize(safe_add_child: Callable) -> void:
  player = _initialize_member(safe_add_child)
  enemy = _initialize_member(safe_add_child)

  var players: Array[Node2D] = [ player ]
  var enemies: Array[Node2D] = [ enemy ]
  battle_groups = BattleGroups.new(players, enemies)

  action = Action.new(player)
  

func set_action_skill(skill: Ingress) -> void:
  action.skill = skill


func set_action_target(target: Ingress.Target) -> void:
  match target:
    Ingress.Target.ENEMY:
      action.target = enemy


func reset_members_ingress() -> void:
  player.modifiers.current_ingress = player.stats.max_ingress
  enemy.modifiers.current_ingress = player.stats.max_ingress


func _initialize_member(safe_add_child: Callable) -> Node2D:
  var member := TALON.instantiate()
  safe_add_child.call(member)
  member.stats = load("res://players/Talon/levels/talon_1_stats.tres")
  member.modifiers.current_ingress = member.stats.max_ingress
  return member