extends Node

var name_map: Dictionary[String, Human] = {}
var cn_name_map: Dictionary[String, Human] = {}
var id_map: Dictionary[String, Human] = {}

func show() -> void:
	print(name_map)
	print(cn_name_map)
	print(id_map)
