class_name SaveAndLoad

enum Path {
	GAME,
	TEST,
	EMPTY,
	VICTORY_SCREEN
}

# const SAVE_PATH = "res://save.tres"
const SAVE_PATH = "user://save.tres"
# const PLAYER_PATH_ROOT = "res://save_player_"
const PLAYER_PATH_ROOT = "user://save_player_"
const TEST_SAVE_PATH = "res://test.tres"

var save_path: String

const GAME_DATA := "game_data"
const PLAYER_DATA := "player_data"

func _init(path: Path = Path.GAME) -> void:
	match(path):
		Path.GAME:
			save_path = SAVE_PATH
		Path.TEST:
			save_path = TEST_SAVE_PATH


func save_data(data: SaveFileData) -> void:
	ResourceSaver.save(data, save_path)


func save_player(index: int, data: PlayerData) -> void:
	var player_path := PLAYER_PATH_ROOT + str(index) + ".tres"
	data.slot = index
	ResourceSaver.save(data, player_path)
	var updated_player_data := load(player_path)
	var loaded := ResourceLoader.load(save_path)
	loaded.players_data[index] = updated_player_data
	save_data(loaded)


func load_data() -> SaveFileData:
	if ResourceLoader.exists(save_path):
		return load(save_path)
	return null
