class_name SaveAndLoad

const SAVE_PATH = "res://save.cfg"
const TEST_SAVE_PATH = "res://test.cfg"
var save_path: String
#const SAVE_PATH = "user://save.cfg"

var config := ConfigFile.new()

const GAME_DATA := "game_data"
const PLAYER_DATA := "player_data"

func _init(is_test: bool = false) -> void:
	if(is_test): save_path = TEST_SAVE_PATH
	else: save_path = SAVE_PATH

	config.load(save_path)

func save_data(data: SaveFileData) -> void:
	_set_game_data(data)
	_set_player_data(data)

	config.save(save_path)

func load_data(id: String) -> SaveFileData:
	var error := config.load(save_path)
	if error:
		print("An error happened while loading data: ", error)
		return

	var players_data: Array[Dictionary] = _load_player_data(id)

	return SaveFileData.new(
		id,
		_create_players_data(players_data),
		 _load_data(id, GAME_DATA, "save_time"),
		 _load_data(id, GAME_DATA, "round_number"),
	)


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
	print("Get sections section: ", id + "_" + PLAYER_DATA)
	var section_keys := config.get_section_keys(id + "_" + PLAYER_DATA)
	print(section_keys)

	for key in section_keys:
		players_data.append(_load_data(id, PLAYER_DATA, key))
	
	return players_data


func _load_data(id: String, type: String, key: String) -> Variant:
	# print("id: ", id)
	# print("type: ", type)
	# print("key: ", key)
	return config.get_value(id + "_" + type, key)


func _create_players_data(players_data: Array[Dictionary]) -> Array[PlayerData]:
	var players: Array[PlayerData] = []
	for data in players_data: players.append(_create_player_data(data))
	return players


func _create_skills_array(skills: Array) -> Array[Ingress]:
	var ingress: Array[Ingress] = []

	for skill_data: Array in skills:
		var new_ingress := Ingress.load_ingress(skill_data)
		ingress.append(new_ingress)
	return ingress


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
		_create_skills_array(data.skills),
		data.type
	)


func _player_data_lambda(player_data: PlayerData) -> Dictionary: 
	return player_data.format_for_save()

