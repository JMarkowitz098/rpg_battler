extends Node
class_name Modifiers

signal ingress_updated
signal no_ingress(unique_id: String)

var current_ingress := 1 
var current_refrain_block_element := Element.Type.NONE
var current_refrain_element := Element.Type.NONE
var has_refrain_block := false
var has_small_refrain_open := false
var is_dodging := false
var is_eth_dodging := false
var plus_agility := 0
var plus_incursion := 0
var plus_max_ingress := 0
var plus_refrain := 0
var rand_agi := 1
var refrain_blocker: Node2D

func set_current_ingress(new_value: int, max_ingress: int) -> void:
  current_ingress = clamp(new_value, 0, max_ingress)
  ingress_updated.emit()
  if current_ingress == 0: no_ingress.emit(get_parent().unique_id.id)
