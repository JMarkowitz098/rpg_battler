class_name Element

enum Type {
  ETH,
  ENH,
  SHOR,
  SCOR,
  NONE
}

static func get_label(type: Type) -> String:
  match type:
    Element.Type.ETH:
      return "Eth"
    Element.Type.ENH:
      return "Enh"
    Element.Type.SHOR:
      return "Shor"
    Element.Type.SCOR: 
      return "Scor"
    _:
      return ""
