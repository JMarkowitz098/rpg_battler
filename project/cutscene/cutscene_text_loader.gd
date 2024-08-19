class_name CutsceneTextLoader

static func load_chapter(file_path: String) -> Array[SceneText]:
	var scene_texts: Array[SceneText] = [] 
	var file := FileAccess.open(file_path, FileAccess.READ)
	var line := file.get_line() # First line is column names

	while not file.eof_reached():
		line = file.get_line()
		var split := line.split(",")
		var new_scene_text := SceneText.new(split[0], split[1], split[2])
		scene_texts.append(new_scene_text)

	return scene_texts

static func get_file_path(team_id: Team.Id, round_number: Round.Number) -> String:
	var root_path := "res://cutscene/scene_text_files/"
	return root_path + _get_team(team_id) + "/" + _get_chapter(round_number) + ".txt"


static func _get_team(team_id: Team.Id) -> String:
	match team_id:
		Team.Id.ONE:
			return "team_1"
		Team.Id.TWO:
			return "team_2"
		Team.Id.THREE:
			return "team_3"
		_:
			return ""

static func _get_chapter(round_number: Round.Number) -> String:
	match round_number:
		Round.Number.ONE:
			return "chapter_1"
		Round.Number.TWO:
			return "chapter_2"
		Round.Number.THREE:
			return "chapter_3"
		_:
			return ""
