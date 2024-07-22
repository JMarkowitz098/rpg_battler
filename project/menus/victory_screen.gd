extends Panel

@onready var defeated_portraits := $Screen1/DefeatedPortraits
@onready var next_battle_button := $Screen2/NextBattleButton
@onready var next_screen_button := $Screen1/NextScreenButton
@onready var player_columns := $Screen2/PlayerColumns
@onready var screen_1 := $Screen1
@onready var screen_2 := $Screen2
@onready var summary_data := $Screen1/SummaryData

var players_level_info: Array[LevelUpDetails] = []
var save_and_load := SaveAndLoad.new()

func _ready() -> void:
	next_screen_button.focus_no_sound()
	_render_summary()
	_level_up_player_and_save()
	_render_level_up_columns()
	await Music.fade()
	Music.play(Music.menu_theme)

func _render_summary() -> void:
	var defeated: Array[Player.Id] = Utils.get_param("defeated")
	# var defeated: Array[Player.Id] = [Player.Id.TALON, Player.Id.NASH] # For debugging
	var summary_data_text := "You defeated "
	
	for player_id: Player.Id in defeated:
		summary_data_text += PlayerDetails.get_player_label(player_id) + " and "
		defeated_portraits.add_child(_create_portrait_texture_rec(player_id))
		
	summary_data.text = summary_data_text.trim_suffix(" and ")

func _create_portrait_texture_rec(player_id: Player.Id) -> TextureRect:
	var new_texture_rect := TextureRect.new()
	new_texture_rect.texture = Utils.get_player_portrait(player_id)
	new_texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	new_texture_rect.self_modulate = Color("red")
	return new_texture_rect
	
func _level_up_player_and_save() -> void:
	var loaded_players := save_and_load.load_data().players_data

	for loaded_player_data in loaded_players:
		if(loaded_player_data):
			var level_up_details := LevelUpDetails.new()
			level_up_details.slot = loaded_player_data.slot
			level_up_details.player_details = loaded_player_data.player_details
			level_up_details.old_stats = loaded_player_data.stats
			level_up_details.old_skills = loaded_player_data.learned_skills

			var new_stats := _save_and_return_new_stats(loaded_player_data)
			var new_skills := _save_and_return_new_skills(loaded_player_data)
			level_up_details.new_stats = new_stats
			level_up_details.new_skills = new_skills

			players_level_info.append(level_up_details)


func _save_and_return_new_stats(loaded_player_data: PlayerData) -> Stats:
	var new_stats := Stats.get_new_stats(
		loaded_player_data.player_details.player_id, 
		loaded_player_data.stats.level + 1
	)

	loaded_player_data.stats = new_stats
	save_and_load.save_player(loaded_player_data.slot, loaded_player_data)
	return new_stats

func _save_and_return_new_skills(loaded_player_data: PlayerData) -> SkillGroup:
	var new_skills := Ing.get_new_skills(
		loaded_player_data.player_details.player_id, 
		loaded_player_data.stats.level # Level already updated
	)
	loaded_player_data.learned_skills = new_skills
	save_and_load.save_player(loaded_player_data.slot, loaded_player_data)
	return new_skills

func _render_level_up_columns() -> void:
	var level_up_columns := player_columns.get_children()

	for details in players_level_info:
		var column := level_up_columns[details.slot]

		_render_column_player_label(column, details.player_details)
		_render_column_portrait(column, details.player_details)
		_render_column_stats(column, details.old_stats, details.new_stats)
		_render_column_skills(column, details.old_skills, details.new_skills)

		column.show()
	
func _render_column_player_label(column: VBoxContainer, player_details: PlayerDetails) -> void:
	column.find_child("PlayerLabel").text = PlayerDetails.get_player_label(player_details.player_id)

func _render_column_portrait(column: VBoxContainer, player_details: PlayerDetails) -> void:
	var player_portait := Utils.get_player_portrait(player_details.player_id)
	column.find_child("PlayerPortrait").texture = player_portait

func _render_column_stats(column: VBoxContainer, old_stats: Stats, new_stats: Stats) -> void:
	var message := _create_stat_message(old_stats, new_stats, "max_ingress", "Ingress")
	message += _create_stat_message(old_stats, new_stats, "incursion", "Incursion")
	message += _create_stat_message(old_stats, new_stats, "refrain", "Refrain")
	message += _create_stat_message(old_stats, new_stats, "agility", "Agility")

	column.find_child("StatIncreases").text = message

func _create_stat_message(old_stats: Stats, new_stats: Stats, stat_key: String, stat_label: String) -> String:
	return stat_label + " +" + str(new_stats[stat_key] - old_stats[stat_key]) + "\n"

func _render_column_skills(column: VBoxContainer, old_skills: SkillGroup, new_skills: SkillGroup) -> void:
	var message := ""
	for skill: Ingress in new_skills.skills:
		if not skill in old_skills.skills:
			message += skill.label + "\n"

	column.find_child("SkillsData").text = message

func _on_next_button_pressed() -> void:
	Sound.play(Sound.confirm)
	screen_1.hide()
	screen_2.show()
	next_battle_button.focus()
	
func _on_next_battle_button_pressed() -> void:
	Sound.play(Sound.confirm)
	get_tree().change_scene_to_file("res://battle_scene/battle_scene.tscn")
