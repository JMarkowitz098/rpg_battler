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
			return CharacterStats.get_player_label(player_id))
		var summary_data_text = "You defeated "
		for label in labels:
			summary_data_text += label + " and "
		summary_data.text = summary_data_text.trim_suffix(" and ")
	
func _update_players_stats_and_skills():
	var loaded = SaveAndLoadPlayer.load_all_players()

	var slot_index := 0
	for loaded_stats in loaded:
		if(loaded_stats):
			loaded_stats.agility += 3
			loaded_stats.max_ingress_energy += 10
			loaded_stats.incursion_power += 3
			loaded_stats.refrain_power += 2
			loaded_stats.current_ingress_energy = loaded_stats.max_ingress_energy
			
			loaded_stats.skills.append(Skill.Id.ETH_INCURSION_DOUBLE)
			loaded_stats.skills.append(Skill.Id.ETH_REFRAIN_SMALL_GROUP)
			
			SaveAndLoadPlayer.save_player(slot_index, loaded_stats)
			players_stats.append(loaded_stats)
			slot_index += 1

func _render_players_stats():
	var players_stats_message := ""
	for stats in players_stats:
		players_stats_message += stats.label + " " + str(stats.slot) + ": "
		players_stats_message += "+1 Ingress, +1 Incursion, +1 Refrain, +1 Agility"
		players_stats_message += "\n"
	
	stat_data.text = players_stats_message

func _render_players_skills():
	var players_skills_message := ""
	for stats in players_stats:
		players_skills_message += stats.label + " " + str(stats.slot) + ": "
		players_skills_message += "learned \"Double Eth Incursion\" and \"Small Eth Refrain Wide\""
		players_skills_message += "\n"
	
	skills_data.text = players_skills_message

	


func _on_next_battle_pressed():
	get_tree().change_scene_to_file("res://world/battle_scene.tscn")
