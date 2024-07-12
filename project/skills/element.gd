class_name Element

enum Type {
  ETH,
  ENH,
  SHOR,
  SCOR,
  NONE
}

static func get_label(type: Type) -> String:
  # Can't use member variable in static function, so manually set match statement
  match type:
    0:
      return "Eth"
    1:
      return "Enh"
    2:
      return "Shor"
    3: 
      return "Scor"
    _:
      return ""
