class_name ComponentHolder

var action_queue: HBoxContainer
var action_type: GridContainer
var current_action_button: Button
var enemy_group: Node2D
var info_label: Label
var player_group: Node2D
var skill_ui: SkillMenuUi

func _init(init):
  action_queue = init.action_queue
  action_type = init.action_type
  current_action_button = init.current_action_button
  enemy_group = init.enemy_group
  info_label = init.info_label
  player_group = init.player_group
  skill_ui = init.skill_ui
