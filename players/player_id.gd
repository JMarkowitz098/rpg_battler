class_name PlayerId

enum Id {
  TALON, # 0
  NASH, # 1
  ESEN # 2
}

static func get_label(player_id: int) -> String:
  match player_id:
    0:
      return "Talon"
    1:
      return "Nash"
    2:
      return "Esen"
    _:
      return ""