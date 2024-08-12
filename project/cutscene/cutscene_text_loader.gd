class_name CutsceneTextLoader

func load_chapter(file_path: String) -> Array[SceneText]:
  var scene_texts: Array[SceneText] = [] 
  var file := FileAccess.open(file_path, FileAccess.READ)
  var line := file.get_csv_line() # First line is column names

  while not file.eof_reached():
    line = file.get_csv_line()
    var new_scene_text := SceneText.new(line[0], line[1], line[2])
    scene_texts.append(new_scene_text)

  return scene_texts