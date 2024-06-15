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

var current
var previous

var choosing_action_state: ChoosingAction
var choosing_action_queue_state: ChoosingActionQueue
var choosing_skill_state: ChoosingSkill

func _init(holder):
	var init_params := {
		"change_state": change_state,
		"change_to_previous_state": change_to_previous_state,
		"holder": holder
	}
	choosing_action_state = ChoosingAction.new(init_params)
	choosing_action_queue_state = ChoosingActionQueue.new(init_params)
	choosing_skill_state = ChoosingSkill.new(init_params)

func change_state(new_state_id: Type):
	match new_state_id:
		Type.CHOOSING_ACTION:
			_update_state_vars(choosing_action_state)
		Type.CHOOSING_ACTION_QUEUE:
			_update_state_vars(choosing_action_queue_state)
		Type.CHOOSING_SKILL:
			_update_state_vars(choosing_skill_state)

func change_to_previous_state():
	var new_state = previous
	previous = current
	current = new_state
	new_state.enter()

func _update_state_vars(new_state):
	previous = current
	current = new_state
	new_state.enter()
