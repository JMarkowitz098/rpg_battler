class_name SaveAndLoad

enum Path {
	GAME,
	TEST,
	EMPTY,
	VICTORY_SCREEN
}

const SAVE_PATH = "res://save.cfg"
const TEST_SAVE_PATH = "res://test.cfg"
var save_path: String
# const SAVE_PATH = "user://save.cfg"

var config := ConfigFile.new()

const GAME_DATA := "game_data"
const PLAYER_DATA := "player_data"

func _init(path: Path = Path.GAME) -> void:
	match(path):
		Path.GAME:
			save_path = SAVE_PATH
		Path.TEST:
			save_path = TEST_SAVE_PATH


	if (OS.get_name() != "Web"): config.load(save_path)

func save_data(data: SaveFileData) -> void:
	if (OS.get_name() == "Web"):
		if data.players_data.size() != 0: 
			Utils.game_data.players_data = data.players_data
	else:
		_set_game_data(data)
		_set_player_data(data)
		config.save(save_path)


func save_player(save_file_id: String, index: int, data: PlayerData) -> void:
	if (OS.get_name() == "Web"):
		Utils.game_data.players_data[index] = data
	else:
		_set_data(save_file_id, PLAYER_DATA, "player_" + str(index), data.format_for_save())
		config.save(save_path)


func load_data(id: String) -> SaveFileData:
	if (OS.get_name() == "Web"):
		return SaveFileData.new(
			id,
			Utils.game_data.players_data,
			"",
			Round.Number.ONE,
	)
	else:
		var error := config.load(save_path)
		if error:
			print("An error happened while loading data: ", error)
			return
		
		if (config.get_sections().size() == 0): return null

		var players_data: Array[Dictionary] = _load_player_data(id)

		return SaveFileData.new(
			id,
			_create_players_data(players_data),
			_load_data(id, GAME_DATA, "save_time"),
			_load_data(id, GAME_DATA, "round_number"),
		)


func clear_data() -> void:
	config.clear()
	config.save(save_path)


func _set_game_data(data: SaveFileData) -> void:
	_set_data(data.id, GAME_DATA, "id", data.id) 
	_set_data(data.id, GAME_DATA, "save_time", data.save_time) 
	_set_data(data.id, GAME_DATA, "round_number", data.round_number) 


func _set_player_data(data: SaveFileData) -> void:
	var players_data := data.players_data.map(_player_data_lambda)
	for index in players_data.size():
		_set_data(data.id, PLAYER_DATA, "player_" + str(index), players_data[index])


func _set_data(id: String, type: String, key: String, val: Variant) -> void:
	config.set_value(id + "_" + type, key, val)


func _load_player_data(id: String) -> Array[Dictionary]:
	var players_data: Array[Dictionary] = []
	if not config.has_section(id + "_" + PLAYER_DATA): return players_data
	var section_keys := config.get_section_keys(id + "_" + PLAYER_DATA)

	for key in section_keys:
		players_data.append(_load_data(id, PLAYER_DATA, key))
	
	return players_data


func _load_data(id: String, type: String, key: String) -> Variant:
	return config.get_value(id + "_" + type, key)


func _create_players_data(players_data: Array[Dictionary]) -> Array[PlayerData]:
	var players: Array[PlayerData] = []
	for data in players_data: players.append(_create_player_data(data))
	return players


func _create_skills_array(skills: Array) -> Array[Ingress]:
	var new_skills: Array[Ingress ]= []

	for skill_data: Array in skills:
		var new_ingress := Ing.load_ingress(skill_data)
		new_skills.append(new_ingress)

	return new_skills


func _create_player_data(data: Dictionary) -> PlayerData:
	var player_details := PlayerDetails.new(
		data.player_details.player_id, 
		data.player_details.label, 
		data.player_details.elements, 
		_create_skills_array(data.player_details.learnable_skills) 
	)
	var stats := Stats.new(
		data.stats.level, 
		data.stats.max_ingress, 
		data.stats.incursion, 
		data.stats.refrain, 
		data.stats.agility
	)

	return PlayerData.new(
		player_details,
		stats,
		UniqueId.new(data.unique_id),
		_create_skills_array(data.learned_skills),
		data.type,
		data.slot
	)


func _player_data_lambda(player_data: PlayerData) -> Dictionary: 
	return player_data.format_for_save()

