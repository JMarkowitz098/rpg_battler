extends Node
class_name State

enum Type { 
	CHOOSING_ENEMY, 
	CHOOSING_ACTION_QUEUE, 
	IS_BATTLING, 
	CHOOSING_ACTION,
	CHOOSING_SKILL,
	GAME_OVER,
	VICTORY
}

var current: Variant
var previous: Variant

var choosing_action_state: ChoosingAction
var choosing_action_queue_state: ChoosingActionQueue
var choosing_skill_state: ChoosingSkill
var choosing_enemy_state: ChoosingEnemy
var is_battling_state: IsBattling

func _init() -> void:
	choosing_action_state = ChoosingAction.new()
	choosing_action_queue_state = ChoosingActionQueue.new()
	choosing_skill_state = ChoosingSkill.new()
	choosing_enemy_state = ChoosingEnemy.new()
	is_battling_state = IsBattling.new()

	Events.change_state.connect(change_state)
	Events.change_to_previous_state.connect(change_to_previous_state)

func change_state(new_state_id: Type) -> void:
	match new_state_id:
		Type.CHOOSING_ACTION:
			_update_state_vars(choosing_action_state)
		Type.CHOOSING_ACTION_QUEUE:
			_update_state_vars(choosing_action_queue_state)
		Type.CHOOSING_SKILL:
			_update_state_vars(choosing_skill_state)
		Type.CHOOSING_ENEMY:
			_update_state_vars(choosing_enemy_state)
		Type.IS_BATTLING:
			_update_state_vars(is_battling_state)

func change_to_previous_state() -> void:
	var new_state: Variant = previous
	previous = current
	current = new_state
	new_state.enter()

func _update_state_vars(new_state: Variant) -> void:
	previous = current
	current = new_state
	new_state.enter()
