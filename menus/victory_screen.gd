extends Panel

@onready var defeated_portraits := $Screen1/DefeatedPortraits
@onready var next_battle_button := $Screen2/NextBattleButton
@onready var next_screen_button := $Screen1/NextScreenButton
@onready var player_columns := $Screen2/PlayerColumns
@onready var screen_1 := $Screen1
@onready var screen_2 := $Screen2
@onready var summary_data := $Screen1/SummaryData

var players_stats := []

func _ready() -> void:
	next_screen_button.focus(true)
	_render_summary()
	_level_up_player_and_save()
	_render_level_up_columns()
	await Music.fade()
	Music.play(Music.menu_theme)

func _render_summary() -> void:
	var defeated: Array[String] = Utils.get_param("defeated")
	# var defeated: Array[String] = ["0_123", "1_456"] # For debugging
	var summary_data_text := "You defeated "
	
	for unique_id: String in defeated:
		var player_id := int(unique_id[0])
		summary_data_text += Stats.get_player_label(player_id) + " and "

		var new_texture_rect := _create_portrait_texture_rec(player_id)
		defeated_portraits.add_child(new_texture_rect)
		
	summary_data.text = summary_data_text.trim_suffix(" and ")

func _get_player_portrait(player_id: Stats.PlayerId) -> Texture2D:
	match(player_id):
		Stats.PlayerId.TALON:
			return Utils.get_player_portrait(Stats.PlayerId.TALON)
		Stats.PlayerId.NASH:
			return Utils.get_player_portrait(Stats.PlayerId.NASH)
		Stats.PlayerId.ESEN:
			return Utils.get_player_portrait(Stats.PlayerId.ESEN)
		_:
			return null

func _create_portrait_texture_rec(player_id: Stats.PlayerId) -> TextureRect:
	var player_portait := _get_player_portrait(player_id)
	var new_texture_rect := TextureRect.new()
	new_texture_rect.texture = player_portait
	new_texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	new_texture_rect.self_modulate = Color("red")
	return new_texture_rect
	
func _level_up_player_and_save() -> void:
	var loaded_players := SaveAndLoadPlayer.load_all_players()

	for loaded_player_data in loaded_players:
		if(loaded_player_data):
			players_stats.append({"player_details": loaded_player_data})

			var old_level_data: Variant = LevelStats.load_level_data(
				loaded_player_data.player_id, loaded_player_data.level)
			players_stats[loaded_player_data.slot]["old"] = old_level_data

			var new_save_data := _save_and_return_new_level_data(loaded_player_data)
			var new_level_data: Variant = LevelStats.load_level_data(
				new_save_data.player_id, new_save_data.level)
			players_stats[loaded_player_data.slot]["new"] = new_level_data

func _save_and_return_new_level_data(loaded_player_data: PlayerSaveData) -> PlayerSaveData:
	var new_save_data := PlayerSaveData.new({
		"level": loaded_player_data.level + 1,
		"player_id": loaded_player_data.player_id,
		"slot": loaded_player_data.slot,
		"unique_id": loaded_player_data.unique_id
	})
	SaveAndLoadPlayer.save_player(loaded_player_data.slot, new_save_data)
	return new_save_data

func _render_level_up_columns() -> void:
	var level_up_columns := player_columns.get_children()

	for stats: Dictionary in players_stats:
		var column := level_up_columns[stats.player_details.slot]

		_render_column_player_label(column, stats)
		_render_column_portrait(column, stats)
		_render_column_stats(column, stats)
		_render_column_skills(column, stats)

		column.show()
	
func _render_column_player_label(column: VBoxContainer, stats: Dictionary) -> void:
	column.find_child("PlayerLabel").text = Stats.get_player_label(stats.player_details.player_id)

func _render_column_portrait(column: VBoxContainer, stats: Dictionary) -> void:
	var player_portait := _get_player_portrait(stats.player_details.player_id)
	column.find_child("PlayerPortrait").texture = player_portait

func _render_column_stats(column: VBoxContainer, stats: Dictionary) -> void:
	var message := _create_stat_message(stats, "max_ingress", "Ingress")
	message += _create_stat_message(stats, "incursion", "Incursion")
	message += _create_stat_message(stats, "refrain", "Refrain")
	message += _create_stat_message(stats, "agility", "Agility")

	column.find_child("StatIncreases").text = message

func _create_stat_message(stats: Dictionary, stat_key: String, stat_label: String) -> String:
	return stat_label + " +" + str(stats.new[stat_key] - stats.old[stat_key]) + "\n"

func _render_column_skills(column: VBoxContainer, stats: Dictionary) -> void:
	var message := ""
	for skill: Ingress in stats.new.skills:
		if not skill in stats.old.skills:
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
