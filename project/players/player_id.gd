class_name PlayerId

enum Id {
  TALON, # 0
  NASH, # 1
  ESEN, # 2
  NALTA, # 3
  SORAH, # 4
  DEVLIN, # 5
  NONE
}

static func get_label(player_id: PlayerId.Id) -> String:
  match player_id:
    PlayerId.Id.TALON:
      return "Talon"
    PlayerId.Id.NASH:
      return "Nash"
    PlayerId.Id.ESEN:
      return "Esen"
    PlayerId.Id.NALTA:
      return "Nalta"
    PlayerId.Id.SORAH:
      return "Sorah"
    PlayerId.Id.DEVLIN:
      return "Devlin"
    _:
      return ""