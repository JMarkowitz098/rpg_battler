class_name ComponentHolder

var action_queue: HBoxContainer
var action_type: GridContainer
var current_action_button: Button
var current_skill: SkillStats
var current_skill_button: Button
var current_skill_type: Skill.Type
var enemy_group: Node2D
var info_label: Label
var player_group: Node2D
var skill_ui: SkillMenuUi
var skill_choice_list: GridContainer

func _init(init):
  action_queue = init.action_queue
  action_type = init.action_type
  current_action_button = init.current_action_button
  current_skill = init.current_skill
  current_skill_button = init.current_skill_button
  current_skill_type = init.current_skill_type
  enemy_group = init.enemy_group
  info_label = init.info_label
  player_group = init.player_group
  skill_choice_list = init.skill_choice_list
  skill_ui = init.skill_ui
