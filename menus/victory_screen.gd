extends ColorRect

@onready var summary_data = $VBoxContainer/SummaryData
@onready var stat_data = $VBoxContainer/StatData
@onready var skills_data = $VBoxContainer/SkillsData

var players_stats := []

func _ready():
	_render_summary()
	_update_players_stats_and_skills()
	_render_players_stats()
	_render_players_skills()

func _render_summary() -> void:
	var defeated = Utils.get_param("defeated")
	if defeated:
		var labels = defeated.map(func(unique_id): 
			var player_id = int(unique_id[0])
			return Stats.get_player_label(player_id))
		var summary_data_text = "You defeated "
		for label in labels:
			summary_data_text += label + " and "
		summary_data.text = summary_data_text.trim_suffix(" and ")
	
func _update_players_stats_and_skills():
	var loaded = SaveAndLoadPlayer.load_all_players()
	var level_loader = SaveAndLoadLevel.new()

	var slot_index := 0
	for loaded_stats in loaded:
		if(loaded_stats):
			players_stats.append({"old": loaded_stats})
			var new_stats = level_loader.get_data(loaded_stats.player_id, loaded_stats.level + 1)
			_fill_new_stats(new_stats, loaded_stats)
			SaveAndLoadPlayer.save_player(slot_index, new_stats)
			players_stats[slot_index]["new"] = new_stats
			slot_index += 1

func _fill_new_stats(new_stats: Dictionary, loaded_stats: Dictionary):
	var keys = [
		"elements",
		"icon_type",
		"label",
		"level",
		"player_id",
		"slot",
		"unique_id"
	]
	for key in keys:
		new_stats[key] = loaded_stats[key]
	new_stats.current_ingress_energy = new_stats.max_ingress_energy
	new_stats.level = loaded_stats.level + 1

func _render_players_stats():
	var players_stats_message := ""
	for stats in players_stats:
		players_stats_message += stats.new.label + " " + str(stats.new.slot) + ": "
		players_stats_message += _create_stat_message(stats, "max_ingress_energy", "Ingress")
		players_stats_message += _create_stat_message(stats, "incursion_power", "Incursion")
		players_stats_message += _create_stat_message(stats, "refrain_power", "Refrain")
		players_stats_message += _create_stat_message(stats, "agility", "Agility")
		players_stats_message += "\n"
	
	stat_data.text = players_stats_message.trim_suffix(",")

func _create_stat_message(stats: Dictionary, stat_key: String, stat_label: String) -> String:
	return " +" + str(stats.new[stat_key] - stats.old[stat_key]) + " " + stat_label + ","

func _render_players_skills():
	var players_skills_message := ""
	for stats in players_stats:
		players_skills_message += stats.new.label + " " + str(stats.new.slot) + " learned: "
		for skill_id in stats.new.skills:
			if not skill_id in stats.old.skills:
				players_skills_message += Skill.get_skill_label(skill_id) + ", "
		players_skills_message += "\n"
	
	skills_data.text = players_skills_message

func _on_next_battle_pressed():
	get_tree().change_scene_to_file("res://world/battle_scene.tscn")
