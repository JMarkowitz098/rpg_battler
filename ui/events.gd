extends Node

signal change_state(new_state: int)
signal change_to_previous_state()

signal choose_enemy()

signal enter_action_queue_handle_input

signal choosing_action_state_entered
signal choosing_action_queue_state_entered
signal choosing_skill_state_entered
signal choosing_enemy_state_entered
signal choosing_enemy_all_state_entered

signal is_battling_state_entered

signal pause_game(current_state: int)

signal update_action_index(new_index: int)
signal update_action_queue_focuses()
signal update_enemy_group_current
signal update_info_label(new_message: String)
signal update_info_label_with_skill_description()
